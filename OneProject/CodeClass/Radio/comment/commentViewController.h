//
//  commentViewController.h
//  OneProject
//
//  Created by lanouhn on 16/4/29.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadDatileModel.h"
#import "ReadCircleModel.h"
#import "ReadInfoViewController.h"
@interface commentViewController : UITableViewController
//将要评论的数据带进来.需要让服务器知道评论的是哪条文章
@property (nonatomic, strong)ReadDatileModel *tempDetailModel;
@property (nonatomic, strong)ReadCircleModel *aCircleModel;
@property (nonatomic, strong)NSString *commentstr;//传值
@end
