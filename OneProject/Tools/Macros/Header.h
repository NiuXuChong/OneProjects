//
//  Header.h
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#ifndef Header_h
#define Header_h
//header.h文件 一般用于添加宏定义以及一些常用的数据，比如接口

//屏幕的宽
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width

//屏幕的高度
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
//阅读主界面接口
#define kReadListURL @"http://api2.pianke.me/read/columns"
//阅读二级界面接口
#define kReadDateliURL @"http://api2.pianke.me/read/columns_detail"
//阅读三级界面接口
#define kReadInfoURL @"http://api2.pianke.me/article/info"
//阅读删除评论接口
#define kReadRemoveURL @"http://api2.pianke.me/comment/del"

//电台界面接口
#define kRadioListURL @"http://api2.pianke.me/ting/radio"
//电台首界面下mian 加载接口
#define kRadioDownLoadURL @"http://api2.pianke.me/ting/radio_list"
//电台主界面上mian刷新接口
#define kRadioUpdataURL @"http://api2.pianke.me/ting/radio"
//电台详情&&刷新界面接口
#define kRadioDetailURL @"http://api2.pianke.me/ting/radio_detail"
//电台主题界面刷新接口
#define kRadioSubectRefreshURL @"http://api2.pianke.me/ting/radio_detail"
//电台主题界面加载接口
#define kRadioSubjectURL @"http://api2.pianke.me/ting/radio_detail_list"
//话题界面接口
#define kTopicListURL @"http://api2.pianke.me/group/posts_hotlist"
//良品界面接口
#define kGoodPlantURL @"http://api2.pianke.me/pub/shop"

//注册接口

#define KRegisUrl @"http://api2.pianke.me/user/reg"

//登陆接口

#define KLoginUrl @"http://api2.pianke.me/user/login"

//评论接口

#define KConmentListUrl @"http://api2.pianke.me/comment/get"

//发表评论接口
#define KAddConmentUrl @"http://api2.pianke.me/comment/add"

//社会化分享
#define UMAPPK   @"564913af67e58ed0d7005bb3"  // 友盟注册的AppKey






#endif /* Header_h */
