//
//  BaseNavigationViewController.m
//  AairbnbAnimation
//
//  Created by ian on 16/11/2.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController


#pragma mark - life style

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableDictionary *norNavTitle = [NSMutableDictionary dictionary];
    norNavTitle[NSForegroundColorAttributeName] = [UIColor blackColor];
    norNavTitle[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [self.navigationBar setTitleTextAttributes:norNavTitle];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    UIImage *image = [self imageWithColor:[UIColor greenColor]];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[self imageWithColor2:[UIColor greenColor]]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithColor2:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, .5);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
