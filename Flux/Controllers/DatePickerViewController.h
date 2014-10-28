//
//  DatePickerViewController.h
//  Flux
//
//  Created by hdd on 26/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PDTSimpleCalendar.h"

@interface DatePickerViewController : UIViewController <PDTSimpleCalendarViewDelegate>

@property (strong, nonatomic) NSURL *URL;

@end
