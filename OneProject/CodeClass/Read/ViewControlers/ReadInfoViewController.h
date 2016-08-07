//
//  ReadInfoViewController.h
//  OneProject
//
//  Created by lanouhn on 16/4/26.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "BaseViewController.h"
#import "ReadDatileModel.h"
#import "ReadCircleModel.h"
@interface ReadInfoViewController : BaseViewController

@property (nonatomic, strong)ReadDatileModel *tempModel;
@property (nonatomic, strong)ReadCircleModel * circleModel;
@property (nonatomic, strong)NSString *aStr;


@end
