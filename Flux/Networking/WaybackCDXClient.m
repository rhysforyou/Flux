//
//  WaybackCDXClient.m
//  Flux
//
//  Created by Rhys Powell on 26/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import "WaybackCDXClient.h"

static NSString * const WaybackCDXClientBaseURL = @"http://web.archive.org/cdx/";

@implementation WaybackCDXClient

+ (instancetype)sharedClient {
    static WaybackCDXClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WaybackCDXClient alloc] initWithBaseURL:[NSURL URLWithString:WaybackCDXClientBaseURL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

    });
    return _sharedClient;
}

- (NSURLSessionDataTask *)searchWithDomain:(NSString *)domain accuracy:(WaybackCDXClientAccuracy)accuracy success:(WaybackCDXClientSuccess)success failure:(WaybackCDXClientFailure)failure {
    NSMutableDictionary *params = [@{@"url" : domain,
                                     @"output" : @"json",
                                     @"fl" : @"timestamp,original"} mutableCopy];
    
    switch (accuracy) {
        case WaybackCDXClientAccuracyMaximum:
            break;
        case WaybackCDXClientAccuracyHour:
            params[@"collapse"] = @"timestamp:10";
        case WaybackCDXClientAccuracyDay:
            params[@"collapse"] = @"timestamp:8";
            break;
        case WaybackCDXClientAccuracyMonth:
            params[@"collapse"] = @"timestamp:6";
            break;
        case WaybackCDXClientAccuracyYear:
            params[@"collapse"] = @"timestamp:4";
            break;
        default:
            break;
    }
    
    return [self GET:@"/search/cdx" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, (NSArray *)responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

@end
