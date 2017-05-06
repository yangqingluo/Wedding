//
//  WEAskInfoController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/12.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEAskInfoController.h"
#import "WELookDetailCell.h"
#import "WELookDetailModel.h"
#import "XWPickerView.h"
#import "WESeletedController.h"
@interface WEAskInfoController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray      *dataSource;
@end

@implementation WEAskInfoController


- (void)configDataSource{
    
    /**
     *  数组不够20的话，其余的用 0 充数
     */
    NSMutableArray *replaceAr = [NSMutableArray arrayWithArray:self.anserArray];
    if (self.anserArray.count < 20) {
        for (int i = 0; i < 20 - self.anserArray.count; i ++) {
            [replaceAr addObject:@"0"];
        }
    }
    self.anserArray = [replaceAr mutableCopy];
   
    
    NSLog(@"%@",self.anserArray);
    self.dataSource = [NSMutableArray array];
    WELookDetailModel  *model0 = [[WELookDetailModel alloc]init];
    model0.title  = @"您认为婚姻在爱情中的比重是？";
    model0.content = [self transferStr:self.anserArray[0]];
    [self.dataSource addObject:model0];
    
    
    WELookDetailModel  *model1 = [[WELookDetailModel alloc]init];
    model1.title  = @"您的恋爱观比较接近于下列哪种情况？";
    model1.content = [self transferStr:self.anserArray[1]];

    [self.dataSource addObject:model1];
    
    
    WELookDetailModel  *model2 = [[WELookDetailModel alloc]init];
    model2.title  = @"您认为在婚姻中最合适的理财方式是 ";
    model2.content = [self transferStr:self.anserArray[2]];
    [self.dataSource addObject:model2];
    
    
    
    
    
    WELookDetailModel  *model4 = [[WELookDetailModel alloc]init];
    model4.title  = @"您认为恋人间应该";
    model4.content = [self transferStr:self.anserArray[3]];
    [self.dataSource addObject:model4];
    
    
    
    NSString *s  = @"谈恋爱时实行AA制、婚前财产公证、原则上婚后家务按情况分摊、子女由双方共同抚养、常看望双方父母，搞好家人关系、双方多交流陪伴，互为良师益友、能力范围内，经常制造惊喜、记得对方生日等重要纪念日、自制力，避免家庭争吵";
    NSArray *data = [s componentsSeparatedByString:@"、"];
    WELookDetailModel  *model5 = [[WELookDetailModel alloc]init];
    model5.title  = @"您最看重下列哪些行为";
    model5.content = [self transferStr:self.anserArray[4]];
    [self.dataSource addObject:model5];
    
    
    WELookDetailModel  *model6 = [[WELookDetailModel alloc]init];
    model6.title  = @"您对奢华的浪漫婚姻和朴实婚姻的态度是";
    model6.content = [self transferStr:self.anserArray[5]];
    [self.dataSource addObject:model6];
    
    
    WELookDetailModel  *model7 = [[WELookDetailModel alloc]init];
    model7.title  = @"您打算如何同另一半相处？";
    model7.content = [self transferStr:self.anserArray[6]];
    [self.dataSource addObject:model7];
    
    
    s  = @"经济是否宽裕、城市还是农村、家人是否好相处、生活习惯、养老负担、是否有违法背景、是否单亲家庭、不会特别在意";
    data = [s componentsSeparatedByString:@"、"];
    WELookDetailModel  *model8 = [[WELookDetailModel alloc]init];
    model8.title  = @"最在意对方家的哪个方面?";
    model8.content = [self transferStr:self.anserArray[7]];
    [self.dataSource addObject:model8];
    
    
    s  = @"有车有房、工作稳定、亲朋好友支持、感情好就行、差距不能太大、有私人空间、滋养彼此,成就彼此、无条件信任与宽容";
    data = [s componentsSeparatedByString:@"、"];

    WELookDetailModel  *model9 = [[WELookDetailModel alloc]init];
    model9.title  = @"您认为什么是结婚的必要条件? ";
    model9.content = [self transferStr:self.anserArray[8]];
    [self.dataSource addObject:model9];
    
    
    s  = @"金钱、权力地位、名誉事业、爱情、知识、开心健康、家庭、美貌";
    data = [s componentsSeparatedByString:@"、"];
    WELookDetailModel  *model10 = [[WELookDetailModel alloc]init];
    model10.title  = @"您认为在人的一生中，以下哪几项对您来说最重要";
    model10.content = [self transferStr:self.anserArray[9]];
    [self.dataSource addObject:model10];
    
    
    s  = @"读书看报学习、运动健身或户外活动、上网、休闲娱乐（唱K，打牌，聚会，看电影等）、睡觉、逛街购物、其它";
    data = [s componentsSeparatedByString:@"、"];
    WELookDetailModel  *model11 = [[WELookDetailModel alloc]init];
    model11.title  = @"你的业余时间一般是如何安排的";
    model1.content = [self transferStr:self.anserArray[10]];
    [self.dataSource addObject:model11];
    
    
    s  = @"忠诚坦诚、信任、尊重、宽容大方、自制力、其他";
    data = [s componentsSeparatedByString:@"、"];
    WELookDetailModel  *model12 = [[WELookDetailModel alloc]init];
    model12.title  = @"您认为维持爱情的因素是";
    model12.content = [self transferStr:self.anserArray[11]];
    [self.dataSource addObject:model12];
    
    
    s  = @"兴趣爱好相同、能力和文化水平、经济条件、地域家庭、身高外表、性格和三观、年龄、对感情专一程度";
    data = [s componentsSeparatedByString:@"、"];
    WELookDetailModel  *model13 = [[WELookDetailModel alloc]init];
    model13.title  = @"您找对象的主要标准是";
    model13.content = [self transferStr:self.anserArray[12]];
    [self.dataSource addObject:model13];
    
    
    s  = @"物质基础、感情共鸣、体谅与包容、相近的世界观，人生观，价值观、家庭背景、小孩、受外界诱惑的程度、其他";
    data = [s componentsSeparatedByString:@"、"];
    WELookDetailModel  *model14 = [[WELookDetailModel alloc]init];
    model14.title  = @"您认为维系婚姻的关键？";
    model4.content = [self transferStr:self.anserArray[13]];
    [self.dataSource addObject:model14];
    
    
    
    WELookDetailModel  *model15 = [[WELookDetailModel alloc]init];
    model15.title  = @"将来为人父母时，您最有可能是？";
    model15.content = [self transferStr:self.anserArray[14]];
    [self.dataSource addObject:model15];
    
    
    s  = @"奢华城市游、舒适度假海岛游、浪漫风情小镇游、古朴风情村落、奔放豪情大漠，大草原游、原始森林土著游、人文情怀，江南水乡";
    data = [s componentsSeparatedByString:@"、"];
    WELookDetailModel  *model16 = [[WELookDetailModel alloc]init];
    model16.title  = @"如果您去旅游您会更喜欢哪种风格的景色？";
    model16.content = [self transferStr:self.anserArray[15]];
    [self.dataSource addObject:model16];
    
    
    s  = @"外观、质量、品牌、价格、习惯、服务、其他";
    data = [s componentsSeparatedByString:@"、"];
    WELookDetailModel  *model17 = [[WELookDetailModel alloc]init];
    model17.title  = @"影响您购买决策的主要是";
    model17.content = [self transferStr:self.anserArray[16]];
    [self.dataSource addObject:model17];
    
    
    WELookDetailModel  *model18 = [[WELookDetailModel alloc]init];
    model18.title  = @"你的消费观是？";
    model18.content = [self transferStr:self.anserArray[17]];
    [self.dataSource addObject:model18];
    
    
    WELookDetailModel  *model19 = [[WELookDetailModel alloc]init];
    model19.title  = @"您如何看待路边行乞人员？";
    model19.content = [self transferStr:self.anserArray[18]];
    [self.dataSource addObject:model19];
    
    
    s  = @"聪慧善良、善解人意、浪漫风趣、诚信温和、务实能干、成熟稳重、开朗活泼、热心正义";
    data = [s componentsSeparatedByString:@"、"];
    WELookDetailModel  *model3 = [[WELookDetailModel alloc]init];
    model3.title  = @"您的理想恋爱对象是什么样的性格 ";
    model3.content = [self transferStr:self.anserArray[19]];
    [self.dataSource addObject:model3];

}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问卷";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configDataSource];
    [self.tableView registerNib:[UINib nibWithNibName:@"WELookDetailCell" bundle:nil] forCellReuseIdentifier:WELookDetailCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.sectionHeaderHeight = 100;
    
    
    if (self.type == WEAskInfoControllerTypeChangeInfo) {
        [self setNavigationRightBtnWithTitle:@"保存" selecterBack:@selector(save)];
    }
}

- (void)save {
    
    NSMutableString *resultStr = [NSMutableString string];
    for (int i = 0; i < self.dataSource.count; i ++) {
        WELookDetailModel *model = self.dataSource[i];
        if (model.content == nil) {
            NSString *errorStr = [NSString stringWithFormat:@"%d项未填写",i];
            SVPERROR(errorStr);
            return;
        } else{
            // 1.把数据源的“,”转化成“;”
            NSString *transferStr = [model.content stringByReplacingOccurrencesOfString:@";" withString:@"|"];
            NSString *appendStr = i == self.dataSource.count - 1 ? transferStr : [NSString stringWithFormat:@"%@&",transferStr];
            [resultStr appendString:appendStr];
        }
    }
    
    //发送的数据
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"mySurvey"] = resultStr;
    mDic[@"telNumber"] = [XWUserModel getUserInfoFromlocal].telNumber;
    NSString *url = BASEURL(@"/user/updatesurvey");
    [BANetManager ba_requestWithType:BAHttpRequestTypePost
                           urlString:url
                          parameters:mDic
                        successBlock:^(id response) {
                            NSLog(@"上传资料---->%@",response);
                            if ([response[@"success"] intValue] == 1) {
                                SVPSUCCESS(@"上传成功");

                                
                            } else{
                                SVPERROR(response[@"msg"]);
                            }
                        }
                        failureBlock:^(NSError *error) {
                            
                        }
                            progress:nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WELookDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:WELookDetailCellID];
    WELookDetailModel *model = self.dataSource[indexPath.row];
    cell.oneLable.text = model.title;
    cell.twoLable.text = model.content;
    if (indexPath.row<self.anserArray.count) {
        cell.twoLable.text = self.anserArray[indexPath.row];
        
    }else{
        
    }
    cell.wenjuanBtn.hidden = YES;
    cell.pingjia.hidden = YES;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WELookDetailModel *model = self.dataSource[indexPath.row];
    
    return [model xw_cellHeight]+50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.type == WEAskInfoControllerTypeChangeInfo) {
        WELookDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:{
                
                XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
                    cell.twoLable.text = seletedString;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = seletedString;
                } WithDataSource:@[@"0~25%",@"26％～50％",@"51%~75%",@"76％～100％"]];
                
                [view show];
                break;
            }
            case 1:{
                XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
                    cell.twoLable.text = seletedString;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = seletedString;
                } WithDataSource:@[@"遇到喜欢的人,有感觉,就会谈恋爱",@"能否长久无所谓,有空闲就想找人谈恋爱",@"对恋爱持谨慎态度,会考虑双方性格是否合适",@"以结婚为前提恋爱，认真而专一",@"为以后的婚姻提供宝贵的参考经验",@"其他"]];
                [view show];
                break;
                
            }
            case 2:{
                XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
                    cell.twoLable.text = seletedString;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = seletedString;
                } WithDataSource:@[@"双方钱财完全独立、互不干涉",@"钱财全部交给一方管理",@"钱财由双方共同管理",@"其它"]];
                [view show];
                break;
                
            }
            case 3:{
                XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
                    cell.twoLable.text = seletedString;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = seletedString;
                } WithDataSource:@[@"天天粘在一起",@"经常见面",@"距离产生美，偶尔见见",@"看情况，即便不见面时也要电话、短信嘘寒问暖"]];
                [view show];
                break;
                
            }
                
            case 4:{
                
                NSString *s  = @"谈恋爱时实行AA制、婚前财产公证、原则上婚后家务按情况分摊、子女由双方共同抚养、常看望双方父母，搞好家人关系、双方多交流陪伴，互为良师益友、能力范围内，经常制造惊喜、记得对方生日等重要纪念日、自制力，避免家庭争吵";
                NSArray *data = [s componentsSeparatedByString:@"、"];
                
                WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"最多3项"  type:@"all" maxCount:3 back:^(NSString *s) {
                    cell.twoLable.text = s;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = s;
                } originalString:cell.twoLable.text];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
                
                
            }
                
            case 5:{
                XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
                    cell.twoLable.text = seletedString;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = seletedString;
                } WithDataSource:@[@"希望大部分是奢华浪漫的生活",@"希望奢华和朴实参半",@"希望大部分是朴实的生活、偶尔制造些浪漫的惊喜",@"希望大部分是朴实的生活、偶尔制造些浪漫的惊喜",@"只要两个人一起携手同行,什么样的生活都无所谓"]];
                [view show];
                break;
                
            }
                
            case 6:{
                XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
                    cell.twoLable.text = seletedString;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = seletedString;
                } WithDataSource:@[@"双方有共同目标,一起努力",@"各自有发展方向,彼此理解",@"大多男方说了算",@"大多女方说了算",@"大多双方商量决定"]];
                [view show];
                break;
                
            } case 7:{
                
                NSString *s  = @"经济是否宽裕、城市还是农村、家人是否好相处、生活习惯、养老负担、是否有违法背景、是否单亲家庭、不会特别在意";
                NSArray *data = [s componentsSeparatedByString:@"、"];
                
                WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"最多3项"  type:@"all" maxCount:3 back:^(NSString *s) {
                    cell.twoLable.text = s;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = s;
                } originalString:cell.twoLable.text];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
                
                
            }
            case 8:{
                
                NSString *s  = @"有车有房、工作稳定、亲朋好友支持、感情好就行、差距不能太大、有私人空间、滋养彼此,成就彼此、无条件信任与宽容";
                NSArray *data = [s componentsSeparatedByString:@"、"];
                
                WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"最多3项"  type:@"all" maxCount:3 back:^(NSString *s) {
                    cell.twoLable.text = s;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = s;
                } originalString:cell.twoLable.text];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
                
                
            }
            case 9:{
                
                NSString *s  = @"金钱、权力地位、名誉事业、爱情、知识、开心健康、家庭、美貌";
                NSArray *data = [s componentsSeparatedByString:@"、"];
                
                WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"最多3项"  type:@"all" maxCount:3 back:^(NSString *s) {
                    cell.twoLable.text = s;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = s;
                } originalString:cell.twoLable.text];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
                
                
            }
                
            case 10:{
                
                NSString *s  = @"读书看报学习、运动健身或户外活动、上网、休闲娱乐（唱K，打牌，聚会，看电影等）、睡觉、逛街购物、其它";
                NSArray *data = [s componentsSeparatedByString:@"、"];
                
                WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"最多3项"  type:@"all" maxCount:3 back:^(NSString *s) {
                    cell.twoLable.text = s;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = s;
                } originalString:cell.twoLable.text];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
                
                
            }
                
            case 11:{
                
                NSString *s  = @"忠诚坦诚、信任、尊重、宽容大方、自制力、其他";
                NSArray *data = [s componentsSeparatedByString:@"、"];
                
                WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"最多3项"  type:@"all" maxCount:3 back:^(NSString *s) {
                    cell.twoLable.text = s;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = s;
                } originalString:cell.twoLable.text];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
                
                
            }
            case 12:{
                
                NSString *s  = @"兴趣爱好相同、能力和文化水平、经济条件、地域家庭、身高外表、性格和三观、年龄、对感情专一程度";
                NSArray *data = [s componentsSeparatedByString:@"、"];
                
                WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"最多3项"  type:@"all" maxCount:3 back:^(NSString *s) {
                    cell.twoLable.text = s;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = s;
                } originalString:cell.twoLable.text];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
                
                
            }
            case 13:{
                
                NSString *s  = @"物质基础、感情共鸣、体谅与包容、相近的世界观，人生观，价值观、家庭背景、小孩、受外界诱惑的程度、其他";
                NSArray *data = [s componentsSeparatedByString:@"、"];
                
                WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"最多3项"  type:@"all" maxCount:3 back:^(NSString *s) {
                    cell.twoLable.text = s;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = s;
                } originalString:cell.twoLable.text];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
                
                
            }
            case 14:{
                XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
                    cell.twoLable.text = seletedString;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = seletedString;
                    
                } WithDataSource:@[@"不干涉子女自由或是容易心软的",@"严厉的或是直接给予方向性指导的",@"实际行动代替语言来表示关爱或是高要求的",@"会陪孩子一起玩耍的，孩子朋友们也喜欢的"]];
                [view show];
                break;
            }
            case 15:{
                
                NSString *s  = @"奢华城市游、舒适度假海岛游、浪漫风情小镇游、古朴风情村落、奔放豪情大漠，大草原游、原始森林土著游、人文情怀，江南水乡";
                NSArray *data = [s componentsSeparatedByString:@"、"];
                
                WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"最多3项"  type:@"all" maxCount:3 back:^(NSString *s) {
                    cell.twoLable.text = s;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = s;
                } originalString:cell.twoLable.text];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
                
                
            }
                
            case 16:{
                
                NSString *s  = @"外观、质量、品牌、价格、习惯、服务、其他";
                NSArray *data = [s componentsSeparatedByString:@"、"];
                
                WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"最多3项"  type:@"all" maxCount:3 back:^(NSString *s) {
                    cell.twoLable.text = s;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = s;
                } originalString:cell.twoLable.text];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
                
                
            }
            case 17:{
                XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
                    cell.twoLable.text = seletedString;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = seletedString;
                    
                } WithDataSource:@[@"有钱先存起来，以备未来的开支",@"钱存着会贬值，不如趁早投资或花掉",@"存一点，消费一点，投资一点",@"有存款也会贷款消费或投资",@"没钱也要贷款消费"]];
                [view show];
                break;
            }
                
            case 18:{
                XWPickerView *view = [[XWPickerView alloc]initWithCallBack:^(NSString *seletedString) {
                    cell.twoLable.text = seletedString;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = seletedString;
                    
                } WithDataSource:@[@"确实生活有困难，会施舍",@"都是假的，肯定不会施舍",@"看情况（老人或残疾等）施舍",@"不关我事"]];
                [view show];
                break;
            }
                
                
            case 19:{
                
                NSString *s  = @"聪慧善良、善解人意、浪漫风趣、诚信温和、务实能干、成熟稳重、开朗活泼、热心正义";
                NSArray *data = [s componentsSeparatedByString:@"、"];
                
                WESeletedController *vc = [[WESeletedController alloc]initWithDataSource:data title:@"最多3项"  type:@"all" maxCount:3 back:^(NSString *s) {
                    cell.twoLable.text = s;
                    WELookDetailModel *model = self.dataSource[indexPath.row];
                    model.content = s;
                    
                } originalString:cell.twoLable.text];
                [self.navigationController pushViewController:vc animated:YES];
                
                break;
                
                
            }
                
                
                
                
            default:
                break;
        }

    }
}

#pragma mark - 头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [UIView new];
    header.frame = CGRectMake(0, 0, SCREEN_W, 100);
    UILabel *lab = [UILabel new];
    lab.frame = CGRectMake(20, 0, SCREEN_W - 20, 100);
    lab.text = @"问卷代表ta的心";
    lab.font = [UIFont systemFontOfSize:20];
    [header addSubview:lab];
    return header;
}

/**
 *  取消header 的悬停
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 100;
//    NSLog(@"滑动的%lf",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    NSLog(@"滑动的%lf",scrollView.contentOffset.y);
}


#pragma mark - private
- (NSString *)transferStr:(NSString *)indexStr {
    
    NSMutableString *resultStr = [NSMutableString string];
    if ([indexStr rangeOfString:@"|"].location == NSNotFound) {
        resultStr = [indexStr mutableCopy];
    } else{
        NSArray *selectedIndexAr = [indexStr componentsSeparatedByString:@"|"];
        for (int i = 0; i < selectedIndexAr.count; i ++) {
            [resultStr appendFormat:@"%@,",selectedIndexAr[i]];
        }
        [resultStr deleteCharactersInRange:NSMakeRange(resultStr.length - 1, 1)];
    }
    return resultStr;
}

- (NSString *)chooseWithArray:(NSArray *)dataAr selectedIndex:(NSString *)indexStr {
    
    NSMutableString *resultStr = [NSMutableString string];
    if ([indexStr rangeOfString:@"|"].location == NSNotFound) { //只有一个选项
        resultStr = dataAr[[indexStr integerValue]];
    } else{ //很多选项
        NSArray *selectedIndexAr = [indexStr componentsSeparatedByString:@"|"];
        for (int i = 0; i < selectedIndexAr.count; i ++) {
            [resultStr appendFormat:@"%@,",dataAr[[selectedIndexAr[i] integerValue]]];
        }
        [resultStr deleteCharactersInRange:NSMakeRange(resultStr.length - 1, 1)];
    }
    return resultStr;
}
@end
