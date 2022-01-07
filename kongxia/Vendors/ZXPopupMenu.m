//
//  ZXPopupMenu.m
//  ZXartApp
//
//  Created by Apple on 2016/12/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ZXPopupMenu.h"
#define kAnimationDuration 0.5
#define kWindow [UIApplication sharedApplication].keyWindow
#define ZX_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })
@interface YBPopupMenuPath : NSObject

+ (CAShapeLayer *)zx_maskLayerWithRect:(CGRect)rect
                            rectCorner:(UIRectCorner)rectCorner
                          cornerRadius:(CGFloat)cornerRadius
                            arrowWidth:(CGFloat)arrowWidth
                           arrowHeight:(CGFloat)arrowHeight
                         arrowPosition:(CGFloat)arrowPosition
                        arrowDirection:(ZXPopupMenuArrowDirection)arrowDirection;

+ (UIBezierPath *)zx_bezierPathWithRect:(CGRect)rect
                             rectCorner:(UIRectCorner)rectCorner
                           cornerRadius:(CGFloat)cornerRadius
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor
                        backgroundColor:(UIColor *)backgroundColor
                             arrowWidth:(CGFloat)arrowWidth
                            arrowHeight:(CGFloat)arrowHeight
                          arrowPosition:(CGFloat)arrowPosition
                         arrowDirection:(ZXPopupMenuArrowDirection)arrowDirection;
@end

@implementation YBPopupMenuPath

+ (CAShapeLayer *)zx_maskLayerWithRect:(CGRect)rect
                            rectCorner:(UIRectCorner)rectCorner
                          cornerRadius:(CGFloat)cornerRadius
                            arrowWidth:(CGFloat)arrowWidth
                           arrowHeight:(CGFloat)arrowHeight
                         arrowPosition:(CGFloat)arrowPosition
                        arrowDirection:(ZXPopupMenuArrowDirection)arrowDirection{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [self zx_bezierPathWithRect:rect rectCorner:rectCorner cornerRadius:cornerRadius borderWidth:0 borderColor:nil backgroundColor:nil arrowWidth:arrowWidth arrowHeight:arrowHeight arrowPosition:arrowPosition arrowDirection:arrowDirection].CGPath;
    return shapeLayer;
}

+ (UIBezierPath *)zx_bezierPathWithRect:(CGRect)rect
                             rectCorner:(UIRectCorner)rectCorner
                           cornerRadius:(CGFloat)cornerRadius
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor
                        backgroundColor:(UIColor *)backgroundColor
                             arrowWidth:(CGFloat)arrowWidth
                            arrowHeight:(CGFloat)arrowHeight
                          arrowPosition:(CGFloat)arrowPosition
                         arrowDirection:(ZXPopupMenuArrowDirection)arrowDirection{
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (borderColor) {
        [borderColor setStroke];
    }
    if (backgroundColor) {
        [backgroundColor setFill];
    }
    bezierPath.lineWidth = borderWidth;
    rect = CGRectMake(borderWidth / 2, borderWidth / 2, CGRectGetWidth(rect) - borderWidth, CGRectGetHeight(rect) - borderWidth);
    CGFloat topRightRadius = 0,topLeftRadius = 0,bottomRightRadius = 0,bottomLeftRadius = 0;
    CGPoint topRightArcCenter,topLeftArcCenter,bottomRightArcCenter,bottomLeftArcCenter;
    
    if (rectCorner & UIRectCornerTopLeft) {
        topLeftRadius = cornerRadius;
    }
    if (rectCorner & UIRectCornerTopRight) {
        topRightRadius = cornerRadius;
    }
    if (rectCorner & UIRectCornerBottomLeft) {
        bottomLeftRadius = cornerRadius;
    }
    if (rectCorner & UIRectCornerBottomRight) {
        bottomRightRadius = cornerRadius;
    }
    
    switch (arrowDirection) {
        case ZXPopupMenuArrowDirectionTop:{
            topLeftArcCenter = CGPointMake(topLeftRadius + CGRectGetMinX(rect), arrowHeight + topLeftRadius + CGRectGetMinX(rect));
            topRightArcCenter = CGPointMake(CGRectGetWidth(rect) - topRightRadius + CGRectGetMinX(rect), arrowHeight + topRightRadius + CGRectGetMinX(rect));
            bottomLeftArcCenter = CGPointMake(bottomLeftRadius + CGRectGetMinX(rect), CGRectGetHeight(rect) - bottomLeftRadius + CGRectGetMinX(rect));
            bottomRightArcCenter = CGPointMake(CGRectGetWidth(rect) - bottomRightRadius + CGRectGetMinX(rect), CGRectGetHeight(rect) - bottomRightRadius + CGRectGetMinX(rect));
            if (arrowPosition < topLeftRadius + arrowWidth / 2) {
                arrowPosition = topLeftRadius + arrowWidth / 2;
            }else if (arrowPosition > CGRectGetWidth(rect) - topRightRadius - arrowWidth / 2) {
                arrowPosition = CGRectGetWidth(rect) - topRightRadius - arrowWidth / 2;
            }
            [bezierPath moveToPoint:CGPointMake(arrowPosition - arrowWidth / 2, arrowHeight + CGRectGetMinX(rect))];
            [bezierPath addLineToPoint:CGPointMake(arrowPosition, CGRectGetMinY(rect) + CGRectGetMinX(rect))];
            [bezierPath addLineToPoint:CGPointMake(arrowPosition + arrowWidth / 2, arrowHeight + CGRectGetMinX(rect))];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) - topRightRadius, arrowHeight + CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) + CGRectGetMinX(rect), CGRectGetHeight(rect) - bottomRightRadius - CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + CGRectGetMinX(rect), CGRectGetHeight(rect) + CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(rect), arrowHeight + topLeftRadius + CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
        }
            break;
        case ZXPopupMenuArrowDirectionBottom:{
            topLeftArcCenter = CGPointMake(topLeftRadius + CGRectGetMinX(rect),topLeftRadius + CGRectGetMinX(rect));
            topRightArcCenter = CGPointMake(CGRectGetWidth(rect) - topRightRadius + CGRectGetMinX(rect), topRightRadius + CGRectGetMinX(rect));
            bottomLeftArcCenter = CGPointMake(bottomLeftRadius + CGRectGetMinX(rect), CGRectGetHeight(rect) - bottomLeftRadius + CGRectGetMinX(rect) - arrowHeight);
            bottomRightArcCenter = CGPointMake(CGRectGetWidth(rect) - bottomRightRadius + CGRectGetMinX(rect), CGRectGetHeight(rect) - bottomRightRadius + CGRectGetMinX(rect) - arrowHeight);
            if (arrowPosition < bottomLeftRadius + arrowWidth / 2) {
                arrowPosition = bottomLeftRadius + arrowWidth / 2;
            }else if (arrowPosition > CGRectGetWidth(rect) - bottomRightRadius - arrowWidth / 2) {
                arrowPosition = CGRectGetWidth(rect) - bottomRightRadius - arrowWidth / 2;
            }
            [bezierPath moveToPoint:CGPointMake(arrowPosition + arrowWidth / 2, CGRectGetHeight(rect) - arrowHeight + CGRectGetMinX(rect))];
            [bezierPath addLineToPoint:CGPointMake(arrowPosition, CGRectGetHeight(rect) + CGRectGetMinX(rect))];
            [bezierPath addLineToPoint:CGPointMake(arrowPosition - arrowWidth / 2, CGRectGetHeight(rect) - arrowHeight + CGRectGetMinX(rect))];
            [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + CGRectGetMinX(rect), CGRectGetHeight(rect) - arrowHeight + CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(rect), topLeftRadius + CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) - topRightRadius + CGRectGetMinX(rect), CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) + CGRectGetMinX(rect), CGRectGetHeight(rect) - bottomRightRadius - CGRectGetMinX(rect) - arrowHeight)];
            [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        }
            break;
        case ZXPopupMenuArrowDirectionLeft:{
            topLeftArcCenter = CGPointMake(topLeftRadius + CGRectGetMinX(rect) + arrowHeight,topLeftRadius + CGRectGetMinX(rect));
            topRightArcCenter = CGPointMake(CGRectGetWidth(rect) - topRightRadius + CGRectGetMinX(rect), topRightRadius + CGRectGetMinX(rect));
            bottomLeftArcCenter = CGPointMake(bottomLeftRadius + CGRectGetMinX(rect) + arrowHeight, CGRectGetHeight(rect) - bottomLeftRadius + CGRectGetMinX(rect));
            bottomRightArcCenter = CGPointMake(CGRectGetWidth(rect) - bottomRightRadius + CGRectGetMinX(rect), CGRectGetHeight(rect) - bottomRightRadius + CGRectGetMinX(rect));
            if (arrowPosition < topLeftRadius + arrowWidth / 2) {
                arrowPosition = topLeftRadius + arrowWidth / 2;
            }else if (arrowPosition > CGRectGetHeight(rect) - bottomLeftRadius - arrowWidth / 2) {
                arrowPosition = CGRectGetHeight(rect) - bottomLeftRadius - arrowWidth / 2;
            }
            [bezierPath moveToPoint:CGPointMake(arrowHeight + CGRectGetMinX(rect), arrowPosition + arrowWidth / 2)];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(rect), arrowPosition)];
            [bezierPath addLineToPoint:CGPointMake(arrowHeight + CGRectGetMinX(rect), arrowPosition - arrowWidth / 2)];
            [bezierPath addLineToPoint:CGPointMake(arrowHeight + CGRectGetMinX(rect), topLeftRadius + CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) - topRightRadius, CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) + CGRectGetMinX(rect), CGRectGetHeight(rect) - bottomRightRadius - CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(arrowHeight + bottomLeftRadius + CGRectGetMinX(rect), CGRectGetHeight(rect) + CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        }
            break;
        case ZXPopupMenuArrowDirectionRight:{
            topLeftArcCenter = CGPointMake(topLeftRadius + CGRectGetMinX(rect),topLeftRadius + CGRectGetMinX(rect));
            topRightArcCenter = CGPointMake(CGRectGetWidth(rect) - topRightRadius + CGRectGetMinX(rect) - arrowHeight, topRightRadius + CGRectGetMinX(rect));
            bottomLeftArcCenter = CGPointMake(bottomLeftRadius + CGRectGetMinX(rect), CGRectGetHeight(rect) - bottomLeftRadius + CGRectGetMinX(rect));
            bottomRightArcCenter = CGPointMake(CGRectGetWidth(rect) - bottomRightRadius + CGRectGetMinX(rect) - arrowHeight, CGRectGetHeight(rect) - bottomRightRadius + CGRectGetMinX(rect));
            if (arrowPosition < topRightRadius + arrowWidth / 2) {
                arrowPosition = topRightRadius + arrowWidth / 2;
            }else if (arrowPosition > CGRectGetHeight(rect) - bottomRightRadius - arrowWidth / 2) {
                arrowPosition = CGRectGetHeight(rect) - bottomRightRadius - arrowWidth / 2;
            }
            [bezierPath moveToPoint:CGPointMake(CGRectGetWidth(rect) - arrowHeight + CGRectGetMinX(rect), arrowPosition - arrowWidth / 2)];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) + CGRectGetMinX(rect), arrowPosition)];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) - arrowHeight + CGRectGetMinX(rect), arrowPosition + arrowWidth / 2)];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) - arrowHeight + CGRectGetMinX(rect), CGRectGetHeight(rect) - bottomRightRadius - CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + CGRectGetMinX(rect), CGRectGetHeight(rect) + CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(rect), arrowHeight + topLeftRadius + CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) - topRightRadius + CGRectGetMinX(rect) - arrowHeight, CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
        }
            break;
        default:{
            topLeftArcCenter = CGPointMake(topLeftRadius + CGRectGetMinX(rect),  topLeftRadius + CGRectGetMinX(rect));
            topRightArcCenter = CGPointMake(CGRectGetWidth(rect) - topRightRadius + CGRectGetMinX(rect),  topRightRadius + CGRectGetMinX(rect));
            bottomLeftArcCenter = CGPointMake(bottomLeftRadius + CGRectGetMinX(rect), CGRectGetHeight(rect) - bottomLeftRadius + CGRectGetMinX(rect));
            bottomRightArcCenter = CGPointMake(CGRectGetWidth(rect) - bottomRightRadius + CGRectGetMinX(rect), CGRectGetHeight(rect) - bottomRightRadius + CGRectGetMinX(rect));
            [bezierPath moveToPoint:CGPointMake(topLeftRadius + CGRectGetMinX(rect), CGRectGetMinX(rect))];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) - topRightRadius, CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect) + CGRectGetMinX(rect), CGRectGetHeight(rect) - bottomRightRadius - CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + CGRectGetMinX(rect), CGRectGetHeight(rect) + CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(rect), arrowHeight + topLeftRadius + CGRectGetMinX(rect))];
            [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
        }
            break;
    }
    
    [bezierPath closePath];
    return bezierPath;
}

@end

#pragma mark - private cell

@interface ZXPopupMenuCell : UITableViewCell
@property (nonatomic, assign) BOOL    isShowSeparator;
@property (nonatomic, strong) UIColor *separatorColor;
@end

@implementation ZXPopupMenuCell

- (void)setIsShowSeparator:(BOOL)isShowSeparator{
    _isShowSeparator = isShowSeparator;
    [self setNeedsDisplay];
}

- (void)setSeparatorColor:(UIColor *)separatorColor{
    _separatorColor = separatorColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    if (!_isShowSeparator) return;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5)];
    [_separatorColor setFill];
    [bezierPath fillWithBlendMode:kCGBlendModeNormal alpha:1.f];
    [bezierPath closePath];
}

@end

#pragma mark - ZXPopupMenu main

@interface ZXPopupMenu ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView      * menuBackView;
@property (nonatomic) CGRect                relyRect;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) CGFloat       minSpace;
@property (nonatomic, assign) CGFloat       itemWidth;
@property (nonatomic, strong) NSArray     * titles;
@property (nonatomic, strong) NSArray     * images;
@property (nonatomic) CGPoint               point;
@property (nonatomic, assign) BOOL          isCornerChanged;
@property (nonatomic, strong) UIColor     * separatorColor;
@property (nonatomic, assign) BOOL          isChangeDirection;
@end

@implementation ZXPopupMenu
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setDefaultSettings];
    }
    return self;
}

- (void)setDefaultSettings{
    _cornerRadius = 5.0;
    _rectCorner = UIRectCornerAllCorners;
    self.isShowShadow = YES;
    _isShowSeparator = YES;
    _dismissOnSelected = YES;
    _dismissOnTouchOutside = YES;
    _fontSize = 15;
    _textColor = [UIColor blackColor];
    _offset = 0.0;
    _relyRect = CGRectZero;
    _point = CGPointZero;
    _borderWidth = 0.0;
    _borderColor = [UIColor lightGrayColor];
    _arrowWidth = 15.0;
    _arrowHeight = 10.0;
    _backColor = [UIColor whiteColor];
    self.type = ZXPopupMenuTypeDefault;
    _arrowDirection = ZXPopupMenuArrowDirectionTop;
    _priorityDirection = ZXPopupMenuPriorityDirectionTop;
    _minSpace = 10.0;
    _maxVisibleCount = 5;
    _itemHeight = 44;
    _isCornerChanged = NO;
    _showMaskView = YES;
    _menuBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _menuBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    _menuBackView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutside)];
    [_menuBackView addGestureRecognizer:tap];
    self.alpha = 0;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tableView];
}

#pragma mark zxPopupMenuAction

- (void)touchOutside{
    if (_dismissOnTouchOutside) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(zxPopupMenuTouchOutside:)]) {
            [self.delegate zxPopupMenuTouchOutside:self];
        }
        [self dismiss];
    }
}

- (void)dismiss{
    if (self.delegate && [self.delegate respondsToSelector:@selector(zxPopupMenuBeganDismiss)]) {
        [self.delegate zxPopupMenuBeganDismiss];
    }
    [UIView animateWithDuration:kAnimationDuration delay:0.f usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        _menuBackView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(zxPopupMenuDidDismiss)]) {
            [self.delegate zxPopupMenuDidDismiss];
        }
        self.delegate = nil;
        [self removeFromSuperview];
        [_menuBackView removeFromSuperview];
    }];
}

- (void)show{
    [kWindow addSubview:_menuBackView];
    [kWindow addSubview:self];
    ZXPopupMenuCell *cell = [self getLastVisibleCell];
    cell.isShowSeparator = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(zxPopupMenuBeganShow)]) {
        [self.delegate zxPopupMenuBeganShow];
    }
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:kAnimationDuration delay:0.f usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.f, 1.f);
        self.alpha    = 1.f;
        _menuBackView.alpha = 1.f;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(zxPopupMenuDidShow)]) {
            [self.delegate zxPopupMenuDidShow];
        }
    }];
}

#pragma mark zxPopupMenu initMethod

#pragma mark - publics
+ (ZXPopupMenu *)showAtPoint:(CGPoint)point titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth delegate:(id<ZXPopupMenuDelegate>)delegate{
    ZXPopupMenu *popupMenu = [[ZXPopupMenu alloc] init];
    popupMenu.point = point;
    popupMenu.titles = titles;
    popupMenu.images = icons;
    popupMenu.itemWidth = itemWidth;
    popupMenu.delegate = delegate;
    [popupMenu show];
    return popupMenu;
}

+ (ZXPopupMenu *)showRelyOnView:(UIView *)view titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth delegate:(id<ZXPopupMenuDelegate>)delegate{
    CGRect absoluteRect = [view convertRect:view.bounds toView:kWindow];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    ZXPopupMenu *popupMenu = [[ZXPopupMenu alloc] init];
    popupMenu.point = relyPoint;
    popupMenu.relyRect = absoluteRect;
    popupMenu.titles = titles;
    popupMenu.images = icons;
    popupMenu.itemWidth = itemWidth;
    popupMenu.delegate = delegate;
    [popupMenu show];
    return popupMenu;
}

+ (ZXPopupMenu *)showAtPoint:(CGPoint)point titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth otherSettings:(void (^) (ZXPopupMenu * popupMenu))otherSetting{
    ZXPopupMenu *popupMenu = [[ZXPopupMenu alloc] init];
    popupMenu.point = point;
    popupMenu.titles = titles;
    popupMenu.images = icons;
    popupMenu.itemWidth = itemWidth;

    ZX_SAFE_BLOCK(otherSetting,popupMenu);
    [popupMenu show];
    return popupMenu;
}

+ (ZXPopupMenu *)showRelyOnView:(UIView *)view titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth otherSettings:(void (^) (ZXPopupMenu * popupMenu))otherSetting{
    CGRect absoluteRect = [view convertRect:view.bounds toView:kWindow];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    ZXPopupMenu *popupMenu = [[ZXPopupMenu alloc] init];
    popupMenu.point = relyPoint;
    popupMenu.relyRect = absoluteRect;
    popupMenu.titles = titles;
    popupMenu.images = icons;
    popupMenu.itemWidth = itemWidth;
    ZX_SAFE_BLOCK(otherSetting,popupMenu);
    [popupMenu show];
    return popupMenu;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark tableViewDelegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"zxopupMenu";
    ZXPopupMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ZXPopupMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.numberOfLines = 0;
    }
    cell.selectionStyle  = _selectionStyle;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = _textColor;
    cell.textLabel.font = [UIFont systemFontOfSize:_fontSize];
    cell.textLabel.textAlignment = _textAlignment;
    if ([_titles[indexPath.row] isKindOfClass:[NSAttributedString class]]) {
        cell.textLabel.attributedText = _titles[indexPath.row];
    }else if ([_titles[indexPath.row] isKindOfClass:[NSString class]]) {
        cell.textLabel.text = _titles[indexPath.row];
    }else {
        cell.textLabel.text = nil;
    }
    cell.isShowSeparator = (indexPath.row + 1) == _titles.count || (indexPath.row + 1) == _maxVisibleCount ? NO : _isShowSeparator;
    cell.separatorColor  = _separatorColor;
    if (_images.count >= indexPath.row + 1) {
        if ([_images[indexPath.row] isKindOfClass:[NSString class]]) {
            cell.imageView.image = [UIImage imageNamed:_images[indexPath.row]];
        }else if ([_images[indexPath.row] isKindOfClass:[UIImage class]]){
            cell.imageView.image = _images[indexPath.row];
        }else {
            cell.imageView.image = nil;
        }
    }else {
        cell.imageView.image = nil;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dismissOnSelected) [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(zxPopupMenuDidSelectedAtIndex:zxPopupMenu:)]) {
        [self.delegate zxPopupMenuDidSelectedAtIndex:indexPath.row zxPopupMenu:self];
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!_isShowSeparator) return;
    ZXPopupMenuCell *cell = [self getLastVisibleCell];
    cell.isShowSeparator = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!_isShowSeparator) return;
    ZXPopupMenuCell *cell = [self getLastVisibleCell];
    cell.isShowSeparator = NO;
}

- (ZXPopupMenuCell *)getLastVisibleCell{
    NSArray <NSIndexPath *>*indexPaths = [self.tableView indexPathsForVisibleRows];
    indexPaths = [indexPaths sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *  _Nonnull obj1, NSIndexPath *  _Nonnull obj2) {
        return obj1.row < obj2.row;
    }];
    NSIndexPath *indexPath = indexPaths.firstObject;
    return [self.tableView cellForRowAtIndexPath:indexPath];
}

- (void)setIsShowShadow:(BOOL)isShowShadow{
    _isShowShadow = isShowShadow;
    self.layer.shadowOpacity = isShowShadow ? 0.5 : 0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = isShowShadow ? 2.0 : 0;
}

- (void)setShowMaskView:(BOOL)showMaskView{
    _showMaskView = showMaskView;
    _menuBackView.backgroundColor = showMaskView ? [[UIColor blackColor] colorWithAlphaComponent:0.1] : [UIColor clearColor];
}

- (void)setType:(ZXPopupMenuType)type{
    _type = type;
    switch (type) {
        case ZXPopupMenuTypeDark:{
            _textColor = [UIColor lightGrayColor];
            _backColor = [UIColor colorWithRed:0.25 green:0.27 blue:0.29 alpha:1];
            _separatorColor = [UIColor lightGrayColor];
        }
            break;
            
        default:{
            _textColor = [UIColor blackColor];
            _backColor = [UIColor whiteColor];
            _separatorColor = [UIColor lightGrayColor];
        }
            break;
    }
    [self updateUI];
}

- (void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    [self.tableView reloadData];
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [self.tableView reloadData];
}

- (void)setPoint:(CGPoint)point{
    _point = point;
    [self updateUI];
}

- (void)setItemWidth:(CGFloat)itemWidth{
    _itemWidth = itemWidth;
    [self updateUI];
}

- (void)setItemHeight:(CGFloat)itemHeight{
    _itemHeight = itemHeight;
    self.tableView.rowHeight = itemHeight;
    [self updateUI];
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    [self updateUI];
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    [self updateUI];
}

- (void)setArrowPosition:(CGFloat)arrowPosition{
    _arrowPosition = arrowPosition;
    [self updateUI];
}

- (void)setArrowWidth:(CGFloat)arrowWidth{
    _arrowWidth = arrowWidth;
    [self updateUI];
}

- (void)setArrowHeight:(CGFloat)arrowHeight{
    _arrowHeight = arrowHeight;
    [self updateUI];
}

- (void)setArrowDirection:(ZXPopupMenuArrowDirection)arrowDirection{
    _arrowDirection = arrowDirection;
    [self updateUI];
}

- (void)setMaxVisibleCount:(NSInteger)maxVisibleCount{
    _maxVisibleCount = maxVisibleCount;
    [self updateUI];
}

- (void)setBackColor:(UIColor *)backColor{
    _backColor = backColor;
    [self updateUI];
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self updateUI];
}

- (void)setImages:(NSArray *)images{
    _images = images;
    [self updateUI];
}

- (void)setPriorityDirection:(ZXPopupMenuPriorityDirection)priorityDirection{
    _priorityDirection = priorityDirection;
    [self updateUI];
}

- (void)setRectCorner:(UIRectCorner)rectCorner{
    _rectCorner = rectCorner;
    [self updateUI];
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    [self updateUI];
}

- (void)setOffset:(CGFloat)offset{
    _offset = offset;
    [self updateUI];
}

- (void)updateUI{
    CGFloat height;
    if (_titles.count > _maxVisibleCount) {
        height = _itemHeight * _maxVisibleCount + _borderWidth * 2;
        self.tableView.bounces = YES;
    }else {
        height = _itemHeight * _titles.count + _borderWidth * 2;
        self.tableView.bounces = NO;
    }
    _isChangeDirection = NO;
    
    switch (_priorityDirection) {
        case ZXPopupMenuPriorityDirectionTop:{
            if (_point.y + height + _arrowHeight > SCREEN_HEIGHT - _minSpace) {
                _arrowDirection = ZXPopupMenuArrowDirectionBottom;
                _isChangeDirection = YES;
            }else {
                _arrowDirection = ZXPopupMenuArrowDirectionTop;
                _isChangeDirection = NO;
            }
        }
            break;
        case ZXPopupMenuPriorityDirectionBottom:{
            if (_point.y - height - _arrowHeight < _minSpace) {
                _arrowDirection = ZXPopupMenuArrowDirectionTop;
                _isChangeDirection = YES;
            }else {
                _arrowDirection = ZXPopupMenuArrowDirectionBottom;
                _isChangeDirection = NO;
            }
        }
            break;
        case ZXPopupMenuPriorityDirectionLeft:{
            if (_point.x + _itemWidth + _arrowHeight > SCREEN_WIDTH - _minSpace) {
                _arrowDirection = ZXPopupMenuArrowDirectionRight;
                _isChangeDirection = YES;
            }else {
                _arrowDirection = ZXPopupMenuArrowDirectionLeft;
                _isChangeDirection = NO;
            }
        }
            break;
        case ZXPopupMenuPriorityDirectionRight:{
            if (_point.x - _itemWidth - _arrowHeight < _minSpace) {
                _arrowDirection = ZXPopupMenuArrowDirectionLeft;
                _isChangeDirection = YES;
            }else {
                _arrowDirection = ZXPopupMenuArrowDirectionRight;
                _isChangeDirection = NO;
            }
        }
            break;

        default:
            break;
    }
    [self setArrowPosition];
    [self setRelyRect];
    
    switch (_arrowDirection) {
        case ZXPopupMenuArrowDirectionTop:{
            CGFloat y = _isChangeDirection ? _point.y  : _point.y;
            if (_arrowPosition > _itemWidth / 2) {
                self.frame = CGRectMake(SCREEN_WIDTH - _minSpace - _itemWidth, y, _itemWidth, height + _arrowHeight);
            }else if (_arrowPosition < _itemWidth / 2) {
                self.frame = CGRectMake(_minSpace, y, _itemWidth, height + _arrowHeight);
            }else {
                self.frame = CGRectMake(_point.x - _itemWidth / 2, y, _itemWidth, height + _arrowHeight);
            }
        }
            break;
        case ZXPopupMenuArrowDirectionBottom:{
            CGFloat y = _isChangeDirection ? _point.y - _arrowHeight - height : _point.y - _arrowHeight - height;
            if (_arrowPosition > _itemWidth / 2) {
                self.frame = CGRectMake(SCREEN_WIDTH - _minSpace - _itemWidth, y, _itemWidth, height + _arrowHeight);
            }else if (_arrowPosition < _itemWidth / 2) {
                self.frame = CGRectMake(_minSpace, y, _itemWidth, height + _arrowHeight);
            }else {
                self.frame = CGRectMake(_point.x - _itemWidth / 2, y, _itemWidth, height + _arrowHeight);
            }
        }
            break;
        case ZXPopupMenuArrowDirectionLeft:{
            CGFloat x = _isChangeDirection ? _point.x : _point.x;
            if (_arrowPosition < _itemHeight / 2) {
                self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
            }else if (_arrowPosition > _itemHeight / 2) {
                self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
            }else {
                self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
            }
        }
            break;
        case ZXPopupMenuArrowDirectionRight:{
            CGFloat x = _isChangeDirection ? _point.x - _itemWidth - _arrowHeight : _point.x - _itemWidth - _arrowHeight;
            if (_arrowPosition < _itemHeight / 2) {
                self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
            }else if (_arrowPosition > _itemHeight / 2) {
                self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
            }else {
                self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
            }
        }
            break;
        default:
            break;
    }
    if (_isChangeDirection) {
        [self changeRectCorner];
    }
    [self setAnchorPoint];
    [self setOffset];
    [self.tableView reloadData];
    [self setNeedsDisplay];
}

- (void)setRelyRect{
    if (CGRectEqualToRect(_relyRect, CGRectZero)) {
        return;
    }
    switch (_arrowDirection) {
        case ZXPopupMenuArrowDirectionTop:
            _point.y = _relyRect.size.height + _relyRect.origin.y;
            break;
        case ZXPopupMenuArrowDirectionBottom:
            _point.y = _relyRect.origin.y;
            break;
        case ZXPopupMenuArrowDirectionLeft:
            _point = CGPointMake(_relyRect.origin.x + _relyRect.size.width, _relyRect.origin.y + _relyRect.size.height / 2);
            break;
        case ZXPopupMenuArrowDirectionRight:
            _point = CGPointMake(_relyRect.origin.x, _relyRect.origin.y + _relyRect.size.height / 2);
            break;
        default:
            break;
    }
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    switch (_arrowDirection) {
        case ZXPopupMenuArrowDirectionTop:
            self.tableView.frame = CGRectMake(_borderWidth, _borderWidth + _arrowHeight, frame.size.width - _borderWidth * 2, frame.size.height - _arrowHeight);
            break;
        case ZXPopupMenuArrowDirectionBottom:
            self.tableView.frame = CGRectMake(_borderWidth, _borderWidth, frame.size.width - _borderWidth * 2, frame.size.height - _arrowHeight);
            break;
        case ZXPopupMenuArrowDirectionLeft:
            self.tableView.frame = CGRectMake(_borderWidth + _arrowHeight, _borderWidth , frame.size.width - _borderWidth * 2 - _arrowHeight, frame.size.height);
            break;
        case ZXPopupMenuArrowDirectionRight:
            self.tableView.frame = CGRectMake(_borderWidth , _borderWidth , frame.size.width - _borderWidth * 2 - _arrowHeight, frame.size.height);
            break;
        default:
            break;
    }
}

- (void)changeRectCorner{
    if (_isCornerChanged || _rectCorner == UIRectCornerAllCorners) {
        return;
    }
    BOOL haveTopLeftCorner = NO, haveTopRightCorner = NO, haveBottomLeftCorner = NO, haveBottomRightCorner = NO;
    if (_rectCorner & UIRectCornerTopLeft) {
        haveTopLeftCorner = YES;
    }
    if (_rectCorner & UIRectCornerTopRight) {
        haveTopRightCorner = YES;
    }
    if (_rectCorner & UIRectCornerBottomLeft) {
        haveBottomLeftCorner = YES;
    }
    if (_rectCorner & UIRectCornerBottomRight) {
        haveBottomRightCorner = YES;
    }
    switch (_arrowDirection) {
        case ZXPopupMenuArrowDirectionTop:
        case ZXPopupMenuArrowDirectionBottom:{
            if (haveTopLeftCorner) {
                _rectCorner = _rectCorner | UIRectCornerBottomLeft;
            }else {
                _rectCorner = _rectCorner & (~UIRectCornerBottomLeft);
            }
            if (haveTopRightCorner) {
                _rectCorner = _rectCorner | UIRectCornerBottomRight;
            }else {
                _rectCorner = _rectCorner & (~UIRectCornerBottomRight);
            }
            if (haveBottomLeftCorner) {
                _rectCorner = _rectCorner | UIRectCornerTopLeft;
            }else {
                _rectCorner = _rectCorner & (~UIRectCornerTopLeft);
            }
            if (haveBottomRightCorner) {
                _rectCorner = _rectCorner | UIRectCornerTopRight;
            }else {
                _rectCorner = _rectCorner & (~UIRectCornerTopRight);
            }
        }
            break;
        case ZXPopupMenuArrowDirectionLeft:
        case ZXPopupMenuArrowDirectionRight:{
            if (haveTopLeftCorner) {
                _rectCorner = _rectCorner | UIRectCornerTopRight;
            }else {
                _rectCorner = _rectCorner & (~UIRectCornerTopRight);
            }
            if (haveTopRightCorner) {
                _rectCorner = _rectCorner | UIRectCornerTopLeft;
            }else {
                _rectCorner = _rectCorner & (~UIRectCornerTopLeft);
            }
            if (haveBottomLeftCorner) {
                _rectCorner = _rectCorner | UIRectCornerBottomRight;
            }else {
                _rectCorner = _rectCorner & (~UIRectCornerBottomRight);
            }
            if (haveBottomRightCorner) {
                _rectCorner = _rectCorner | UIRectCornerBottomLeft;
            }else {
                _rectCorner = _rectCorner & (~UIRectCornerBottomLeft);
            }
        }
            break;
        default:
            break;
    }
    
    _isCornerChanged = YES;
}

- (void)setOffset{
    if (_itemWidth == 0) return;
    CGRect originRect = self.frame;
    switch (_arrowDirection) {
        case ZXPopupMenuArrowDirectionTop:
            originRect.origin.y += _offset;
            break;
        case ZXPopupMenuArrowDirectionBottom:
            originRect.origin.y -= _offset;
            break;
        case ZXPopupMenuArrowDirectionLeft:
            originRect.origin.x += _offset;
            break;
        case ZXPopupMenuArrowDirectionRight:
            originRect.origin.x -= _offset;
            break;
        default:
            break;
    }
    self.frame = originRect;
}

- (void)setAnchorPoint{
    if (_itemWidth == 0) return;
    CGPoint point = CGPointMake(0.5, 0.5);
    switch (_arrowDirection) {
        case ZXPopupMenuArrowDirectionTop:
            point = CGPointMake(_arrowPosition / _itemWidth, 0);
            break;
        case ZXPopupMenuArrowDirectionBottom:
            point = CGPointMake(_arrowPosition / _itemWidth, 1);
            break;
        case ZXPopupMenuArrowDirectionLeft:
            point = CGPointMake(0, (_itemHeight - _arrowPosition) / _itemHeight);
            break;
        case ZXPopupMenuArrowDirectionRight:
            point = CGPointMake(1, (_itemHeight - _arrowPosition) / _itemHeight);
            break;
        default:
            break;
    }
    CGRect originRect = self.frame;
    self.layer.anchorPoint = point;
    self.frame = originRect;
}

- (void)setArrowPosition{
    switch (_arrowDirection) {
        case ZXPopupMenuArrowDirectionTop:
        case ZXPopupMenuArrowDirectionBottom:{
            if (_point.x + _itemWidth / 2 > SCREEN_WIDTH - _minSpace) {
                _arrowPosition = _itemWidth - (SCREEN_WIDTH - _minSpace - _point.x);
            }else if (_point.x < _itemWidth / 2 + _minSpace) {
                _arrowPosition = _point.x - _minSpace;
            }else {
                _arrowPosition = _itemWidth / 2;
            }
        }
            break;
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect{
    UIBezierPath *bezierPath = [YBPopupMenuPath zx_bezierPathWithRect:rect rectCorner:_rectCorner cornerRadius:_cornerRadius borderWidth:_borderWidth borderColor:_borderColor backgroundColor:_backColor arrowWidth:_arrowWidth arrowHeight:_arrowHeight arrowPosition:_arrowPosition arrowDirection:_arrowDirection];
    [bezierPath fill];
    [bezierPath stroke];
}

@end
