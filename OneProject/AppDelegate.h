//
//  AppDelegate.h
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DDMenuController.h"//即将作为根视图控制器

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong)DDMenuController *ddMenuController;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//定义block属性
//void(^)(UIEvent *event) 类型
//变量名
@property (nonatomic, copy) void(^Block)(UIEvent *event);



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

