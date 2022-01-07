//
//  SubTitleView.m
//
//  Created by app on 2016/12/28.
//  Copyright © 2016年 潘杨. All rights reserved.
//

#import "SubTitleView.h"
#import <Masonry.h>

@interface SubTitleView ()

/**
 *  滑块子视图
 */
@property (nonatomic, strong) UIView  *sliderView;

/**
 *  子标题按钮数组
 **/
@property (nonatomic, strong) NSMutableArray *subTitleButtonArray;

@property (nonatomic, strong) UIButton *currentSelectedButton;

@end

@implementation SubTitleView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _selectTag = 0;
    }
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    [self removeAllSubviews];
    [self configSubTitles];
    [self addSubview:self.sliderView];
    
}

- (void)transToShowAtIndex:(NSInteger)index
{
    if(index < 0 || index >= self.subTitleButtonArray.count) {
        return;
    }
    UIButton *btn = [self.subTitleButtonArray objectAtIndex:index];
    [self selectedAtButton:btn isFirstStart:NO];
}

- (void)configSubTitles
{
    // 计算每个titleView的宽度
    CGFloat width = SCREEN_WIDTH / _titleArray.count;
    
    for (NSInteger index = 0; index < _titleArray.count; index++) {
        NSString *title = [_titleArray objectAtIndex:index];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:RGBCOLOR(244, 203, 7) forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:RGBCOLOR(244, 203, 7) forState:UIControlStateHighlighted | UIControlStateSelected];
        btn.tag = index;
        btn.frame = CGRectMake(width * index, 0, width, 42);
        btn.titleLabel.font = AdaptedFontSize(15);
        btn.adjustsImageWhenHighlighted = NO;//取消按钮的点击高亮状态
        [btn addTarget:self action:@selector(subTitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.subTitleButtonArray addObject:btn];
        [self addSubview:btn];
    }
    
}

- (void)setSelectTag:(NSInteger)selectTag {
    CGFloat width = SCREEN_WIDTH / _titleArray.count;
    self.sliderView.frame = CGRectMake((width-AdaptedWidth(78))/2+width*selectTag, 42, AdaptedWidth(78), 2);
    UIButton *firstBtn = self.subTitleButtonArray[selectTag];
    [self selectedAtButton:firstBtn isFirstStart:YES];
    self.currentSelectedButton = firstBtn;
    _selectTag = selectTag;
}

#pragma mark - action

/**
 *  选中一个按钮
 **/
- (void)selectedAtButton:(UIButton *)btn isFirstStart:(BOOL)first{
    btn.selected = YES;
    self.currentSelectedButton = btn;
    if(!first) {
        [UIView animateWithDuration:0.25 animations:^{
            self.sliderView.center = CGPointMake(btn.center.x,  self.sliderView.center.y);
        }];
    }
    [self unselectedAllButton:btn];
}

/**
 *  对所有按钮颜色执行反选操作
 */
- (void)unselectedAllButton:(UIButton *)btn {
    for(UIButton *sbtn in self.subTitleButtonArray) {
        if(sbtn == btn) {
            continue;//判断是当前的的按钮就不管
        }
        sbtn.selected = NO;
    }
}

/**
 *  按钮点击事件回调
 */
- (void)subTitleBtnClick:(UIButton *)btn {
    if(btn == self.currentSelectedButton) {
        return;
    }
    if([self.delegate respondsToSelector:@selector(subTitleViewDidSelected:atIndex:title:)]) {
        [self.delegate subTitleViewDidSelected:self atIndex:[self.subTitleButtonArray indexOfObject:btn] title:btn.titleLabel.text];
    }
    [self selectedAtButton:btn isFirstStart:NO];
}


#pragma mark - Getter & Setter

- (NSMutableArray *)subTitleButtonArray
{
    if (!_subTitleButtonArray) {
        _subTitleButtonArray = [[NSMutableArray alloc] init];
    }
    return _subTitleButtonArray;
}

/**
 *  按钮下面的标示滑块
 **/
- (UIView *)sliderView
{
    if (!_sliderView) {
        _sliderView = [[UIView alloc] init];
        _sliderView.backgroundColor = RGBCOLOR(244, 203,7);
    }
    return _sliderView;
}


- (void)subTitleViewDidSelected:(SubTitleView *)titleView atIndex:(NSInteger)index title:(NSString *)title {
    
}
@end

