//
//  WEMYAskViewController.m
//  WB_wedding
//
//  Created by 谢威 on 17/1/17.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEMYAskViewController.h"

#import "WEMyAskCell.h"
@interface WEMYAskViewController ()<UITableViewDataSource,UITableViewDelegate,WEMyAskCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (nonatomic,strong)NSMutableArray  *dataSouce;
@property (nonatomic, strong) NSMutableArray *questionMar;

@end

@implementation WEMYAskViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.dataSouce = [NSMutableArray arrayWithCapacity:3];
    if (self.questionStr && self.questionStr.length > 0) {
        _questionMar = [NSMutableArray arrayWithArray:[self.questionStr componentsSeparatedByString:@"&"]];
    }
    self.view.backgroundColor = [UIColor whiteColor];

    [self.dataSouce addObject:@"1"];
    [self.dataSouce addObject:@"1"];
    [self.dataSouce addObject:@"1"];
    
    if (_questionMar.count > 3) {
        for (int i = 0; i < _questionMar.count - 3; i ++) {
            [self.dataSouce addObject:@"1"];
        }
    }

    self.title  = @"我的提问";
    [self.tabelView registerNib:[UINib nibWithNibName:@"WEMyAskCell" bundle:nil] forCellReuseIdentifier:WEMyAskCellID];
    self.tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabelView.rowHeight = 60;
    
    QKWEAKSELF;
    [self setNavigationRightBtnWithTitle:@"保存" actionBack:^{
        NSMutableString *resultStr = [NSMutableString string];
        for (int i = 0; i < self.dataSouce.count ; i ++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
            WEMyAskCell *cell = [weakself.tabelView cellForRowAtIndexPath:path];
            if (cell.textFiled.text.length < 1 && i < 3) {
                SVPERROR(@"至少输入三项");
                return ;
            } else if(cell.textFiled.text.length > 0 && cell.textFiled.text){
                [resultStr appendString:[NSString stringWithFormat:@"%@&",cell.textFiled.text]];
            }
        }
        if (resultStr.length > 0) {
            [resultStr deleteCharactersInRange:NSMakeRange(resultStr.length - 1, 1)];
            if (self.blockAskBlock) {
                self.blockAskBlock(resultStr);
                [weakself.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return MAX(self.dataSouce.count, 3);
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WEMyAskCell *cell = [tableView dequeueReusableCellWithIdentifier:WEMyAskCellID];
    cell.one.text = [NSString stringWithFormat:@"%ld.",indexPath.row+1];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    if (self.questionMar.count > indexPath.row) {
        cell.textFiled.text = self.questionMar[indexPath.row];
    }
    
    if (indexPath.row<=2) {
        cell.deleteBtn.hidden = YES;
    }else{
         cell.deleteBtn.hidden = NO;
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"添加问题" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, KScreenWidth, 60);
    [btn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
    
}

- (void)add:(UIButton *)sender{
    if (self.dataSouce.count > 9) {
        SVPERROR(@"最多添加10个问题");
        return;
    }
    [self.dataSouce addObject:@"1"];
    [self.tabelView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 60;
}

- (void)didDeleteIndex:(NSIndexPath *)indexPath{
    
    if (indexPath.row>=3) {
        [self.dataSouce removeObjectAtIndex:indexPath.row];
        [self.tabelView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tabelView reloadData];

    }
    
}


@end
