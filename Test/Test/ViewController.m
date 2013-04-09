//
//  ViewController.m
//  Test
//
//  Created by Vincent Tang on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "TestData.h"
@implementation ViewController
@synthesize testStr;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITableView *theTb = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    theTb.delegate = self;
    theTb.dataSource = self;
    [self.view addSubview:theTb];
    [theTb release];
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    for (int i = 0; i < 5 ; i++) {
//        TestData *test = [[TestData alloc] init];
//        test.str1 = @"nihao";
//        test.str2 = @"hello";
//        test.array = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
//        [arr addObject:test];
//        [test release];
//    }
//    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
//    [tf setText:@"nihao"];
//    [tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//    tf.borderStyle = UITextBorderStyleRoundedRect;
//    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
//    tf.enablesReturnKeyAutomatically = YES;
//    tf.returnKeyType = UIReturnKeySend;
//    tf.textColor = [UIColor redColor];
//    [self.view addSubview:tf];
//    [tf release];
//    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
//    tv.backgroundColor = [UIColor grayColor];
//    [tv setTextAlignment:UITextAlignmentLeft];
//    tv.delegate = self;
//    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 50, 20)];
//    lable.tag = 333;
//    lable.text = @"请点我";
//    lable.userInteractionEnabled = NO;
//    [tv addSubview:lable];
//    [lable release];
//    [self.view addSubview:tv];
//    
//    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(50, 50, 50, 30)];
//    tf.placeholder = @"sdfsdf";
//    [self.view addSubview:tf];
    
//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(43, 11, 37, 20)];
//    [leftButton setBackgroundColor:[UIColor whiteColor]];
//    [leftButton setTitle:@"退出" forState:UIControlStateNormal];
//    //    [rightButton setTitle:@"设置" forState:UIControlStateSelected];
//    leftButton.titleLabel.font = [UIFont systemFontOfSize:12];
//    leftButton.titleLabel.textColor = [UIColor purpleColor];
//    [leftButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        [leftButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(exitDownloadView:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:leftButton];
//    [leftButton release];

    
}

#pragma mark--
#pragma mark ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xx"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 40) reuseIdentifier:@"xx"] autorelease];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"xx%d",indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = (NSMutableDictionary *)[tableView valueForKey:@"_reusableTableCells"];
    for (NSObject *obj  in [dict allKeys]) {
        NSLog(@"obj ==> %@",obj);
    }
    
}
-(void) exitDownloadView:(id)sender
{

}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"beginEditing");
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"endEditing");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    UILabel *label = (UILabel *)[textView viewWithTag:333];
    if ([textView.text length]) {
        label.hidden = YES;
    }else{
        label.hidden = NO;
    }
    NSLog(@"change ===> %@",textView.text);
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    NSLog(@"selection === >%@",textView.text);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
