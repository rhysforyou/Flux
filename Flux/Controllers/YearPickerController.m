//
//  YearPickerController.m
//  Flux
//
//  Created by Rhys Powell on 29/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import "YearPickerController.h"

@interface YearPickerController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic) NSInteger currentYear;
@property (nonatomic) NSInteger startYear;

@end

@implementation YearPickerController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.startYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:self.startDate];
    [self.pickerView reloadAllComponents];
}

- (NSDate *)selectedDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = self.startYear + [self.pickerView selectedRowInComponent:0];
    dateComponents.month = 1;
    dateComponents.day = 1;

    return [calendar dateFromComponents:dateComponents];
}

#pragma mark - Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.currentYear - self.startYear + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld", self.startYear + row];
}

@end
