//
//  LZiCloudDocument.h
//  LZiCloudDemo
//
//  Created by Artron_LQQ on 2016/12/2.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^loadBlock)(BOOL success);

typedef void(^downloadBlock)(id obj);

@interface LZiCloudDocument : NSObject

+ (BOOL)iCloudEnable;
+ (NSURL *)iCloudDocumentUrl;
+ (NSURL *)localFileUrl;

+ (void)uploadToiCloudwithBlock:(loadBlock)block ;

+ (void)downloadFromiCloudWithBlock:(downloadBlock)block ;
@end
