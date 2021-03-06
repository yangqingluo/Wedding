//
//  AppType.h
//
//  Created by yangqingluo on 2017/5/3.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppType : NSObject

@property (strong, nonatomic) NSString *ID;

@end


@interface AppUserData : AppType

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


+ (NSString *)showRelationTimeWithTimeString:(NSString *)string;

- (BOOL)hasLover;
- (BOOL)isVip;
- (NSString *)showStringOfSex;
- (NSString *)subItemStringWithKey:(NSString *)string;
- (NSArray *)subItemsIndexWithKey:(NSString *)string andSeparatedByString:(NSString *)separatedByString;
- (NSString *)showStringOfMyQuestion;
- (NSArray *)showArrayOfMyQuestion;
- (NSArray *)showImageArray;
- (NSString *)showStringOfMySurveyForIndex:(NSUInteger)index andLists:(NSString *)listsString;
- (NSString *)showStringOfBirthday;
- (NSDate *)dateOfBirthday;


@end


@interface UserInfoItemData : NSObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *subItems;
@property (assign, nonatomic) NSUInteger subItemMaxNumber;//子项的最大数目

@end

@interface UserJudgementDate : AppType

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *commentTime;
@property (strong, nonatomic) NSString *otherNickname;
@property (strong, nonatomic) NSString *otherTouxiangUrl;
@property (strong, nonatomic) NSString *myId;
@property (strong, nonatomic) NSString *otherId;

@end

typedef enum {
    UserMessageTypeNormal = 0,//普通
    UserMessageTypeLove,//表白
    UserMessageTypeReLove,//复合
    UserMessageTypeLocate,//定位
}UserMessageType;

@interface UserMessageData : AppType

@property (assign, nonatomic) int msgType;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *msgTime;
@property (strong, nonatomic) NSString *myId;
@property (strong, nonatomic) NSString *imgName;
@property (strong, nonatomic) NSString *otherId;
@property (strong, nonatomic) NSString *otherNickName;
@property (strong, nonatomic) NSString *isMessageRead;

@end

@interface UserWalletDetailData : AppType

@property (strong, nonatomic) NSString *balance;
@property (strong, nonatomic) NSString *consumeAmount;
@property (strong, nonatomic) NSString *consumeContent;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *vipEndTime;

@end

@interface UserTimeLineData : AppType

@property (strong, nonatomic) NSString *backgroundUrl;
@property (strong, nonatomic) NSString *loversId;
@property (strong, nonatomic) NSString *relationTime;

@end

@interface UserTimeLineEventData : AppType

@property (strong, nonatomic) NSString *boysNote;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *eventContent;
@property (strong, nonatomic) NSString *eventTime;
@property (strong, nonatomic) NSString *girlsNote;
@property (strong, nonatomic) NSArray *imgArray;
@property (strong, nonatomic) NSString *imgs;
@property (strong, nonatomic) NSString *isBoyDelete;
@property (strong, nonatomic) NSString *isGirlDelete;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *timeEventId;

@end
