//
//  ScrollerBarViewController.m
//  MasonryDemo
//
//  Created by yuanyongguo on 16/5/17.
//  Copyright © 2016年 doomedes. All rights reserved.
//

#import "ScrollerBarViewController.h"
#import "Masonry.h"
#import "ScrollerBarItem.h"

#define  UIColorRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1] 
 

@interface ScrollerBarViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView * rootScrollView;
@property(nonatomic,strong) UIView *rootView;
@property(nonatomic,strong) UIScrollView * scrollBar;//导航条
@property(nonatomic,strong) UIScrollView * scrollContent;//内容
@property(nonatomic,strong) UIView * underLine; //导航条下划线
@property(nonatomic,strong) UIView * bottomSplitLine; //底部分割线
@property(nonatomic,assign) BOOL jugeFirst;//是否第一次加载

@end

@implementation ScrollerBarViewController
{
     NSInteger preSelectIndex;
     NSInteger startTag;
    /*
     scrollContent滚动相关的变量
     */
     CGFloat startContentOffsetX; //开始滑动时scrollContent的offsetX
     CGRect  startSplitFrame; //开始滑动时splitLine的frame
     bool    isMoving; //是否还在滑动（用于区别设置offset导致的滑动）
    CGFloat bottomSplitLineHeight;
}


#pragma mark- 相关属性


-(NSArray *)scrollerBarItems {
    if(!_scrollerBarItems){
        _scrollerBarItems =[NSArray array];
    }
    return _scrollerBarItems;
}

-(CGFloat)barItemHeight {
    if(_barItemHeight<=0){
        return 40;
    }else{
        return _barItemHeight;
    }
}

-(CGFloat)underLineHeight {
    if(_underLineHeight<=0){
        return 3;
    }else{
        return _underLineHeight;
    }
}

-(UIColor *)barBackgroundColor {
    if(!_barBackgroundColor){
        _barBackgroundColor=[UIColor whiteColor];
    }
    return _barBackgroundColor;
}

-(UIColor *)contentBackgroundColor {
    if(!_contentBackgroundColor){
        _contentBackgroundColor=[UIColor whiteColor];
    }
    return _contentBackgroundColor;
}

-(UIColor *)titleNormalColor {
    if(!_titleNormalColor){
        _titleNormalColor=[UIColor blackColor];
    }
    return _titleNormalColor;
}

-(CGFloat)titleFontSize {
    if(_titleFontSize<=0){
        _titleFontSize=16;
    }
    return _titleFontSize;
}

-(UIColor *)titleSelectedColor {
    if(!_titleSelectedColor){
        _titleSelectedColor=[UIColor orangeColor];
    }
    return _titleSelectedColor;
}

-(UIColor *)underLineColor {
    if(!_underLineColor){
        _underLineColor=[UIColor cyanColor];
    }
    return _underLineColor;
}

-(UIColor *)bottomSplitLineColor {
    if(!_bottomSplitLineColor){
        _bottomSplitLineColor=UIColorRGB(219, 219, 219);
    }
    return _bottomSplitLineColor;
}

#pragma mark- 事件

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadData];
    self.jugeFirst=YES;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.jugeFirst){
        self.jugeFirst=NO;
        [self loadScrollBarAndScrollContent];
        [self loadChildView];
        [self loadChildViewOffset];
    }
   
}

-(void)viewDidLayoutSubviews {
  
    //第一种方式：修改rootView的高度
    CGRect newRect= self.rootView.frame;
    if(self.navigationController){
        newRect.size.height=[UIScreen mainScreen].bounds.size.height-[self.topLayoutGuide length];
    }
    self.rootView.frame=newRect;
    
//第二种方式：修改contentView中每一个VC的高度
//    for (ScrollerBarItem * item in self.scrollerBarItems) {
//        for (NSLayoutConstraint * layout in item.viewController.view.constraints) {
//                    if(layout.firstAttribute==NSLayoutAttributeHeight){
//                        layout.constant= [UIScreen mainScreen].bounds.size.height-self.barItemHeight-self.splitLineHeight-[self.topLayoutGuide length];
//                    }
//                }
//    }
//    NSLog(@"rootView:%@",NSStringFromCGRect(self.rootView.frame));
//    NSLog(@"scrollBar:%@",NSStringFromCGRect(self.scrollBar.frame));
//    NSLog(@"scrollContent:%@",NSStringFromCGRect(self.scrollContent.frame));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 方法

/**
 *  初始化数据
 */
-(void) loadData{
    startTag=100;
    preSelectIndex=-1;
    
    startContentOffsetX=0;
    startSplitFrame=CGRectZero;
    isMoving=NO;
    bottomSplitLineHeight=0.5;
    
}

/**
 *  加载bar与content
 */
- (void)loadScrollBarAndScrollContent {
  
    CGFloat screenWidth=[UIScreen mainScreen].bounds.size.width;
    
    self.rootScrollView=[[UIScrollView alloc]init];
    self.rootScrollView.frame=[UIScreen mainScreen].bounds;
    self.rootScrollView.backgroundColor=self.view.backgroundColor;
    [self.view addSubview:self.rootScrollView];

    self.rootView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.rootView.backgroundColor=self.view.backgroundColor;
    [self.rootScrollView addSubview:self.rootView];
    
    //bar与content的初始化
    self.scrollBar=[[UIScrollView alloc]init];
    self.scrollBar.backgroundColor=self.barBackgroundColor;
    self.scrollBar.showsHorizontalScrollIndicator=NO;
    self.scrollBar.showsVerticalScrollIndicator=NO;
    [self.rootView addSubview:self.scrollBar];
    
    self.scrollContent=[[UIScrollView alloc]init];
    self.scrollContent.backgroundColor=self.contentBackgroundColor;
    self.scrollContent.delegate=self;
    self.scrollContent.pagingEnabled=YES;
    self.scrollContent.showsVerticalScrollIndicator=NO;
    self.scrollContent.showsHorizontalScrollIndicator=NO;
//    self.scrollContent.bounces=YES;
    
    [self.rootView addSubview:self.scrollContent];
    
    CGFloat contentSizeHeight=self.barItemHeight+self.underLineHeight+bottomSplitLineHeight;
    self.scrollBar.translatesAutoresizingMaskIntoConstraints=NO;
    [self.scrollBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rootView.mas_top);
        make.left.equalTo(self.rootView.mas_left);
        make.right.equalTo(self.rootView.mas_right);
        make.height.mas_equalTo(contentSizeHeight);
        
    }];
    
    CGFloat contentSizeWith=0;
    contentSizeHeight=[UIScreen mainScreen].bounds.size.height-contentSizeHeight;
    if(!self.scrollerBarItems||self.scrollerBarItems.count==0){
        contentSizeWith=screenWidth;
    }else{
        contentSizeWith=screenWidth*self.scrollerBarItems.count;
    }
    
    //防止上下滚动
    self.scrollContent.contentSize=CGSizeMake(contentSizeWith, 0);
    self.scrollContent.translatesAutoresizingMaskIntoConstraints=NO;
    [self.scrollContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollBar.mas_bottom);
        make.left.equalTo(self.rootView.mas_left);
        make.right.equalTo(self.rootView.mas_right);
        make.bottom.equalTo(self.rootView.mas_bottom);
    }];

   
    //无VC处理
    if(!self.scrollerBarItems||self.scrollerBarItems.count==0){
        return;
    }
    /*
     bar中的每一项设置
     */
    CGFloat sumWidth=((NSString *)[self.scrollerBarItems valueForKeyPath:@"@sum.width"]).floatValue;
    CGFloat itemAddWidth=0;
    CGFloat startOffsetX=0;
    
    
    if(sumWidth<screenWidth){
        itemAddWidth=(screenWidth-sumWidth)/self.scrollerBarItems.count;
        sumWidth=screenWidth;
    }
    for (int i=0;i<self.scrollerBarItems.count;i++) {
        ScrollerBarItem * item=self.scrollerBarItems[i];
        item.validWidth=item.width+itemAddWidth;
        item.offsetX=startOffsetX; // 计算offsetX
        startOffsetX=item.offsetX+item.validWidth;
        item.underLineOffsetX=item.offsetX+(item.validWidth-item.underLineWidth)/2;
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(item.offsetX, 0, item.validWidth, self.barItemHeight)];
        [btn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
         btn.titleLabel.font=[UIFont systemFontOfSize:self.titleFontSize];
        [self.scrollBar addSubview:btn];
        
        btn.translatesAutoresizingMaskIntoConstraints=NO;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollBar.mas_top);
            make.left.equalTo(self.scrollBar.mas_left).offset(item.offsetX);
            make.width.mas_equalTo(item.validWidth);
            make.height.mas_equalTo(self.barItemHeight);
        }];

        btn.tag=startTag+i; //特殊表示
        [btn setTitle:item.title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(barItemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.scrollBar.contentSize=CGSizeMake(sumWidth, self.barItemHeight+self.underLineHeight);
    
    //bar中的下划线
    ScrollerBarItem * currentItem=self.scrollerBarItems[self.currentIndex];
    self.underLine=[[UIView alloc]init];
    self.underLine.backgroundColor=self.underLineColor;
    [self.scrollBar addSubview:self.underLine];
    self.underLine.frame=CGRectMake(currentItem.underLineOffsetX, self.barItemHeight,currentItem.underLineWidth , self.underLineHeight);
    
    [self barItemSelectedUpdate];
    self.bottomSplitLine=[[UIView alloc]init];
    self.bottomSplitLine.frame=CGRectMake(0, self.barItemHeight+self.underLineHeight, sumWidth, bottomSplitLineHeight);
    self.bottomSplitLine.backgroundColor=self.bottomSplitLineColor;
    [self.scrollBar addSubview:self.bottomSplitLine];

    
    
    
    
}

/**
 *  VC加载时初次加载相应的childVC或者点击导航时重新加载
 */
- (void)loadChildView {
    if(self.scrollerBarItems.count<=3){
        for (int i=0;i<self.scrollerBarItems.count;i++) {
            [self loadChildViewPositionWithIndex:i];
        }
    }else{
        if(self.currentIndex<1){
            for (int i=0;i<3;i++) {
                 [self loadChildViewPositionWithIndex:i];            }
        }else if(self.currentIndex==(self.scrollerBarItems.count-1)){
            for (int i=0;i<3;i++) {
                NSInteger index=self.currentIndex+i-2;
                 [self loadChildViewPositionWithIndex:index];
            }
        }else{
            for (int i=0;i<3;i++) {
                NSInteger index=self.currentIndex+i-1;
                [self loadChildViewPositionWithIndex:index];
            }
        }
  }

}

/**
 *  设置每一个view对应的位置（约束）
 *
 *  @param i 下标
 */
-(void) loadChildViewPositionWithIndex:(NSInteger) i {
    
    CGFloat width=[UIScreen mainScreen].bounds.size.width;

//    用于第二种方式修改高度（下面的约束则修改为等于一个固定高度，viewDidLayoutSubviews中动态修改）
//    CGFloat height=[UIScreen mainScreen].bounds.size.height-self.barItemHeight-self.splitLineHeight;
    ScrollerBarItem * item=self.scrollerBarItems[i];
    if(!item.isAdd){
        item.viewController.view.translatesAutoresizingMaskIntoConstraints=NO;
        [self addChildViewController:item.viewController];
        [self.scrollContent addSubview:item.viewController.view];
        [item.viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.scrollContent.mas_top);
            make.left.mas_equalTo(self.scrollContent.mas_left).offset(i*width);
            make.width.mas_equalTo(self.rootView.mas_width);
            make.height.mas_equalTo(self.scrollContent.mas_height);
        }];
        item.isAdd=YES;
    }
}

/**
 *  更新相应childVC显示的位置
 */
- (void)loadChildViewOffset {
    CGFloat width=[UIScreen mainScreen].bounds.size.width;
    self.scrollContent.contentOffset=CGPointMake(self.currentIndex*width, 0);
}

/**
 *  导航条中每一项点击事件
 *
 *  @param btn
 */
- (void)barItemClick:(UIButton *)btn {
    NSInteger index= btn.tag-startTag;
    if(self.currentIndex!=index){
        self.currentIndex=index;
        [self moveSplitLineNewPosition];
        [self loadChildView];
        [self loadChildViewOffset];
        [self barItemSelectedUpdate];
        [self commandDelegate];
    }
}

/**
 *  选中状态更新
 */
- (void)barItemSelectedUpdate {
    //选中项状态切换
    if(self.currentIndex!=preSelectIndex){
        UIButton *preSelectBtn=(UIButton *)[self.scrollBar viewWithTag:(startTag+preSelectIndex)];
        if(preSelectBtn){
            preSelectBtn.selected=NO;
        }
        
        UIButton *selectBtn=(UIButton *)[self.scrollBar viewWithTag:(startTag+self.currentIndex)];
        if(selectBtn){
            selectBtn.selected=YES;
        }
        
        preSelectIndex=self.currentIndex;
    }
}

/**
 *  底部Line滑动动画操作
 *
 */
- (void)moveSplitLineNewPosition{
    ScrollerBarItem * currentItem=self.scrollerBarItems[self.currentIndex];;
    [UIView animateWithDuration:0.2 animations:^{
        self.underLine.frame=CGRectMake(currentItem.underLineOffsetX, self.barItemHeight, currentItem.underLineWidth, self.underLineHeight);
    } completion:^(BOOL finished) {
        [self splitExceedUpdateScrollBarOffset];
    }];
}

/**
 *  底部Line点击或者滑动动画到指定的位置后不在屏幕中的处理（移动到屏幕中：特殊情况，左边与右边）
 *
 */
-(void)splitExceedUpdateScrollBarOffset{
    ScrollerBarItem * currentItem=self.scrollerBarItems[self.currentIndex];;
    CGFloat offsetX=currentItem.offsetX;
    CGSize barSize=self.scrollBar.bounds.size;
    CGPoint offset=self.scrollBar.contentOffset;
    CGFloat newOffsetX=0;
    
    if((offsetX+currentItem.validWidth)>(barSize.width+offset.x)){
        //超出右边
        newOffsetX=(offsetX+currentItem.validWidth)-barSize.width;
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollBar.contentOffset=CGPointMake(newOffsetX, 0);
        }];
        
    }else if(offsetX<offset.x){
        //超出左边
        newOffsetX=offsetX;
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollBar.contentOffset=CGPointMake(newOffsetX, 0);
        }];
    }
}


-(void)commandDelegate {
//      NSLog(@"%ld",(long)self.currentIndex);
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(scrollerBarViewController:didSelectItem:)]){
            [self.delegate performSelector:@selector(scrollerBarViewController:didSelectItem:) withObject:self withObject:self.scrollerBarItems[self.currentIndex]];
        }
    }
}

#pragma mark- UIScrollViewDelegate

/**
 *  滚动中
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //防止滚动结束后设置contentoffset触发的响应
    if(scrollView==self.scrollContent&&isMoving){
        
        CGFloat scrollW=scrollView.bounds.size.width;
        CGFloat scrollOffsetX=scrollView.contentOffset.x;
        
        CGFloat disX=(startContentOffsetX-scrollOffsetX);
        
        NSInteger nextIndex=self.currentIndex;
        
        if(disX>0){
            //右滑 nexIndex -
            if(nextIndex>0){
                nextIndex-=ceilf(disX/scrollW);
            }
        }else if(disX<0){
            //左滑 nextIndex ＋
            if(nextIndex<(self.scrollerBarItems.count-1)){
                nextIndex+=ceilf(-disX/scrollW);;
            }
        }
        
        //注意：最重要的地方
        ScrollerBarItem * nextItem;
        if(nextIndex>self.scrollerBarItems.count-1){
         ScrollerBarItem * mid=self.scrollerBarItems[self.scrollerBarItems.count-1];
            nextItem=[[ScrollerBarItem alloc]initWithTtile:@"" width:mid.width underLineWidth:mid.underLineWidth viewController:nil];
            nextItem.validWidth=mid.validWidth;
            nextItem.offsetX=mid.offsetX+mid.validWidth;
        }else if(nextIndex<0){
            ScrollerBarItem * mid=self.scrollerBarItems[0];
            nextItem=[[ScrollerBarItem alloc]initWithTtile:@"" width:mid.width underLineWidth:mid.underLineWidth viewController:nil];
            nextItem.validWidth=mid.validWidth;
            nextItem.offsetX=mid.offsetX-mid.validWidth;
        } else{
             nextItem=self.scrollerBarItems[nextIndex];
        }
       
        NSInteger currIndex=self.currentIndex;
        if(labs((nextIndex-self.currentIndex))>1){
            if(disX>0){
                currIndex=nextIndex+1;
            }
            if(disX<0){
                currIndex=nextIndex-1;
            }
        }
        
       
        ScrollerBarItem * currentItem=self.scrollerBarItems[currIndex];
        CGRect newFrame=CGRectMake(currentItem.underLineOffsetX, self.barItemHeight,currentItem.underLineWidth , self.underLineHeight);

        //计算x与width的比例变化值
        CGFloat splitDisX=0;
        CGFloat disCount=disX/scrollW;
    
        CGFloat dis=disX;
        if(disCount>1){
            if(disCount==(CGFloat)((NSInteger)disCount)){
                dis=disX-(NSInteger)(disCount-1)*scrollW;
            }else{
                 dis=disX-(NSInteger)disCount*scrollW;
            }
        }else if(disCount<-1){
            
            if(disCount==(CGFloat)((NSInteger)disCount)){
                dis=disX-(NSInteger)(disCount+1)*scrollW;
            }else{
                dis=disX-(NSInteger)disCount*scrollW;
            }
        }
        
        if(nextIndex>self.currentIndex){
           splitDisX=-dis/scrollW*(nextItem.underLineOffsetX-currentItem.underLineOffsetX);
        }else if(nextIndex<self.currentIndex){
            splitDisX=-dis/scrollW*(currentItem.underLineOffsetX-nextItem.underLineOffsetX);
        }
        
        CGFloat splitDisW=fabs(dis)/scrollW*(nextItem.underLineWidth-currentItem.underLineWidth);
        newFrame.origin.x=newFrame.origin.x+splitDisX;
        newFrame.size.width=newFrame.size.width+splitDisW;
        self.underLine.frame=newFrame;
     
//        NSLog(@"currentIndex:%ld,nextIndex:%ld,%f:%f:%f,frame:%@",currIndex,nextIndex,dis,disX,disCount,NSStringFromCGRect(newFrame));
    }
}

/**
 *  开始滚动
 *
 *  @param scrollView
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(scrollView==self.scrollContent){
        if(isMoving==NO){
             ScrollerBarItem * item=self.scrollerBarItems[self.currentIndex];
            [item.viewController.view endEditing:YES];
            isMoving=YES;
            startContentOffsetX=scrollView.contentOffset.x;
        }
    }
 }

/**
 *  滚动结束
 *
 *  @param scrollView
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView==self.scrollContent){
        isMoving=NO;
        NSInteger preIndex=self.currentIndex;
        self.currentIndex=self.scrollContent.contentOffset.x/self.scrollContent.bounds.size.width;
        [self barItemSelectedUpdate];
        [self splitExceedUpdateScrollBarOffset];
        [self loadChildView];
        if(preIndex!=self.currentIndex){
            [self commandDelegate];
        }

    }
}


@end
