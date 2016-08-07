//
//  RegisterViewController.m
//  OneProject
//
//  Created by lanouhn on 16/4/28.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordTF.secureTextEntry = YES;
    
}
//返回登录
- (IBAction)cancleLoginButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//注册
- (IBAction)registerButtonAction:(UIButton *)sender {
 /*   self.loginViewC = [[LoginViewController alloc]init];
    if (self.userNameTF.text.length != 0 && self.userNameTF.text.length != 0 && self.passwordTF.text.length != 0) {
        
        self.loginViewC.userNameTF.text = self.userNameTF.text;
        self.loginViewC.passwordTF.text = self.passwordTF.text;
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
  */
    //将用户输入的个人信息发送给服务器
    [NetworkingManager requestPOSTWithUrlString:KRegisUrl parDic:@{@"email":self.userNameTF.text, @"passwd":self.passwordTF.text, @"gender":@(self.gender), @"uname":self.unameTF.text} finish:^(id responseObject) {
        //如果注册成功  就让注册界面收回 并且保存账号密码信息  方便用户登录使用
        //如果注册失败  就给出提示框，将后台返回给我们的信息  告诉用户.
        
        int result = [[responseObject objectForKey:@"result"] intValue];
        if (result == 1) {
            //注册成功，存储用户的账号和密码.（一般在登陆成功的时候存储uid 头像等个人信息）
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.userNameTF.text forKey:@"userName"];
            [userDefaults setObject:self.passwordTF.text forKey:@"password"];
            //保存
            [userDefaults synchronize];
            //返回上一级界面
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
        //注册失败
            NSString *aMessage = [[responseObject objectForKey:@"data"] objectForKey:@"msg"];
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:aMessage preferredStyle:UIAlertControllerStyleAlert];
                       //  取消事件
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                       [control addAction:cancel];
                    //  弹出警示框
            [self presentViewController:control animated:YES completion:nil];              
        }
      
    } error:^(NSError *error) {
        
    }];
}

//男
- (IBAction)boyButtonAction:(UIButton *)sender {
    sender.backgroundColor = [UIColor blueColor];//蓝色
    self.girlButton.backgroundColor = [UIColor whiteColor];
    self.gender = 0;//0代表男性
}
//女
- (IBAction)girlButtonAction:(UIButton *)sender {
    sender.backgroundColor = [UIColor blueColor];
    self.boyButton.backgroundColor = [UIColor whiteColor];
    self.gender = 1;//1代表女性
    
}


@end
