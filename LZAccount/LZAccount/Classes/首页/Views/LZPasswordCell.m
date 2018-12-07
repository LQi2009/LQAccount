//
//  LZPasswordCell.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZPasswordCell.h"

//static NSString *passwordShowNotificationKey = @"passwordShowNotification";
@interface LZPasswordCell ()

@property (strong, nonatomic)UITextField *titleField;
@property (strong, nonatomic)UILongPressGestureRecognizer *longPressGesture;
@property (strong, nonatomic)UIButton *button;
@end

@implementation LZPasswordCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    UITextField *titleField = [UITextField new];
    titleField.textColor = LZColorFromHex(0x555555);
    titleField.font = [UIFont systemFontOfSize:16];
    titleField.borderStyle = UITextBorderStyleNone;
    [self.contentView addSubview:titleField];
    titleField.text = @"账 号:";
    self.titleField = titleField;
    
    UITextField *detailField = [UITextField new];
    detailField.textColor = LZColorFromHex(0x444444);
    detailField.font = [UIFont systemFontOfSize:14];
    detailField.borderStyle = UITextBorderStyleNone;
    detailField.secureTextEntry = YES;
    [self.contentView addSubview:detailField];
    detailField.text = @"流火绯瞳";
    self.detailField = detailField;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"show_password"] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"hidden_password"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    self.button = button;
    
    [titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(@60);
    }];
    
    [detailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(titleField.mas_right).offset(10);
        make.right.mas_equalTo(button.mas_left).offset(-10);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.width.mas_equalTo(button.mas_height);
        }];
    
    //接收来自编辑页和详情页的通知,是否显示密码
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shoPassword:) name:passwordShowNotificationKey object:nil];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    longPress.enabled = NO;
    [self.contentView addGestureRecognizer:longPress];
    self.longPressGesture = longPress;
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)press {
    
    if (self.longPressBlock) {
        self.longPressBlock(self.detailField.text);
    }
}
- (void)shoPassword:(NSNotification*)noti {
    
    NSNumber *showNum = noti.object;
    BOOL showPSW = [showNum boolValue];
    
    self.detailField.secureTextEntry = !showPSW;
    self.button.selected = showPSW;
    self.longPressGesture.enabled = showPSW;
    _showPSW = showPSW;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)buttonClick:(UIButton*)button {
    
//    self.detailField.secureTextEntry = button.selected;
//    button.selected = !button.selected;
    
    if (self.showBlock) {
        self.showBlock(button.selected);
    }
    
}

- (void)setShowPSW:(BOOL)showPSW {
    
    self.detailField.secureTextEntry = !showPSW;
    self.button.selected = showPSW;
    _showPSW = showPSW;
}

- (void)setTitle:(NSString *)title {
    self.titleField.text = title;
    _title = title;
}

- (void)setDetailTitle:(NSString *)detailTitle {
    self.detailField.text = detailTitle;
    _detailTitle = detailTitle;
}

- (void)setEditEnabled:(BOOL)editEnabled {
    
    _editEnabled = editEnabled;
    self.titleField.userInteractionEnabled = editEnabled;
    self.detailField.userInteractionEnabled = editEnabled;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
