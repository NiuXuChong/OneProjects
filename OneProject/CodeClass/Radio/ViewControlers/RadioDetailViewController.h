//
//  RadioDetailViewController.h
//  OneProject
//
//  Created by lanouhn on 16/4/27.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "BaseViewController.h"
#import "RadioListModel.h"
#import "RadioCircleModel.h"
#import "AVPlayManager.h"
@interface RadioDetailViewController : BaseViewController
@property (nonatomic, strong)RadioCircleModel *radioModel;
@property (nonatomic, strong)RadioListModel *radioListModel;
@property (nonatomic, strong)NSString *aStr;
@end
