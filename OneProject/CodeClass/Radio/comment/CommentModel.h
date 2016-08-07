//
//  CommentModel.h
//  OneProject
//
//  Created by lanouhn on 16/4/29.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
//发表评论的时间
@property (nonatomic, strong)NSString *addtime_f;
//评论内容
@property (nonatomic, strong)NSString *content;
//评论的id
@property (nonatomic, strong)NSString *contentid;
//用户信息
@property (nonatomic, strong)NSDictionary *userinfo;




@end
