//
//  YearPickerController.h
//  Flux
//
//  Created by Rhys Powell on 29/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YearPickerController : UIViewController

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, readonly) NSDate *selectedDate;

@end
