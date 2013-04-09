//
//  ViewController.h
//  Test
//
//  Created by Vincent Tang on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *testStr;
}
@property (nonatomic,copy) NSString *testStr;
@end
