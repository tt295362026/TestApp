//
//  TestData.h
//  Test
//
//  Created by Vincent Tang on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestData : NSObject
{
    NSString *str1;
    NSArray *array;
    NSString *str2;
    int num;
}
@property (nonatomic,assign)int num;
@property (nonatomic,retain) NSString *str1;
@property (nonatomic,retain) NSArray *array;
@property (nonatomic,retain) NSString *str2;
@end
