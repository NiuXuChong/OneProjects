//
//  ReadDetailViewController.h
//  OneProject
//
//  Created by lanouhn on 16/4/26.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "BaseViewController.h"
#import "ReadListModel.h"//cell上的model
@interface ReadDetailViewController : BaseViewController
@property (nonatomic, strong)ReadListModel *tempModel;//声明属性用于传值
@end
