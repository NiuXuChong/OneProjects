//
//  KeyBoardTextView.h
//  OneProject
//
//  Created by lanouhn on 16/4/28.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyBoardTextViewDelegate <NSObject>
//代理对象需要实现的方法
- (void)keyBoardView:(UITextView *)aTextView;

@end

@interface KeyBoardTextView : UIView <UITextViewDelegate>
//声明代理属性
@property (nonatomic, assign)id<KeyBoardTextViewDelegate> delegate;
//声明属性
@property (nonatomic, strong)UITextView *textView;
//监测输入是否改变
@property (nonatomic, assign)BOOL isChange;

@end
