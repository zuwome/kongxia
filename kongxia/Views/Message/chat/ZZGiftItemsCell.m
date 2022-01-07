//
//  ZZGiftItemCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/22.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZGiftItemsCell.h"
#import "ZZGiftModel.h"

@interface ZZGiftItemsCell ()

@property (nonatomic, copy) NSArray<ZZGiftItemView *> *itemsArr;

@property (nonatomic, copy) NSArray<ZZGiftModel *> *giftsArr;

@end

@implementation ZZGiftItemsCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - public Method
- (void)configureGifts:(NSArray<ZZGiftModel *> *)giftsModelArr selectedGift:(ZZGiftModel *)selectedGiftModel {
    _giftsArr = giftsModelArr;
    
    [_itemsArr enumerateObjectsUsingBlock:^(ZZGiftItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= _giftsArr.count) {
            obj.hidden = YES;
        }
        else {
            obj.hidden = NO;
            
            ZZGiftModel *model = _giftsArr[idx];
            [obj configureGift:model];
            
            if ([model._id isEqualToString:selectedGiftModel._id]) {
                [obj shouldShowSelectedView:YES];
            }
            else {
                [obj shouldShowSelectedView:NO];
            }
        }
    }];
}

#pragma mark - response method
- (void)choose:(UITapGestureRecognizer *)recognizer {
    ZZGiftModel *model = _giftsArr[recognizer.view.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:chooseGift:)]) {
        [self.delegate cell:self chooseGift:model];
    }
}

#pragma mark - Layout
- (void)layout {
    CGFloat itemWidth = SCREEN_WIDTH / 4;
    CGFloat itemHeight = self.height / 2;
    
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < 8; i++) {
        ZZGiftItemView *view = [self createItemsView:i];
        view.frame = CGRectMake(0 + itemWidth * (i % 4), 0 + itemHeight * (i / 4), itemWidth, itemHeight);
        [arr addObject:view];
    }
    
    _itemsArr = arr.copy;
}

- (ZZGiftItemView *)createItemsView:(NSInteger)index {
    ZZGiftItemView *view = [[ZZGiftItemView alloc] init];
    view.tag = index;
    [self addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choose:)];
    [view addGestureRecognizer:tap];
    
    return view;
}

@end

@interface ZZGiftItemView ()

@property (nonatomic, strong) UIImageView *mebiIconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subtitleLabel;

@property (nonatomic, strong) UIView *selectedBGView;

@end

@implementation ZZGiftItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureGift:(ZZGiftModel *)model {
    [_mebiIconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

    }];

    _titleLabel.text = model.name;
    _subtitleLabel.text = [NSString stringWithFormat:@"%ld么币", model.mcoin];
}

- (void)shouldShowSelectedView:(BOOL)shouldShow {
    _selectedBGView.hidden = !shouldShow;
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.selectedBGView];
    [self addSubview:self.mebiIconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    
    [_selectedBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_mebiIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(59, 59));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.right.equalTo(self);
        make.top.equalTo(_mebiIconImageView.mas_bottom);
        make.height.equalTo(@18.5);
    }];
    
    [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.right.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.height.equalTo(@14);
    }];
}

#pragma mark - getters and setters
- (UIView *)selectedBGView {
    if (!_selectedBGView) {
        _selectedBGView = [[UIView alloc] init];
        _selectedBGView.backgroundColor = RGBCOLOR(255, 249, 223);
        _selectedBGView.layer.borderColor = kGoldenRod.CGColor;
        _selectedBGView.layer.borderWidth = 1;
        _selectedBGView.hidden = YES;
    }
    return _selectedBGView;
}

- (UIImageView *)mebiIconImageView {
    if (!_mebiIconImageView) {
        _mebiIconImageView = [[UIImageView alloc] init];
    }
    return _mebiIconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"text";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.text = @"subtext";
        _subtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
        _subtitleLabel.textColor = RGBCOLOR(153, 153, 153);
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subtitleLabel;
}

@end
