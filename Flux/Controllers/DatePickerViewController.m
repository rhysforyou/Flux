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
#import "PDTSimpleCalendar.h"

@interface DatePickerViewController ()

@property (nonatomic, strong) NSArray *URLArray;
@property (nonatomic, strong) NSDateComponents *currentDateComponents;
@property (nonatomic, strong) PDTSimpleCalendarViewController *calendarController;

@end

@implementation DatePickerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:self.URL.host];

    [[WaybackCDXClient sharedClient] searchWithURL:self.URL accuracy:WaybackCDXClientAccuracyDay success:^(NSURLSessionDataTask *task, NSArray *responseObject) {
        self.URLArray = [responseObject copy];
        [self.calendarController.collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Unable to load results: %@", error.localizedDescription);
    }];

    NSDate *now = [NSDate date];
    self.currentDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:now];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.calendarController scrollToDate:[NSDate date] animated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showWeb"]) {
        // Figure out what URL to use
    } else if ([segue.identifier isEqualToString:@"embedCalendar"]) {
        self.calendarController = segue.destinationViewController;
        self.calendarController.delegate = self;
        self.calendarController.lastDate = [NSDate date];
        NSDateComponents *startDateComponents = [[NSDateComponents alloc] init];
        startDateComponents.day = 1;
        startDateComponents.month = 1;
        startDateComponents.year = 1995;
        self.calendarController.firstDate = [self.calendarController.calendar dateFromComponents:startDateComponents];
    }
}

- (BOOL)hasEntryForDate:(NSDate *)date {
    NSCalendar *calendar = self.calendarController.calendar;
    NSDateComponents *startDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitYear fromDate:date];
    NSDateComponents *oneDay = [NSDateComponents new];
    oneDay.day = 1;
    
    NSDate *startDate = [calendar dateFromComponents:startDateComponents];
    NSDate *endDate = [calendar dateByAddingComponents:oneDay toDate:startDate options:0];
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"(timestamp >= %@) && (timestamp < %@)", startDate, endDate];
    NSArray *filteredResults = [self.URLArray filteredArrayUsingPredicate:datePredicate];
    return filteredResults.count > 0;
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
}

@end
