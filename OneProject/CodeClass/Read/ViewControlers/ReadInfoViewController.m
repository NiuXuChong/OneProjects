//
//  ReadInfoViewController.m
//  OneProject
//
//  Created by lanouhn on 16/4/26.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "ReadInfoViewController.h"
#import "commentViewController.h"//评论界面
#import "LoginViewController.h"//登录界面
//引入代理类
#import "AppDelegate.h"
//引入模型
#import "UserLikerModel.h"
//引入友盟
#import "UMSocial.h"
@interface ReadInfoViewController ()<UIWebViewDelegate, UMSocialUIDelegate>
@property (nonatomic, strong)UIWebView *myWebView;
@property (nonatomic, strong)NSString *str;


@end

@implementation ReadInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//创建对象
    self.myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [self.view addSubview:self.myWebView];
    //重点
    //1.自适应屏幕大小
    [self.myWebView sizeToFit];
    //2.设置代理对象
    self.myWebView.delegate = self;
   
    //数据请求
    [self requestData];
    // *******************************
    //收藏
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStyleDone target:self action:@selector(collectAction:)];
    //分享 和 评论
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(shareAction:)];
    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc]initWithTitle:@"评论" style:UIBarButtonItemStyleDone target:self action:@selector(commentAction:)];
    
    self.navigationItem.rightBarButtonItems = @[collectItem, shareItem, commentItem];
//    ********************收藏查询 ******************
    //1.先获取上下文管理器
    NSManagedObjectContext *managerObjectContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    //创建查询请求对象
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"UserLikerModel"];
    //2.设置谓词（查询单条数据）
    
    //NSLog(@"readid:%@,name:%@",)
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"readid == %@ and uname == %@", self.tempModel.readId, self.tempModel.name];
    //3.将谓词给查询对象
    fetchRequest.predicate = predicate;
    //4.获取查询结果
    NSArray *array = [managerObjectContext executeFetchRequest:fetchRequest error:nil];
    if ([array firstObject]) {
        collectItem.title = @"已收藏";
    }else{
        collectItem.title = @"收藏";
    }

    
}
#pragma mark -- collectItem 收藏
- (void)collectAction:(UIBarButtonItem *)sender {
//    先获取上下文管理器
    NSManagedObjectContext *managerObjectContext = ((AppDelegate *) [UIApplication sharedApplication].delegate).managedObjectContext;
    if ([sender.title isEqualToString:@"已收藏"]) {
//        代表已经收藏过 那么该删除数据了
//        删除数据
//        1.查询这张表,创建查询请求对象
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"UserLikerModel"];
//        2.设置谓词（查询当条数据)
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"readid == %@ and uname = %@", self.tempModel.readId, self.tempModel.name];
//        3.将谓词赋值给查询对象
        fetchRequest.predicate = predicate;
//        4.获取查询结果
        NSArray *array = [managerObjectContext executeFetchRequest:fetchRequest error:nil];
//        5.删除数据
        [managerObjectContext deleteObject:[array firstObject]];
//        6.刷新数据库
        [managerObjectContext save:nil];
//        7.将sender的title设置为收藏
        sender.title = @"收藏";
    }else{
//        没有收藏过.要添加数据（title=收藏）
//        添加数据
        UserLikerModel *likeModel = [NSEntityDescription insertNewObjectForEntityForName:@"UserLikerModel" inManagedObjectContext:managerObjectContext];
//        赋值操作
        likeModel.title = self.tempModel.title;
        likeModel.coverimg = self.tempModel.coverimg;
        likeModel.uname = self.tempModel.name;
        likeModel.readid = self.tempModel.readId;
        likeModel.content = self.tempModel.content;
        self.aStr = self.circleModel.url;
//        保存
        [managerObjectContext save:nil];
        
//        将title设置为取消收藏
        sender.title = @"已收藏";
    }
    
    
    
}
#pragma mark -- shareItem
- (void)shareAction:(UIBarButtonItem *)sender {
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAPPK shareText:@"" shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.tempModel.coverimg]]] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren, nil] delegate:self];
    
    
    
    
}
#pragma mark -- commentItem
- (void)commentAction:(UIBarButtonItem *)sender {
    NSLog(@"评论");
    //想要进入评论界面  就要判断auth这个值是否存在，他是登录成功后的返回值.并且我们已经做过存储到沙河的操作.所以，如果辞职存在 就评论，不在的话就跳转到登录界面
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"auth"]) {
        //存在 就跳转到评论界面
        commentViewController *commentVC = [[commentViewController alloc]init];
        //属性传值
        
        commentVC.tempDetailModel = self.tempModel;
        commentVC.commentstr = self.circleModel.url;
        
        UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:commentVC];
        [self.view.window.rootViewController presentViewController:naVC animated:YES completion:nil];
    }else {
        //跳转到登录界面
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.view.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
        
        
    }
}



#pragma mark -- 网络请求
- (void)requestData {
    
    if (self.tempModel.readId == nil) {
        self.str = self.circleModel.url;
    }else{
        self.str = self.tempModel.readId;
    }
    
    [NetworkingManager requestPOSTWithUrlString:kReadInfoURL parDic:@{@"contentid":self.str} finish:^(id responseObject) {
        //一旦拿到数据 开始赋值给web
        
             [self.myWebView loadHTMLString:[[responseObject objectForKey:@"data"] objectForKey:@"html"] baseURL:nil];
        
        
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
#pragma mark -- 实现web代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *str=[NSString stringWithFormat:@"var script = document.createElement('script');"
                "script.type = 'text/javascript';"
                "script.text = \"function ResizeImages() { "
                "var myimg,oldwidth;"
                "var maxwidth =%f;"// UIWebView中显示的图片宽度
                 "for(i=0;i <document.images.length;i++){"
                   "myimg = document.images[i];"
                   "if(myimg.width > maxwidth){"
                   "oldwidth = myimg.width;"
                    "myimg.width = maxwidth;"
                   "}"
"}"
                    "}\";"
                  "document.getElementsByTagName('head')[0].appendChild(script);",self.view.frame.size.width-15];
  [webView stringByEvaluatingJavaScriptFromString:str];
  [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    
}

@end
