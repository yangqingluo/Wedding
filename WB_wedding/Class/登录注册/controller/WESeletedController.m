
//
//  WESeletedController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/23.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WESeletedController.h"
#import "WESeletedViewCell.h"
#import "WESeletedController.h"

static NSString *const SeperatorCharacter = @"|";

@interface WESeletedController ()<UITableViewDelegate,UITableViewDataSource,WESeletedViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,copy)NSString  *titless;


@property (nonatomic,copy)NSArray       *data;
@property (nonatomic,copy)backAction    back;

@property (nonatomic,copy)NSString      *type;
@property (nonatomic,strong)NSMutableArray  *cellArray; //被选中的cell   (IndexPath)
@property (nonatomic,strong)NSMutableArray  *seletStringArray;
@property (nonatomic,assign)NSInteger       count;
@property (nonatomic, strong) NSString *originalStr;

@end

@implementation WESeletedController


- (instancetype)initWithDataSource:(NSArray *)data title:(NSString *)title type:(NSString *)type maxCount:(NSInteger)count  back:(backAction)back originalString:(NSString *)originalStr{
    if (self == [super init]) {
        self.data = data;
        self.back = back;
        self.titless = title;
        self.type = type;
        self.count = count;
        // 过滤一次，怕里面没得
        NSArray *strAr = [originalStr componentsSeparatedByString:SeperatorCharacter];
        if ([data containsObject:strAr[0]]) {
            self.originalStr = originalStr;
        } else {
            self.originalStr = nil;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellArray  = [NSMutableArray array];
    self.seletStringArray = [NSMutableArray array];
    [self.tableview registerNib:[UINib nibWithNibName:@"WESeletedViewCell" bundle:nil] forCellReuseIdentifier:WESeletedViewCellID];
    self.tableview.tableFooterView = [UIView new];
    self.title = self.titless;
 
    if ([self.type isEqualToString:@"all"]) {
        QKWEAKSELF;
        [self setNavigationRightBtnWithTitle:@"保存" actionBack:^{
            if (weakself.seletStringArray.count != 0) {
                NSMutableString *name = [NSMutableString string];
                for (NSString *ss in weakself.seletStringArray) {
                    [name appendString:[NSString stringWithFormat:@"%@%@",ss,SeperatorCharacter]];
                }
                [name deleteCharactersInRange:NSMakeRange(name.length - 1, 1)];
                if (weakself.back) {
                    weakself.back(name);
                    [weakself.navigationController popViewControllerAnimated:YES];
                }

            } else {
                SVPERROR(@"还未选择");
            }
        }];
        
        // 找到原来的ar;
        self.seletStringArray = [NSMutableArray arrayWithArray:[self.originalStr componentsSeparatedByString:SeperatorCharacter]];
        
        
        for (NSString *str in self.seletStringArray) {
            NSInteger index = [self.data indexOfObject:str];
            NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
            [self.cellArray addObject:path];
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WESeletedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WESeletedViewCellID];
    cell.name.text = self.data[indexPath.row];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.icon.selected = NO;
    
    if ([self.type isEqualToString:@"all"]) {
        
//        for (NSIndexPath  *idx in self.cellArray) {
//            WESeletedViewCell *cells = [tableView cellForRowAtIndexPath:idx];
//            cells.icon.selected = YES;
//           
//        }
        if ([self.cellArray containsObject:indexPath]) {
            cell.icon.selected = YES;
        }
        
    } else{
        
        if ([self.originalStr isEqualToString:self.data[indexPath.row]]) {
            cell.icon.selected = YES;
        }
    }
    
      return cell;
    
    
    
}
- (void)didSelted:(NSIndexPath *)indexPath sender:(UIButton *)sender{
    if ([self.type isEqualToString:@"all"]) {
        
        
        
        
        
        
            if (self.cellArray.count>=3) {
                
                // 先判断是不是点击的原来三个
                if ([self.cellArray containsObject:indexPath]) {
                    
                    sender.selected =!sender.selected;
                    if (sender.selected == YES) {
                        NSString *string = self.data[indexPath.row];
                        
                        [self.seletStringArray addObject:string];
                        [self.cellArray    addObject:indexPath];
                        NSLog(@"加入 %ld",indexPath.row);
                        
                        
                    }else{
                        [self.cellArray removeObject:indexPath];
                        NSString *string = self.data[indexPath.row];
                        [self.seletStringArray removeObject:string];
                        NSLog(@"移除 %ld",indexPath.row);
                        
                    }
                    
                    return;
                } else{
                    [self showMessage:@"最多选择3项" toView:self.view];
                    
                    return;
                }
                
            }
            

        
        
        
        
        
        
        
        sender.selected =!sender.selected;
        
        if (sender.selected == YES) {
            NSString *string = self.data[indexPath.row];
            
            [self.seletStringArray addObject:string];
            [self.cellArray    addObject:indexPath];
            NSLog(@"加入 %ld",indexPath.row);
            
            
        }else{
            [self.cellArray removeObject:indexPath];
            NSString *string = self.data[indexPath.row];
            [self.seletStringArray removeObject:string];
            NSLog(@"移除 %ld",indexPath.row);

        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToString:@"all"]) {
        
    }else{
        if (self.back) {
            self.back(self.data[indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


@end
