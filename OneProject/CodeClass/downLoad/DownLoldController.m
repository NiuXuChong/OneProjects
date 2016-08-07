//
//  DownLoldController.m
//  OneProject
//
//  Created by lanouhn on 16/5/5.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "DownLoldController.h"
#import "DownLoadCell.h"
#import "DownLoadManager.h"
#import "AppDelegate.h"
@interface DownLoldController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)AppDelegate *myApp;//程序代理类

@property (nonatomic, strong)UILabel *playLabel;

@end

@implementation DownLoldController


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [DownLoadManager sharedDownManager].dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    RadioDetailModel *model = [[RadioDetailModel alloc]init];
    model = [[DownLoadManager sharedDownManager].dataArray objectAtIndex:indexPath.row];
    //给cell赋值
    cell.unameLabel.text = [[model.playInfo objectForKey:@"authorinfo"] objectForKey:@"uname"];
    cell.titleLabel.text = model.title;
    NSURL *url = [NSURL URLWithString:model.coverimg];
    [cell.coverimg setImageWithURL:url];
    [model setProgressBlock:^(float progress) {
        if (progress != 1.0) {
            cell.downLoadLabel.text = [NSString stringWithFormat:@"%.2f%%", progress *100];
        }else{
            cell.downLoadLabel.text = @"";
            
        }

    }];
    return cell;
}
/*
//cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cathPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *musicPath = [cathPath stringByAppendingPathComponent:@"MyMp3"];
    RadioDetailModel * musicModel = [self.downLoldArray objectAtIndex:indexPath.row];
    //创建文件夹要存储的路径
    NSString *filePath = [musicPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",musicModel.title]];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [[AVPlayManager sharedAVPlayManager] setPlayAVPlayerUrl:url];    
    if (a == 1) {
        [[AVPlayManager sharedAVPlayManager]play];
        a = 0;
    }else{
        [[AVPlayManager sharedAVPlayManager]pause];
        a = 1;
    }
 
}
*/

//返回菜单
- (void)liftItemAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

 int a = 1;

- (void)viewDidLoad {
   
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.myApp = [UIApplication sharedApplication].delegate;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    [self.tableView registerNib:[UINib nibWithNibName:@"DownLoadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
//设置代理对象
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(liftItemAction:)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
