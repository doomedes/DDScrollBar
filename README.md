# DDScrollBar
仿腾讯新闻（新闻切换）的一个控制器

介绍：
主要涉及两个类和一个协议：
ScrollerBarItem.h 切换的每一个UIViewController的信息类
<pre><code>
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
</code></pre>


ScrollerBarViewController.h  控制UIViewController集合切换的管理类

<pre><code>
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
@property(nonatomic,copy) UIColor *bottomSplitLineColor;//导航底部分割线颜色
@property(nonatomic,weak) id<UIScrollViewDelegate> delegate;
@end
</code></pre>

ScrollerBarViewControllerDelegate 协议 用于ScrollerBarViewController中选择每一项的处理

<pre><code>
@protocol ScrollerBarViewControllerDelegate <NSObject>
@optional
-(void)scrollerBarViewController:(ScrollerBarViewController *) scrollerBarViewController didSelectItem:(ScrollerBarItem *) selectedItem;
@end
</code></pre>

具体使用与效果：
![Alt text](https://github.com/doomedes/DDScrollBar/blob/master/scrollbar.png)

<pre><code>
    ScrollerBarViewController * scrollerBarVC=[[ScrollerBarViewController alloc]init]; //创建一个ScrollerBarViewController
    scrollerBarVC.bottomSplitLineColor=UIColorRGB(219, 219, 219); //设置导航底部分割线颜色
    
    UIViewController *one= [UIViewController new];
    one.view.backgroundColor=[UIColor grayColor];
    UIViewController *two= [UIViewController new];
    two.view.backgroundColor=[UIColor yellowColor];
    UIViewController *three= [UIViewController new];
    three.view.backgroundColor=[UIColor blueColor];
    UIViewController *four= [UIViewController new];
    four.view.backgroundColor=[UIColor orangeColor];
    UIViewController *five= [UIViewController new];
    
    CGFloat scale= [UIScreen mainScreen].bounds.size.width/414.0;
    //设置里面显示项的集合
    scrollerBarVC.scrollerBarItems=@[
                                     [[ScrollerBarItem alloc]initWithTtile:@"拍卖中" width:100*scale underLineWidth:54*scale viewController:one],
                                     [[ScrollerBarItem alloc]initWithTtile:@"成交" width:70*scale underLineWidth:54*scale viewController:two],
                                     [[ScrollerBarItem alloc]initWithTtile:@"流拍" width:70*scale underLineWidth:54*scale viewController:three],
                                     [[ScrollerBarItem alloc]initWithTtile:@"仲裁" width:70*scale underLineWidth:54*scale viewController:four],
                                     [[ScrollerBarItem alloc]initWithTtile:@"交易成功" width:100*scale underLineWidth:54*scale viewController:five]
                                     ];
    scrollerBarVC.title=@"发拍记录";
    scrollerBarVC.titleNormalColor=[UIColor colorWithRed:97/255.0 green:97/255.0 blue:97/255.0 alpha:2];//设置导航title的颜色
    scrollerBarVC.titleSelectedColor=[UIColor colorWithRed:45/255.0 green:150/255.0 blue:205/255.0 alpha:2]; //设置导航选择项title的颜色
    scrollerBarVC.underLineColor=[UIColor colorWithRed:45/255.0 green:150/255.0 blue:205/255.0 alpha:2];//设置导航底部分割线颜色
    
    //    [self presentViewController:scrollerBarVC animated:YES completion:nil]; //使用Present方式显示
    [self.navigationController pushViewController:scrollerBarVC animated:YES];  //使用navigationController显示
    
    </code></pre>

    
    
