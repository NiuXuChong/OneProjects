//
//  ReadListCell.h
//  OneProject
//
//  Created by lanouhn on 16/5/9.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadListCell : UICollectionViewCell
//图片
@property (strong, nonatomic) IBOutlet UIImageView *coverimageView;
//标题
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@end
