//
//  ViewController.m
//  Flux
//
//  Created by Rhys Powell on 26/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDatePicker"]) {
        DatePickerViewController *datePickerVC = (DatePickerViewController *)segue.destinationViewController;
        NSURL *url = [NSURL URLWithString:self.URLField.text];
        if (!url.scheme) {
            url = [NSURL URLWithString:[@"http://" stringByAppendingString:self.URLField.text]];
        }
        datePickerVC.URL = url;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self performSegueWithIdentifier:@"showDatePicker" sender:self];

    return NO;
}

@end
