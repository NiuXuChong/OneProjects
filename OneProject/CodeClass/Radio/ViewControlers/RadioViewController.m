//
//  RadioViewController.m
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioListModel.h"
#import "RadioCircleModel.h"
#import "RadioListCell.h"
#import "RadioDetailViewController.h"
#import "UIImageView+AFNetworking.h"


@interface RadioViewController ()<UITableViewDataSource, UITableViewDelegate>

//声明集合视图属性
@property (nonatomic, strong)UITableView *tableView;
//轮播图数据源
@property (nonatomic, strong)NSMutableArray *circlrImageArray;
//电台列表数据源
@property (nonatomic, strong)NSMutableArray *radioListArray;
//将轮播图声明为属性
@property (nonatomic, strong)CircleView *circleView;
//@property (nonatomic, assign)BOOL isDown;
//用于上拉加载更多数据的属性
@property (nonatomic, assign)NSInteger aStar;
@end
BOOL aisDown = YES;//向下刷新
@implementation RadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    //开辟数据源
    self.circlrImageArray = [NSMutableArray array];
    self.radioListArray = [NSMutableArray array];
    //请求数据方法
    [self requestData];
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"radioCell"] ;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView headerBeginRefreshing];
    // ************ 刷新加载控件 ************
    //给加载数据的参数赋初始值
    self.aStar = 0;
    //添加两个头部刷新控件
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshWithRefreshViewType:LORefreshViewTypeHeaderDefault refreshingBlock:^{
       //下拉刷新
        //1请求最新的数据
        weakSelf.aStar = 9;
        //安全起见 清空数组放在数据请求之后 封装model之前
        aisDown = YES;
        
        //请求数据
        [weakSelf requestData];
      
    }];
    //添加尾部控件
    [self.tableView addRefreshWithRefreshViewType:LORefreshViewTypeFooterDefault refreshingBlock:^{
        aisDown = NO;
        weakSelf.aStar += 10;
        //请求数据
     
        [weakSelf requestUpdataWithRadioid:[NSString stringWithFormat:@"%ld", (long)weakSelf.aStar]];
    }];
    [self showProgressHUDWithString:@"玩命加载中"];
 
}
#pragma mark -- 加载网络请求
- (void)requestUpdataWithRadioid:(NSString *)radioid{
    [NetworkingManager requestPOSTWithUrlString:kRadioDownLoadURL parDic:@{@"start":radioid} finish:^(id responseObject) {
        [self handleParserDataWithResponseObject:responseObject];
        
    } error:^(NSError *error) {
        
    }];
     
}



//上啦加载解析数据
- (void)handleParserDataWithResponseObject:(id)responseObject {
    if (aisDown) {
        [self.radioListArray removeAllObjects];
    }
    NSArray *listArray = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
    
    for (NSDictionary *dic in listArray) {
        RadioListModel *listModel = [[RadioListModel alloc]init];
        [listModel setValuesForKeysWithDictionary:dic];
        //放进列表数据源数组中
        [self.radioListArray addObject:listModel];
    }
    [self.tableView reloadData];
    [self.tableView.defaultHeader endRefreshing];
    [self.tableView.defaultFooter endRefreshing];
}




#pragma mark -- 请求数据

- (void)requestData {
    //使用封装好的网络请求
    [NetworkingManager requestGETWithUrlString:kRadioListURL parDic:nil finish:^(id responseObject) {
        //开始解析数据
        [self handleParserDataWithResponse:responseObject];
        
    } error:^(NSError *error) {
    }];
}

//解析封装数据
- (void)handleParserDataWithResponse:(id)data {
    //先封装轮播图数据源
    NSArray *imageArray = [[data objectForKey:@"data"]objectForKey:@"carousel"];
    //创建临时数组，用于给轮播图传值
    NSMutableArray *urlImageArray = [NSMutableArray array];
    //遍历数组，封装model
    for (NSDictionary *dic in imageArray) {
        [urlImageArray addObject:[dic objectForKey:@"img"]];
        //封装model
        RadioCircleModel *circleModel = [[RadioCircleModel alloc]init];
        [circleModel setValuesForKeysWithDictionary:dic];//KVC赋值
        //把model放入数据源数组
        [self.circlrImageArray addObject:circleModel];
    }
    //遍历结束，轮播图url准备完毕
    //添加轮播图
    self.circleView = [[CircleView alloc]initWithImageURLArray:urlImageArray changeTime:1.5 withFrame:CGRectMake(0, 0, kDeviceWidth, 165)];
    //点击事件
    __weak typeof(self) weakSelf = self;
    self.circleView.tapActionBlock = ^(NSInteger pageIndex) {
// 周二上完read的之后在写
        RadioCircleModel *tempModel = [weakSelf.circlrImageArray objectAtIndex:pageIndex];
        RadioDetailViewController *radioDetailVC = [[RadioDetailViewController alloc]init];
        //字符串截取
        radioDetailVC.radioModel = [[RadioCircleModel alloc]init];
        radioDetailVC.radioModel.url = [[tempModel.url componentsSeparatedByString:@"/"]lastObject];
        radioDetailVC.aStr = radioDetailVC.radioModel.url;
        [weakSelf.navigationController pushViewController:radioDetailVC animated:YES];
        
    };
    //添加到根视图上
   // [self.view addSubview:self.circleView];
    self.tableView.tableHeaderView = self.circleView;
    //封装视图列表数据源
    NSArray *hotArray = [[data objectForKey:@"data"]objectForKey:@"hotlist"];
    if (aisDown == YES) {
        [self.radioListArray removeAllObjects];
    }
  
    //遍历数组
    for (NSDictionary *dic in hotArray) {
        //封装模型
        RadioListModel *listModel = [[RadioListModel alloc]init];
        [listModel setValuesForKeysWithDictionary:dic];
        [self.radioListArray addObject:listModel];
    }
    NSArray *listArray = [[data objectForKey:@"data"]objectForKey:@"alllist"];
    //遍历数组
        for (NSDictionary *dic in listArray) {
        //封装模型
        RadioListModel *listModel = [[RadioListModel alloc]init];
        [listModel setValuesForKeysWithDictionary:dic];
        [self.radioListArray addObject:listModel];
    }
    //刷新界面
    [self.tableView reloadData];
    [self hideProgressHUD];//停止玩命加载
    [self.tableView.defaultHeader endRefreshing];//停止刷新
}

#pragma mark -- UITableView
//单元格数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.radioListArray.count;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}


//配置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RadioListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"radioCell" forIndexPath:indexPath];
    //取出对应的model
    RadioListModel *tempModel = [self.radioListArray objectAtIndex:indexPath.row];
    //给cell赋值
    cell.titleLabel.text = tempModel.title;
    cell.countLabel.text = [NSString stringWithFormat:@"%@", tempModel.count];
    cell.descLabel.text = tempModel.desc;
    cell.unnameLabel.text = [tempModel.userinfo objectForKey:@"uname"];
    
    NSURL *url = [NSURL URLWithString:tempModel.coverimg];
    [cell.coverimg setImageWithURL:url];
    
    return cell;
}

//点击cell跳转界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RadioDetailViewController *radioDetailVC = [[RadioDetailViewController alloc]init];
    //属性传值
    radioDetailVC.radioListModel = [self.radioListArray objectAtIndex:indexPath.row];
    radioDetailVC.aStr = radioDetailVC.radioListModel.radioid;
    //跳转界面
    [self.navigationController pushViewController:radioDetailVC animated:YES];
 
}

- (void)dealloc {
    //移除观察者
    [self.tableView removeObserver:self.tableView.defaultFooter forKeyPath:@"contentSize"];
    [self.tableView removeObserver:self.tableView.defaultFooter forKeyPath:@"contentOffset"];
    [self.tableView removeObserver:self.tableView.defaultHeader forKeyPath:@"contentOffset"];
}












@end
