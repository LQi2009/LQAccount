//
//  LZFoldButton.m
//  LZFoldButton
//
//  Created by Artron_LQQ on 16/5/5.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZFoldButton.h"

@interface LZFoldButton ()<UITableViewDelegate,UITableViewDataSource>
{
    CGSize _showSize;
    BOOL _isTableFold;
    NSArray *_dataArray;
}

@property (strong,nonatomic)UITableView *lzTableView;
@property (strong,nonatomic)UIButton *lzButton;
@property (strong,nonatomic)UIView *lzBackgroundView;
@end

@implementation LZFoldButton

-(instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray*)dataArray {
    self = [super init];
    if (self) {

        self.frame = frame;
        _showSize = frame.size;
        _dataArray = dataArray;
        _lzTitleChanged = YES;
        _lzHeight = 200;
        [self setUI];
    }
    
    return self;
}

- (void)LZCloseTable {
    if (self.lzSelected == YES) {
        [self buttonClick:self.lzButton];
    }
}

- (void)LZOpenTable {
    if (self.lzButton.selected == NO) {
        [self buttonClick:self.lzButton];
    }
}

- (void)setUI {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.bounds;
    NSString *title = nil;
    if (_dataArray.count > 0 && !title) {
        title = _dataArray[0];
    } else {
        title = @"选择";
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _lzButton = button;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, _showSize.height, _showSize.width, 0)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    _lzBackgroundView = bgView;
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, _showSize.height, _showSize.width, 0) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor clearColor];
    [self addSubview:table];
    _lzTableView = table;
}

#pragma mark - UITableView 代理及数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foldButtonCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"foldButtonCellID"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:self.lzFontSize];
        cell.textLabel.textColor = self.lzFontColor;
    }
    
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id obj = [_dataArray objectAtIndex:indexPath.row];
    
    if (self.lzDelegate && [self.lzDelegate respondsToSelector:@selector(LZFoldButton:didSelectObject:)]) {
        
        [self.lzDelegate LZFoldButton:self didSelectObject:obj];
    }
   
    if (self.lzResultBlock) {
        
        self.lzResultBlock(obj);
    }
    
    if (self.lzTitleChanged) {
        [self LZSetTitle:obj forState:UIControlStateNormal];
    }
    
    [self buttonClick:self.lzButton];
}

#pragma mark - 自定义按钮设置方法
- (void)LZSetTitle:(NSString*)title forState:(UIControlState)state {
    [self.lzButton setTitle:title forState:state];
}

-(void)LZSetTitleColor:(UIColor*)color forState:(UIControlState)state {
    [self.lzButton setTitleColor:color forState:state];
}

- (void)LZSetBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [self.lzButton setBackgroundImage:image forState:state];
}

- (void)LZSetImage:(UIImage *)image forState:(UIControlState)state {
    [self.lzButton setImage:image forState:state];
    
    if (_lzButtonType == LZFoldButtonTypeRight) {
        [self setLzButtonType:LZFoldButtonTypeRight];
    }
}

- (void)LZReloadData {
    
    [self.lzTableView reloadData];
}
#pragma mark - 重写属性setter方法
-(void)setBackgroundColor:(UIColor *)backgroundColor {
    
    self.lzButton.backgroundColor = backgroundColor;
}

- (void)setLzTitleFontSize:(CGFloat)lzTitleFontSize {
    self.lzButton.titleLabel.font = [UIFont systemFontOfSize:lzTitleFontSize];
}

-(void)setLzColor:(UIColor *)lzColor {
    _lzColor = lzColor;
    self.lzBackgroundView.backgroundColor = lzColor;
}

- (void)setLzAlpha:(CGFloat)lzAlpha {
    self.lzBackgroundView.alpha = lzAlpha;
    _lzAlpha = lzAlpha;
}

//- (void)setLzSelected:(BOOL)lzSelected {
//    
//}

- (void)setLzButtonType:(LZFoldButtonType)lzButtonType {
    _lzButtonType = lzButtonType;
    
    switch (lzButtonType) {
        case LZFoldButtonTypeNormal:
            
            break;
        case LZFoldButtonTypeRight:{
            
            //需要在外部修改标题背景色的时候将此代码注释
            self.lzButton.titleLabel.backgroundColor = self.lzButton.backgroundColor;
            self.lzButton.imageView.backgroundColor = self.lzButton.backgroundColor;
            
            CGSize titleSize = self.lzButton.titleLabel.bounds.size;
            CGSize imageSize = self.lzButton.imageView.bounds.size;
            CGFloat interval = 1.0;
            
            [self.lzButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [self.lzButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            
            [self.lzButton setImageEdgeInsets:UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval))];
            [self.lzButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval)];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 重写属性getter方法
- (BOOL)lzSelected {
    
    return self.lzButton.selected;
}

#pragma mark - 按钮点击事件
- (void)buttonClick:(UIButton*)button {
    //保证在父视图的最前面,不被其他视图遮挡
    if (self.superview != nil) {
        if ([self.superview.subviews lastObject] != self) {
            [self.superview bringSubviewToFront:self];
        }
    }
    
    button.selected = !button.selected;
    if (_isTableFold) {
        
        [self tableClose];
    } else {
        
        [self tableOpen];
    }
}

- (void)tableClose {
    //如果已经关闭了,直接返回
    if (_isTableFold == NO) {
        return;
    }
    _isTableFold = NO;
    CGRect rect = self.frame;
    rect.size.height -= self.lzHeight;
    self.frame = rect;
    [UIView animateWithDuration:0.1 animations:^{
        CGRect rect1 = self.lzTableView.frame;
        rect1.size.height -= self.lzHeight;
        self.lzTableView.frame = rect1;
        
        CGRect rect2 = self.lzBackgroundView.frame;
        rect2.size.height -= self.lzHeight;
        self.lzBackgroundView.frame = rect2;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)tableOpen {
    //如果已经展开了,直接返回
    if (_isTableFold == YES) {
        return;
    }
    _isTableFold = YES;
    CGRect rect = self.frame;
    rect.size.height += self.lzHeight;
    self.frame = rect;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect1 = self.lzTableView.frame;
        rect1.size.height += self.lzHeight;
        self.lzTableView.frame = rect1;
        
        CGRect rect2 = self.lzBackgroundView.frame;
        rect2.size.height += self.lzHeight;
        self.lzBackgroundView.frame = rect2;
    } completion:^(BOOL finished) {
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
