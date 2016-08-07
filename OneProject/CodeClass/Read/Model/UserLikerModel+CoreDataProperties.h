//
//  UserLikerModel+CoreDataProperties.h
//  OneProject
//
//  Created by lanouhn on 16/4/29.
//  Copyright © 2016年 Mr.Niu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserLikerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserLikerModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *uname;
@property (nullable, nonatomic, retain) NSString *readid;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *coverimg;

@end

NS_ASSUME_NONNULL_END
