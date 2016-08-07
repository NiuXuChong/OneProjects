//
//  commentViewController.m
//  OneProject
//
//  Created by lanouhn on 16/4/29.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "commentViewController.h"
#import "CommentModel.h"
#import "commentCell.h"
#import "KeyBoardTextView.h"//自己封装的
@interface commentViewController ()<KeyBoardTextViewDelegate>

//声明数据源数组
@property (nonatomic, strong)NSMutableArray *listCommettArray;
//设置输入框为属性
@property (nonatomic, strong)KeyBoardTextView *keyboardView;
@property (nonatomic ,strong)NSString *contentid;
@end

@implementation commentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listCommettArray = [NSMutableArray array];
    //添加表头
    self.title = @"评论按钮";
    //在导航栏上添加返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backItemAction:)];
    //设置为左按钮
    self.navigationItem.leftBarButtonItem = backItem;
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithTitle:@"发表评论" style:UIBarButtonItemStyleDone target:self action:@selector(addItemAction:)];
    //设置为右按钮
    self.navigationItem.rightBarButtonItem = addItem;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"commentCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
    [self requestData];
}

#pragma mark -- 网络请求封装
- (void)requestData {
    //获取评论列表.需要登录的auth 以及文章的id
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *auth = [userDefaults objectForKey:@"auth"];
    //文章的id
    if (self.tempDetailModel == nil) {
       
        self.contentid = self.commentstr;
;
    }else{
        self.contentid = self.tempDetailModel.readId;
    }
    
    
    //网络
    
    [NetworkingManager requestPOSTWithUrlString:KConmentListUrl parDic:@{@"auth":auth, @"contentid":self.contentid} finish:^(id responseObject) {
        [self handleParserDataWith:responseObject];
        
    } error:^(NSError *error) {
    }];
}
#pragma mark -- 封装解析方法
- (void)handleParserDataWith:(id)data {
    [self.listCommettArray removeAllObjects];
    NSArray *listArray = [[data objectForKey:@"data"] objectForKey:@"list"];
    //开始遍历
    for (NSDictionary *dic in listArray) {
        CommentModel *tempModel = [[CommentModel alloc]init];
        [tempModel setValuesForKeysWithDictionary:dic];//KVC赋值
        [self.listCommettArray addObject:tempModel];
    }
    //刷新界面
    [self.tableView reloadData];
}



#pragma mark -- Item方法的实现
- (void)backItemAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//发表评论
- (void)addItemAction:(UIBarButtonItem *)sender {
//    输入框操作
//    监测键盘即将出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
//    键盘即将小时的监测方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
//    创建我们的输入框
    if (self.keyboardView == nil) {
        self.keyboardView = [[KeyBoardTextView alloc]initWithFrame:CGRectMake(0, kDeviceHeight - 44, kDeviceWidth, 44)];
       }
//        代理对象
        self.keyboardView.delegate = self;
//       让键盘弹出
        [self.keyboardView.textView becomeFirstResponder];
    
        [self.view.window addSubview:self.keyboardView];
   
    
    
}

#pragma mark -- 实现键盘即将消失的方法
- (void)keyboardHide:(NSNotification *)notifi {
    //获取键盘的高度
    CGRect keyboardRect = [[notifi.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];//CGRectValue将字符串转为CGRect结构体
//    获取键盘守护需要的时间
    float time = [[notifi.userInfo objectForKey:UIKeyboardWillHideNotification] floatValue];
//    现在使用动画改变keyboardView的位置
    [UIView animateWithDuration:time animations:^{
        self.keyboardView.transform = CGAffineTransformMakeTranslation(0, keyboardRect.size.height);
        self.keyboardView.textView.text = @"";
//        并且从父视图上移除
        [self.keyboardView removeFromSuperview];
    }];
    if (self.keyboardView.textView.frame.size.height > 44) {
        CGRect frame = self.keyboardView.frame;
        frame.size.height = 44;
        frame.origin.y = 22;
        self.keyboardView.frame = frame;
        CGRect keyboardFrame = self.keyboardView.textView.frame;
        keyboardFrame.size.height = 44 - 10;
        self.keyboardView.textView.frame = keyboardFrame;
        
    }
    self.keyboardView.isChange = NO;
    
    
    
}
#pragma mark -- 键盘即将出现的方法
- (void)keyBoardShow:(NSNotification *)notifi {
//    同样 获取键盘的高度
    CGRect keyboardRect = [[notifi.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    获取键盘弹出所需的时间
    float time = [[notifi.userInfo objectForKey:UIKeyboardWillShowNotification] floatValue];
//    以此来做动画
    [UIView animateWithDuration:time animations:^{
        self.keyboardView.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
    }];
}
#pragma mark -- 实现textView的代理方法
- (void)keyBoardView:(UITextView *)aTextView{

//    网络请求  向服务器发送评论内容
//    用户登录成功的唯一标识
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *auth = [userDefaults objectForKey:@"auth"];
//    content用户发表的言论
    NSString *content = [NSString stringWithFormat:@"%@", aTextView.text];
//    contentid:标识需要被评论文章的标识
    NSString *contentid = self.tempDetailModel.readId;
    if (contentid.length == 0) {
        contentid = self.commentstr;
    }
   
//    开始请求
    [NetworkingManager requestPOSTWithUrlString:KAddConmentUrl parDic:@{@"auth":auth, @"content":content, @"contentid":contentid} finish:^(id responseObject) {
        int result = [[responseObject objectForKey:@"result"]intValue];
        if (result == 1) {
            /*
//            只有服务器给我们评论成功的标识.我们才需要插入cell.否则需要提示用户 评论失败
//            获取评论信息 直接插入cell 不在浪费流量重新请求数据
//            CommentModel *model = [[CommentModel alloc]init];
////            创建字典 整合数据
//            NSDictionary *dic = @{@"icon":[userDefaults objectForKey:@"icon"], @"uid":[userDefaults objectForKey:@"uid"], @"uname":[userDefaults objectForKey:@"uname"]};
//            NSDictionary *tempDic = @{@"addtime":@"刚刚", @"content":content, @"userinfo":dic};
////            给model赋值
//            [model setValuesForKeysWithDictionary:tempDic];
////            加入数据源
//            [self.listCommettArray insertObject:model atIndex:0];
////            按下标 插入cell
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight
 //            ];
            */
            [self requestData];
            
        }
   
    } error:^(NSError *error) {
    }];
    //    释放第一响应者 收回键盘
    [aTextView resignFirstResponder];
    
}

#pragma mark - Table view data source
//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listCommettArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    commentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    //取出model
    CommentModel *model = [self.listCommettArray objectAtIndex:indexPath.row];
    //调用方法 回cell内部赋值
    [cell showDataWitnModel:model];
    
    return cell;
}
#pragma mark -- 界面即将消失
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.keyboardView != nil) {
        [self.keyboardView.textView resignFirstResponder];
    }
}

//设置编辑风格（默认删除）
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;//删除
}



//是否允许编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *deleteModel = [self.listCommettArray objectAtIndex:indexPath.row];
    //取出此条评论的uid
    NSString *commentUid = [[deleteModel.userinfo objectForKey:@"uid"]stringValue];
    //从沙盒中取出用户的uid
    NSUserDefaults *userDefealts = [NSUserDefaults standardUserDefaults];
    NSString *deleteUid = [[userDefealts objectForKey:@"uid"]stringValue];
    //判断是否相等
    if ([commentUid isEqualToString:deleteUid]) {
        return YES;
    }
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //先拿到model
        CommentModel *deleteModel = [self.listCommettArray objectAtIndex:indexPath.row];
        //先删除服务器中的数据
        [self requestDeleteDataModel:deleteModel indexPath:indexPath];
        
      
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    
    }   
}
//删除数据网络请求

- (void)requestDeleteDataModel:(CommentModel *)model indexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *contentid = self.tempDetailModel.readId;
    if (contentid.length == 0) {
        contentid = self.commentstr;
    }
   
    [NetworkingManager requestPOSTWithUrlString:kReadRemoveURL parDic:@{@"auth":[userDefaults objectForKey:@"auth"], @"contentid":contentid, @"commentid":model.contentid} finish:^(id responseObject) {
        
     int result = [[responseObject objectForKey:@"result"] intValue];
        if (result == 1) {
            
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除成功"preferredStyle:UIAlertControllerStyleAlert];
           
            //  确定事件
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //删除数据源中此条数据
                [self.listCommettArray removeObject:model];

                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [control addAction:confirm];
            
            //  弹出警示框
            [self presentViewController:control animated:YES completion:nil];
            
        }else{
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除失败"preferredStyle:UIAlertControllerStyleAlert];
            //  确定事件
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [control addAction:confirm];

            //  弹出警示框
            [self presentViewController:control animated:YES completion:nil];
        }
       
    } error:^(NSError *error) {
        
    }];
    
}



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
