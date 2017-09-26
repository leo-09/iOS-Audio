//
//  YZSortViewController.h
//  PullDownMenu
//
//  Created by yz on 16/8/12.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const YZUpdateMenuTitleDictKey;

@interface YZSortViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *titleArray;
@property (nonatomic, assign) NSInteger selectedCol;

@property (nonatomic, retain) NSString *ctxTag;

@end
