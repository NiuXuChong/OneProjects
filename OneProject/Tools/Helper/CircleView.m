//
//  CircleView.m
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "CircleView.h"
#import "UIImageView+AFNetworking.h"

//延展部分.用于定义私有属性.不必要向外界暴漏的
@interface CircleView ()<UIScrollViewDelegate>
//滑动视图属性
@property (nonatomic, strong)UIScrollView *myScrollView;
//页码控件
@property (nonatomic,strong)UIPageControl *myPageControl;
//定时器
@property (nonatomic,strong)NSTimer *myTimer;
//image数组
@property (nonatomic, strong)NSMutableArray *imageURLArray;
//时间
@property (nonatomic, assign)NSTimeInterval timeInterval;


@end
@implementation CircleView
//初始化方法
- (id)initWithImageURLArray:(NSMutableArray *)imageURLArray changeTime:(NSTimeInterval)timeIntervar withFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //给属性赋值.只是为了方便全局访问
        self.imageURLArray = imageURLArray;
        //时间赋值
        self.timeInterval = timeIntervar;
        //创建新数组，开辟空间，并且在另外插入第一个对象和最后一个对象
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray addObject:[imageURLArray lastObject]];
        [tempArray addObjectsFromArray:imageURLArray];
        [tempArray addObject:[imageURLArray firstObject]];
        //展示图片（封装方法）
        [self scrollViewWithImageURLArray:tempArray];
        //封装定时器方法
        [self initWithTimer];
        
        
    }
    return self;
}

#pragma mark -- 定时器方法
- (void)initWithTimer {
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

//定时器方法实现
- (void)timerAction:(NSTimer *)timer {
    if (self.myScrollView.contentOffset.x/kDeviceWidth == self.imageURLArray.count + 1) {
        
        [self.myScrollView setContentOffset:CGPointMake(kDeviceWidth , 0)];
    }
    [self.myScrollView setContentOffset:CGPointMake(self.myScrollView.contentOffset.x + kDeviceWidth, 0) animated:YES];
}

//关闭定时器
- (void)removeTime{
    [self.myTimer invalidate];//定时器失效
    self.myTimer = nil;
}





#pragma mark - - 展示图片
- (void)scrollViewWithImageURLArray:(NSMutableArray *)imageURLArray {
    self.myScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    //设置内容区域大小
    self.myScrollView.contentSize = CGSizeMake(imageURLArray.count *self.bounds.size.width, self.bounds.size.height);
    //设置默认显示的图片（需要偏移一个屏幕的宽度）
    self.myScrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    //设置代理
    self.myScrollView.delegate = self;
    //设置整屏滚动
    self.myScrollView.pagingEnabled = YES;
    //添加到视图上
    [self addSubview:self.myScrollView];
    //开始循环遍历.添加图片
    for (int i = 0; i < imageURLArray.count; i++) {
      UIImageView *aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width * i, 0, self.bounds.size.width, self.bounds.size.height)];
        //请求图片，并放在aImageView上
        NSURL *url = [NSURL URLWithString:imageURLArray[i]];
        [aImageView setImageWithURL:url];
        //给aImageView添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        //打开用户交互
        aImageView.userInteractionEnabled = YES;
        //添加手势到aImageView上
        [aImageView addGestureRecognizer:tap];
        //将aImageView添加到滑动视图上
        [self.myScrollView addSubview:aImageView];
        
    }
    //小圆点
    self.myPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.bounds.size.width - 100, self.bounds.size.height - 30, 100, 30)];
    self.myPageControl.numberOfPages = self.imageURLArray.count;
    //添加到视图上
    [self addSubview:self.myPageControl];
    
}
#pragma mark -- 实现轻拍手势
- (void)tapAction:(UIGestureRecognizer *)tap {
    //调用block.为了把当前被点击的图片的下标传递到控制器上
    if (self.tapActionBlock) {
        self.tapActionBlock(self.myPageControl.currentPage);
    }
}
#pragma mark -- UIScrollViewDelegate
//只要发生滑动就会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
    //给pageControl赋值
    NSInteger tempNumber = scrollView.contentOffset.x / self.myScrollView.frame.size.width;
    
    self.myPageControl.currentPage = tempNumber - 1;
    
    
}
//将要拖拽的时候.需要将计时器暂停

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   //定时器暂停
    [self.myTimer setFireDate:[NSDate distantFuture]];
    
    
}
//减速结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //更改动画.对第一张或者最后一张做处理（封装）
    [self headerAndFooterChangeImage];
    //重新开启计时器
    [self.myTimer setFireDate:[[NSDate alloc]initWithTimeIntervalSinceNow:self.timeInterval]];
    
    
    
   
    
    
}
#pragma mark -- 封装第一张和最后一张的处理方法
- (void)headerAndFooterChangeImage {
    //如果是第一张
    if (self.myScrollView.contentOffset.x == 0) {
        [self.myScrollView setContentOffset:CGPointMake(self.myScrollView.frame.size.width *self.imageURLArray.count, 0)];
    }
    //跳转到第一张上
    if (self.myScrollView.contentOffset.x == self.myScrollView.frame.size.width * (self.imageURLArray.count + 1)) {
        [self.myScrollView setContentOffset:CGPointMake(self.myScrollView.frame.size.width, 0)];//不要动画
    }
}
#pragma  mark -- 滑动结束
//针对定时器自东滑动结束处理第一张和最后一张
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self headerAndFooterChangeImage];
}






@end