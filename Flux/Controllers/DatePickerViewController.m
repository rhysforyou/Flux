//
//  DatePickerViewController.m
//  Flux
//
//  Created by hdd on 26/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DatePickerViewController.h"
#import "DatePickerViewCell.h"
#import "DateHeaderView.h"
#import "WaybackCDXClient.h"
#import "WaybackCDXEntry.h"
#import "WebViewController.h"

@interface DatePickerViewController ()

@property (nonatomic, strong) NSArray *URLArray;
@property (nonatomic, strong) NSDictionary *dateCache;
@property (nonatomic, strong) PDTSimpleCalendarViewController *calendarController;
@property (nonatomic, strong) WaybackCDXEntry *selectedEntry;

@end

@implementation DatePickerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:self.URL.host];

    [[WaybackCDXClient sharedClient] searchWithURL:self.URL accuracy:WaybackCDXClientAccuracyDay success:^(NSURLSessionDataTask *task, NSArray *responseObject) {
        [self processSearchResults:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Unable to load results: %@", error.localizedDescription);
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showWebView"]) {
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.WebURL = self.selectedEntry.accessableURL;
    } else if ([segue.identifier isEqualToString:@"embedCalendar"]) {
        self.calendarController = segue.destinationViewController;
        self.calendarController.delegate = self;
        self.calendarController.lastDate = [NSDate date];
        self.calendarController.calendar.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        NSDateComponents *startDateComponents = [[NSDateComponents alloc] init];
        startDateComponents.day = 1;
        startDateComponents.month = 1;
        startDateComponents.year = 1995;
    }
}

- (BOOL)hasEntryForDate:(NSDate *)date {
    NSCalendar *calendar = self.calendarController.calendar;
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return self.dateCache[dateComponents] != nil;
}

- (void)processSearchResults:(NSArray *)results {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSMutableDictionary *newCache = [[NSMutableDictionary alloc] init];
        NSCalendar *calendar = self.calendarController.calendar;
        
        [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDate *date = [(WaybackCDXEntry *)obj timestamp];
            NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
            newCache[components] = @YES;
        }];
        
        self.URLArray = results;
        self.dateCache = newCache;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            WaybackCDXEntry *firstEntry = self.URLArray[0];
            self.calendarController.firstDate = firstEntry.timestamp;
            [self.calendarController.collectionView reloadData];
        });
    });
}

- (WaybackCDXEntry *)entryForDate:(NSDate *)date {
    NSCalendar *calendar = self.calendarController.calendar;
    NSDateComponents *startDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSDateComponents *oneDay = [NSDateComponents new];
    oneDay.day = 1;
    
    NSDate *startDate = [calendar dateFromComponents:startDateComponents];
    NSDate *endDate = [calendar dateByAddingComponents:oneDay toDate:startDate options:0];
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"(timestamp >= %@) && (timestamp < %@)", startDate, endDate];
    NSArray *filteredResults = [self.URLArray filteredArrayUsingPredicate:datePredicate];
    
    if ([filteredResults count] > 0) {
        return filteredResults[0];
    } else {
        return nil;
    }
}

#pragma - mark Simple Calendar View Delegate

- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller textColorForDate:(NSDate *)date {
    if ([self hasEntryForDate:date]) {
        return [UIColor blackColor];
    } else {
        return [UIColor lightGrayColor];
    }
}

- (BOOL)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller shouldUseCustomColorsForDate:(NSDate *)date {
    return YES;
}

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date {
    self.selectedEntry = [self entryForDate:date];
    if (self.selectedEntry != nil) {
        [self performSegueWithIdentifier:@"showWebView" sender:self];
    }
}

@end
