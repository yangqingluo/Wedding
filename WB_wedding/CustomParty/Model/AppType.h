//
//  AppType.h
//
//  Created by yangqingluo on 2017/5/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppType : NSObject

@end


@interface AppUserData : NSObject


@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *telNumber;
@property (strong, nonatomic) NSString *lastLoginTime;
@property (strong, nonatomic) NSString *userRight;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *imgFileNames;
@property (strong, nonatomic) NSString *realname;
@property (strong, nonatomic) NSArray *imgArray;
@property (assign, nonatomic) int money;//喜币
@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSString *isFirstToday;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *sendMatchTime;
@property (strong, nonatomic) NSString *vipEndTime;
@property (strong, nonatomic) NSString *isLocationOpen;
@property (assign, nonatomic) int age;//年龄
@property (strong, nonatomic) NSString *height;//身高
@property (strong, nonatomic) NSString *birthday;//生日
@property (strong, nonatomic) NSString *sex;//性别
@property (strong, nonatomic) NSString *xingZuo;//星座
@property (strong, nonatomic) NSString *city;//城市
@property (strong, nonatomic) NSString *ageRange;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

@property (strong, nonatomic) NSString *relationBeginTime;
@property (strong, nonatomic) NSString *exsRelationTime;
@property (strong, nonatomic) NSString *exloverIds;//前朋友Ids
@property (strong, nonatomic) NSString *matcherIds;
@property (strong, nonatomic) NSString *loverId;

@property (strong, nonatomic) NSString *salary;
@property (strong, nonatomic) NSString *parentSituation;
@property (strong, nonatomic) NSString *liveWithParent;
@property (strong, nonatomic) NSString *educationBackground;
@property (strong, nonatomic) NSString *visitedPlace;
@property (strong, nonatomic) NSString *profession;
@property (strong, nonatomic) NSString *entertainment;
@property (strong, nonatomic) NSString *fBookCartoon;
@property (strong, nonatomic) NSString *hobby;
@property (strong, nonatomic) NSString *fSport;
@property (strong, nonatomic) NSString *job;
@property (strong, nonatomic) NSString *regularPlace;
@property (strong, nonatomic) NSString *fFood;
@property (strong, nonatomic) NSString *selfEvaluation;
@property (strong, nonatomic) NSString *fMovie;

@property (strong, nonatomic) NSString *myQuestion;
@property (strong, nonatomic) NSString *mySurvey;

//他人资料特有
@property (strong, nonatomic) NSString *matchDegree;//匹配度
@property (strong, nonatomic) NSString *isRecieverRead;//已读

- (BOOL)isVip;

- (NSString *)showStringOfSex;
- (NSString *)subItemStringWithKey:(NSString *)string;
- (NSArray *)subItemsIndexWithKey:(NSString *)string andSeparatedByString:(NSString *)separatedByString;
- (NSString *)showStringOfMyQuestion;
- (NSArray *)showArrayOfMyQuestion;
- (NSArray *)showImageArray;
- (NSString *)showStringOfMySurveyForIndex:(NSUInteger)index andLists:(NSString *)listsString;
- (NSString *)showStringOfBirthday;
@end


@interface UserInfoItemData : NSObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *subItems;
@property (assign, nonatomic) NSUInteger subItemMaxNumber;//子项的最大数目

@end
