//
//  LZPasswordView.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZPasswordView.h"

@interface LZPasswordView ()

@property (strong, nonatomic)NSMutableArray *viewArray;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *warnLabel;
@end
@implementation LZPasswordView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.backgroundColor = LZColorFromRGB(239, 239, 244);
        [self setupUI];
    }
    
    return self;
}

- (NSMutableArray *)viewArray {
    if (_viewArray == nil) {
        _viewArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _viewArray;
}

- (void)setupUI {
    
    UILabel *titleLabel = [[UILabel alloc]init];

    titleLabel.frame = CGRectMake(0, LZNavigationHeight, LZSCREEN_WIDTH, 30);
    titleLabel.text = @"请输入密码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    NSInteger width = 20;
    NSInteger paging = (LZSCREEN_WIDTH - width * 7)/2;
    for (int i = 0; i < 4; i++) {
        UIView *vi = [[UIView alloc]init];
        vi.frame = CGRectMake(paging + (2*width) * i,LZNavigationHeight + 80, width, 3);
        vi.tag = 1;
        vi.backgroundColor = [UIColor blackColor];
        [self addSubview:vi];
        
        [self.viewArray addObject:vi];
    }
    
    UILabel *warnLabel = [[UILabel alloc]init];
//    warnLabel.center = CGPointMake(self.center.x, 4*LZNavigationHeight);
//    warnLabel.bounds = CGRectMake(0, 0, 200, 30);
    warnLabel.frame = CGRectMake(0, 3*LZNavigationHeight, LZSCREEN_WIDTH, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.font = [UIFont systemFontOfSize:16];
    warnLabel.textColor = [UIColor redColor];
    warnLabel.text = @"两次密码输入不一致,请重新输入!";
    warnLabel.hidden = YES;
    [self addSubview:warnLabel];
    self.warnLabel = warnLabel;
}

- (void)resetView {
    for (UIView *vi in self.viewArray) {
        if (vi.tag > 0) {
            vi.bounds = vi.bounds = CGRectMake(0, 0, 20, 3);
            vi.layer.cornerRadius = 0;
            vi.tag = 1;
        }
    }
}

- (void)changeViewAtIndex:(NSInteger)index {
    
    UIView *view = [self.viewArray objectAtIndex:index];
    if (view.tag == 2) {
    
        view.bounds = CGRectMake(0, 0, 20, 3);
        view.layer.cornerRadius = 0;
        view.tag = 1;
    } else {
        
        view.bounds = CGRectMake(0, 0, 16, 16);
        view.layer.cornerRadius = 8;
        view.tag = 2;
    }
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    _title = title;
}

- (void)setShowWarning:(BOOL)showWarning {
    self.warnLabel.hidden = !showWarning;
    _showWarning = showWarning;
}

- (void)showWarningWithString:(NSString*)string {
    
    self.warnLabel.hidden = NO;
    self.warnLabel.text = string;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
