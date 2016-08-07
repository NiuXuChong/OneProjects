//
//  commentCell.m
//  OneProject
//
//  Created by lanouhn on 16/4/29.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "commentCell.h"

@implementation commentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

//实现赋值方法
- (void)showDataWitnModel:(CommentModel *)tempModel{
    if (tempModel) {
        NSString *iconURL = [tempModel.userinfo objectForKey:@"icon"];
        NSString *nameStr = [tempModel.userinfo objectForKey:@"uname"];
        //赋值
        [self.headerImageView setImageWithURL:[NSURL URLWithString:iconURL]];
        self.nameLabel.text = nameStr;
        self.timeLabel.text = tempModel.addtime_f;
        self.contentLabel.text = tempModel.content;
        
    }
}





@end
