//
//  TopicViewController.m
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicListModel.h"
#import "aImageCell.h"
#import "CustomCell.h"
#import "TopicInfoViewController.h"
@interface TopicViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *TopicArray;


@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    self.TopicArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self requestData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"aImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"aImageCell"];
   [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CustomCell"];
    
}
#pragma mark -- 请求数据
- (void)requestData {
   //使用封装好的网络请求
    [NetworkingManager requestGETWithUrlString:kTopicListURL parDic:nil finish:^(id responseObject) {
       //开始解析数据
        [self handleParserDataWithResponse:responseObject];
        
    } error:^(NSError *error) {
    }];
}

//封装解析数据
- (void)handleParserDataWithResponse:(id)data {
    //封装视图列表数据源
    NSArray *listArray = [[data objectForKey:@"data"]objectForKey:@"list"];
    for (NSDictionary *dic in listArray) {
        //封装模型
        TopicListModel *listModel = [[TopicListModel alloc]init];
        [listModel setValuesForKeysWithDictionary:dic];
        [self.TopicArray addObject:listModel];
    }
    //刷新界面
    [self.tableView reloadData];
}

#pragma mark -- 配置单元格
//单元格数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.TopicArray.count;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}

//给cell赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicListModel *tempModel = [self.TopicArray objectAtIndex:indexPath.row];
    if (tempModel.coverimg.length == 0) {
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
        //给cell赋值
        cell.viewLabel.text = [NSString stringWithFormat:@"%@", [tempModel.counterList objectForKey:@"view"]];
        cell.titleLabel.text = tempModel.title;
        cell.conmentLabel.text =[NSString stringWithFormat:@"%@",[tempModel.counterList objectForKey:@"comment"]];
        cell.likeLabel.text = [NSString stringWithFormat:@"%@", [tempModel.counterList objectForKey:@"like"]];
        cell.unameLabel.text = [NSString stringWithFormat:@"%@", [tempModel.userinfo objectForKey:@"uname"]];
        cell.contentLabel.text = tempModel.content;
        
        return cell;
    }else {
        aImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aImageCell" forIndexPath:indexPath];
        //给cell赋值
        cell.viewLabel.text = [NSString stringWithFormat:@"%@", [tempModel.counterList objectForKey:@"view"]];
        cell.titleLabel.text = tempModel.title;
        cell.conmentLabel.text =[NSString stringWithFormat:@"%@",[tempModel.counterList objectForKey:@"comment"]];
        cell.likeLabel.text = [NSString stringWithFormat:@"%@", [tempModel.counterList objectForKey:@"like"]];
        cell.unameLabel.text = [NSString stringWithFormat:@"%@", [tempModel.userinfo objectForKey:@"uname"]];
        cell.contentLabel.text = tempModel.content;
        NSURL *url = [NSURL URLWithString:tempModel.coverimg];
        [cell.coverimgView setImageWithURL:url];

        return cell;
    }
}

//cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell跳转界面
    TopicInfoViewController *topicInfoVC = [[TopicInfoViewController alloc]init];
    topicInfoVC.topicModle = [self.TopicArray objectAtIndex:indexPath.row];
    topicInfoVC.str = topicInfoVC.topicModle.contentid;
    [self.navigationController pushViewController:topicInfoVC animated:YES];
    
    
}

@end
