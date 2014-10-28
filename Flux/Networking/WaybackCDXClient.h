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

/** Get a singleton shared client
 
 @returns a singleton client
 */
+ (instancetype)sharedClient;

/** Search for archive entries for a given domain.
 
 @param URL the URL of the resource to search the archive for
 @param accuracy controls the frequency of returned snapshots
 @param success a callback called upon successful completion of the search
 @param failure a callback called when there were issues with the request.
 */
- (NSURLSessionDataTask *)searchWithURL:(NSURL *)URL
                               accuracy:(WaybackCDXClientAccuracy)accuracy
                                success:(WaybackCDXClientSuccess)success
                                failure:(WaybackCDXClientFailure)failure;

@end
