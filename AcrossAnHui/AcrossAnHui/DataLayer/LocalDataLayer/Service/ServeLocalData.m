//
//  ServeData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ServeLocalData.h"

static NSString *serveCollectionKey = @"serveCollectionKey";
static NSString *selectedServeKey = @"selectedServeKey";

@implementation ServeLocalData

#pragma mark - 单例模式

static ServeLocalData *instance;

+ (id) allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (instancetype) sharedInstance {
    static dispatch_once_t oncetToken;
    dispatch_once(&oncetToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id) copyWithZone:(NSZone *)zone {
    return instance;
}

#pragma mark - 读取项目工程中的服务列表信息

// 默认的服务列表信息
- (NSArray *) readLocalServeCollection {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ServeCollection" ofType:@"json"];
    
    NSString *jsonStr = [self deleteSpecialCodeWithStr:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]];
    NSData *jsonData   = [[NSData alloc] initWithData:[[self deleteSpecialCodeWithStr:jsonStr] dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingMutableContainers) error:nil];
    
    NSArray *serveCollection = [ServeSuperModel convertFromArray:jsonArray];
    return serveCollection;
}

#pragma mark - 读取服务列表信息

- (ServeSuperModel *) readSelectedServe {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [NSString stringWithFormat:@"%@/SelectedServe.json", document];
    
    // json文件的内容
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    if (!content) {
        ServeSuperModel *defaultModel = [self readLocalSelectedServe];
        
        // 兼容以前版本, 否则可以直接返回
//        return defaultModel;
        
        // 兼容以前版本, 否则可以直接用上一句代码来返回
        return [self comapareOldVersionHomePage:defaultModel];
    }
    
    NSString *jsonStr = [self deleteSpecialCodeWithStr:content];
    NSData *jsonData = [[NSData alloc] initWithData:[[self deleteSpecialCodeWithStr:jsonStr] dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingMutableContainers) error:nil];
    
    // 文件存储的 已定制的 服务
    ServeSuperModel *selectedServe = [ServeSuperModel convertFromDict:jsonDict];
    
    // 如果 已定制的服务 还不是最新的，需要更新其中的服务
    if (![self isUpdateSelectedServeToDocuments]) {
        /*
         因为更新App，不会更新用户的服务定制，所以要判断已定制的服务还有没有，并且更新该服务的最新状态,如下：
         */
        // 取出最新的所有的服务集合
        NSArray *serves = [self readLocalServeCollection];
        NSMutableArray *allServeArray = [[NSMutableArray alloc] init];
        for (ServeSuperModel *superModel in serves) {
            [allServeArray addObjectsFromArray:superModel.serveArray];
        }
        
        // 比较定制的服务 与 最新的服务，还存在则更新，否则过滤该定制的服务
        NSMutableArray *serveArray = [[NSMutableArray alloc] init];
        for (ServeModel *serveModel in selectedServe.serveArray) {
            for (ServeModel *allServeModel in allServeArray) {
                if ([serveModel.serveID isEqualToString:allServeModel.serveID]) {
                    [serveArray addObject:allServeModel];
                    break;
                }
            }
        }
        
        // 更新最新的ServeModel
        [selectedServe setServeArray:serveArray];
    }
    
    return selectedServe;
}

#pragma mark - 更新服务列表信息

- (void) updateSelectedServe:(ServeSuperModel *)model {
    // 转换为String
    NSString *jsonString = [model serveModelToJSONString];
    
    // 写文件
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [NSString stringWithFormat:@"%@/SelectedServe.json", document];
    
    NSError *error;
    BOOL res1 = [jsonString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (res1) {
        [self updateSelectedServeToDocuments:@"YES"];
        NSLog(@"文件写入成功");
    } else {
        NSLog(@"文件写入失败");
    }
}

- (BOOL) isUpdateSelectedServeToDocuments {
    static NSString *isUpdateSelectedServeKey = @"isUpdateSelectedServeToDocuments";
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *isUpdateSelectedServe = [userDefault objectForKey:isUpdateSelectedServeKey];// 是否第一次安装
    
    if ([isUpdateSelectedServe isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void) updateSelectedServeToDocuments:(NSString *) isUpdate {
    static NSString *isUpdateSelectedServeKey = @"isUpdateSelectedServeToDocuments";
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:isUpdate forKey:isUpdateSelectedServeKey];
}

#pragma mark - private method 读取默认定制的服务

// 默认的 选中的 服务信息
- (ServeSuperModel *) readLocalSelectedServe {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SelectedServe" ofType:@"json"];
    
    NSString *jsonStr = [self deleteSpecialCodeWithStr:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]];
    NSData *jsonData   = [[NSData alloc] initWithData:[[self deleteSpecialCodeWithStr:jsonStr] dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingMutableContainers) error:nil];
    
    ServeSuperModel *selectedServe = [ServeSuperModel convertFromDict:jsonDict];
    return selectedServe;
}

/**
 处理json格式的字符串中的换行符、回车符
 
 @param str json格式的字符串
 @return 替代了换行符、回车符等的字符串
 */
- (NSString *) deleteSpecialCodeWithStr:(NSString *)str {
    // 空格不能替换
    NSString *string = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    return string;
}

#pragma mark - 兼容以前版本：用户在首页的定制服务：HomePage.plist、NewHomePage.plist、NewHomePageData.plist

- (ServeSuperModel *) comapareOldVersionHomePage:(ServeSuperModel *)defaultModel {
    // 沙盒中没有SelectedServe.json文件, 则表示第一次安装, 就需要兼顾旧版
    NSArray *homePage = [self getOldVersionHomePage];
    if (homePage) {
        // 如果旧版有定制服务，则删除默认的定制
        [defaultModel.serveArray removeAllObjects];
        
        // 取出最新的所有的服务集合
        NSArray *serves = [self readLocalServeCollection];
        NSMutableArray *allServeArray = [[NSMutableArray alloc] init];
        for (ServeSuperModel *superModel in serves) {
            [allServeArray addObjectsFromArray:superModel.serveArray];
        }
        
        // 比较旧版定制的服务 与 最新的服务，还存在则更新，否则过滤该定制的服务
        NSMutableArray *serveArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in homePage) {
            for (ServeModel *allServeModel in allServeArray) {
                if ([dict[@"title"] isEqualToString:allServeModel.name]) {// 旧版的定制服务 需要按名字匹配
                    [serveArray addObject:allServeModel];
                    break;
                }
            }
        }
        
        // 更新最新的ServeModel
        [defaultModel setServeArray:serveArray];
        
        // 保存下来
        [self updateSelectedServe:defaultModel];
    }
    
    return defaultModel;
}

- (NSArray *) getOldVersionHomePage {
    NSArray *homePage = [self getOldVersionHomePage:@"NewHomePageData.plist"];// 3.3.0
    if (!homePage) {
        homePage = [self getOldVersionHomePage:@"NewHomePage.plist"];// 第二版
    }
    if (!homePage) {
        homePage = [self getOldVersionHomePage:@"HomePage.plist"];// 第一版
    }
    
    // 还有原版本数据
    if (homePage && homePage.count > 0) {
        return homePage;
    } else {
        return nil;
    }
}

- (NSArray *)getOldVersionHomePage:(NSString *)path {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", document, path];
    
    if (filePath) {
        NSArray *homePage = [[NSArray alloc] initWithContentsOfFile:filePath];
        [self clearCachesWithFilePath:filePath];// 删除旧版的定制服务的文件
        
        if (homePage && homePage.count > 0) {
            return homePage;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

// 删除指定目录或文件
- (BOOL)clearCachesWithFilePath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError *error;
    BOOL result = [manager removeItemAtPath:path error:&error];
    
    return result;
}

@end
