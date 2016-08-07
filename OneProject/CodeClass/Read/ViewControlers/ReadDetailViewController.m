//
//  ReadDetailViewController.m
//  OneProject
//
//  Created by lanouhn on 16/4/26.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "ReadDetailViewController.h"
#import "ReadDatileModel.h"
#import "ReadDatailCell.h"
#import "ReadInfoViewController.h"

@interface ReadDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

//声明两个表视图
//最新
@property (nonatomic, strong)UITableView *newsTableView;
//最热
@property (nonatomic, strong)UITableView *hotTableView;
//滑动视图
@property (nonatomic, strong)UIScrollView *rootScrollView;
//分栏控件
@property (nonatomic, strong)UISegmentedControl *segmentedControl;
//数据源数组****************
//最新数据源数组
@property (nonatomic, strong)NSMutableArray *newsDataArray;
//最热数据源数组
@property (nonatomic, strong)NSMutableArray *hotDataArray;

//用于上拉加载更多数据的属性
//服务于最新
@property (nonatomic, assign)NSInteger newStart;
//服务于最热
@property (nonatomic, assign)NSInteger hotStart;

@end

BOOL isDown = YES;//向下 刷新

@implementation ReadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.newsDataArray = [NSMutableArray array];
    self.hotDataArray = [NSMutableArray array];
    //封装添加表视图方法
    [self addScrollViewAndTableView];
    //关闭导航栏自适应高度的64高度
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //封装请求数据方法
    //最热的数据请求
    [self requestDataWithSort:@"hot"];
    //最新的数据请求
    [self requestDataWithSort:@"addtime"];
// ***************刷新加载控件 *************
    //给加载数据的参数赋初始值
    self.newStart = 0;
    self.hotStart = 0;
    //添加两个头部刷新控件
    __weak typeof(self)weakSelf = self;
    [self.hotTableView addRefreshWithRefreshViewType:LORefreshViewTypeHeaderDefault refreshingBlock:^{
       //下拉刷新
        //1.请求最新的数据
        weakSelf.hotStart = 0;
        //安全起见 清空数组放在数据请求之后 封装model之前
        isDown = YES;
        //请求数据
        [weakSelf requestDataWithSort:@"hot"];
    }];
    //添加最新数据的头部控件
    [self.newsTableView addRefreshWithRefreshViewType:LORefreshViewTypeHeaderDefault refreshingBlock:^{
        weakSelf.newStart = 0;
        isDown = YES;
        [weakSelf requestDataWithSort:@"addtime"];
    }];
    //添加尾部控件
    [self.hotTableView addRefreshWithRefreshViewType:LORefreshViewTypeFooterDefault refreshingBlock:^{
        isDown = NO;
        weakSelf.hotStart += 10;
        [weakSelf requestDataWithSort:@"hot"];
    }];
    //添加最新尾部控件
    [self.newsTableView addRefreshWithRefreshViewType:LORefreshViewTypeFooterDefault refreshingBlock:^{
        isDown = NO;
        weakSelf.newStart += 10;
        [weakSelf requestDataWithSort:@"addtime"];
        
    }];
    
}

#pragma mark --- 添加滑动视图和表视图
- (void)addScrollViewAndTableView {
    //1.创建最新的表视图
    self.newsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 64) style:UITableViewStylePlain];
    self.newsTableView.dataSource = self;
    self.newsTableView.delegate = self;
    [self.newsTableView registerNib:[UINib nibWithNibName:@"ReadDatailCell" bundle:nil] forCellReuseIdentifier:@"newCell"];
    //创建最热表视图
    self.hotTableView = [[UITableView alloc]initWithFrame:CGRectMake(kDeviceWidth, 0, kDeviceWidth, kDeviceHeight - 64) style:UITableViewStylePlain];
    self.hotTableView.dataSource = self;
    self.hotTableView.delegate = self;
    [self.hotTableView registerNib:[UINib nibWithNibName:@"ReadDatailCell" bundle:nil] forCellReuseIdentifier:@"hotCell"];
    // *****************滑动视图 ********************
    self.rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight - 64)];
    self.rootScrollView.contentSize = CGSizeMake(kDeviceWidth * 2, kDeviceHeight);
    self.rootScrollView.pagingEnabled = YES;
    self.rootScrollView.delegate = self;
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView addSubview:self.newsTableView];
    [self.rootScrollView addSubview:self.hotTableView];
    //滑动方向锁定
    self.rootScrollView.directionalLockEnabled = YES;
    // 添加分栏控件 ***************
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"News", @"HOT"]];
    self.segmentedControl.frame = CGRectMake(0, 0, 100, 30);
    self.navigationItem.titleView = self.segmentedControl;
//默认选中下标
    self.segmentedControl.selectedSegmentIndex = 0;
    //给分栏控件添加点击事件
    [self.segmentedControl addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    
    





}

#pragma mark -- 实现分栏的点击方法
- (void)segmentedAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [self.rootScrollView setContentOffset:CGPointMake(kDeviceWidth, 0) animated:YES];
    }
}

#pragma mark -- UIScrollViewDelegate
//滑动视图改变 分栏的选中状态也要改变
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //判断 只有是滑动视图才需要修改
    if (scrollView == self.rootScrollView) {
        self.segmentedControl.selectedSegmentIndex = scrollView.contentOffset.x / kDeviceWidth;
    }
}

#pragma mark -- 开始网络请求
- (void)requestDataWithSort:(NSString *)sort {
    //详情界面的接口需要typeID（在从上个界面接收的model中）
    NSString *typeID = self.tempModel.type;
    //利用sort参数 来判断该去哪一种start
    NSInteger tempStart = 0;
    if ([sort isEqualToString:@"hot"]) {
        tempStart = self.hotStart;
    }else{
        tempStart = self.newStart;
    }
    NSString *tempStr = [NSString stringWithFormat:@"%ld", (long)tempStart];
    
    //请求开始
    [NetworkingManager requestPOSTWithUrlString:kReadDateliURL parDic:@{@"typeid":typeID, @"sort":sort, @"start":tempStr} finish:^(id responseObject) {
        //解析数据
        [self handleDataWithSort:sort responseObject:responseObject];
        
    } error:^(NSError *error) {
    }];
    
}

#pragma mark -- 数据解析
- (void)handleDataWithSort:(NSString *)sort responseObject:(id)data {
    //不管是最新还是最热 数据都在list键值对中
    NSArray *tempArray = [[data objectForKey:@"data"]objectForKey:@"list"];
    //判断 是hot 还是 addtime
    if ([sort isEqualToString:@"hot"]) {
        if (isDown == YES) {
            [self.hotDataArray removeAllObjects];
        }
     
        //最热 开始遍历
        for (NSDictionary *dic in tempArray) {
            ReadDatileModel *hotModel = [[ReadDatileModel alloc]init];
            [hotModel setValuesForKeysWithDictionary:dic];
            hotModel.readId = [dic objectForKey:@"id"];
            [self.hotDataArray addObject:hotModel];
        }
         //刷新界面
        [self.hotTableView reloadData];
        //停止刷新
        [self.hotTableView.defaultFooter endRefreshing];
        [self.hotTableView.defaultHeader endRefreshing];
        
    }else{
        if (isDown == YES) {
            [self.newsDataArray removeAllObjects];
        }
        
        
        for (NSDictionary *dic in tempArray) {
            ReadDatileModel *newsModel = [[ReadDatileModel alloc]init];
            [newsModel setValuesForKeysWithDictionary:dic];
            newsModel.readId = [dic objectForKey:@"id"];
            [self.newsDataArray addObject:newsModel];
        }
         //刷新界面
        [self.newsTableView reloadData];
        //结束刷新
        [self.newsTableView.defaultHeader endRefreshing];
        [self.newsTableView.defaultFooter endRefreshing];
    }
    
   
}

#pragma mark -- 配置单元格
//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.hotTableView) {
        return self.hotDataArray.count;
    }
    return self.newsDataArray.count;
}
//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

//配置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.hotTableView) {
        //最热
        ReadDatailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell" forIndexPath:indexPath];
        //取出对应的model
        ReadDatileModel *hotModel = [self.hotDataArray objectAtIndex:indexPath.row];
        //调用cell内部的赋值方法
        [cell dataForCellWithModel:hotModel];
        return cell;
    }
    ReadDatailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newCell" forIndexPath:indexPath];
    //取出对应的model
    ReadDatileModel *newsModel = [self.newsDataArray objectAtIndex:indexPath.row];
    //调用cell内部的复制方法
    [cell dataForCellWithModel:newsModel];
    return cell;
   
}
//cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到第三季界面 并传值
    ReadInfoViewController *readInfoVC = [[ReadInfoViewController alloc]init];
    if (tableView == self.hotTableView) {
        readInfoVC.tempModel = [self.hotDataArray objectAtIndex:indexPath.row];
        
    }else{
        readInfoVC.tempModel = [self.newsDataArray objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:readInfoVC animated:YES];
}

- (void)dealloc {
    //移除观察者
    [self.hotTableView removeObserver:self.hotTableView.defaultFooter forKeyPath:@"contentSize"];
    [self.hotTableView removeObserver:self.hotTableView.defaultHeader forKeyPath:@"contentOffset"];
    [self.hotTableView removeObserver:self.hotTableView.defaultFooter forKeyPath:@"contentOffset"];
    
    
    [self.newsTableView removeObserver:self.newsTableView.defaultFooter forKeyPath:@"contentSize"];
    [self.newsTableView removeObserver:self.newsTableView.defaultHeader forKeyPath:@"contentOffset"];
    [self.newsTableView removeObserver:self.newsTableView.defaultFooter forKeyPath:@"contentOffset"];
    
    
}

@end
