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
#import "YearPickerController.h"

@interface DatePickerViewController ()

@property (nonatomic, strong) NSArray *URLArray;
@property (nonatomic, strong) NSDictionary *dateCache;
@property (nonatomic, strong) PDTSimpleCalendarViewController *calendarController;
@property (nonatomic, strong) WaybackCDXEntry *selectedEntry;
@property (nonatomic, strong) UIImageView *loadingView;
@property (nonatomic, strong) NSURL *lastLoadedURL;

@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *loadingView = [[UIImageView alloc] initWithFrame:self.view.frame];
    loadingView.animationImages = @[ [UIImage imageNamed:@"LoadingSpinner1"],
                                     [UIImage imageNamed:@"LoadingSpinner2"],
                                     [UIImage imageNamed:@"LoadingSpinner3"] ];
    loadingView.animationDuration = 1.0;
    loadingView.backgroundColor = [UIColor whiteColor];
    loadingView.contentMode = UIViewContentModeCenter;

    self.loadingView = loadingView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:self.URL.host];

    if ([self.lastLoadedURL isEqual:self.URL])
        return;

    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimating];

    [[WaybackCDXClient sharedClient] searchWithURL:self.URL accuracy:WaybackCDXClientAccuracyDay success:^(NSURLSessionDataTask *task, NSArray *responseObject) {
        self.lastLoadedURL = self.URL;
        [self processSearchResults:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unable to load"
                                                                                 message:@"We couldn't load data about this website. Perhaps you're having connectivity issues?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
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
    } else if ([segue.identifier isEqualToString:@"showDatePicker"]) {
        UINavigationController *navVC = segue.destinationViewController;
        YearPickerController *yearPickerController = (YearPickerController *)[navVC topViewController];
        WaybackCDXEntry *firstEntry = self.URLArray[0];
        yearPickerController.startDate = firstEntry.timestamp;
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
            
            [UIView animateWithDuration:0.5 animations:^{
                self.loadingView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.loadingView removeFromSuperview];
                self.loadingView.alpha = 1.0f;
            }];
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

- (IBAction)unwindFromYearPicker:(UIStoryboardSegue *)unwindSegue {
    if ([unwindSegue.identifier  isEqualToString:@"doneYearPicker"]) {
        YearPickerController *yearPickerController = unwindSegue.sourceViewController;
        [self.calendarController scrollToDate:yearPickerController.selectedDate animated:YES];
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
