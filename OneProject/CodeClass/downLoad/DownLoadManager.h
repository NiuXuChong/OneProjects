//
//  DownLoadManager.h
//  LessonDownLoad_17
//
//  Created by lanouhn on 16/4/12.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RadioDetailModel.h"
#import "AppDelegate.h"
#import "AVPlayManager.h"
#import "MusicModel.h"
@interface DownLoadManager : NSObject <NSURLSessionDownloadDelegate>
@property (nonatomic, strong)NSMutableArray *dataArray;//数据源数组
@property (nonatomic, strong)AppDelegate *myApp;//程序代理类
@property (nonatomic, strong)AVPlayManager *manager;
//单例
+ (DownLoadManager *)sharedDownManager;
//get请求
- (void)getDataFromServerWithUrlStr:(NSString *)urlStr success:(void(^)(NSData *data))successBlock fail:(void(^)(NSError *error))failBlock;
//下载
- (void)downLoadWihModel:(RadioDetailModel *)model;


@end
