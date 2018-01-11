//
//  ViewController.m
//  WLJSearchTableView
//
//  Created by wanglijun on 2018/1/10.
//  Copyright © 2018年 wanglijun. All rights reserved.
//

#import "ViewController.h"
#import "MYViewController.h"
@interface ViewController ()
@end

@implementation ViewController
- (IBAction)push:(id)sender {
    [self.navigationController pushViewController:[MYViewController new] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
@end
