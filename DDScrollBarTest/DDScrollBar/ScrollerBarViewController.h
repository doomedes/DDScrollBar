//
//  ScrollerBarViewController.h
//  MasonryDemo
//
//  Created by yuanyongguo on 16/5/17.
//  Copyright © 2016年 doomedes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollerBarViewController;
#import "ScrollerBarItem.h"

@protocol ScrollerBarViewControllerDelegate <NSObject>

@optional

-(void)scrollerBarViewController:(ScrollerBarViewController *) scrollerBarViewController didSelectItem:(ScrollerBarItem *) selectedItem;


@end

@interface ScrollerBarViewController : UIViewController

@property(nonatomic,assign) NSInteger currentIndex;//当前显示第几个VC

@property(nonatomic,copy) NSArray * scrollerBarItems; //包含的VC集合

@property(nonatomic,assign) CGFloat barItemHeight; //头部导航栏中每一项的高度

@property(nonatomic,assign) CGFloat underLineHeight; //头部导航栏中下划线的高度

@property(nonatomic,copy) UIColor *barBackgroundColor; //导航条背景颜色

@property(nonatomic,copy) UIColor *contentBackgroundColor; //中间内容的背景颜色

@property(nonatomic,copy) UIColor *titleNormalColor; //导航条中每一项title对应 normal颜色

@property(nonatomic,assign) CGFloat titleFontSize; //导航条中每一项title对应 font

@property(nonatomic,copy) UIColor *titleSelectedColor; //导航条中每一项title对应 selected颜色

@property(nonatomic,copy) UIColor *underLineColor; //导航条底部的滚动条颜色

@property(nonatomic,copy) UIColor *bottomSplitLineColor;//底部分割线颜色


@property(nonatomic,weak) id<UIScrollViewDelegate> delegate;


@end



