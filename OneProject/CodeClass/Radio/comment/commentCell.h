//
//  commentCell.h
//  OneProject
//
//  Created by lanouhn on 16/4/29.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface commentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

//声明方法  内部给cell赋值
- (void)showDataWitnModel:(CommentModel *)tempModel;


@end
