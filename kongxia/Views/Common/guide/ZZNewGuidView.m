//
//  ZZNewGuidView.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZNewGuidView.h"

@interface ZZNewGuidView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation ZZNewGuidView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)confirm {
    [self removeFromSuperview];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    if (self.delegate && [self.delegate respondsToSelector:@selector(guideViewDidFinish)]) {
        [self.delegate guideViewDidFinish];
    }
}

- (void)layout {
    self.backgroundColor = ColorWhite;
    [self addSubview:self.bgImageView];
    [self addSubview:self.scrollView];
    [self addSubview:self.confirmBtn];
    [self addSubview:self.pageControl];
    [self createViews];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(140, 44));
    }];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(_confirmBtn.mas_top).offset(-17);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 15));
    }];
    
}

- (void)createViews {
    NSArray *titleArray = @[@"按你喜好，一键发布通告",@"你是多才多艺的达人？",@"优质达人推荐，一对一邀请"];
    NSArray *subTitleArray = @[@"多位达人报名，快速挑选到志同道合的TA",@"发布你想要活动，分享时间，赚取收益 ",@"与志同道和的Ta ，探索生活多种可能"];
    NSArray *imagesArray = @[@"yindaoye1", @"yindaoye2", @"yindaoye3"];
    for (int i = 0; i < 3; i++) {
        ZZNewGuidSubView *subView = [[ZZNewGuidSubView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [subView configureTitle:titleArray[i] subTitle:subTitleArray[i] icon:imagesArray[i] index:i];
        subView.backgroundColor = ColorClear;
        [_scrollView addSubview:subView];
    }
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0.0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x - SCREEN_WIDTH * (3 - 1) > 60) {
//        GCDRunOne(^{
//            [self skipToIndex];
//        });
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self confirm];
        });
        return;
    }
    
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    _pageControl.currentPage = page;
}

#pragma mark - getters and setters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.normalImage = [UIImage imageNamed:@"iconLijitiyan"];
        [_confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.currentPageIndicatorTintColor = kYellowColor;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"bg"];
        _bgImageView.backgroundColor = ColorWhite;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

@end


@interface ZZNewGuidSubView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *naviagtorImageView;

@end

@implementation ZZNewGuidSubView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureTitle:(NSString *)title subTitle:(NSString *)subTitle icon:(NSString *)icon index:(NSInteger)index {
    _titleLabel.text = title;
    _subTitleLabel.text = subTitle;
    _imageView.image = [UIImage imageNamed:icon];
    _naviagtorImageView.hidden = index != 0;
}

- (void)layout {
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.imageView];
    [self addSubview:self.naviagtorImageView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(71);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom).offset(15);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_subTitleLabel.mas_bottom).offset(21);
//        make.size.mas_equalTo(CGSizeMake(203, 414));
    }];
    
    [_naviagtorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(420.5);
        make.right.equalTo(self).offset(-21);
        make.size.mas_equalTo(CGSizeMake(88.5, 51.5));
    }];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _subTitleLabel.font = [UIFont systemFontOfSize:16];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = ColorWhite;
//        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIImageView *)naviagtorImageView {
    if (!_naviagtorImageView) {
        _naviagtorImageView = [[UIImageView alloc] init];
        _naviagtorImageView.contentMode = UIViewContentModeScaleAspectFill;
        _naviagtorImageView.image = [UIImage imageNamed:@"group63"];
        
    }
    return _naviagtorImageView;
}
@end
