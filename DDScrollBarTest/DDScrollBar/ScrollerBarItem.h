//
//  ScrollerBarItem.h
//  MasonryDemo
//
//  Created by yuanyongguo on 16/5/17.
//  Copyright © 2016年 doomedes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScrollerBarItem : NSObject

@property(nonatomic,copy)   NSString * title;

@property(nonatomic,strong) UIViewController * viewController;

@property(nonatomic,assign) CGFloat width;      //title按钮的宽度

@property(nonatomic,assign) CGFloat validWidth; //title按钮实际有效宽度

@property(nonatomic,assign) CGFloat  offsetX; //计算出title的offsetX

@property(nonatomic,assign) CGFloat underLineWidth; //滚动条的宽度

@property(nonatomic,assign) CGFloat underLineOffsetX;//计算出underLine的offset

@property(nonatomic,assign) bool isAdd; //是否已经添加到ScrollView

-(instancetype)initWithTtile:(NSString *)title width:(CGFloat) width underLineWidth:(CGFloat) underLineWidth viewController:(UIViewController *) viewController ;

@end

