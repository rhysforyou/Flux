//
//  DatePickerViewCell.m
//  Flux
//
//  Created by hdd on 26/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import "DatePickerViewCell.h"

@interface DatePickerViewCell ()

@end

@implementation DatePickerViewCell

@synthesize cellLabel;
@synthesize cellURL;

- (DatePickerViewCell *)copy {
    DatePickerViewCell *newCell = [[DatePickerViewCell alloc] init];
    newCell.cellURL = self.cellURL;
    newCell.cellLabel = self.cellLabel;
    return newCell;
}
@end
