//
//  WaybackCDXClient.h
//  Flux
//
//  Created by Rhys Powell on 26/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void (^WaybackCDXClientSuccess)(NSURLSessionDataTask *task, NSArray *responseObject);
typedef void (^WaybackCDXClientFailure)(NSURLSessionDataTask *task, NSError *error);

typedef NS_ENUM(NSInteger, WaybackCDXClientAccuracy) {
    WaybackCDXClientAccuracyMaximum,
    WaybackCDXClientAccuracyHour,
    WaybackCDXClientAccuracyDay,
    WaybackCDXClientAccuracyMonth,
    WaybackCDXClientAccuracyYear
};

@interface WaybackCDXClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (NSURLSessionDataTask *)searchWithDomain:(NSString *)domain
                                  accuracy:(WaybackCDXClientAccuracy)accuracy
                                   success:(WaybackCDXClientSuccess)success
                                   failure:(WaybackCDXClientFailure)failure;

@end
