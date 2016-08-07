//
//  LoginViewController.m
//  OneProject
//
//  Created by lanouhn on 16/4/28.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
//视图即将出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //如果保存了账号和密码.就让账号密码填充到输入框内
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        self.userNameTF.text = [userDefault objectForKey:@"userName"];
        self.passwordTF.text = [userDefault objectForKey:@"password"];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
//配置，默认情况输入框上没有字符串的.并且密码输入框加密
    self.userNameTF.text = @"";
    self.passwordTF.text = @"";
    self.passwordTF.secureTextEntry = YES;//密码加密
    
    
    
    
}
//登录按钮事件
- (IBAction)loginButtonAction:(UIButton *)sender {
    //需要将账号密码发送给服务器
    [NetworkingManager requestPOSTWithUrlString:KLoginUrl parDic:@{@"email":self.userNameTF.text,@"passwd":self.passwordTF.text} finish:^(id responseObject) {
        //登陆成功后.接收并且解析服务器返回的数据.并且存储  方便进行下次调用接口时作为参数使用（比如评论、收藏等都需要用户信息作为参数）
        NSDictionary *dic = [responseObject objectForKey:@"data"];
        //存储到沙盒中
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[dic objectForKey:@"auth"] forKey:@"auth"];
        [userDefaults setObject:[dic objectForKey:@"coverimg"] forKey:@"coverimg"];
        [userDefaults setObject:[dic objectForKey:@"icon"] forKey:@"icon"];
        [userDefaults setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
        [userDefaults setObject:[dic objectForKey:@"uname"] forKey:@"uname"];
        //最后一步.同步到沙盒中
        [userDefaults synchronize];
        
        //返回上一界面
        [self dismissViewControllerAnimated:YES completion:nil];
    } error:^(NSError *error) {
        //打印错误信息
    }];
    
}

//注册按钮事件
- (IBAction)rehisterButtonAction:(UIButton *)sender {
    //使用模态跳转到注册界面
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self presentViewController:registerVC animated:YES completion:nil];
    
}
//返回抽屉界面
- (IBAction)cancleButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
