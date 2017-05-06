//
//  XWUserModel.h
//  WB_wedding
//
//  Created by 谢威 on 17/2/4.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "BaseModel.h"

#define KISLogin    @"islogin"
#define KLoginStyle @"loginStyle"

/**账号的key */
#define KAccout @"accout"
/**密码的key */
#define KPassword @"password"



/**
 *  用户信息模型
 */
@interface XWUserModel : BaseModel

/**
 *  是否给父母住
 */
@property (nonatomic, strong) NSString *liveWithParent;

/**
 *  父母情况
 */
@property (nonatomic, strong) NSString *parentSituation;

/**
 *  薪水
 */
@property (nonatomic, strong) NSString *salary;
/**
 *  年龄
 */
@property (nonatomic,copy)NSString *age;

/**
 *  年龄范围
 */
@property (nonatomic,copy)NSString *ageRange;

/**
 *  生日
 */
@property (nonatomic,copy)NSString *birthday;

/**
 *  城市
 */
@property (nonatomic,copy)NSString *city;
/**
 *  身高
 */
@property (nonatomic, strong) NSString *height;

/**
 *  距离
 */
@property (nonatomic,copy)NSString *distance;

/**
 *  教育背景
 */
@property (nonatomic,copy)NSString *educationBackground;

/**
 *  娱乐
 */
@property (nonatomic,copy)NSString *entertainment;

/**
 *  年龄
 */
@property (nonatomic,copy)NSString *exloverIds;

/**
 *  年龄
 */
@property (nonatomic,copy)NSString *exsRelationTime;

/**
 *  漫画卡通
 */
@property (nonatomic,copy)NSString *fBookCartoon;

/**
 *  最爱的食物
 */
@property (nonatomic,copy)NSString *fFood;

/**
 *  最爱的电影
 */
@property (nonatomic,copy)NSString *fMovie;

/**
 *  运动
 */
@property (nonatomic,copy)NSString *fSport;

/**
 *  爱好
 */
@property (nonatomic,copy)NSString *hobby;

/**
 *  用户id
 */
@property (nonatomic,copy)NSString *xw_id;

/**
 *
 */
@property (nonatomic,copy)NSString *imgFileNames;

/**
 *  年龄
 */
@property (nonatomic,copy)NSString *ip;

/**
 *
 */
@property (nonatomic,copy)NSString *isFirstToday;

/**
 *  年龄
 */
@property (nonatomic,copy)NSString *isLocationOpen;


/**
 *  工作
 */
@property (nonatomic,copy)NSString *job;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *latitude;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *longitude;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *loverId;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *matcherIds;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *money;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *myQuestion;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *mySurvey;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *nickname;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *profession;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *realname;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *regularPlace;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *relationBeginTime;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *selfEvaluation;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *sendMatchTime;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *sex;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *status;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *telNumber;


/**
 *  vip
 */
@property (nonatomic,copy)NSString *userRight;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *vipEndTime;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *visitedPlace;


/**
 *  年龄
 */
@property (nonatomic,copy)NSString *xingZuo;


+(NSString *)filePath;

-(BOOL)saveUserInfo;

/**在本地移除 包括移除登录信息 账号名密码 用户信息*/
+ (BOOL)removeUserInfoFromlocal;

/**读取 */
+ (XWUserModel *)getUserInfoFromlocal;

/** 是否登录*/
+ (BOOL)isLogin;

/** 根据模型，设置单例属性值 */
- (void)setPropertyWithModel:(XWUserModel *)user;
/**
 *  存储登录信息
 *
 *  @param account 账号
 *  @param pwd     密码
 */
- (void)saveLoginInfoWithAccout:(NSString *)account pwd:(NSString *)pwd;


- (BOOL)isVip;


@end
