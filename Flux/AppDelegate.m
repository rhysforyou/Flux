//
//  AppDelegate.m
//  Flux
//
//  Created by Rhys Powell on 26/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import "AppDelegate.h"
#import "WaybackCDXClient.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setDefaultAppearance];

    return YES;
}

- (void)setDefaultAppearance {
    [[UITextField appearance] setFont:[UIFont fontWithName:@"Avenir-Book" size:14.0f]];
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Avenir-Book" size:14.0f]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Avenir-Book" size:17.0f] } forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Avenir-Heavy" size:17.0f] }];
}

@end
