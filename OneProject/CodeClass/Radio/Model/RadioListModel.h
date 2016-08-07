//
//  RadioListModel.h
//  OneProject
//
//  Created by lanouhn on 16/4/25.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioListModel : NSObject
@property (strong, nonatomic) NSString *coverimg;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *count;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSDictionary *userinfo;
@property (nonatomic, strong) NSString *isnew;
@property (nonatomic, strong) NSString *radioid;
@end
