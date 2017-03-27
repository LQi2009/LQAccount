//
//  LZNumberView.m
//  LZPasswordView
//
//  Created by Artron_LQQ on 2016/10/19.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZNumberView.h"
#import "LZItem.h"

@interface LZNumberView ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *inputs;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *textBgView;
@end

@implementation LZNumberView
- (instancetype)initWithStyle:(LZNumberViewStyle)style {
    
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        self.style = style;
        _position = 0.4;
    }
    
    return self;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        self.style = LZNumberViewStyleNumberFour;
        _position = 0.4;
    }
    
    return self;
}


/**
 懒加载模式,不使用时,不创建

 @return warnLabel
 */
-(UILabel *)warnLabel {
    
    if (_warnLabel == nil) {
        
        _warnLabel = [[UILabel alloc]init];
        _warnLabel.font = [UIFont systemFontOfSize:12];
        _warnLabel.textAlignment = NSTextAlignmentCenter;
        _warnLabel.frame = CGRectMake(0, self.position*CGRectGetHeight(self.frame)*0.8, CGRectGetWidth(self.frame), 30);
        [self addSubview:_warnLabel];
    }
    
    return _warnLabel;
}

- (UILabel *)subWarnLabel {
    if (_subWarnLabel == nil) {
        
        _subWarnLabel = [[UILabel alloc]init];
        _subWarnLabel.font = [UIFont systemFontOfSize:12];
        _subWarnLabel.textAlignment = NSTextAlignmentCenter;
        _subWarnLabel.frame = CGRectMake(0, self.position*CGRectGetHeight(self.frame)*1.2, CGRectGetWidth(self.frame), 30);
        _subWarnLabel.textColor = [UIColor redColor];
        [self addSubview:_subWarnLabel];
    }
    
    return _subWarnLabel;
}

- (NSMutableArray *)items {
    
    if (_items == nil) {
        _items = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _items;
}

- (NSMutableArray *)inputs {
    if (_inputs == nil) {
        _inputs = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _inputs;
}

- (UITextField *)textField {
    if (_textField == nil) {
        
        _textField = [[UITextField alloc]init];
        _textField.secureTextEntry = YES;
        _textField.frame = CGRectMake(20, 0, self.frame.size.width - 40, 30);
        _textField.delegate = self;
        [_textField becomeFirstResponder];
    }
    
    return _textField;
}

- (UIView *)textBgView {
    
    if (_textBgView == nil) {
        _textBgView = [[UIView alloc]init];
        _textBgView.bounds = CGRectMake(0, 0, self.frame.size.width, 30);
    }
    
    return _textBgView;
}

- (void)setStyle:(LZNumberViewStyle)style {
    
    _style = style;
    
    if (self.items.count > 0) {
        
        [self.items removeAllObjects];
    }
    
    switch (style) {
        case LZNumberViewStyleNumberFour:
        {
            for (int i = 0; i < 4; i++) {
                
                LZItem *item = [[LZItem alloc]init];
                
                //                item.backgroundColor = self.backgroundColor;
                [self.items addObject:item];
            }
        } break;
        case LZNumberViewStyleNumberSix:
        {
            for (int i = 0; i < 6; i++) {
                
                LZItem *item = [[LZItem alloc]init];
                
                item.backgroundColor = self.backgroundColor;
                [self.items addObject:item];
            }
        } break;
        case LZNumberViewStyleCustom:
        {
            [self.items removeAllObjects];
            self.items = nil;
        } break;
            
        default:
            break;
    }
}


- (void)becomeFirstRespond {
    
    [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstRespond {
    
    return [self.textField resignFirstResponder];
}

- (void)reset {
    
    [self.inputs removeAllObjects];
    for (int i = 0; i < self.items.count; i++) {
        
        LZItem *item = [self.items objectAtIndex:i];
        item.style = LZItemStyleLine;
        [self.items replaceObjectAtIndex:i withObject:item];
    }
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    if (self.subviews.count > 0) {
//        
//        for (UIView *vi in self.subviews) {
//            
//            if (![vi isKindOfClass:[UILabel class]]) {
//                
//                [vi removeFromSuperview];
//            }
//        }
//    }
    
    switch (self.style) {
        case LZNumberViewStyleNumberFour:
        {
            CGFloat padding = 14.0;
            CGFloat orginY = CGRectGetHeight(self.frame)*self.position;
            CGFloat leftPad = (self.frame.size.width - itemLineWidth*4 - padding*3)/2.0;
            
            for (int i = 0; i< 4; i++) {
                
                LZItem *item = self.items[i];
                
                CGRect frame = item.frame;
                frame.origin = CGPointMake(leftPad + (padding + CGRectGetWidth(frame))*i, orginY);
                item.frame = frame;
                [self addSubview:item];
            }
            
            CGRect rect = self.textField.frame;
            rect.origin = CGPointMake(rect.origin.x, orginY);
            self.textField.frame = rect;
            
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.textBgView.center = self.textField.center;
            
            [self insertSubview:self.textField atIndex:0];
            [self insertSubview:self.textBgView atIndex:1];
            self.textBgView.backgroundColor = self.backgroundColor;
            
        } break;
        case LZNumberViewStyleNumberSix:
        {
            CGFloat padding = 14.0;
            CGFloat orginY = self.center.y - 40;
            CGFloat leftPad = (self.frame.size.width - itemLineWidth*6 - padding*5)/2.0;
            for (int i = 0; i< 6; i++) {
                
                LZItem *item = self.items[i];
                
                CGRect frame = item.frame;
                frame.origin = CGPointMake(leftPad + (padding + CGRectGetWidth(frame))*i, orginY);
                item.frame = frame;
                [self addSubview:item];
            }
            
            self.textField.center = CGPointMake(self.center.x, self.center.y - 20);
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.textBgView.center = self.textField.center;
            
            [self insertSubview:self.textField atIndex:0];
            [self insertSubview:self.textBgView atIndex:1];
            self.textBgView.backgroundColor = self.backgroundColor;
            
        } break;
        case LZNumberViewStyleCustom:
        {
            self.textField.center = CGPointMake(self.center.x, self.center.y - 20);
            self.textField.keyboardType = UIKeyboardTypeDefault;
            self.textBgView.center = self.textField.center;
            
            [self insertSubview:self.textField atIndex:1];
            [self insertSubview:self.textBgView atIndex:0];
            self.textBgView.backgroundColor = [UIColor whiteColor];
        } break;
            
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate ,验证输入信息
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.style == LZNumberViewStyleCustom) {
        
        // 点击的是删除键
        if (!string || string.length <= 0) {
            
            if (self.inputs.count == 0) {
                
                return YES;
            }
            
            [self.inputs removeAllObjects];
        } else {
            
            [self.inputs addObject:string];
        }
        
        
    } else {
        
        //输入的是纯数字密码
        return [self checkNumberPsw:string];
    }
    
    return YES;
}

- (BOOL)checkNumberPsw:(NSString *)string {
    
    // 点击的是删除键
    if (!string || string.length <= 0) {
        
        if (self.inputs.count == 0) {
            
            return YES;
        }
        
        NSInteger index = self.inputs.count - 1;
        
        LZItem *item = self.items[index];
        item.style = LZItemStyleLine;
        [self.items replaceObjectAtIndex:index withObject:item];
        
        [self.inputs removeLastObject];
    } else {
        
        if (self.inputs.count < self.items.count) {
            
            [self.inputs addObject:string];
            
            LZItem *item = self.items[self.inputs.count - 1];
            item.style = LZItemStyleCicle;
            [self.items replaceObjectAtIndex:self.inputs.count - 1 withObject:item];
            
            if (self.inputs.count == self.items.count) {
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(numberView:didInput:)]) {
                    
                    NSString *result = [self.inputs componentsJoinedByString:@""];
                    
                    [self.delegate numberView:self didInput:result];
                }
            }
        }
    }
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation CALayer (Anim)


/*
 *  摇动
 */
-(void)shake{
    
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    CGFloat s = 5;
    
    kfa.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    
    //时长
    kfa.duration = 0.3f;
    
    //重复
    kfa.repeatCount = 2;
    
    //移除
    kfa.removedOnCompletion = YES;
    
    [self addAnimation:kfa forKey:@"shake"];
}

@end
