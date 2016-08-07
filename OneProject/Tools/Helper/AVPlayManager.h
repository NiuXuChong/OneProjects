//
//  AVPlayManager.h
//  OneProject
//
//  Created by lanouhn on 16/5/3.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>//引入框架
#import <AVFoundation/AVPlayer.h>


//将播放模式设置 随机、单曲、列表
typedef NS_ENUM(NSInteger, PlayType){
    PlayerTypeRandom,//随机
    PlayerTypeSingle,//单曲
    PlayerTypeList//列表
    
};
//播放状态
typedef NS_ENUM(NSInteger, PlayStatus){
    PlayStatusPlay,//播放
    PlayStatusPause//暂停
};


@interface AVPlayManager : NSObject
//声明一些辅助属性
//歌曲的下标
@property (nonatomic, assign)NSInteger index;
//歌曲的数据源
@property (nonatomic, strong)NSMutableArray *musicArray;
//播放模式
@property (nonatomic, assign)PlayType playType;
//播放器状态
@property (nonatomic, assign)PlayStatus playStatus;
//播放总时长
@property (nonatomic, assign)float totalTime;
//当前时长
@property (nonatomic, assign)float currenTime;
//播放器
@property (nonatomic, strong)AVPlayer *avPlayer;


//开始声明方法
//单例方法
+ (AVPlayManager *)sharedAVPlayManager;

//停止
- (void)stop;//用于手动点击下一曲时，将正在播放的歌曲信息清楚
//播放
- (void)play;
//暂停
- (void)pause;
//上一首
- (void)lastMusic;
//下一首
- (void)nextMusic;
//指定下标的位置进行播放（选取数组中某个对象进行播放）
- (void)changeMusicWithIndex:(NSInteger)index;
//指定位置进行播放(进度条更爱后进行播放)
- (void)seekTime:(float)time;
//播放完成后的操作；
- (void)playDidFinsh;
//播放模式
- (void)changePlayTypebutton:(UIButton *)button;
//创建下载播放器
- (void)setPlayAVPlayerUrl:(NSURL *)url;




@end
