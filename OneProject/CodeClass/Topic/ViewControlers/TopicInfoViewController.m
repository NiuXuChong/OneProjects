//
//  TopicInfoViewController.m
//  OneProject
//
//  Created by lanouhn on 16/4/26.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "TopicInfoViewController.h"
#import "UMSocial.h"
@interface TopicInfoViewController ()<UIWebViewDelegate, UMSocialUIDelegate>
@property (nonatomic, strong)UIWebView *myWebView;


@end

@implementation TopicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建对象
    self.myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [self.view addSubview:self.myWebView];
    //自适应屏幕大小
    [self.myWebView sizeToFit];
    //设置代理对象
    self.myWebView.delegate = self;
    [self requestData];
    // *******************************
    //收藏
    /*
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStyleDone target:self action:@selector(collectAction:)];
     */
    //分享 和 评论
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(shareAction:)];
 /*   UIBarButtonItem *commentItem = [[UIBarButtonItem alloc]initWithTitle:@"评论" style:UIBarButtonItemStyleDone target:self action:@selector(commentAction:)];
   */
    self.navigationItem.rightBarButtonItem = shareItem;

}
/*
#pragma mark -- collectItem
- (void)collectAction:(UIBarButtonItem *)sender {
    
}
 */
#pragma mark -- shareItem
- (void)shareAction:(UIBarButtonItem *)sender {
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAPPK shareText:@"" shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.topicModle.coverimg]]] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren, nil] delegate:self];
    

}
/*
#pragma mark -- commentItem
- (void)commentAction:(UIBarButtonItem *)sender {
    
}
 */
#pragma mark -- 数据请求
- (void)requestData {
    
    [NetworkingManager requestPOSTWithUrlString:kReadInfoURL parDic:@{@"contentid":self.str} finish:^(id responseObject) {
        //铺数据
        [self.myWebView loadHTMLString:[[responseObject objectForKey:@"data"] objectForKey:@"html"] baseURL:nil];
        
    } error:^(NSError *error) {
    }];
    
}


#pragma mark - - 实现web代理方法
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
