//
//  AirTableView.m
//  AairbnbAnimation
//
//  Created by ian on 16/11/3.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "AirTableView.h"

@implementation AirTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
