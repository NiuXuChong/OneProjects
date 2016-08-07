//
//  RadioDetailViewController.m
//  OneProject
//
//  Created by lanouhn on 16/4/27.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "RadioDetailViewController.h"
#import "RadioDetailCell.h"
#import "RadioDetailModel.h"

#import "AVPlayerController.h"
@interface RadioDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray *radioArray;
//声明表视图
@property (nonatomic, strong)UITableView *tableView;

//上面图片的属性
@property (nonatomic, strong)UIImageView *coverimg;
@property (nonatomic, strong)UILabel *descLabel;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *unameLabel;
@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UIView *bView;

@property (nonatomic, assign)NSInteger str;

@end
BOOL subjectIsDown = YES;//向下刷新
@implementation RadioDetailViewController

//添加刷新加载控件
- (void)setRefresh{
    //给加载数据的参数赋初始值
    self.str = 0;
    //添加两个头部刷新控件
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshWithRefreshViewType:LORefreshViewTypeHeaderDefault refreshingBlock:^{
       //下拉刷新
        //1.请求最新的数据
        weakSelf.str = 9;
        //安全起见 清空数组放在数据请求之后 封装model之前
        subjectIsDown = YES;
        //请求数据
        [weakSelf requestData];
    }];
    //添加尾部控件
    [self.tableView addRefreshWithRefreshViewType:LORefreshViewTypeFooterDefault refreshingBlock:^{
        subjectIsDown = NO;
        weakSelf.str += 10;
        //请求数据
        [weakSelf requestData];
        
    }];
  //  [self showProgressHUDWithString:@"玩命加载中"];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.radioArray = [NSMutableArray array];
    //数据请求
    [self requestData];
  
    //添加表视图方法
    [self addWithTableView];
    [self setRefresh];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}

//封装创建tableHeaderView信息方法
- (void) playTableHeaderView{
    self.bView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 250)];
    self.coverimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 180)];
    self.descLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 185, kDeviceWidth, 40)];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 140, 200, 20)];
    self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 220, 30, 30)];
    self.unameLabel = [[UILabel alloc]initWithFrame:CGRectMake(38, 230, 50, 20)];
    [self.bView addSubview:self.coverimg];
    [self.bView addSubview:self.descLabel];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.bView addSubview:self.titleLabel];
    
    [self.bView addSubview:self.iconView];
    [self.bView addSubview:self.unameLabel];
    self.tableView.tableHeaderView = self.bView;
}

#pragma mark -- 添加表视图方法

- (void)addWithTableView {
   //创建表视图
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioDetailCell" bundle:nil] forCellReuseIdentifier:@"RadioDetailCell"];
  
}

#pragma mark -- 请求数据
- (void)requestData {
    NSString *string = nil;
    
    if (self.aStr) {
        string = self.aStr;
    }else {
        string = self.radioListModel.radioid;
    }
    NSString *url = nil;
    if (subjectIsDown == YES) {//刷新
        url = kRadioDetailURL;
    }else{
        url = kRadioSubjectURL;//加载更多
    }
    
    //使用封装好的网络请求
    __weak typeof(self)WeakSelf = self;
    [NetworkingManager requestPOSTWithUrlString:url
    parDic:@{@"radioid":string} finish:^(id responseObject) {
       //解析封装数据
        [WeakSelf playTableHeaderView];
        [WeakSelf handlePaeserDataWithResponse:responseObject];
        
    } error:^(NSError *error) {
    }];
    //停止刷新
    [self.tableView.defaultHeader endRefreshing];
    [self.tableView.defaultFooter endRefreshing];
  //  [self hideProgressHUD];//停止玩命加载
    
}

//解析封装数据
- (void)handlePaeserDataWithResponse:(id)data {
  //先封装轮播图数据源
    NSDictionary *dic = [[data objectForKey:@"data"] objectForKey:@"radioInfo"];
    self.unameLabel.text = [dic[@"userinfo"]objectForKey:@"uname"];
    self.titleLabel.text = dic[@"title"];
    self.descLabel.text = dic[@"desc"];
    NSURL *url = [NSURL URLWithString:dic[@"coverimg"]];
    [self.coverimg setImageWithURL:url];
    NSURL *aUrl = [NSURL URLWithString:[dic[@"authinfo"] objectForKey:@"icon"]];
    [self.iconView setImageWithURL:aUrl];
    NSArray *listArray = [[data objectForKey:@"data"] objectForKey:@"list"];
    //遍历数组
    for (NSDictionary *dic in listArray) {
        RadioDetailModel *radioDaModel = [[RadioDetailModel alloc]init];
        radioDaModel.uid = [[[data objectForKey:@"data"] objectForKey:@"userinfo"] objectForKey:@"uid"];
        /*
//        radioDaModel.uid = [dic objectForKey:@"uid"];
//        radioDaModel.musicvisitnum = [dic objectForKey:@"musicvisitnum"];
//        radioDaModel.title = [dic objectForKey:@"title"];
//        radioDaModel.desc = [dic objectForKey:@"desc"];
//        radioDaModel.coverimg = [dic objectForKey:@"coverimg"];
//        radioDaModel.musicVisit = [dic objectForKey:@"musicVisit"];
         */
        [radioDaModel setValuesForKeysWithDictionary:dic];
        [self.radioArray addObject:radioDaModel];
        //刷新界面
        [self.tableView reloadData];
        }
    //刷新界面
    [self.tableView reloadData];
}


#pragma mark -- 配置tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.radioArray.count;
}

//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

//配置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RadioDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RadioDetailCell" forIndexPath:indexPath];
    RadioDetailModel *aModel = [self.radioArray objectAtIndex:indexPath.row];
    
    //赋值
    cell.musicvisitnumLabel.text = [NSString stringWithFormat:@"%@", aModel.musicvisitnum];
    cell.titleLabel.text = aModel.title;
    cell.musicvisitnumLabel.text = [NSString stringWithFormat:@"%@", aModel.musicVisit];
    NSInteger x = arc4random() % 1001 + 100;
    cell.uidLanel.text = [NSString stringWithFormat:@"%ld", (long)x];
    NSURL *url = [NSURL URLWithString:aModel.coverimg];
    [cell.coverimgView setImageWithURL:url];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AVPlayerController *AVPlayerVC = [[AVPlayerController alloc]init];

    AVPlayerVC.detailModel = [self.radioArray objectAtIndex:indexPath.row];
    [AVPlayManager sharedAVPlayManager].musicArray = [self.radioArray mutableCopy];
    [AVPlayManager sharedAVPlayManager].index = indexPath.row;
    [self.navigationController pushViewController:AVPlayerVC animated:YES];
   
}
- (void)dealloc {
    //移除观察者
    [self.tableView removeObserver:self.tableView.defaultFooter forKeyPath:@"contentSize"];
    [self.tableView removeObserver:self.tableView.defaultFooter forKeyPath:@"contentOffset"];
    [self.tableView removeObserver:self.tableView.defaultHeader forKeyPath:@"contentOffset"];
}


@end
