//
//  PublicSelectionVC.m
//  WB_wedding
//
//  Created by yangqingluo on 2017/5/15.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "PublicSelectionVC.h"

@interface PublicSelectionVC ()


@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, copy) SelectDoneBlock doneBlock;

@property (nonatomic, assign) NSUInteger maxSelectCount;

@end

@implementation PublicSelectionVC

- (instancetype)initWithDataSource:(NSArray *)data selectedArray:(NSArray *)selectdArray maxSelectCount:(NSUInteger)count back:(SelectDoneBlock)block{
    self = [super init];
    if (self) {
        self.dataSource = [data copy];
        
        self.selectedArray = [NSMutableArray arrayWithCapacity:self.dataSource.count];
        for (int i = 0; i < self.dataSource.count; i++) {
            [self.selectedArray addObject:@NO];
        }
        
        for (NSString *object in selectdArray) {
            int index = [object intValue] - 1;
            if (index < self.selectedArray.count && index >= 0) {
                self.selectedArray[index] = @YES;
            }
        }
        
        self.maxSelectCount = count;
        if (count == 0) {
            self.maxSelectCount = self.dataSource.count;
        }
        self.doneBlock = block;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}

- (void)setupNav {
    [self createNavWithTitle:self.title ? self.title : @"请选择" createMenuItem:^UIView *(int nIndex){
        if (nIndex == 0){
            UIButton *btn = NewBackButton(nil);
            [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
        
        return nil;
    }];
    
}

- (void)goBack{
    if (self.doneBlock) {
        NSString *string = @"";
        for (int i = 0; i < self.selectedArray.count; i++) {
            NSNumber *object = self.selectedArray[i];
            if ([object boolValue]) {
                string = [string stringByAppendingString:[NSString stringWithFormat:@"%@%d", string.length ? @"," : @"", i + 1]];
            }
        }
        
        self.doneBlock(string);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSUInteger)calculateSelectedCount{
    NSUInteger count = 0;
    for (NSNumber *object in self.selectedArray) {
        if ([object boolValue]) {
            count++;
        }
    }
    
    return count;
}

#pragma tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kEdge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"selection_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.font = [UIFont systemFontOfSize:appLabelFontSize];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.accessoryType = [self.selectedArray[indexPath.row] boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.maxSelectCount == 1) {
        for (NSUInteger i = 0; i < self.selectedArray.count; i++) {
            self.selectedArray[i] = @(i == indexPath.row);
        }
    }
    else {
        if ([self.selectedArray[indexPath.row] boolValue]) {
            self.selectedArray[indexPath.row] = @NO;
        }
        else {
            NSUInteger selectedCount = [self calculateSelectedCount];
            if (selectedCount < self.maxSelectCount) {
                self.selectedArray[indexPath.row] = @YES;
            }
            else {
                [self showHint:[NSString stringWithFormat:@"最多只能选择%d项", (int)self.maxSelectCount]];
            }
        }
    }
    
    [tableView reloadData];
}


@end
