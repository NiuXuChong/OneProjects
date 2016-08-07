//
//  RadioDetailModel.h
//  OneProject
//
//  Created by lanouhn on 16/4/27.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioDetailModel : NSObject
@property (nonatomic, strong)NSString *coverimg;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *musicvisitnum;
@property (nonatomic, strong)NSString *musicVisit;
@property (nonatomic, strong)NSString *uid;
@property (nonatomic, strong)NSString *radioid;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *icon;
@property (nonatomic, strong)NSString *musicUrl;
@property (nonatomic, strong)NSString *imgUrl;
@property (nonatomic, strong)NSDictionary *playInfo;
@property (nonatomic, strong)NSString *tinid;
@property (nonatomic, strong)NSString *tingContentid;

//用来记录当前model的下载进度
@property (nonatomic, copy) void (^progressBlock) (float progress);
@end
