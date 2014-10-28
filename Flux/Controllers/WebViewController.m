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

    [self.navigationController setToolbarHidden:NO animated:animated];

    self.forwardButton.enabled = NO;
    self.backButton.enabled = NO;

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.WebURL];
    [self.webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    self.navigationItem.title = @"Loading...";
    
    [self updateBackForwardButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [webView stringByEvaluatingJavaScriptFromString:@"var __bar=document.getElementById('wm-ipp');__bar.parentNode.removeChild(__bar);"];
    
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [self updateBackForwardButtons];
}

- (IBAction)goBack:(id)sender {
    [self.webView goBack];
    
    [self updateBackForwardButtons];
}

- (IBAction)goForward:(id)sender {
    [self.webView goForward];
    
    [self updateBackForwardButtons];
}

- (void)updateBackForwardButtons {
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

@end