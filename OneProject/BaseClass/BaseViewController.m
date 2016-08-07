//
//  BaseViewController.m
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
//使用懒加载创建对象
- (MBProgressHUD *)HUD{
    if (_HUD == nil) {
        self.HUD = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_HUD];
    }
    return _HUD;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -- 显示loading
- (void)showProgressHUD {
    [self showProgressHUDWithString:nil];
   // [self.HUD show:YES];//调用第三方中的方法
}

#pragma mark -- 显示文字提醒的loading
- (void)showProgressHUDWithString:(NSString *)title{
    if (title.length == 0) {
        self.HUD.labelText = nil;
    }else{
        self.HUD.labelText = title;
    }
    //调用第三方显示loading
    [self.HUD show:YES];
    
}

//隐藏
- (void)hideProgressHUD{
    if (self.HUD != nil) {
        [self.HUD removeFromSuperview];//移除
        self.HUD = nil;
    }
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
