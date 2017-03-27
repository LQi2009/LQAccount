//
//  LZDetailTableViewCell.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZDetailTableViewCell.h"

@interface LZDetailTableViewCell ()

@property (strong, nonatomic)UITextField *titleField;

@end
@implementation LZDetailTableViewCell

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
    titleField.text = @"账号:";
    self.titleField = titleField;
    
    UITextField *detailField = [UITextField new];
    detailField.textColor = LZColorFromHex(0x444444);
    detailField.font = [UIFont systemFontOfSize:14];
    detailField.borderStyle = UITextBorderStyleNone;
    [self.contentView addSubview:detailField];
    detailField.text = @"流火绯瞳";
    self.detailField = detailField;
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"showPSW"] forState:UIControlStateSelected];
//    [button setImage:[UIImage imageNamed:@"hiddenPSW"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:button];
    
    LZWeakSelf(ws)
    [titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(ws.contentView);
        make.left.mas_equalTo(ws.contentView).offset(10);
        make.width.mas_equalTo(@60);
    }];
    
    [detailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(ws.contentView);
        make.left.mas_equalTo(titleField.mas_right).offset(10);
        make.right.mas_equalTo(ws.contentView).offset(-10);
    }];
    
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.and.bottom.mas_equalTo(self.contentView);
//        make.right.mas_equalTo(self.contentView).offset(-10);
//        make.width.mas_equalTo(button.mas_height);
//    }];
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
//    self.titleField.userInteractionEnabled = editEnabled;
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
