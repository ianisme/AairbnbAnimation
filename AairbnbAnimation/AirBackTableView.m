//
//  AirBackTableView.m
//  AairbnbAnimation
//
//  Created by ian on 16/11/3.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "AirBackTableView.h"

@implementation AirBackTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
