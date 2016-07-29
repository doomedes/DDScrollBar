//
//  ViewController.m
//  DDScrollBarTest
//
//  Created by yuanyongguo on 16/7/29.
//  Copyright © 2016年 doomedes. All rights reserved.
//

#import "ViewController.h"
#import "ScrollerBarViewController.h"
#import "TestViewController.h"
#define  UIColorRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1] 

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ScrollerBarViewController * scrollerBarVC=[[ScrollerBarViewController alloc]init];
    scrollerBarVC.bottomSplitLineColor=UIColorRGB(219, 219, 219);
    TestViewController *one= [TestViewController new];
    one.view.backgroundColor=[UIColor grayColor];
    UIViewController *two= [UIViewController new];
    two.view.backgroundColor=[UIColor yellowColor];
    UIViewController *three= [UIViewController new];
    three.view.backgroundColor=[UIColor blueColor];
    UIViewController *four= [UIViewController new];
    four.view.backgroundColor=[UIColor orangeColor];
    UIViewController *five= [UIViewController new];
    
    CGFloat scale= [UIScreen mainScreen].bounds.size.width/414.0;
    
    scrollerBarVC.scrollerBarItems=@[
                                     [[ScrollerBarItem alloc]initWithTtile:@"拍卖中" width:100*scale underLineWidth:54*scale viewController:one],
                                     [[ScrollerBarItem alloc]initWithTtile:@"成交" width:70*scale underLineWidth:54*scale viewController:two],
                                     [[ScrollerBarItem alloc]initWithTtile:@"流拍" width:70*scale underLineWidth:54*scale viewController:three],
                                     [[ScrollerBarItem alloc]initWithTtile:@"仲裁" width:70*scale underLineWidth:54*scale viewController:four],
                                     [[ScrollerBarItem alloc]initWithTtile:@"交易成功" width:100*scale underLineWidth:54*scale viewController:five]
                                     ];
    scrollerBarVC.title=@"发拍记录";
    scrollerBarVC.titleNormalColor=[UIColor colorWithRed:97/255.0 green:97/255.0 blue:97/255.0 alpha:2];
    scrollerBarVC.titleSelectedColor=[UIColor colorWithRed:45/255.0 green:150/255.0 blue:205/255.0 alpha:2];
    scrollerBarVC.underLineColor=[UIColor colorWithRed:45/255.0 green:150/255.0 blue:205/255.0 alpha:2];
    
    //    [self presentViewController:scrollerBarVC animated:YES completion:nil];
    [self.navigationController pushViewController:scrollerBarVC animated:YES];
    
}

@end
