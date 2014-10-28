//
//  ViewController.h
//  Flux
//
//  Created by Rhys Powell on 26/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"

@interface MainViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *URLField;

@end
