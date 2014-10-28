//
//  WebViewController.h
//  Flux
//
//  Created by hdd on 27/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView* webView;

@property (strong, nonatomic) NSURL* WebURL;

@property (strong, nonatomic) NSString* Month;

@property NSInteger Year;

@end