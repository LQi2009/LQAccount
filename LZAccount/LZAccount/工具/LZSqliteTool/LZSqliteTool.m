//
//  LZSqliteTool.m
//  AccountManager
//
//  Created by Artron_LQQ on 16/4/18.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZSqliteTool.h"
#import "FMDB.h"
#import "LZStringEncode.h"

//static FMDatabase *LZ_db = nil;
static NSString *LZ_dbPath = nil;
//static NSString *LZ_tableName = nil;

@implementation LZSqliteTool

+ (NSString *)LZCreateSqliteWithName:(NSString*)sqliteName {
    NSString *fileName = nil;
    NSArray *strArr = [sqliteName componentsSeparatedByString:@"."];
    if ([[strArr lastObject] isEqualToString:@"sqlite"]||[[strArr lastObject] isEqualToString:@"db"]) {
        fileName = sqliteName;
    } else {
        fileName = [NSString stringWithFormat:@"%@.db",sqliteName];
    }
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userData"];
    
//    [NSString stringWithFormat:@"Documents/userData/%@",fileName]
    
    NSFileManager *manager = [NSFileManager defaultManager];

    // 创建文件夹
    if (![manager fileExistsAtPath:path]) {
        
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    path = [path stringByAppendingPathComponent:fileName];
    
    LZLog(@"数据库路径: %@",path);
    LZ_dbPath = path;
    if (![manager fileExistsAtPath:path]) {
        
        [manager createFileAtPath:path contents:nil attributes:nil];
    }
    
    return path;
}

+ (FMDatabase*)LZDefaultDataBase {
    
    if (LZ_dbPath == nil) {
        [self LZCreateSqliteWithName:@"myDataBase"];
    }
    
    FMDatabase* db = [[FMDatabase alloc]initWithPath:LZ_dbPath];
    
    return db;
}

//创建数据详情表
+ (void)LZCreateDataTableWithName:(NSString*)tableName {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        return;
    }
    //为数据设置缓存,提高查询效率
    [LZ_db setShouldCacheStatements:YES];
    if (![LZ_db tableExists:tableName]) {
        NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'(identifier TEXT UNIQUE NOT NULL,groupName TEXT,nickName TEXT,userName TEXT,password TEXT,urlString TEXT,email TEXT,dsc TEXT,groupID TEXT NOT NULL)",tableName];
        [LZ_db executeUpdate:createTable];
    }
    
    [LZ_db close];
}

//创建分组详情表
+ (void)LZCreateGroupTableWithName:(NSString*)tableName {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        return;
    }
    //为数据设置缓存,提高查询效率
    [LZ_db setShouldCacheStatements:YES];
    if (![LZ_db tableExists:tableName]) {
        NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'(identifier TEXT UNIQUE NOT NULL,groupName TEXT)",tableName];
        [LZ_db executeUpdate:createTable];
    }
    
    [LZ_db close];
}

//删除表
+ (void)LZDeleteTableWithName:(NSString*)tableName {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        
        return;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        NSString *dropTable = [NSString stringWithFormat:@"DROP TABLE '%@'",tableName];
        [LZ_db executeUpdate:dropTable];
    }
    
    [LZ_db close];
}

//为表添加元素
+ (void)LZAlterToTable:(NSString*)tableName element:(NSString*)element {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        
        return;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        NSString *alter = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD '%@' TEXT",tableName,element];
        
        [LZ_db executeUpdate:alter];
    }
    
    [LZ_db close];
}

//更新数据表
+ (void)LZUpdateTable:(NSString*)tableName model:(LZDataModel*)model {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        
        return;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
//        NSString *update = [NSString stringWithFormat:@"UPDATE '%@' SET userName = '%@',password = '%@' WHERE identifier = '%@'",tableName,model.userName,model.password,model.identifier];
        
        
        NSString *psw = [LZStringEncode encode:model.password];
        NSString *userName = [LZStringEncode encode:model.userName];
        NSString *email = [LZStringEncode encode:model.email];
        NSString *dsc = [LZStringEncode encode:model.dsc];
        NSString *update = [NSString stringWithFormat:@"UPDATE '%@' SET userName = '%@',password = '%@',nickName= '%@',groupName = '%@',dsc = '%@',urlString = '%@',groupID = '%@',email = '%@' WHERE identifier = '%@'",tableName,userName,psw,model.nickName,model.groupName,dsc,model.urlString,model.groupID,email,model.identifier];
        
//        @"UPDATE '%@' SET userName = '%@',password = '%@',nickName= '%@',groupName = '%@',dsc = '%@',urlString = '%@',groupID = '%@',email = '%@' WHERE identifier = '%@'",tableName,model.userName,model.password,model.nickName,model.groupName,model.dsc,model.urlString,model.groupID,model.email,model.identifier
        
//        [LZ_db executeUpdate:@"UPDATE ? SET userName=?,password = ? WHERE identifier = ?",tableName,model.userName,model.password,model.identifier];
//        [LZ_db executeQueryWithFormat:@"UPDATE %@ SET userName = %@,password = %@ WHERE identifier = %@",tableName,model.userName,model.password,model.identifier];
        
        [LZ_db executeUpdate:update];
    }
    
    [LZ_db close];
}

//更新分组表
+ (void)LZUpdateGroupTable:(NSString*)tableName model:(LZGroupModel*)model {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        
        return;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        NSString *update = [NSString stringWithFormat:@"UPDATE '%@' SET groupName = '%@' WHERE identifier = '%@'",tableName,model.groupName,model.identifier];
        
        [LZ_db executeUpdate:update];
        //        [LZ_db executeUpdate:@"UPDATE ? SET userName=?,password = ? WHERE identifier = ?",tableName,model.userName,model.password,model.identifier];
        //        [LZ_db executeQueryWithFormat:@"UPDATE %@ SET userName = %@,password = %@ WHERE identifier = %@",tableName,model.userName,model.password,model.identifier];
    }
    
    [LZ_db close];
}

//插入数据
+ (void)LZInsertOldToTable:(NSString*)tableName model:(LZDataModel*)model {
    
    FMDatabase *db = [self LZDefaultDataBase];
    if (![db open]) {
        [db close];
        return;
    }
    
    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
        //        @"INSERT INTO %@ VALUES (%@,%@,%@,%@,%@)" 顺序需和表一致
        
        NSString *psw = model.password;
        NSString *userName = model.userName;
        NSString *email = model.email;
        NSString *dsc = model.dsc;
        
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO '%@' (identifier,groupName,nickName,userName,password,urlString,dsc,groupID,email) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",tableName,model.identifier,model.groupName,model.nickName,userName,psw,model.urlString,dsc,model.groupID,email];
        
        [db executeUpdate:insert];
    }
    
    [db close];
}

//插入数据
+ (void)LZInsertToTable:(NSString*)tableName model:(LZDataModel*)model {
    
    FMDatabase *db = [self LZDefaultDataBase];
    if (![db open]) {
        [db close];
        return;
    }

    [db setShouldCacheStatements:YES];
    if ([db tableExists:tableName]) {
//        @"INSERT INTO %@ VALUES (%@,%@,%@,%@,%@)" 顺序需和表一致
        
        NSString *psw = [LZStringEncode encode:model.password];
        NSString *userName = [LZStringEncode encode:model.userName];
        NSString *email = [LZStringEncode encode:model.email];
        NSString *dsc = [LZStringEncode encode:model.dsc];
        
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO '%@' (identifier,groupName,nickName,userName,password,urlString,dsc,groupID,email) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",tableName,model.identifier,model.groupName,model.nickName,userName,psw,model.urlString,dsc,model.groupID,email];
        
        [db executeUpdate:insert];
    }
    
    [db close];
}
//插入分组
+ (void)LZInsertToGroupTable:(NSString*)tableName model:(LZGroupModel*)model {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        return;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        
        NSInteger count = [self LZSelectElementCountFromTable:tableName];
        count ++;
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO '%@' (identifier,groupName) VALUES ('%@','%@')",tableName,model.identifier,model.groupName];
        
        [LZ_db executeUpdate:insert];
    }
    
    [LZ_db close];
}


//+ (void)LZInsertToTable:(NSString*)tableName model:(LZDataModel*)model useDataBaseQueue:(NSString*)queueName  {
//    FMDatabaseQueue *baseQueue = [FMDatabaseQueue databaseQueueWithPath:LZ_dbPath];
//    dispatch_queue_t queue = dispatch_queue_create([queueName UTF8String], NULL);
//    dispatch_async(queue, ^{
//        [baseQueue inDatabase:^(FMDatabase *db) {
//            if ([db open]) {
//                [db setShouldCacheStatements:YES];
//                if ([db tableExists:tableName]) {
//                    
//                    NSString *psw = [LZStringEncode encode:model.password];
//                    NSString *userName = [LZStringEncode encode:model.userName];
//                    NSString *email = [LZStringEncode encode:model.email];
//                    NSString *dsc = [LZStringEncode encode:model.dsc];
//                    
//                    NSString *insert = [NSString stringWithFormat:@"INSERT INTO '%@' (identifier,nickName,userName,password,urlString,dsc) VALUES ('%@','%@','%@','%@','%@','%@')",tableName,model.identifier,model.nickName,userName,psw,model.urlString,dsc];
//                    
//                    [db executeUpdate:insert];
//                }
//            }
//            NSLog(@"%@",[NSThread currentThread]);
//            [db close];
//        }];
//    });
//}

+(NSArray*)LZSelectAllOldElementsFromTable {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        return nil;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:@"newUserAccountData"]) {
        NSString *select = [NSString stringWithFormat:@"SELECT * FROM '%@'",@"newUserAccountData"];
        FMResultSet *fs = [LZ_db executeQuery:select];
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
        
        while ([fs next]) {
            LZDataModel *model = [[LZDataModel alloc]init];
            model.identifier = [fs stringForColumn:@"identifier"];
            model.nickName = [fs stringForColumn:@"nickName"];
            
            model.userName = [fs stringForColumn:@"userName"];
            
            NSString *psw = [fs stringForColumn:@"password"];
            model.password = psw;
            model.urlString = [fs stringForColumn:@"urlString"];
            NSString *dsc = [fs stringForColumn:@"dsc"];
            model.dsc = dsc;
            model.groupName = [fs stringForColumn:@"groupName"];
            model.groupID = [fs stringForColumn:@"groupID"];
            NSString *email = [fs stringForColumn:@"email"];
            model.email = email;
            [resultArray addObject:model];
        }
        
        [fs close];
        [LZ_db close];
        
        return resultArray;
    }
    
    return nil;
}

//查询所有数据
+(NSArray*)LZSelectAllElementsFromTable:(NSString*)tableName {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        return nil;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        NSString *select = [NSString stringWithFormat:@"SELECT * FROM '%@'",tableName];
        FMResultSet *fs = [LZ_db executeQuery:select];
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
        
        while ([fs next]) {
            LZDataModel *model = [[LZDataModel alloc]init];
            model.identifier = [fs stringForColumn:@"identifier"];
            model.nickName = [fs stringForColumn:@"nickName"];
            NSString *userName = [fs stringForColumn:@"userName"];
            model.userName = [LZStringEncode decode:userName];
            
            NSString *psw = [fs stringForColumn:@"password"];
            model.password = [LZStringEncode decode:psw];
            model.urlString = [fs stringForColumn:@"urlString"];
            NSString *dsc = [fs stringForColumn:@"dsc"];
            model.dsc = [LZStringEncode decode:dsc];
            model.groupName = [fs stringForColumn:@"groupName"];
            model.groupID = [fs stringForColumn:@"groupID"];
            NSString *email = [fs stringForColumn:@"email"];
            model.email = [LZStringEncode decode:email];
            [resultArray addObject:model];
        }
        
        [fs close];
        [LZ_db close];
        
        return resultArray;
    }
    
    return nil;
}

//查询某个分组下的所有数据
+(NSArray*)LZSelectGroupElementsFromTable:(NSString*)tableName groupID:(NSString*)groupID{
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        return nil;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
//        @"SELECT *FROM menuTable WHERE iKind = ?"
        NSString *select = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE groupID = '%@'",tableName,groupID];
        FMResultSet *fs = [LZ_db executeQuery:select];
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
        
        while ([fs next]) {
            LZDataModel *model = [[LZDataModel alloc]init];
            model.identifier = [fs stringForColumn:@"identifier"];
            model.nickName = [fs stringForColumn:@"nickName"];
            
            NSString *userName = [fs stringForColumn:@"userName"];
            model.userName = [LZStringEncode decode:userName];
            NSString *psw = [fs stringForColumn:@"password"];
            model.password = [LZStringEncode decode:psw];
            model.urlString = [fs stringForColumn:@"urlString"];
            NSString *dsc = [fs stringForColumn:@"dsc"];
            model.dsc = [LZStringEncode decode:dsc];
            model.groupName = [fs stringForColumn:@"groupName"];
            model.groupID = [fs stringForColumn:@"groupID"];
            NSString *email = [fs stringForColumn:@"email"];
            model.email = [LZStringEncode decode:email];
            [resultArray addObject:model];
        }
        
        [fs close];
        [LZ_db close];
        
        return resultArray;
    }
    
    return nil;
}

//查询某个数据
+(LZDataModel*)LZSelectElementFromTable:(NSString*)tableName identifier:(NSString*)identifier{
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        return nil;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        //        @"SELECT *FROM menuTable WHERE iKind = ?"
        NSString *select = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE identifier = '%@'",tableName,identifier];
        FMResultSet *fs = [LZ_db executeQuery:select];
//        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
        
//        while ([fs next]) {
//            
//            [resultArray addObject:model];
//        }
        LZDataModel *model = [[LZDataModel alloc]init];
        if ([fs next]) {
            model.identifier = [fs stringForColumn:@"identifier"];
            model.nickName = [fs stringForColumn:@"nickName"];
            NSString *userName = [fs stringForColumn:@"userName"];
            model.userName = [LZStringEncode decode:userName];
            NSString *psw = [fs stringForColumn:@"password"];
            model.password = [LZStringEncode decode:psw];
            model.urlString = [fs stringForColumn:@"urlString"];
            NSString* dsc = [fs stringForColumn:@"dsc"];
            model.dsc = [LZStringEncode decode:dsc];
            model.groupName = [fs stringForColumn:@"groupName"];
            model.groupID = [fs stringForColumn:@"groupID"];
            NSString *email = [fs stringForColumn:@"email"];
            model.email = [LZStringEncode decode:email];

        }
        
        
        [fs close];
        [LZ_db close];
        
        return model;
    }
    
    return nil;
}


+(NSArray*)LZSelectAllGroupsFromTable:(NSString*)tableName {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        return nil;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        NSString *select = [NSString stringWithFormat:@"SELECT * FROM '%@'",tableName];
        FMResultSet *fs = [LZ_db executeQuery:select];
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
        
        while ([fs next]) {
            LZGroupModel *model = [[LZGroupModel alloc]init];
            model.identifier = [fs stringForColumn:@"identifier"];
            model.groupName = [fs stringForColumn:@"groupName"];
            
            [resultArray addObject:model];
        }
        
        [fs close];
        [LZ_db close];
        
        return resultArray;
    }
    
    return nil;
}

+ (NSArray*)LZSelectPartElementsFromTable:(NSString*)tableName range:(NSRange)range {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        
        return nil;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        NSString *select = [NSString stringWithFormat:@"SELECT * FROM '%@' LIMIT %lu,%lu",tableName,(unsigned long)range.location,(unsigned long)range.length];
        
        FMResultSet *fs = [LZ_db executeQuery:select];
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
        
        while ([fs next]) {
            LZDataModel *model = [[LZDataModel alloc]init];
            
            model.identifier = [fs stringForColumn:@"identifier"];
            model.nickName = [fs stringForColumn:@"nickName"];
            NSString *userName = [fs stringForColumn:@"userName"];
            model.userName = [LZStringEncode decode:userName];
            NSString *psw = [fs stringForColumn:@"password"];
            model.password = [LZStringEncode decode:psw];
            model.urlString = [fs stringForColumn:@"urlString"];
            NSString *dsc = [fs stringForColumn:@"dsc"];
            model.dsc = [LZStringEncode decode:dsc];
            model.groupName = [fs stringForColumn:@"groupName"];
            NSString *email = [fs stringForColumn:@"email"];
            model.email = [LZStringEncode decode:email];
            [resultArray addObject:model];
        }
        
        [fs close];
        [LZ_db close];
        
        return resultArray;
    }
    
    return nil;
}

+ (NSInteger)LZSelectElementCountFromTable:(NSString*)tableName {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        
        return 0;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        NSString *select = [NSString stringWithFormat:@"SELECT count(*) FROM '%@'",tableName];
        FMResultSet *fs = [LZ_db executeQuery:select];
        [fs next];
        NSInteger count = [fs intForColumn:@"count(*)"];
        
        [fs close];
        [LZ_db close];
        
        return count;
    }
    
    return 0;
}

+ (void)LZDeleteFromTable:(NSString*)tableName element:(LZDataModel*)model {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        
        return;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        NSString *delete = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE identifier = '%@'",tableName,model.identifier];
        [LZ_db executeUpdate:delete];
    }
    
    [LZ_db close];
}

//删除分组
+ (void)LZDeleteFromGroupTable:(NSString*)tableName element:(LZGroupModel*)model {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        
        return;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        NSString *delete = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE identifier = '%@'",tableName,model.identifier];
        [LZ_db executeUpdate:delete];
    }
    
    [LZ_db close];
}
#pragma 创建密码表
+ (void)createPswTableWithName:(NSString *)tableName {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        return;
    }
    //为数据设置缓存,提高查询效率
    [LZ_db setShouldCacheStatements:YES];
    if (![LZ_db tableExists:tableName]) {
        NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'(identifier TEXT UNIQUE NOT NULL, dataPsw TEXT)",tableName];
        [LZ_db executeUpdate:createTable];
    }
    
    [LZ_db close];
}

+ (void)LZInsertToPswTable:(NSString*)tableName passwordKey:(NSString *)pswKey passwordValue:(NSString *)pswvalue {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        return;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        
        NSInteger count = [self LZSelectElementCountFromTable:tableName];
        count ++;
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO '%@' (identifier,dataPsw) VALUES ('%@','%@')",tableName,pswKey,pswvalue];
        
        [LZ_db executeUpdate:insert];
    }
    
    [LZ_db close];
}

+(NSString *)LZSelectPswFromTable:(NSString*)tableName passwprdKey:(NSString*)pswKey {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        return nil;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        
        NSString *password = nil;
        
        //        @"SELECT *FROM menuTable WHERE iKind = ?"
        NSString *select = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE identifier = '%@'",tableName,pswKey];
        FMResultSet *fs = [LZ_db executeQuery:select];
    
        if ([fs next]) {
             password = [fs stringForColumn:@"dataPsw"];
        }
        
        
        [fs close];
        [LZ_db close];
        
        return password;
    }
    
    return nil;
}

//更新数据表
+ (void)LZUpdatePswTable:(NSString*)tableName passwordKey:(NSString *)pswKey passwordValue:(NSString *)pswValue {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        
        return;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        
        
        NSString *update = [NSString stringWithFormat:@"UPDATE '%@' SET dataPsw = '%@' WHERE identifier = '%@'",tableName,pswValue, pswKey];
        
        [LZ_db executeUpdate:update];
    }
    
    [LZ_db close];
}

+ (void)LZDeletePswFromTable:(NSString*)tableName passwordKey:(NSString *)pswKey {
    
    FMDatabase *LZ_db = [self LZDefaultDataBase];
    if (![LZ_db open]) {
        [LZ_db close];
        
        return;
    }
    
    [LZ_db setShouldCacheStatements:YES];
    if ([LZ_db tableExists:tableName]) {
        NSString *delete = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE identifier = '%@'",tableName,pswKey];
        [LZ_db executeUpdate:delete];
    }
    
    [LZ_db close];
}
@end
