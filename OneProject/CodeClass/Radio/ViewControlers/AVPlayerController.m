//
//  AVPlayerController.m
//  OneProject
//
//  Created by lanouhn on 16/5/3.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "AVPlayerController.h"
#import "AppDelegate.h"
#import "DownLoldController.h"
#import <AVFoundation/AVFoundation.h>
#import "DownLoadManager.h"

@interface AVPlayerController ()

//创建播放器属性
@property (nonatomic, strong)AVPlayer *player;
//播放条目(资源信息）
@property (nonatomic, strong)AVPlayerItem *playerItem;
//播放时长
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;
//当前时长
@property (strong, nonatomic) IBOutlet UILabel *currenTimeLabel;
//歌手名
@property (strong, nonatomic) IBOutlet UILabel *unameLabel;
//播放或者暂停
@property (strong, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (strong, nonatomic) UIImageView *coverimgView;
//滑杆
@property (strong, nonatomic) IBOutlet UISlider *propressSlider;

//歌曲下标
@property (nonatomic, assign)NSInteger index;
//歌曲的数据源
@property (nonatomic, strong)NSMutableArray *musicArray;


@end
//YES播放，NO暂停
BOOL isaDown = YES;
@implementation AVPlayerController

- (void)byValueModel:(RadioDetailModel *)model{

    self.title = model.title;
    self.unameLabel.text = [[model.playInfo objectForKey:@"authorinfo"] objectForKey:@"uname"];
   
    NSURL *url = [NSURL URLWithString:model.coverimg];
    [self.coverimgView setImageWithURL:url];
    self.coverimgView.layer.cornerRadius = 100;
    self.coverimgView.layer.masksToBounds = YES;
    
    [self showStart];
}
- (void)action{
    [[AVPlayManager sharedAVPlayManager]changeMusicWithIndex:[AVPlayManager sharedAVPlayManager].index];
    [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    isaDown = NO;
    [self startAnimation];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.coverimgView = [[UIImageView alloc]init];
   
    self.coverimgView.frame = CGRectMake((kDeviceWidth-200)/2, 212, 200, 200);
    [self.view addSubview:self.coverimgView];
    self.musicArray = [AVPlayManager sharedAVPlayManager].musicArray ;   //创建播放器对象
    self.player = [AVPlayManager sharedAVPlayManager].avPlayer;
    self.playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[self.detailModel.playInfo objectForKey:@"musicUrl"]]];
    [self action];
    //把item放入播放器中
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self byValueModel:self.detailModel];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    
    
    // -----------**************----------------
//    创建应用程序对象
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    //实现block
    [app setBlock:^(UIEvent *event) {
      //如果接收到远程事件 判断后 调用对应方法
        if (event.type == UIEventTypeRemoteControl) {
            //判断事件的类型
            switch (event.subtype) {
                case UIEventSubtypeRemoteControlNextTrack:
                    //下一首
                    [self nextButtonAction:nil];
                    break;
                case UIEventSubtypeRemoteControlPause:
                    //暂停
                    [self playOrPauseButton];
                    break;
                case UIEventSubtypeRemoteControlPlay:
                    //开始
                    [self playOrPauseButton];
                    break;
                default:
                    break;
            }
        }
        
        
        
    }];
    
    
}
//播放&&暂停
- (IBAction)musicPlayButton:(UIButton *)sender {
    if (isaDown == YES) {
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [[AVPlayManager sharedAVPlayManager]play];
        
        isaDown = NO;
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
        [self startAnimation];
        

    }else{
        [[AVPlayManager sharedAVPlayManager]pause];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.coverimgView.layer removeAnimationForKey:@"rotationAnimation"];
        isaDown = YES;
    }
 
}
//停止
- (IBAction)stopButtonAction:(UIButton *)sender {
    [[AVPlayManager sharedAVPlayManager]stop];
    [self.playOrPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    isaDown = YES;
    [self.coverimgView.layer removeAnimationForKey:@"rotationAnimation"];
}

//下一首
- (IBAction)nextButtonAction:(UIButton *)sender {
    [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [[AVPlayManager sharedAVPlayManager]nextMusic];
    RadioDetailModel *model = [[AVPlayManager sharedAVPlayManager].musicArray objectAtIndex:[AVPlayManager sharedAVPlayManager].index];
        [self byValueModel:model];
    isaDown = NO;
    [self startAnimation];
}
//上一首
- (IBAction)lastButtonAction:(UIButton *)sender {
    [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [[AVPlayManager sharedAVPlayManager]lastMusic];
    RadioDetailModel *model = [[AVPlayManager sharedAVPlayManager].musicArray objectAtIndex:[AVPlayManager sharedAVPlayManager].index];
    [self byValueModel:model];
    isaDown = NO;
    [self startAnimation];
}
//播放模式
- (IBAction)playTypeButtonAction:(UIButton *)sender {
    
    [[AVPlayManager sharedAVPlayManager]changePlayTypebutton:sender];
    
    
  
}
//滑动滑杆方法
- (IBAction)changeSliderAction:(UISlider *)sender {
    [[AVPlayManager sharedAVPlayManager] pause];
    self.currenTimeLabel.text = [NSString stringWithFormat:@"%2f", [[AVPlayManager sharedAVPlayManager]currenTime]];
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%2f", [[AVPlayManager sharedAVPlayManager] totalTime]];
    NSTimeInterval currentTime = sender.value *[AVPlayManager sharedAVPlayManager].totalTime;
   // __weak typeof(self)weakSelf = self;
    [self.player seekToTime:CMTimeMake(currentTime, 1) completionHandler:^(BOOL finished) {
        if (isaDown == YES) {
            [[AVPlayManager sharedAVPlayManager]pause];
        }else{
            [[AVPlayManager sharedAVPlayManager]play];
        }
    }];
}
//定时器方法
- (void)timeAction {
    //计算当前的时间占总时间的百分比
    self.propressSlider.value = [AVPlayManager sharedAVPlayManager].currenTime / [AVPlayManager sharedAVPlayManager].totalTime;
    [self showStart];
    if (self.propressSlider.value == 1.0) {
        [[AVPlayManager sharedAVPlayManager]playDidFinsh];
    }
    
}
//封装开始时间的label的展示
- (void)showStart {
    //获取当前时间
    int currentTime = [[AVPlayManager sharedAVPlayManager]currenTime];
    //分钟
    int mintue = currentTime / 60;
    //获取当前的秒
    int second = currentTime % 60;
    self.currenTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", mintue, second];
    //获取总时间
    int atotalTime = [[AVPlayManager sharedAVPlayManager] totalTime];
    //计算
    int aminute = atotalTime / 60;
    //秒
    int asecond = atotalTime % 60;
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", aminute, asecond];
}

//动画(图片360°旋转)
- (void)startAnimation {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI *2.0];
    rotationAnimation.duration = 5.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100000;
    [self.coverimgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
   }
//下载
- (IBAction)downLoadButtonAction:(UIButton *)sender {
    DownLoldController *downLoadVC = [[DownLoldController alloc]init];//下载界面VC
    downLoadVC.aModel = [[RadioDetailModel alloc]init];//传值
    downLoadVC.aModel = [[AVPlayManager sharedAVPlayManager].musicArray objectAtIndex:[AVPlayManager sharedAVPlayManager].index];//存入单例数组
     [downLoadVC.downLoldArray addObject:downLoadVC.aModel];//存入下载界面数据源数组
    [[DownLoadManager sharedDownManager]downLoadWihModel:downLoadVC.aModel];//下载
  /*  [[DownLoadManager sharedDownManager]getDataFromServerWithUrlStr:downLoadVC.aModel.musicUrl success:^(NSData *data) {
        
    } fail:^(NSError *error) {
        
    }];
   */ 
    NSLog(@"%@", NSHomeDirectory());
    
}


@end
