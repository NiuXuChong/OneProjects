//
//  DownLoadManager.m
//  LessonDownLoad_17
//
//  Created by lanouhn on 16/4/12.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import "DownLoadManager.h"

@implementation DownLoadManager

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


+ (DownLoadManager *)sharedDownManager {
    static DownLoadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownLoadManager alloc]init];
        
    });
    return manager;
}

//get请求
- (void)getDataFromServerWithUrlStr:(NSString *)urlStr success:(void (^)(NSData *))successBlock fail:(void (^)(NSError *))failBlock{
    //创建NSURL连接对象
    NSURL *url = [NSURL URLWithString:urlStr];
    //创建请求类
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //创建全局会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //创建请求任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //这里面是子线程来执行的.
        if (error == nil) {
            //说明请求成功
            //安全判断block是否存在
            if (successBlock) {
                //调用block来传值
                successBlock(data);
            }
        }else{
            if (failBlock) {
                failBlock(error);
            }
        }
        
    }];
    //开启任务
    [dataTask resume];
 
}
//下载方法
- (void)downLoadWihModel:(RadioDetailModel *)model{
//self.datArray 用来存储系在任务的modle
   for (RadioDetailModel *tempModel in self.dataArray) {
        //遍历，查看传进来的model是否已经在下载任务中
        if (tempModel.musicUrl == model.musicUrl) {
            return;//直接结束代码
        }
    }
   
    //将model添加到数组中
    [self.dataArray addObject:model];
    //配置下载请求
    //1.创建NSURL
    NSURL *url = [NSURL URLWithString:model.musicUrl];
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.创建会话配置信息
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //4.将配置信息和会话对象关联起来
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    //5.创建下载任务
    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithRequest:request];
    //6.记录模型的ID.为了避免重复创建下载任务,为了准确查找任务以及model
    downLoadTask.taskDescription = model.musicUrl;
    //7.执行任务
    [downLoadTask resume];
    
}

#pragma mark --NSURLSessionDownLoadDelegate --
//bytesWritten 每秒钟下载的字节数
//totalByteWritten 已经下载的字节数
//totalByteExpectedToWritten 文件的总大小
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    //计算进度条应该显示比例
    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    //查找对应的模型
    //封装查找model的方法
    RadioDetailModel *model = [self searchModelWithDescirtion:downloadTask.taskDescription];
    //调用block
    if (model.progressBlock) {
        model.progressBlock(progress);
        }
    
}
//封装查找model的方法
- (RadioDetailModel *)searchModelWithDescirtion:(NSString *)str{
    //先取出ID
    NSString *musicUrl = str;
    //遍历.查找model
    for (RadioDetailModel *tempModel in self.dataArray) {
        if ([musicUrl isEqualToString:tempModel.musicUrl]) {
            return tempModel;//找到了
        }
    }
    return nil;//没有找到
}

//创建播放器对象


//下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    //将数据,存入沙盒
    //1.获取cache文件夹路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //创建新文件夹路径
    NSString *musicPath = [cachePath stringByAppendingPathComponent:@"MyMp3"];
    //创建文件管理器
    NSFileManager *fileManage = [NSFileManager defaultManager];
    
    //创建文件夹
    [fileManage createDirectoryAtPath:musicPath withIntermediateDirectories:YES attributes:nil error:nil];
    //根据标识查找model
    RadioDetailModel *model = [self searchModelWithDescirtion:downloadTask.taskDescription];
    
    //拼接新的文件路径
    NSString *filePath = [musicPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", model.title]];
    
    //如果想使用中文文件名的话  就使用下面获取路径进行转化的方式   比较灵活(就不需要转拼音了)
    //但是  中文不能直接使用 [NSURL URLWithString:]的方式转为 NSURL哦！！！！
    //给路径转化为URL
    //⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
    NSURL *url = [NSURL fileURLWithPath:filePath];
    //⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
    
    //把下载的资源移动到目的地
    [fileManage moveItemAtURL:location toURL:url error:nil];
   /*
    //拼接新的文件夹路径
   
    //  依照表创建model
    self.myApp = [UIApplication sharedApplication].delegate;
    self.manager = [AVPlayManager sharedAVPlayManager];
    MusicModel *musicModel = [NSEntityDescription insertNewObjectForEntityForName:@"MusicModel" inManagedObjectContext:self.myApp.managedObjectContext];
   // RadioDetailModel *aModel = [self.manager.avPlayer.musicArray objectAtIndex:self.manager.index];
    musicModel.coverimg = model.coverimg;
    musicModel.title = [NSString stringWithFormat:@"%@.mp3", [[model.playInfo objectForKey:@"shareinfo"] objectForKey:@"title"]];
    musicModel.musicUrl = model.musicUrl;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
   // NSString* str = [numberFormatter stringFromNumber:num];
    musicModel.uid = [numberFormatter numberFromString:model.uid];
    [self.dataArray addObject:musicModel];
    //保存
    [self.myApp saveContext];
 */
}

/*
 转化中文
 NSString *str = @"这是中文";
 str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
 NSLog(@"%@", str);
 
 
 */



@end
