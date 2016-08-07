//
//  AVPlayManager.m
//  OneProject
//
//  Created by lanouhn on 16/5/3.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "AVPlayManager.h"
#import "RadioDetailModel.h"
#import "MusicModel.h"
#import <MediaPlayer/MediaPlayer.h>//做后台配置的框架
@implementation AVPlayManager
//实现单例
+ (AVPlayManager *)sharedAVPlayManager{
    static AVPlayManager *playManager = nil;
    //GCD
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playManager = [[AVPlayManager alloc]init];
        
    });
    return playManager;
}
//重写单例对象的初始化方法（单例对象只创建一次.所以初始化方法也只走一次）
- (instancetype)init {
    self = [super init];
    if (self) {
        //创键播放器对象
        self.playType = PlayerTypeList;
        //播放状态
        self.playStatus = PlayStatusPause;
    }
    return self;
}

#pragma mark -- 数据源
- (void)setMusicArray:(NSMutableArray *)musicArray{
    //先清空之前的数据
    [_musicArray removeAllObjects];
    //把最新传进来的
    _musicArray = [musicArray mutableCopy];
    //根据对应的小标来获取对应的url
    MusicModel *tempModel = [_musicArray objectAtIndex:self.index];
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:tempModel.musicUrl]];
//    将item信息给播放器对象.我了保证其唯一性.判断对象是佛存在.如果存在直接使用
    if (_avPlayer) {
        //存在
        [self.avPlayer replaceCurrentItemWithPlayerItem:item];//相当于更换了播放数据
    }else {
        self.avPlayer = [[AVPlayer alloc]initWithPlayerItem:item];
    }
}
//创建播放器对象
- (void)setPlayAVPlayerUrl:(NSURL *)url{
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    if (_avPlayer) {
        //存在
        [self.avPlayer replaceCurrentItemWithPlayerItem:item];//相当于更换了播放数据
    }else {
        self.avPlayer = [[AVPlayer alloc]initWithPlayerItem:item];
    }

}

#pragma mark -- 播放总时长(getter)方法
- (float)totalTime{
   //通过AVPlayer能获取当前播放的比例
   //但是安全判断，比例不能为零(除数不能为0)
    if (self.avPlayer.currentItem.duration.timescale == 0) {
        return 0;
    }
    return  _avPlayer.currentItem.duration.value / self.avPlayer.currentItem.duration.timescale;
  
}
//当前时长
- (float)currenTime{
    if (_avPlayer.currentItem.timebase == 0) {
        return 0;
    }
   //此方法也是时间转换 CMTimeMake(_avPlayer.currentTime.value,  _avPlayer.currentTime.timescale);
    return _avPlayer.currentTime.value / _avPlayer.currentTime.timescale;
}
//停止
- (void)stop{
   //停止
    [self seekTime:0];//进行清零
    [self.avPlayer pause];//暂停
    
}

//播放
- (void)play{
    [self.avPlayer play];
    
    //改变状态
    self.playStatus = PlayStatusPlay;
    //顺便配置后台播放时的信息.比如歌手名.歌曲名、背景图、专辑名等信息（封装）
    [self configLockScreen];
    
    //播放时长
    
 
}
#pragma mark -- 配置后台播放的信息
- (void)configLockScreen {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //这个字典中收进来的都是后台播放界面的配置信息
    //需要引入MPMedial框架
    RadioDetailModel *model = [self.musicArray objectAtIndex:self.index];
    [dic setObject:@"专辑名" forKey:MPMediaItemPropertyAlbumTitle];//专辑名
    [dic setObject:model.title forKey:MPMediaItemPropertyTitle];//歌曲名
    [dic setObject:[[model.playInfo objectForKey:@"authorinfo"] objectForKey:@"uname"] forKey:MPMediaItemPropertyArtist];//歌手名
    //封面图片（一般图片都是接口的链接）.所以需要请求数据
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.coverimg]];
    UIImage *image = [UIImage imageWithData:data];
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc]initWithImage:image];
    [dic setObject:artWork forKey:MPMediaItemPropertyArtwork];
    //播放时长
    [dic setObject:[NSNumber numberWithDouble:CMTimeGetSeconds(self.avPlayer.currentItem.duration)] forKey:MPMediaItemPropertyPlaybackDuration];
    //当前播放的信息中心
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = dic;//赋值操作 给后台配置
    
}


//暂停
- (void)pause{
    [self.avPlayer pause];
    //改变状态
    self.playStatus = PlayStatusPause;
}

//上一首
- (void)lastMusic{
    if (self.playType == PlayerTypeRandom) {
        //随机模式
        self.index = arc4random() % self.musicArray.count;
    }else {
        if (self.index == 0) {
            self.index = self.musicArray.count - 1;
        }else{
            self.index--;
        }
    }
    //调用更换链接的
    [self changeMusicWithIndex:self.index];
}

//下一首
- (void)nextMusic{
    if (self.playType == PlayerTypeRandom) {
        //随机模式
        self.index = arc4random() % self.musicArray.count;
    }else{
        self.index++;
        if (self.index == self.musicArray.count) {
            self.index = 0;
        }
    }
    [self changeMusicWithIndex:self.index];
}
//指定下标播放
- (void)changeMusicWithIndex:(NSInteger)index{
    //进行传值
    self.index = index;
    RadioDetailModel *tempModel = [self.musicArray objectAtIndex:self.index];
    //更改item的数据
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:tempModel.musicUrl]];
    [_avPlayer replaceCurrentItemWithPlayerItem:item];
    //进行播放
    [self play];
}
//播放进度
- (void)seekTime:(float)time{
    //获取当前时间
    CMTime newTime = self.avPlayer.currentTime;
    //重置设置时间
    newTime.value = newTime.timescale *time;
    //给播放器跳转到新的是时间
    [self.avPlayer seekToTime:newTime];
    
}
//播放完成后的操作
- (void)playDidFinsh{
    //此首完成 继续下一首
    if (self.playType == PlayerTypeSingle) {
        [self changeMusicWithIndex:self.index];
    }else{
    [self nextMusic];
    }
}
//播放模式
- (void)changePlayTypebutton:(UIButton *)button{
   
    if ([AVPlayManager sharedAVPlayManager].playType == PlayerTypeList) {
        [AVPlayManager sharedAVPlayManager].playType = PlayerTypeRandom;
        [button setImage:[UIImage imageNamed:@"iconfont-suijibofang"] forState:UIControlStateNormal];
    }else if ([AVPlayManager sharedAVPlayManager].playType == PlayerTypeRandom){
        [AVPlayManager sharedAVPlayManager].playType = PlayerTypeSingle;
        [button setImage:[UIImage imageNamed:@"iconfont-danquxunhuan"] forState:UIControlStateNormal];
    }else{
        [AVPlayManager sharedAVPlayManager].playType = PlayerTypeList;
        [button setImage:[UIImage imageNamed:@"iconfont-shunxubofang"] forState:UIControlStateNormal];
    }
    
    
    

}



@end
