//
//  LZItem.m
//  LZPasswordView
//
//  Created by Artron_LQQ on 2016/10/19.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZItem.h"



static CGFloat itemLineHeight = 2.0;

@implementation LZItem

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _style = LZItemStyleLine;
        self.bounds = CGRectMake(0, 0, itemCicleRadius, itemCicleRadius);
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setStyle:(LZItemStyle)style {
    
    _style = style;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    switch (self.style) {
        case LZItemStyleLine:
            [self drawLine];
            break;
        case LZItemStyleCicle:
            [self drawCicle];
            break;
            
        default:
            break;
    }
}

- (void)drawCicle {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    
    // 填充色
    UIColor *fillColor = [UIColor blackColor];
    [fillColor set];
    [path fill];
    
    
    [path stroke];
}

- (void)drawLine {
    
    CGRect rect = CGRectMake((itemCicleRadius - itemLineWidth)/2.0, (itemCicleRadius - itemLineHeight)/2.0, itemLineWidth, itemLineHeight);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinBevel;
    
    UIColor *fileColor = [UIColor blackColor];
    [fileColor set];
    [path fill];
    
    [path stroke];
}

@end
