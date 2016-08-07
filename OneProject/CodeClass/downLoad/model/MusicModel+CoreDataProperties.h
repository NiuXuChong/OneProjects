//
//  MusicModel+CoreDataProperties.h
//  OneProject
//
//  Created by lanouhn on 16/5/9.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MusicModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *uname;
@property (nullable, nonatomic, retain) NSNumber *uid;
@property (nullable, nonatomic, retain) NSString *coverimg;
@property (nullable, nonatomic, retain) NSString *musicUrl;

@end

NS_ASSUME_NONNULL_END
