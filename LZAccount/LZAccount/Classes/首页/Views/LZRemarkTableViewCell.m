//
//  LZRemarkTableViewCell.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZRemarkTableViewCell.h"

@interface LZRemarkTableViewCell ()

@property (strong, nonatomic)UILabel *titleLabel;
@end
@implementation LZRemarkTableViewCell

//@synthesize detailTitle;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UILabel *label = [UILabel new];
    label.textColor = LZColorFromHex(0x555555);
    label.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:label];
    label.text = @"备 注:";
    self.titleLabel = label;
    
    UITextView *textView = [UITextView new];
    textView.textColor = LZColorFromHex(0x555555);
    textView.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:textView];
    textView.text = @"写点什么吧";
    self.textView = textView;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.top.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(@40);
    }];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(label);
        make.top.mas_equalTo(label.mas_bottom);
        make.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    _title = title;
}

- (void)setDetailTitle:(NSString *)detailTitle {
    self.textView.text = detailTitle;
    _detailTitle = detailTitle;
}

//- (NSString *)detailTitle {
//    
//}

- (void)setEditEnabled:(BOOL)editEnabled {
    
    _editEnabled = editEnabled;
    self.titleLabel.userInteractionEnabled = editEnabled;
    self.textView.userInteractionEnabled = editEnabled;
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
