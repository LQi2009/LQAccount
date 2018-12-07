//
//  LZSettingTableViewCell.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZSettingTableViewCell.h"

@implementation LZSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    UISwitch *swit = [[UISwitch alloc]init];
    
    [self.contentView addSubview:swit];
    
    [swit mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.and.right.mas_equalTo(self.contentView);
//        make.width.mas_equalTo(@60);
        
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@40);
    }];
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
