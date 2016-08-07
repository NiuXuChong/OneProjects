//
//  ReadListModel.h
//  OneProject
//
//  Created by lanouhn on 16/4/25.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadListModel : NSObject

//列表model
//图片地址
@property (nonatomic, strong)NSString *coverimg;
//类型
@property (nonatomic, strong)NSString *enname;
//标题
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *type;//是我们做详情界面的参数



@end
