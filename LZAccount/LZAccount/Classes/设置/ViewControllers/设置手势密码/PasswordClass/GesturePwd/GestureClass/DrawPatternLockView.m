//
//  DrawPatternLockView.m
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com

#import "DrawPatternLockView.h"

@implementation DrawPatternLockView


#pragma mark - life cycle

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    
//    return self;
//}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    if (!_canDraw)
        return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //lineWidth
    CGContextSetLineWidth(context, 3.0);
    //strokeColor
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0.5, 0.5, 0.5, 0.8};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(context, color);
    
    
    /**
     *  core logic --- begin
     */
    CGPoint from;
    UIView *lastDot = nil;
    for (UIView *dotView in _dotViews)
    {
        from = dotView.center;
        if (!lastDot)
        {
            CGContextMoveToPoint(context, from.x, from.y);
        }
        else
        {
            CGContextAddLineToPoint(context, from.x, from.y);
        }
        lastDot = dotView;
    }
    /**
     *  core logic --- end
     */
    
    
    CGPoint pt = _trackPoint;
    //NSLog(@"\t to: %f, %f", pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
    _canDraw = YES; // NO"已修改源码"
}



#pragma mark - ［公开方法］

- (void)clearDotViews {
    [_dotViews removeAllObjects];
}


- (void)addDotView:(UIView *)view {
    if (!_dotViews)
        _dotViews = [[NSMutableArray alloc] init];
    
    [_dotViews addObject:view];
}


- (void)drawLineFromLastDotTo:(CGPoint)pt {
    _canDraw = YES;
    /**
      是否 显示手势轨迹
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * num = [defaults objectForKey:KEY_UserDefaults_isShowGestureTrace];
    if (num) {
        _canDraw = [num boolValue];
    }
    _trackPoint = pt;
    [self setNeedsDisplay];
}


@end
