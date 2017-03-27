//
//  NSObject+LZSortKey.h
//  名称排序
//
//  Created by Artron_LQQ on 16/8/20.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LZSortKey)

/********* 为方便排序,新增一个属性 *************/
@property (nonatomic,copy)NSString *key;
@end
