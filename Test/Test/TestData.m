//
//  TestData.m
//  Test
//
//  Created by Vincent Tang on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TestData.h"

@implementation TestData
@synthesize str1,str2,array;
@synthesize num;
-(id)init
{
    if (self = [super init]) {
        array = [[NSArray alloc] init];
    }
    return self;
}
- (void)dealloc {
    self.str2 = nil;
    self.str1 = nil;
    self.array = nil;
    [super dealloc];
}
@end
