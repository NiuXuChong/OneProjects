//
//  CircleView.h
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *数组参数
 *frame
 *时间
 *
 */
@interface CircleView : UIView

//轮播图的初始化方法
- (id)initWithImageURLArray:(NSMutableArray *)imageURLArray changeTime:(NSTimeInterval)timeIntervar withFrame:(CGRect)frame;
//释放定时器（关闭）
- (void)removeTime;
//轻拍手势.点击时间的回调
@property (nonatomic, copy) void(^tapActionBlock)(NSInteger pageIndex);




@end
