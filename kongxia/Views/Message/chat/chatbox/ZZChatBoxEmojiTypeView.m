//
//  ZZChatBoxEmojiTypeView.m
//  zuwome
//
//  Created by angBiu on 2016/11/8.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatBoxEmojiTypeView.h"

#import "ZZChatBoxEmojiPageView.h"
#import "ZZGifButton.h"

@interface ZZChatBoxEmojiTypeView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *baseScrollView;//最底层的键盘
@property (nonatomic, strong) UIScrollView *scrollView;//子键盘1
@property (nonatomic, strong) UIPageControl *pageControl;//子键盘1
@property (nonatomic, strong) UIScrollView *scrollView2;//子键盘2
@property (nonatomic, strong) UIPageControl *pageControl2;//子键盘2
@end

@implementation ZZChatBoxEmojiTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF8F8F8);
        [self addSubview:self.baseScrollView];
        
        [self setUpUI];
    }
    
    return self;
}
- (void)setUpUI {
    
   self.baseScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
   self.baseScrollView.contentSize=CGSizeMake(2*SCREEN_WIDTH, self.height) ;
   self.baseScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, self.height) ;
    [self.baseScrollView addSubview:self.scrollView];
    [self.baseScrollView addSubview:self.pageControl];
    self.scrollView.tag = 1111;
    
  //  先完成  5 1再来改变吧
    [self.baseScrollView addSubview:self.scrollView2];
    [self.baseScrollView addSubview:self.pageControl2];
    
    self.scrollView2.tag = 2222;
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];

            self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
            self.pageControl.frame = CGRectMake(0, self.height - 15, SCREEN_WIDTH, 15);
            
            NSInteger count = self.scrollView.subviews.count;
            for (int i = 0; i < count; i ++) {
                ZZChatBoxEmojiPageView *pageView = self.scrollView.subviews[i];
                pageView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height);
            }
            self.scrollView.contentSize = CGSizeMake(count*self.scrollView.width, 0);

            self.scrollView2.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.height);
            self.pageControl2.frame = CGRectMake(SCREEN_WIDTH, self.height - 15, SCREEN_WIDTH, 15);
            self.scrollView2.contentSize = CGSizeMake(1*self.scrollView2.width, 0);
}
- (void)setGifArray:(NSArray *)gifArray {
    _gifArray = gifArray;
    for (int i = 0; i < self.gifArray.count; i ++) {
        ZZGifButton *pageView = [ZZGifButton buttonWithType:UIButtonTypeCustom];
        pageView.frame = CGRectMake(i*85+30, 21, 55, 55);
        pageView.model = gifArray[i];
        NSString *imageName = [NSString stringWithFormat:@"%@%@",pageView.model.localPath,@"Cover"];
        [pageView setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        pageView.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [pageView addTarget:self action:@selector(gifClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView2 addSubview:pageView];
    }
}

- (void)gifClick:(ZZGifButton *)sender {
//     sender.enabled = NO;
//    [NSObject asyncWaitingWithTime:0.2 completeBlock:^{
//      sender.enabled = YES;
//    }];
    ZZGifMessageModel *model = [[ZZGifMessageModel alloc]init];
    model.type = sender.model.type;
    model.messageDigest = sender.model.messageDigest;
    model.localPath =sender.model.localPath;
    model.allResultsCount = sender.model.allResultsCount;
    
    model.gifWidth = sender.model.gifWidth;
    model.gifHeight =sender.model.gifHeight;
    if ([model.type isEqualToString:@"game"]) {
        model.resultsType =  1+(arc4random() % model.allResultsCount);
    }
    if (self.sendMessage) {
        self.sendMessage(model);
    }
}
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    switch (self.emojiType) {
        case ZZChatInputExpandEmojiTypeSimple:
            {
                CGFloat btnWidth = 50;
                NSInteger column = SCREEN_WIDTH / btnWidth;
                NSInteger maxCount = column*3 - 1;
                NSInteger count = emotions.count / (column*3 - 1) + 1;
                self.pageControl.numberOfPages = count;
                for (int i=0; i<count; i++) {
                    ZZChatBoxEmojiPageView *pageView = [[ZZChatBoxEmojiPageView alloc] init];
                    NSRange range;
                    range.location              = i * maxCount;
                    NSUInteger left             = emotions.count - range.location;//剩余
                    if (left >= maxCount) {
                        range.length            = maxCount;
                    } else {
                        range.length            = left;
                    }
                    pageView.emotions           = [emotions subarrayWithRange:range];
                    [self.scrollView addSubview:pageView];
                    
                    WeakSelf;
                    pageView.touchDelete = ^{
                        if (weakSelf.touchDelete) {
                            weakSelf.touchDelete();
                        }
                    };
                    pageView.touchEmoji = ^(NSString *emoji){
                        if (weakSelf.touchEmoji) {
                            weakSelf.touchEmoji(emoji);
                        }
                    };
                }
            }
            break;
        case ZZChatInputExpandEmojiTypeGIF:
        {
            
        }
            break;
        default:
            break;
    }

    
    [self setNeedsLayout];
}

- (void)selectIndex:(NSInteger )index {
    
    [self.baseScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0) animated:NO];

}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    if (scrollView.tag ==self.scrollView.tag) {
        self.pageControl.currentPage = index;

    }else if (scrollView.tag ==self.scrollView2.tag) {
        
        self.pageControl2.currentPage = index;
     
    }
    
    if (scrollView ==self.baseScrollView) {
          NSUInteger indexSelect = scrollView.contentOffset.x/SCREEN_WIDTH;;
        if (self.changeSelectScroller) {
            self.changeSelectScroller(indexSelect);
        }
    }
}

#pragma Lazyload

- (UIScrollView *)baseScrollView {
    if (!_baseScrollView) {
        _baseScrollView = [[UIScrollView alloc]init];
        _baseScrollView.delegate = self;
        _baseScrollView.showsHorizontalScrollIndicator = NO;
        _baseScrollView.showsVerticalScrollIndicator = NO;
        _baseScrollView.pagingEnabled = YES;
    }
    return _baseScrollView;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.userInteractionEnabled = NO;
    }
    
    return _pageControl;
}
- (UIScrollView *)scrollView2
{
    if (!_scrollView2) {
        _scrollView2 = [[UIScrollView alloc] init];
        _scrollView2.delegate = self;
        _scrollView2.showsHorizontalScrollIndicator = NO;
        _scrollView2.showsVerticalScrollIndicator = NO;
        _scrollView2.pagingEnabled = YES;
    }
    
    return _scrollView2;
}

- (UIPageControl *)pageControl2
{
    if (!_pageControl2) {
        _pageControl2 = [[UIPageControl alloc] init];
        _pageControl2.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl2.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl2.userInteractionEnabled = NO;
    }
    
    return _pageControl2;
}

@end
