//
//  ViewController.m
//  TestGLes2
//
//  Created by Vincent Tang on 13-4-15.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//
#import "OpenGLView.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    OpenGLView *glview  = [[OpenGLView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:glview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
