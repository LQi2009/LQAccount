//
//  LZGroupModel.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/3.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZGroupModel.h"
#import "LZStringTool.h"

@implementation LZGroupModel
- (NSString *)groupName {
    if (_groupName == nil) {
        return @"默认分组";
    }
    
    return _groupName;
}

- (NSString *)identifier {
    
    if (_identifier == nil) {
        _identifier = [LZStringTool creatRedomMD5String];
    }
    
    return _identifier;
}
@end
