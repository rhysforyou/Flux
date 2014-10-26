//
//  WaybackCDXEntry.h
//  Flux
//
//  Created by Rhys Powell on 26/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaybackCDXEntry : NSObject

@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSURL *originalURL;
@property (nonatomic, strong) NSURL *accessableURL;

- (instancetype)initWithJSONArray:(NSArray *)JSON;

@end
