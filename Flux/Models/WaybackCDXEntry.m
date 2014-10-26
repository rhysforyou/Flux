//
//  WaybackCDXEntry.m
//  Flux
//
//  Created by Rhys Powell on 26/10/2014.
//  Copyright (c) 2014 Rhys Powell. All rights reserved.
//

#import "WaybackCDXEntry.h"

@interface WaybackCDXEntry ()

@property (nonatomic, readonly) NSDateFormatter *JSONDateFormatter;

@end

@implementation WaybackCDXEntry

- (instancetype)initWithJSONArray:(NSArray *)JSON {
    if (self = [super init]) {
        self.timestamp = [self.JSONDateFormatter dateFromString:JSON[0]];
        self.originalURL = [NSURL URLWithString:JSON[1]];
        
        NSString *URLString = [[NSString alloc]initWithFormat:@"http://web.archive.org/web/%@/%@",JSON[0],JSON[1]];
        self.accessableURL = [NSURL URLWithString:URLString];
    }
    return self;
}

- (NSDateFormatter *)JSONDateFormatter {
    static NSDateFormatter *_JSONDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _JSONDateFormatter = [[NSDateFormatter alloc] init];
        _JSONDateFormatter.dateFormat = @"yyyyMMddkkmmss";
        _JSONDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    });
    return _JSONDateFormatter;
}

@end
