//
//  RegisterViewController.h
//  OneProject
//
//  Created by lanouhn on 16/4/28.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LoginViewController.h"

@interface RegisterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *unameTF;
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *boyButton;
@property (strong, nonatomic) IBOutlet UIButton *girlButton;
//声明gender属性 用来接收按钮事件结束后的性别
@property (nonatomic, assign)NSInteger gender;

//@property (nonatomic, strong)LoginViewController *loginViewC;

@end
