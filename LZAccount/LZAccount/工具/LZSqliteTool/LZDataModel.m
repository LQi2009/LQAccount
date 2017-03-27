//
//  LZDataModel.m
//  SqliteTest
//
//  Created by Artron_LQQ on 16/4/19.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZDataModel.h"
#import "LZStringTool.h"

@implementation LZDataModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        
    }
    
    return self;
}

- (NSString *)nickName {
    if (_nickName == nil) {
        _nickName = @"";
    }
    
    return _nickName;
}

-(NSString *)groupName {
    if (_groupName == nil) {
        _groupName = @"";
    }
    
    return _groupName;
}

- (NSString *)groupID {
    if (_groupID == nil) {
        _groupID = @"";
    }
    
    return _groupID;
}

- (NSString *)userName {
    if (_userName == nil) {
        _userName = @"";
    }
    
    return _userName;
}

- (NSString *)password {
    if (_password == nil) {
        _password = @"";
    }
    
    return _password;
}

- (NSString *)urlString {
    if (_urlString == nil) {
        _urlString = @"";
    }
    
    return _urlString;
}

- (NSString *)dsc {
    if (_dsc == nil) {
        _dsc = @"";
    }
    
    return _dsc;
}

- (NSString *)email {
    if (_email == nil) {
        _email = @"";
    }
    
    return _email;
}
- (NSString *)identifier {
    
    if (_identifier == nil) {
        _identifier = [LZStringTool creatRedomMD5String];
    }
    
    return _identifier;
}
@end
