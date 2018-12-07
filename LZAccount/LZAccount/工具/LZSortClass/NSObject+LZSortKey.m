//
//  NSObject+LZSortKey.m
//  名称排序
//
//  Created by Artron_LQQ on 16/8/20.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "NSObject+LZSortKey.h"
#import <objc/runtime.h>

@implementation NSObject (LZSortKey)

- (void)setKey:(NSString *)key {
    
    objc_setAssociatedObject(self, @selector(key), key, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)key {
    
    return objc_getAssociatedObject(self, _cmd);
}
@end
