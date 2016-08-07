//
//  ReadDatailCell.m
//  OneProject
//
//  Created by lanouhn on 16/4/26.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "ReadDatailCell.h"

@implementation ReadDatailCell

- (void)dataForCellWithModel:(ReadDatileModel *)tempModel{
    self.titleLabel.text = tempModel.title;
    self.nameLabel.text = tempModel.name;
    self.contentLabel.text = tempModel.content;
    NSURL *url = [NSURL URLWithString:tempModel.coverimg];
    [self.coverImangView setImageWithURL:url];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
