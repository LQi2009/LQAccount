//
//  LZDocument.m
//  LZiCloudDemo
//
//  Created by Artron_LQQ on 2016/12/2.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZDocument.h"

static NSString *fileName = @"userData.db";
@implementation LZDocument

// 将要保存的数据转换为NSData
// 用于保存文件时提供给 UIDocument 要保存的数据，
- (id)contentsForType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    
    NSLog(@"typeName == %@", typeName);
    
    if (self.wrapper == nil) {
        self.wrapper =[[NSFileWrapper alloc]initDirectoryWithFileWrappers:@{}];
    }
    
    NSDictionary *wrappers = [self.wrapper fileWrappers];
    
    if ([wrappers objectForKey:fileName] == nil && self.data != nil) {
        
        NSFileWrapper *textWrap = [[NSFileWrapper alloc]initRegularFileWithContents:self.data];
        [textWrap setPreferredFilename:fileName];
        [self.wrapper addFileWrapper:textWrap];
    }
    
    return self.wrapper;
}

// 获取已保存数据
// 用于 UIDocument 成功打开文件后，我们将数据解析成我们需要的文件内容，然后再保存起来
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    
    // 这个NSFileWrapper对象是a parent
    self.wrapper = (NSFileWrapper*)contents;
    
    NSDictionary *fileWrappers = self.wrapper.fileWrappers;
    // 获取child fileWrapper 这里才能获取到我们保存的内容
    NSFileWrapper *textWrap = [fileWrappers objectForKey:fileName];
    // .userData.db.icloud
    
    if (textWrap == nil) {
        textWrap = [fileWrappers objectForKey:[NSString stringWithFormat:@".%@.icloud", fileName]];
        
        NSLog(@"textWrap>>> %@", textWrap);
    }
    
    // 获取保存的内容
    if (textWrap.regularFile) {
        
        self.data = textWrap.regularFileContents;
    }

    return YES;
}


@end
