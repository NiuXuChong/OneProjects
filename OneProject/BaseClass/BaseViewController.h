//
//  BaseViewController.h
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <UIKit/UIKit.h>
//基类中，编写公共性功能
//1.网络活动指示器
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController

//活动指示器对象
@property (nonatomic, strong) MBProgressHUD *HUD;
//显示对象
- (void)showProgressHUD;
//隐藏对象
- (void)hideProgressHUD;
//可以显示带有文字的加载对象（默认只有小菊花）
- (void)showProgressHUDWithString:(NSString *)title;

@end
