//
//  WebViewController.m
//  Flux
//
//  Created by hdd on 27/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURLRequest *pageRequest = [[NSURLRequest alloc] initWithURL:self.WebURL];
    [self.webView loadRequest:pageRequest];
    NSLog(@"%@", self.WebURL);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"__wm.h();"];
}
@end