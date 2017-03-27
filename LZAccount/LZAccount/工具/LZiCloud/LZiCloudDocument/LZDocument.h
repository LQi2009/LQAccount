//
//  LZDocument.h
//  LZiCloudDemo
//
//  Created by Artron_LQQ on 2016/12/2.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZDocument : UIDocument

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSFileWrapper *wrapper;
@end

