//
//  ReadDatailCell.h
//  OneProject
//
//  Created by lanouhn on 16/4/26.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadDatileModel.h"
@interface ReadDatailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *coverImangView;
//声明方法 将model带进来给cell赋值
- (void)dataForCellWithModel:(ReadDatileModel *)tempModel;
@end
