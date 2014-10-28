//
//  WaybackCDXEntry.h
//  Flux
//
//  Created by Rhys Powell on 26/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaybackCDXEntry : NSObject

/** When the entry was captured */
@property (nonatomic, strong) NSDate *timestamp;

/** The original URL of this entry */
@property (nonatomic, strong) NSURL *originalURL;
@property (nonatomic, strong) NSURL *accessableURL;

/** Init the entry with a JSON array in the format returned by
 the CDX API.
 
 @param JSON the array to unpack
 
 @return a newly instantiated CDX entry
 */
- (instancetype)initWithJSONArray:(NSArray *)JSON;

@end
