//
//  NetworkingManager.m
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "NetworkingManager.h"
#import "AFNetworking.h"
@implementation NetworkingManager

//GET请求
+ (void)requestGETWithUrlString:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void (^)(id))finish error:(void (^)(NSError *))conError{
    //创建请求对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //数据格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-javascript", nil];
    [manager GET:urlStr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //调用block 将此类中的值 传递到控制其中
        finish(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //调用error block 将错误信息传递出去
        conError(error);
    }];
    
}

//POST请求
+ (void)requestPOSTWithUrlString:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void (^)(id))finish error:(void (^)(NSError *))conError{
    //创建请求对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //数据格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-javascript", nil];
    [manager POST:urlStr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //调用block 将此类中的值 传递到控制其中
        finish(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //调用error block 将错误信息传递出去
        conError(error);
    }];
}

@end
