//
//  WEHomeCacheTool.m
//  WB_wedding
//
//  Created by 谢威 on 17/2/9.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WEHomeCacheTool.h"


static FMDatabase   *_db;
@implementation WEHomeCacheTool
+ (void)initialize{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)lastObject];
    
    NSString *filePath = [path stringByAppendingString:@"HomePageCache.sqlite"];
    // 打开数据库
    
    // 打开数据库
    _db = [FMDatabase databaseWithPath:filePath];
    
    if ([_db open]) {
        NSLog(@"打开数据库成功");
    }else{
        
        NSLog(@"打开数据库失败");
        
    }
        
    // 创建首页缓存表
    BOOL flag = [_db executeUpdateWithFormat:@"create table if not exists t_homePageInfo (id integer primary key autoincrement,dict bolb,xw_id text);"];
    
    if (flag) {
        
        NSLog(@"创建首页缓存表成功");
    }else{
        
        NSLog(@"创建首页缓存表失败");
        
    }

}

+ (void)saveHomeInfoWithArray:(NSArray *)array{
    
    for (NSDictionary *dic in array) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
        BOOL flag = [_db executeUpdate:@"insert into t_homePageInfo (dict,xw_id) values (?,?);",data,dic[@"id"]];
        if (flag) {
            
            NSLog(@"储存数据成功");
            
        }else{
            
            NSLog(@"储存数据失败");
            
        }
        
        
        
    }
    
        
}


+ (NSArray *)readAllInfo{
    
    
    NSString *sql1 = [NSString stringWithFormat:@"select * from t_homePageInfo"];
    FMResultSet *set = [_db executeQuery:sql1];
    
    NSMutableArray *array = [NSMutableArray array];
    while (set.next) {
        
        NSData *data = [set dataForColumn:@"dict"];
        // 二进制转字典
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [array addObject:dic];
        
        
        
    }
    return array;
    
}


+(void)deleteInfoWithID:(NSString *)ID{
    

    BOOL flag =  [_db executeUpdate:@"delete from t_homePageInfo where xw_id = ?;",ID];
    
    if (flag) {
        NSLog(@"删除缓存成功");
    }else{
        NSLog(@"删除缓存失败");
        
    }
    
    
}



@end


