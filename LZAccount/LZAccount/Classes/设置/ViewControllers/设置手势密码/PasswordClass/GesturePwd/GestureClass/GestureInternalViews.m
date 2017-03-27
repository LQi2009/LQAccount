//
//  GestureInternalViews.m
//  v1.0
//  by OYXJ, Hawking.HK@gmail.com


#import "GestureInternalViews.h"

@implementation GestureInternalViews



#pragma mark - getters

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (UILabel *)headLabel
{
    if (!_headLabel) {
        _headLabel = [[UILabel alloc] init];
        
        _headLabel.backgroundColor = [UIColor clearColor];
        _headLabel.textAlignment = NSTextAlignmentCenter;
        _headLabel.font = [UIFont systemFontOfSize:17];
    }
    return _headLabel;
}

- (UILabel *)autoDismissLabel
{
    if (!_autoDismissLabel) {
        _autoDismissLabel = [[UILabel alloc] init];
        
        _autoDismissLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _autoDismissLabel.textColor = [UIColor whiteColor];
        _autoDismissLabel.textAlignment = NSTextAlignmentCenter;
        _autoDismissLabel.font = [UIFont systemFontOfSize:14];
    }
    return _autoDismissLabel;
}

- (UIButton *)btnForgetGesturePwd
{
    if (!_btnForgetGesturePwd) {
        _btnForgetGesturePwd = [[UIButton alloc] init];
        
        _btnForgetGesturePwd.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btnForgetGesturePwd setTitle:@"忘记手势密码？" forState:UIControlStateNormal];
        [_btnForgetGesturePwd setTitleColor:[UIColor colorWithRed:31.0/255.0 green:168.0/255.0 blue:222.0/250.0 alpha:1.0]
                                   forState:UIControlStateNormal];
        [_btnForgetGesturePwd setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
    return _btnForgetGesturePwd;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UIButton *)btnTouchIdUnlock
{
    if (!_btnTouchIdUnlock) {
        _btnTouchIdUnlock = [[UIButton alloc] init];
        
        _btnTouchIdUnlock.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btnTouchIdUnlock setTitle:@" 指纹解锁" forState:UIControlStateNormal];
        [_btnTouchIdUnlock setTitleColor:[UIColor colorWithRed:31.0/255.0 green:168.0/255.0 blue:222.0/250.0 alpha:1.0]
                                forState:UIControlStateNormal];
        [_btnTouchIdUnlock setImage:[UIImage imageNamed:@"gesture_unlock"] forState:UIControlStateNormal];
        [_btnTouchIdUnlock setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
    return _btnTouchIdUnlock;
}


@end
