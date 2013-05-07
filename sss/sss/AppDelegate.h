//
//  AppDelegate.h
//  sss
//
//  Created by Vincent Tang on 13-4-23.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@protocol Appdel <NSObject>


@end
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
   __weak  id<Appdel> adelegate;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (weak,nonatomic) id<Appdel> adelegate;
@end
