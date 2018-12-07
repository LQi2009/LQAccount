//
//  LZMainHeaderView.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZMainHeaderView.h"

@interface LZMainHeaderView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *button;
@property (copy, nonatomic) clickBlock click;
@end
@implementation LZMainHeaderView

- (void)dealloc {
    
    LZLog(@"%@--dealloc",NSStringFromClass([self class]));
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    UILabel *label = [UILabel new];
    label.textColor = LZColorFromHex(0x555555);
    label.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:label];
    self.titleLabel = label;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.userInteractionEnabled = NO;
    [button setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateSelected];
    [self.contentView addSubview:button];
    self.button = button;
    
    UIView *line = [UIView new];
    line.backgroundColor = LZColorFromHex(0xbfbfbf);
    [self.contentView addSubview:line];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.top.and.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(button.mas_left).offset(-10);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).offset(10);
        make.top.and.bottom.mas_equalTo(label);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.width.mas_equalTo(50);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(@1);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewTapped)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)headerViewTapped {
    self.button.selected = !self.button.selected;
    
    if (self.click) {
        self.click(self.button.selected);
    }
}

- (void)lzHeaderViewClickedWithBlock:(clickBlock)block {
    
    if (block) {
        self.click = block;
    }
}
- (void)setText:(NSString *)text {
    self.titleLabel.text = text;
    _text = text;
}

- (void)setSelect:(BOOL)select {
    self.button.selected = select;
    _select = select;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
