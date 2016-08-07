//
//  TopicListModel.h
//  OneProject
//
//  Created by lanouhn on 16/4/25.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicListModel : NSObject
@property (nonatomic, strong)NSString *addtime;
@property (nonatomic, strong)NSString *addtime_f;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *contentid;
@property (nonatomic, strong)NSDictionary *counterList;
@property (nonatomic, strong)NSString *songid;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSDictionary *userinfo;
@property (nonatomic, strong)NSString *total;
@property (nonatomic, strong)NSString *coverimg;
@end
