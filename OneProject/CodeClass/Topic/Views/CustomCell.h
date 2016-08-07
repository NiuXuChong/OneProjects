//
//  CustomCell.h
//  OneProject
//
//  Created by lanouhn on 16/4/25.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *viewLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UILabel *conmentLabel;
@property (strong, nonatomic) IBOutlet UILabel *unameLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@end
