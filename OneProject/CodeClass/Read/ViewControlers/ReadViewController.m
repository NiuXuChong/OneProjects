//
//  ReadViewController.m
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "ReadViewController.h"
//轮播图、网络请求在pch文件 无需再次引入
#import "ReadListModel.h"
#import "ReadCircleModel.h"
#import "ReadListCell.h"
#import "ReadInfoViewController.h"//三级界面
//引入用于图片请求的类（也可以直接引入pch文件中）
#import "UIImageView+AFNetworking.h"
#import "ReadDetailViewController.h"

@interface ReadViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
//声明集合视图属性
@property(nonatomic, strong)UICollectionView *collectionView;
//轮播图数据源
@property (nonatomic, strong)NSMutableArray *circleImageArray;
//阅读列表数据源
@property(nonatomic, strong)NSMutableArray *readListArray;
//将轮播图声明为属性
@property (nonatomic, strong)CircleView *circleView;
@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设施背景色
    self.view.backgroundColor = [UIColor grayColor];
    //开辟数据源
    self.circleImageArray = [NSMutableArray array];
    self.readListArray = [NSMutableArray array];
   // self.automaticallyAdjustsScrollViewInsets = NO;//关闭导航栏高度自适应（64）
// **************请求数据方法***************
    [self requestData];
    
    
    // ************展示列表视图方法 **************
    [self creatCollectionView];
   
}

#pragma mark -- 展示集合视图列表
- (void)creatCollectionView {
    //创建layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置左右最小间距
    layout.minimumInteritemSpacing = 2;
    //设置上下最小间距
    layout.minimumLineSpacing = 2;
    //设置item的大小
    layout.itemSize = CGSizeMake((kDeviceWidth - 20) / 3, (kDeviceHeight - 64 - 165 - 6) / 3);
    //设置分区边界
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    //创建集合视图
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 165, kDeviceWidth, kDeviceHeight  - 165)collectionViewLayout:layout];
    //设置代理（关键）
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ReadListCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"readCell"];

    //背景色
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    //添加到根视图上
    [self.view addSubview:self.collectionView];
    
    
}

#pragma mark -- 请求数据
- (void)requestData {
    //使用封装好的网络请求
    [NetworkingManager requestGETWithUrlString:kReadListURL parDic:nil finish:^(id responseObject) {
        //开始解析数据(封装)
        [self handleParserDataWithResponse:responseObject];
        
    } error:^(NSError *error) {
   
    }];
}

//解析封装数据
- (void)handleParserDataWithResponse:(id)data {
    //先封装轮播图数据源
    NSArray *imageArray = [[data objectForKey:@"data"] objectForKey:@"carousel"];
    //创建临时数组，用于给轮播图传值
    NSMutableArray *urlImageArray = [NSMutableArray array];
    
    //遍历数组，封装model
    for (NSDictionary *dic in imageArray) {
        //先把img图片链接放进轮播图数组中
        [urlImageArray addObject:[dic objectForKey:@"img"]];
        //在封装model（是为了点击轮播图是进行传值用的 需要进入轮播图性情）
        ReadCircleModel *circleModel = [[ReadCircleModel alloc]init];
        [circleModel setValuesForKeysWithDictionary:dic];//KVC赋值
        //model放进数据源中
        [self.circleImageArray addObject:circleModel];
    }
    //遍历结束，意味着轮播图url准备完毕.
    //添加轮播图
    self.circleView = [[CircleView alloc]initWithImageURLArray:urlImageArray changeTime:1 withFrame:CGRectMake(0, 64, kDeviceWidth, 165)];
    
    __weak typeof(self)weakSelf = self;
    self.circleView.tapActionBlock = ^(NSInteger pageIndex) {
// 礼拜二补充详情界面
        
        NSLog(@"array:%@",weakSelf.circleImageArray);
        
        ReadCircleModel *temoModel = [weakSelf.circleImageArray objectAtIndex:pageIndex];
        
        ReadInfoViewController *readInfoVC = [[ReadInfoViewController alloc]init];
        //字符串截取
        readInfoVC.circleModel = [[ReadCircleModel alloc]init];
        readInfoVC.circleModel.url = [[temoModel.url componentsSeparatedByString:@"/"]lastObject];
        
        [weakSelf.navigationController pushViewController:readInfoVC animated:YES];       
        
    };
    //添加到根视图上
    [self.view addSubview:self.circleView];
    //封装集合视图列表数据源
    NSArray *listArray = [[data objectForKey:@"data"]objectForKey:@"list"];
    //遍历数组
    for (NSDictionary *dic in listArray) {
        //封装模型
        ReadListModel *listModel = [[ReadListModel alloc]init];
        [listModel setValuesForKeysWithDictionary:dic];
        [self.readListArray addObject:listModel];
    }
    //刷新界面
    [self.collectionView reloadData];
    
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake((kDeviceWidth - 20) / 3, (kDeviceHeight - 64 - 165 - 6) / 3);
//}

#pragma mark ** UICollectionView
//单元格数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.readListArray.count;
}

//配置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ReadListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"readCell" forIndexPath:indexPath];
    //更新约束
    [cell layoutIfNeeded];
    //取出对应的model
    ReadListModel *tempModel = [self.readListArray objectAtIndex:indexPath.row];
    //给cell赋值
    cell.nameLabel.text = [NSString stringWithFormat:@"%@%@", tempModel.name, tempModel.enname];
    cell.nameLabel.textColor = [UIColor whiteColor];
    cell.nameLabel.font = [UIFont systemFontOfSize:14];
    //给图片赋值
    NSURL *url = [NSURL URLWithString:tempModel.coverimg];
    cell.backgroundColor = [UIColor redColor];
    [cell.coverimageView setImageWithURL:url];
    cell.coverimageView.frame = cell.frame;
    cell.coverimageView.backgroundColor = [UIColor greenColor];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell 将cell上展示的model传递给详情界面.因为详情接口中的参数在model中
    ReadDetailViewController *readDatailVC = [[ReadDetailViewController alloc]init];
    //属性传值
    readDatailVC.tempModel = [self.readListArray objectAtIndex:indexPath.row];
    
    //跳转页面
    [self.navigationController pushViewController:readDatailVC animated:YES];
}






@end
