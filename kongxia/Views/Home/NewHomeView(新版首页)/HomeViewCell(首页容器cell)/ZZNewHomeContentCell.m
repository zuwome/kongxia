//
//  ZZNewHomeContentCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewHomeContentCell.h"

#import "ZZHomeNearbyViewController.h"
#import "ZZHomeTypeViewController.h"
#import "ZZHomeRefreshViewController.h"

@interface ZZNewHomeContentCell () <UIScrollViewDelegate>

@end

@implementation ZZNewHomeContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setCtlsArray:(NSArray *)ctlsArray {
    [super setCtlsArray:ctlsArray];
    if (_scrollView.subviews.count == 0) {  //没加入视图时加入
        for (int i = 0 ; i < ctlsArray.count; i++) {
            ZZViewController *ctl = ctlsArray[i];
            [_scrollView addSubview:ctl.view];
        }
    }
    CGSize size = _scrollView.contentSize;
    size.width = SCREEN_WIDTH * ctlsArray.count;
    size.height = _scrollView.bounds.size.height;
    if (!CGSizeEqualToSize(size, _scrollView.contentSize)) {    //布局变化才设置
        for (int i = 0 ; i < ctlsArray.count; i++) {
            ZZViewController *ctl = ctlsArray[i];
            ctl.view.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollView.bounds.size.height);
            //更新布局要刷新数据，不然视图显示有问题
            if ([ctl isKindOfClass:[ZZHomeNearbyViewController class]]) {
                ZZHomeNearbyViewController *nearBy = (ZZHomeNearbyViewController *)ctl;
                [nearBy.tableView reloadData];
            }
            else if ([ctl isKindOfClass:[ZZHomeTypeViewController class]]) {
                ZZHomeTypeViewController *recommend = (ZZHomeTypeViewController *)ctl;
                 [recommend.tableview reloadData];
            }
            else if ([ctl isKindOfClass:[ZZHomeRefreshViewController class]]) {
                ZZHomeRefreshViewController *fresh = (ZZHomeRefreshViewController *)ctl;
                [fresh.tableView reloadData];
            }
        }
        [_scrollView setContentSize:size];
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    }
}

- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    if (self.ctlsArray[0]) {
        ZZHomeNearbyViewController *nearBy = self.ctlsArray[0];
        nearBy.canScroll = canScroll;
        if (!nearBy.canScroll) {
            nearBy.tableView.contentOffset = CGPointZero;
        }
    }
    if (self.ctlsArray[1]) {
        ZZHomeTypeViewController *recommend = self.ctlsArray[1];
        recommend.canScroll = canScroll;
        if (!recommend.canScroll) {
//            recommend.collectionView.contentOffset = CGPointZero;
            recommend.tableview.contentOffset = CGPointZero;
        }
    }
    if (self.ctlsArray[2]) {
        ZZHomeRefreshViewController *fresh = self.ctlsArray[2];
        fresh.canScroll = canScroll;
        if (!fresh.canScroll) {
            fresh.tableView.contentOffset = CGPointZero;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollView == scrollView) {
        !self.didScroll ? : self.didScroll(scrollView.contentOffset);
    }
}

- (ZZNewHomeContentScroll *)scrollView {
    if (nil == _scrollView) {
        _scrollView = [[ZZNewHomeContentScroll alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
    }
    return _scrollView;
}

@end
