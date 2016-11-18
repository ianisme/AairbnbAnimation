//
//  ViewController.m
//  AairbnbAnimation

//  Created by ian on 16/11/2.
//  Copyright © 2016年 ian. All rights reserved.

#import "ViewController.h"
#import "AirbnbViewController.h"

@interface ViewController ()

@end

@implementation ViewController


#pragma mark - life style

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake((self.view.frame.size.width - 80)/2.0f, (self.view.frame.size.height - 80)/2.0f - 100, 80, 80);
    [btn setTitle:@"Click" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blackColor]];
    btn.layer.cornerRadius = 8.0f;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - action method

- (void)btnClick:(id)sender
{
    NSLog(@"测试");
    AirbnbViewController *controller = [[AirbnbViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}



@end
