//
//  AppPublic.m
//  SafetyOfMAS
//
//  Created by yangqingluo on 16/9/9.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "AppPublic.h"
#import <CommonCrypto/CommonDigest.h>

#import "UIImage+Color.h"
#import "MainTabNavController.h"
#import "FirstPageController.h"
#import "HQMainTabBarController.h"

@implementation AppPublic

__strong static AppPublic  *_singleManger = nil;

+ (AppPublic *)getInstance{
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        _singleManger = [[AppPublic alloc] init];
        
        
    });
    return _singleManger;
}

- (instancetype)init{
    if (_singleManger) {
        return _singleManger;
    }
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma getter
- (AppUserData *)userData{
    if (!_userData) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *data = [ud objectForKey:kUserData];
        if (data) {
            _userData = [AppUserData mj_objectWithKeyValues:data];
        }
    }
    
    return _userData;
}

- (NSArray *)infoItemLists{
    if (!_infoItemLists) {
        _infoItemLists = @[@"行业",@"工作领域",@"学历",@"自我评价",@"娱乐休闲",@"业余爱好",@"喜欢的运动",@"喜欢的食物",@"喜欢的电影",@"喜欢的书籍和动漫",@"去过的地方",@"工资"];
    }
    
    return _infoItemLists;
}

- (NSDictionary *)infoItemDic{
    if (!_infoItemDic) {
        _infoItemDic = @{@"profession":@[@"计算机（软件、硬件、服务）",
                                         @"通信",
                                         @"电信",
                                         @"互联网",
                                         @"电子（半导体、仪器、自动化）",
                                         @"金融服务（会计/审计、银行、保险）",
                                         @"金融/投资/证券",
                                         @"贸易（进出口、批发、零售）",
                                         @"快速消费品（食品、饮料、化妆品)",
                                         @"服装/纺织/皮革",
                                         @"家具/家电/工艺品/玩具",
                                         @"办工用品及设备",
                                         @"医疗/医药",
                                         @"广告/公关/市场推广/会展",
                                         @"影视/媒体/出版/印刷/包装",
                                         @"房地产相关",
                                         @"家具/室内设计/装潢",
                                         @"服务（咨询、人力资源）",
                                         @"法律相关",
                                         @"教育/培训",
                                         @"学术/科研",
                                         @"学术/科研",
                                         @"酒店/餐饮业",
                                         @"旅游",
                                         @"娱乐/体闲/体育",
                                         @"美容/保健",
                                         @"交通（运输、物流、航空、航天）汽车及零配件",
                                         @"美容/保健",
                                         @"农业、政府/非盈利机构",
                                         @"其它行业"],
                         @"job":@[@"创始人",
                                  @"投资人",
                                  @"职业经理人",
                                  @"咨询顾问",
                                  @"服务业",
                                  @"演艺/艺术/音乐人",
                                  @"运营/市场/销售",
                                  @"产品",
                                  @"客服",
                                  @"商务/公关",
                                  @"行政/管理/人事",
                                  @"财务/会计/出纳",
                                  @"工程师/技术",
                                  @"律师",
                                  @"教师",
                                  @"翻译",
                                  @"警察/公务员",
                                  @"科研人员",
                                  @"医护人员",
                                  @"导演/摄影/摄像师",
                                  @"主持人/司仪",
                                  @"化妆/造型",
                                  @"编辑/设计/文字工作者",
                                  @"记者",
                                  @"店长/店员/服务员",
                                  @"自由职业者",
                                  @"企业家/私营业主",
                                  @"采购",
                                  @"航空/航天/航海",
                                  @"餐饮/旅游",
                                  @"运动员/教练",
                                  @"其他"],
                         @"educationBackground":@[@"初中",@"高中",@"大专",@"本科",@"硕士",@"博士",@"博士后",@"教授"],
                         @"selfEvaluation":@[@"聪慧善良",@"善解人意",@"浪漫风趣",@"诚信温和",@"务实能干",@"成熟稳重",@"开朗活泼",@"热心正义"],
                         @"entertainment":@[@"酒吧水吧",@"清吧",@"茶室",@"台球室",@"电影院",@"洗浴",@"足浴",@"保健按摩",@"健身房",@"咖啡厅",@"图书馆",@"美术馆",@"话剧社",@"家具城",@"商场",@"游泳馆",@"瑜珈馆",@"美食城",@"KTV",@"公园",@"棋牌",@"书屋",@"养生会馆",@"温泉"],
                         @"hobby":@[@"诗词歌赋",@"茶艺",@"插花",@"国学",@"文学",@"哲学",@"禅宗",@"音乐",@"交际",@"收藏",@"运动",@"跑酷",@"天文",@"地理",@"政治",@"航海",@"汽车",@"飞机",@"军事",@"投资",@"摄影",@"美术",@"模型",@"小说",@"动漫",@"写作",@"书法",@"表演",@"烘培",@"陶艺",@"阅读",@"手工制作",@"游戏",@"乐器"],
                         @"fSport":@[@"单车",@"乒乓球",@"羽毛球",@"游泳",@"跑步",@"瑜伽",@"篮球",@"足球",@"壁球",@"排球",@"棒球",@"橄榄球",@"自行车",@"摩托车",@"空手道",@"体操",@"航海",@"柔道",@"潜水",@"滑板",@"滑雪",@"滑冰",@"武术",@"钓鱼",@"水上运动",@"健身",@"汽车",@"网球",@"高尔夫",@"台球",@"舞蹈",@"街舞",@"健身房",@"射箭",@"击剑",@"射击",@"拳击",@"跆拳道",@"爬山",@"骑马",@"郊游",@"暴走",@"睡觉"],
                         @"fFood":@[@"北京烤鸭",@"火锅",@"麻辣香锅",@"泰国菜",@"法国菜",@"意大利菜",@"日式料理",@"牛排",@"港式茶餐厅",@"烧烤",@"烤鱼",@"冒菜",@"川菜",@"素食",@"越南菜",@"娘惹菜",@"生煎包",@"卤肉饭",@"石锅拌饭",@"韩式烤肉",@"墨西哥Tacos",@"披萨",@"汉堡",@"薯条",@"美式炸鸡",@"土耳其烤肉",@"甜点蛋糕",@"奶酪芝士",@"巧克力",@"冰激凌"],
                         @"fMovie":@[@"泰坦尼克号",@"当幸福来敲门",@"纵横四海",@"机械师",@"北京遇上西雅图",@"忠犬八公的故事",@"罗马假日",@"肖申克的救赎",@"霸王别姬",@"这个杀手不太冷",@"教父",@"阿甘正传",@"盗梦空间",@"黑客帝国",@"蝙蝠侠",@"低俗小说",@"搏击俱乐部",@"海上钢琴师",@"触不可及",@"千与千寻",@"乱世佳人",@"辛德勒的名单",@"天使爱美丽",@"两杆大烟枪",@"飞越疯人院",@"闻香识女人",@"死亡诗社",@"美丽心灵",@"魔戒三部曲",@"狮子王",@"哈利波特",@"机器人总动员",@"英雄本色",@"赌神",@"无间道",@"大话西游",@"喜剧之王",@"东邪西毒",@"倩女幽魂",@"中国合伙人",@"阳光灿烂的日子",@"那些年，我们一起追的女孩",@"老男孩",@"功夫熊猫",@"我的野蛮女友",@"初恋这件小事",@"重庆森林",@"春光乍泄",@"情书",@"偷拐抢骗",@"杀死比尔",@"被解救的姜戈",@"沉默的羔羊",@"心灵捕手",@"日落大道",@"美国往事",@"上帝之城",@"大鱼",@"雨人",@"角斗士",@"穆赫兰道",@"X战警",@"终结者",@"变形金刚",@"星球大战",@"源代码",@"美丽人生",@"放牛班的春天",@"剪刀手爱德华",@"天堂电影院",@"燃情岁月",@"记忆碎片",@"撞车",@"第九区",@"傲慢与偏见",@"两小无猜",@"猩球崛起",@"小时代"],
                         @"fBookCartoon":@[@"纳兰容若",@"王阳明",@"白落梅",@"三毛",@"张爱玲",@"金庸",@"古龙",@"鲁迅",@"韩寒",@"郭敬明",@"王朔",@"王小波",@"琼瑶",@"亦舒",@"几米",@"村上春树",@"米兰。昆德拉",@"海贼王",@"火影忍者",@"灌篮高手",@"哆啦A梦",@"名侦探柯南",@"七龙珠",@"进击的巨人",@"新世纪福音战士",@"棋魂",@"樱桃小丸子",@"宠物小精灵",@"蜡笔小新",@"Hello Kitty",@"美少女战士",@"圣斗士星矢",@"幽游白书",@"乱马1/2",@"城市猎人",@"金田一少年事件簿",@"天使禁猎区",@"喜羊羊与灰太狼",@"妖精的尾巴",@"黑子的篮球",@"美食的俘虏",@"死神",@"网球王子"],
                         @"visitedPlace":@[@"美国",@"德国",@"奥地利",@"匈牙利",@"马来西亚",@"泰国",@"迪拜",@"法国",@"希腊",@"意大利",@"瑞士",@"捷克",@"成都",@"桂林",@"三亚",@"丽江",@"大理",@"香格里拉",@"西藏",@"鼓浪屿",@"张家界",@"九寨沟",@"台湾",@"日本",@"韩国",@"巴厘岛",@"塞班岛",@"新加坡",@"印度",@"越南",@"朝鲜",@"尼泊尔",@"土耳其",@"加拿大",@"澳大利亚",@"英国",@"西班牙",@"葡萄牙",@"芬兰",@"荷兰",@"比利时",@"瑞典",@"丹麦",@"古巴",@"阿根廷",@"巴西",@"新西兰",@"俄罗斯",@"埃及",@"柬埔寨",@"老挝",@"伊朗",@"菲律宾",@"缅甸",@"墨西哥",@"帕劳",@"大溪地",@"夏威夷",@"关岛",@"马尔代夫",@"毛里求斯",@"斯里兰卡",@"智利",@"冰岛",@"挪威",@"斐济",@"非洲"],
                         @"salary":@[@"0-4999",@"5000-9999",@"10000-19999",@"20000-29999",@"30000+"]
                         };
    }
    
    return _infoItemDic;
}

#pragma public
//检查该版本是否第一次使用
BOOL isFirstUsing(){
    //#if DEBUG
    //    NSString *key = @"CFBundleVersion";
    //#else
    NSString *key = @"CFBundleShortVersionString";
    //#endif
    
    // 1.当前版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    
    // 2.从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    // 3.写入本次版本号
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return ![version isEqualToString:saveVersion];
}

NSString *sha1(NSString *string){
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    
    
    NSMutableString *outputStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    
    
    for(int i=0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        
        [outputStr appendFormat:@"%02x", digest[i]];
        
    }
    
    return outputStr;
}

UIButton *NewTextButton(NSString *title, UIColor *textColor){
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(screen_width - 64, 0, 64, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    //    saveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    return button;
}

UIButton *NewBackButton(UIColor *color){
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *i = [UIImage imageNamed:@"nav_back"];
    if (color) {
        i = [i imageWithColor:color];
    }
    
    [btn setImage:i forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 64, 44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(10, kEdge, 10, 64 - kEdge - 14);
    return btn;
}

//日期-文本转换
NSDate *dateFromString(NSString *dateString, NSString *format){
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:format];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    
    return destDate;
    
}

NSString *stringFromDate(NSDate *date, NSString *format){
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:format];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    
    return destDateString;
}

+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantWidth:(CGFloat)width{
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = 0;
    
    NSStringDrawingOptions drawOptions = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attibutes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    
    return [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:drawOptions attributes:attibutes context:nil].size;
}

+ (CGSize)textSizeWithString:(NSString *)text font:(UIFont *)font constantHeight:(CGFloat)height{
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = 0;
    
    
    NSStringDrawingOptions drawOptions = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attibutes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:drawOptions attributes:attibutes context:nil].size;
}

/** 将数组转化为json字符串 */
+ (NSString *)convertArrayToJson:(NSArray *)array{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        if (jsonData && jsonData.length > 0) {
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            return jsonStr;
        }
        return nil;
    } else {
        return nil;
    }
}


/** 将字典转化为json字符串 *///
+ (NSString *)convertDictionaryToJson:(NSDictionary *)dictionary{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        if (jsonData && jsonData.length > 0) {
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            return jsonStr;
        }
        return nil;
    } else {
        return nil;
    }
}

//开始抖动
+ (void)BeginWobble:(UIView *)view{
    srand([[NSDate date] timeIntervalSince1970]);
    float rand = (float)random();
    CFTimeInterval t = rand * 0.0000000001;
    
    [UIView animateWithDuration:0.1 delay:t options:0 animations:^{
        view.transform = CGAffineTransformMakeRotation(-0.01);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^{
            view.transform = CGAffineTransformMakeRotation(0.01);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

//停止抖动
+ (void)EndWobble:(UIView *)view{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

//切圆角
+ (void)roundCornerRadius:(UIView *)view{
    view.layer.cornerRadius = 0.5 * MAX(view.width, view.height);
    view.layer.masksToBounds = YES;
}

- (void)logOut{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kUserData];
    _userData = nil;
    
    [self goToLoginCompletion:nil];
}

- (void)loginDonewithUserData:(NSDictionary *)data username:(NSString *)username password:(NSString *)password{
    if (!data || !username) {
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:username forKey:kUserName];
    _userData = [AppUserData mj_objectWithKeyValues:data[@"Data"]];
    [ud setObject:[_userData mj_keyValues] forKey:kUserData];
    
    [self goToMainVC];
}

- (void)goToMainVC{
    MainTabNavController *nav = [MainTabNavController new];
    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
}

- (void)goToLoginCompletion:(void (^)(void))completion{
    FirstPageController *vc = [FirstPageController new];
    
    [UIApplication sharedApplication].delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
}

@end
