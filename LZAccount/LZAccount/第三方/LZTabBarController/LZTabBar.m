//
//  LZTabBar.m
//  LZTabBarController
//
//  Created by Artron_LQQ on 2016/12/12.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZTabBar.h"
//#import "LZTabBarItem.h"

@interface LZTabBar ()<LZTabBarItemDelegate>

@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *topLine;
@end
@implementation LZTabBar

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
//        self.backgroundColor = LZBaseColor;
    }
    
    return self;
}
- (UIView *)topLine {
    if (_topLine == nil) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = [UIColor grayColor];
        [self addSubview:_topLine];
    }
    
    return _topLine;
}

- (UIVisualEffectView *)effectView {
    if (_effectView == nil) {
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.alpha = 1.0;
        [self addSubview:_effectView];
    }
    
    return _effectView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    self.effectView.frame = self.bounds;
    
    [self setupItems];
    
    self.topLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.6);
}

- (void)setupItems {
    
    CGFloat width = CGRectGetWidth(self.frame)/self.items.count;
    CGFloat height = CGRectGetHeight(self.frame);
    
    for (int i = 0; i < self.items.count; i++) {
        
        LZTabBarItem *item = [self.items objectAtIndex:i];
        item.frame = CGRectMake(i*width, 0, width, height);
        [self addSubview:item];
        item.delegate = self;
    }
}

- (void)tabBarItem:(LZTabBarItem *)item didSelectIndex:(NSInteger)index {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectItem:atIndex:)]) {
        
        [self.delegate tabBar:self didSelectItem:item atIndex:index];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
// *****************************************************
#pragma mark - LZTabBarItem
static NSInteger defaultTag = 100000;
@interface LZTabBarItem ()

@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@end

@implementation LZTabBarItem
- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClicked:)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)setTag:(NSInteger)tag {
    
    [super setTag:tag + defaultTag];
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconImageView];
    }
    
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor grayColor];
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (void)setIcon:(NSString *)icon {
    _icon = icon;
    
    self.iconImageView.image = [UIImage imageNamed:icon];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    self.titleLabel.textColor = titleColor;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = 6.0;
    
    switch (self.type) {
        case LZTabBarItemTypeDefault: {
            
            CGFloat iconHeight = (CGRectGetHeight(self.frame) - space * 3)*2/3.0 ;
            self.iconImageView.frame = CGRectMake(space, space, CGRectGetWidth(self.frame) - 2 * space, iconHeight);
            self.titleLabel.frame = CGRectMake(space, CGRectGetMaxY(self.iconImageView.frame) + space, CGRectGetWidth(self.frame) - 2*space, iconHeight/2.0);
        }
            break;
        case LZTabBarItemTypeImage: {
            
            self.iconImageView.frame = CGRectMake(space, space, CGRectGetWidth(self.frame) - 2*space, CGRectGetHeight(self.frame) - 2*space);
        }
            break;
        case LZTabBarItemTypeText: {
            
            self.titleLabel.frame = CGRectMake(space, space, CGRectGetWidth(self.frame) - 2*space, CGRectGetHeight(self.frame) - 2*space);
        }
            break;
            
        default:
            break;
    }
//    if (self.icon.length > 0 && self.title.length > 0) {
//        
//        CGFloat iconHeight = (CGRectGetHeight(self.frame) - space * 3)*2/3.0 ;
//        self.iconImageView.frame = CGRectMake(space, space, CGRectGetWidth(self.frame) - 2 * space, iconHeight);
//        self.titleLabel.frame = CGRectMake(space, CGRectGetMaxY(self.iconImageView.frame) + space, CGRectGetWidth(self.frame) - 2*space, iconHeight/2.0);
//    } else if (self.icon.length > 0 && self.title.length <= 0) {
//        
//        self.iconImageView.frame = CGRectMake(space, space, CGRectGetWidth(self.frame) - 2*space, CGRectGetHeight(self.frame) - 2*space);
//    } else if (self.title.length > 0 && self.icon.length <= 0) {
//        
//        self.titleLabel.frame = CGRectMake(space, space, CGRectGetWidth(self.frame) - 2*space, CGRectGetHeight(self.frame) - 2*space);
//    }
}

- (void)itemClicked:(UITapGestureRecognizer *)tap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarItem:didSelectIndex:)]) {
        
        [self.delegate tabBarItem:self didSelectIndex:self.tag - defaultTag];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

