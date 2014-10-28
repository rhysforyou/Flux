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
@property (nonatomic, strong) NSDateComponents *currentDateComponents;

@end

@implementation DatePickerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:self.URL.host];

    [[WaybackCDXClient sharedClient] searchWithURL:self.URL accuracy:WaybackCDXClientAccuracyMonth success:^(NSURLSessionDataTask *task, NSArray *responseObject) {
        self.URLArray = [responseObject copy];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Unable to load results: %@", error.localizedDescription);
    }];

    NSDate *now = [NSDate date];
    self.currentDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:now];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.currentDateComponents.month;
    } else {
        return 12;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.currentDateComponents.year - 1995;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DatePickerViewCell *cell = (DatePickerViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DatePickerCell" forIndexPath:indexPath];
    NSString *thisMonthStr = [self getMonthStr:indexPath.row];
    cell.cellURL = nil;
    [cell.cellLabel setTextColor:[UIColor lightGrayColor]];
    //[cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    NSInteger thisYear = self.currentDateComponents.year - indexPath.section;
    NSInteger thisMonth = indexPath.row + 1;
    for (WaybackCDXEntry *entry in self.URLArray) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:entry.timestamp];
        NSInteger entryMonth = [components month];
        NSInteger entryYear = [components year];
        if (entryMonth == thisMonth && entryYear == thisYear) {
            cell.cellURL = entry.accessableURL;
            [cell.cellLabel setTextColor:[UIColor blackColor]];
            //[cell setBackgroundColor:[UIColor lightGrayColor]];
            break;
        }
    }
    [cell.cellLabel setText:thisMonthStr];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 2, 3, 2);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    DateHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DateHeader" forIndexPath:indexPath];
    NSInteger thisYear = self.currentDateComponents.year - indexPath.section;
    NSString *yearStr = [NSString stringWithFormat:@"%ld", (long)thisYear];

    [header.headerLabel setText:yearStr];

    return header;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showWeb"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems][0];
        DatePickerViewCell *cell = (DatePickerViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell.cellURL != nil) {
            return YES;
        }
    }
    return NO;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showWeb"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems][0];
        DatePickerViewCell *cell = (DatePickerViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        ((WebViewController *)segue.destinationViewController).WebURL = cell.cellURL;
        ((WebViewController *)segue.destinationViewController).Month = cell.cellLabel.text;
        ((WebViewController *)segue.destinationViewController).Year = self.currentDateComponents.year - indexPath.section;
    }
}

- (NSString *)getMonthStr:(NSInteger)month {
    NSString *monthStr;
    switch (month) {
    case 0:
        monthStr = @"January";
        break;
    case 1:
        monthStr = @"February";
        break;
    case 2:
        monthStr = @"March";
        break;
    case 3:
        monthStr = @"April";
        break;
    case 4:
        monthStr = @"May";
        break;
    case 5:
        monthStr = @"June";
        break;
    case 6:
        monthStr = @"July";
        break;
    case 7:
        monthStr = @"August";
        break;
    case 8:
        monthStr = @"September";
        break;
    case 9:
        monthStr = @"October";
        break;
    case 10:
        monthStr = @"November";
        break;
    case 11:
        monthStr = @"December";
        break;
    default:
        break;
    }
    return monthStr;
}

@end
