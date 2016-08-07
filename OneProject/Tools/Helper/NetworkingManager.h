//
//  NetworkingManager.h
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingManager : NSObject

/*
 *GET请求方式
 *
 *@param urlStr 请求地址
 *@param dic 请求链接的参数
 *@param finish 请求成功后的回调
 *@param error 请求失败后的回调
 */

+ (void)requestGETWithUrlString:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void(^)(id responseObject))finish error:(void(^)(NSError *error))conError;

+ (void)requestPOSTWithUrlString:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void(^)(id responseObject))finish error:(void(^)(NSError *error))conError;



@end
