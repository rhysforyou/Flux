//
//  WebViewController.m
//  Flux
//
//  Created by hdd on 27/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController()

@end

@implementation WebViewController

@synthesize webView;
@synthesize WebURL;
@synthesize Month;
@synthesize Year;
-(void)viewDidLoad{
    [super viewDidLoad];
    NSString *NVtitle = [[NSString alloc]initWithFormat:@"%@, %ld",Month,(long)Year];
    [self.navigationItem setTitle:NVtitle];
    [webView setDelegate:self];
    NSURLRequest *pageRequest = [[NSURLRequest alloc]initWithURL:WebURL];
    [webView loadRequest:pageRequest];
    NSLog(@"%@",WebURL);
    
}



-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"__wm.h();"];
}
@end