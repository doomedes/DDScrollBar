//
//  ScrollerBarItem.m
//  MasonryDemo
//
//  Created by yuanyongguo on 16/5/17.
//  Copyright © 2016年 doomedes. All rights reserved.
//

#import "ScrollerBarItem.h"


@implementation ScrollerBarItem


-(instancetype)initWithTtile:(NSString *)title width:(CGFloat) width underLineWidth:(CGFloat) underLineWidth viewController:(UIViewController *) viewController {
    self = [super init];
    if (self) {
        self.title=title;
        self.width=width;
        self.viewController=viewController;
        self.isAdd=NO;
        self.underLineWidth=underLineWidth;
    }
    return self;
}

@end