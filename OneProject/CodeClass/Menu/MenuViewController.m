//
//  MenuViewController.m
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "MenuViewController.h"
#import "DDMenuController.h"//第三方抽屉控制器
#import "ReadViewController.h"
#import "RadioViewController.h"
#import "TopicViewController.h"
#import "GoodProductViewController.h"
#import "UIButton+Action.h"//自己封装的button
#import "LoginViewController.h"
#import "RegisterViewController.h"
//引入程序代理类
#import "AppDelegate.h"
#import "DownLoldController.h"
@interface MenuViewController ()

@property (nonatomic, strong) NSArray *listArray;//菜单栏列表

//声明头像
@property (nonatomic, strong)UIImageView *headerImageView;
//声明登录注册按钮（放在一起，一旦点击进入登录界面，登录界面有按钮跳转到注册）
@property (nonatomic, strong)UIButton *loginButton;
//下载
@property (nonatomic, strong)UIButton *downLoadButton;
//喜欢（收藏）
//@property (nonatomic, strong)UIButton *likeButton;
@property (nonatomic, strong)UIView *rootView;

@end

@implementation MenuViewController

#pragma mark -- 视图即将出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   //假设登陆成功
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"uid"]) {
        //那登录注册按钮上应该显示的是用户名
        [self.loginButton setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"uname"] forState:UIControlStateNormal];
        //取出头像
        [self.headerImageView setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"icon"]]];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //给数组开空间
    self.listArray = [NSArray arrayWithObjects:@"阅读", @"电台", @"话题", @"良品", nil];
    //注册cell(xib注册nib，storyboard不用注册，但是要设置重用标识符)
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"menuCell"];
    self.tableView.scrollEnabled = YES;
    // 摆放空间 ***************
    self.rootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 110)];
    self.rootView.backgroundColor  = [UIColor lightGrayColor];
    self.tableView.tableHeaderView = self.rootView;
    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, 50, 50)];
    self.headerImageView.layer.cornerRadius = 25;//切圆角
    self.headerImageView.layer.masksToBounds = YES;
   // self.headerImageView.backgroundColor = [UIColor greenColor];
    self.headerImageView.image = [UIImage imageNamed:@"pjoto.png"];

    [self.rootView addSubview:self.headerImageView];
    
    //登录注册按钮
    self.loginButton = [UIButton setButtonWithFrame:CGRectMake(80, 30, 100, 30) title:@"登录|注册" target:self action:@selector(handLeloginButtonAction:)];
    self.loginButton.backgroundColor = [UIColor clearColor];
    [self.rootView addSubview:self.loginButton];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //下载按钮
    self.downLoadButton = [UIButton setButtonWithFrame:CGRectMake(80, 60, 80, 30) title:@"下载" target:self action:@selector(handleDownLoadButtonAction:)];
    self.downLoadButton.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rootView addSubview:self.downLoadButton];
    //喜欢按钮
 //   self.likeButton = [UIButton setButtonWithFrame:CGRectMake(160, 60, 50, 30) title:@"收藏" target:self action:@selector(handleLikeButtonAction:)];
 //   self.likeButton.backgroundColor = [UIColor clearColor];
 //   [self.rootView addSubview:self.likeButton];
    
}

#pragma mark -- 按钮方法实现
//登录注册
- (void)handLeloginButtonAction:(UIButton *)sender {
    //一按钮  要做两种功能  登录或者退出登录
    //利用用户的uid来判断的当前按钮的状态（因为只有登录成功的用户的有uid）
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"uid"]) {
        //弹出提示框 提示用户 要退出登录
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出"preferredStyle:UIAlertControllerStyleAlert];
       
        //  取消事件
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        //  确定事件
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          //一旦点击确定，意味着退出登录 那么删除沙盒中的用户信息
            [userDefaults removeObjectForKey:@"icon"];
            [userDefaults removeObjectForKey:@"uid"];
            [userDefaults removeObjectForKey:@"uname"];
            [userDefaults removeObjectForKey:@"coverimg"];
            [userDefaults removeObjectForKey:@"auth"];
            
            //并且将按钮标题重新置为登录|注册
            [sender setTitle:@"登录|注册" forState:UIControlStateNormal];

            
        }];
        [control addAction:cancel];
        [control addAction:confirm];
        //  弹出警示框
        [self presentViewController:control animated:YES completion:nil];
        self.headerImageView.image = nil;
       
    }else{
        //此时uid不存在  那意味着用户没有登录
        //跳转到登录界面
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.view.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
    }
 
}
//下载
- (void)handleDownLoadButtonAction:(UIButton *)sender {
       DownLoldController *downLoadVC = [[DownLoldController alloc]init];
//模态跳转
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:downLoadVC];
     [self presentViewController:naVC animated:YES completion:nil];
}
/*
//收藏
- (void)handleLikeButtonAction:(UIButton *)sender{
    
}
 */
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    //给cell赋值
    cell.textLabel.text = [self.listArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark -- 关键，cell的点击事件.
//点击不同cell 进入不同的控制器中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //先获取跟控制器 DDMenuViewController
    DDMenuController *menuViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).ddMenuController;
    //通过判断cell的下标.来确定应该进入那一个控制器
    switch (indexPath.row) {
        case 0:
        {
            ReadViewController *readVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateInitialViewController];
            //导航控制器
            UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:readVC];
            
            //将readVC设置为根视图控制器
            [menuViewController setRootController:navigation animated:YES];
        }
            break;
        case 1:
        {
            RadioViewController *redioVC = [[RadioViewController alloc]init];
            //导航控制器
            UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:redioVC];
            //设置为DDMenu为根视图控制器
            [menuViewController setRootController:naVC animated:YES];
        }
            break;
        case 2:
        {
            TopicViewController *topicVC = [[TopicViewController alloc]init];
            //导航控制器
            UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:topicVC];
            //设置为DDMenu为根视图控制器
            [menuViewController setRootController:naVC animated:YES];
        }
            break;
        case 3:
        {
            GoodProductViewController *goodProductVC = [[GoodProductViewController alloc]init];
            //导航控制器
            UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:goodProductVC];
            //设置为DDMenu为根视图控制器
            [menuViewController setRootController:naVC animated:YES];
        }
            break;
        default:
            break;
    }
}






/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
