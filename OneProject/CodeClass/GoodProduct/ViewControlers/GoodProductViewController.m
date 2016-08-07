//
//  GoodProductViewController.m
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "GoodProductViewController.h"
#import "GoodProductModel.h"
#import "GoodProductCell.h"
#import "ProductViewController.h"
@interface GoodProductViewController ()<UITableViewDataSource, UITableViewDelegate>

//声明集合视图属性
@property (nonatomic, strong)UITableView *tableView;
//良品列表数据源
@property (nonatomic, strong)NSMutableArray *GoodProductArray;


@end

@implementation GoodProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    self.GoodProductArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self requestData];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodProductCell" bundle:nil] forCellReuseIdentifier:@"goodCell"];
}

#pragma mark -- 请求数据
- (void)requestData {
    //使用封装好的网络请求
    [NetworkingManager requestGETWithUrlString:kGoodPlantURL parDic:nil finish:^(id responseObject) {
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
        GoodProductModel *listModel = [[GoodProductModel alloc]init];
        [listModel setValuesForKeysWithDictionary:dic];
        [self.GoodProductArray addObject:listModel];
    }
    //刷新界面
    [self.tableView reloadData];
}

#pragma mark -- 配置单元格
//单元格数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.GoodProductArray.count;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}
//配置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodCell" forIndexPath:indexPath];
    //取出对应的model
    GoodProductModel *tempModel = [self.GoodProductArray objectAtIndex:indexPath.row];
    //给cell赋值
    cell.titleLabel.text = tempModel.title;
    cell.titleLabel.font = [UIFont systemFontOfSize:23];
    NSURL *url = [NSURL URLWithString:tempModel.coverimg];
    [cell.coverImageView setImageWithURL:url];
    
    return cell;
}
//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell
    ProductViewController *productVC = [[ProductViewController alloc]init];
    //属性传值
    productVC.goodModel = [self.GoodProductArray objectAtIndex:indexPath.row];
    productVC.str = productVC.goodModel.contentid;
    //跳转界面
    [self.navigationController pushViewController:productVC animated:YES];
}


@end
