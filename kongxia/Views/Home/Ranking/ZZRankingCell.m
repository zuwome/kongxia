//
//  ZZRankingCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZRankingCell.h"
#import "ZZLevelImgView.h"
#import "ZZListRankView.h"

#import "kongxia-Swift.h"

@interface ZZRankingCell () <ZZListRankViewDelegate>

@property (nonatomic, strong) ZZListRankView *rankView;

@property (nonatomic, strong) UIView *seperateLine;

@end

@implementation ZZRankingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData:(ZZUser *)user index:(NSInteger)index {
    [_rankView configureUser:user rank:index + 1];
}


#pragma mark - ZZListRankViewDelegate
- (void)view:(ZZListRankView *)view showUserInfo:(ZZUser *)userInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showUserInfo:)]) {
        [self.delegate cell:self showUserInfo:userInfo];
    }
}

- (void)view:(ZZListRankView *)view goChat:(ZZUser *)userInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:goChat:)]) {
        [self.delegate cell:self goChat:userInfo];
    }
}



#pragma mark - Layout
- (void)layout {
    [self.contentView addSubview:self.rankView];
    [self.contentView addSubview:self.seperateLine];
    [_rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.right.equalTo(self).offset(-15.0);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}


#pragma mark - getters and setters
- (ZZListRankView *)rankView {
    if (!_rankView) {
        _rankView = [[ZZListRankView alloc] init];
        _rankView.delegate = self;
    }
    return _rankView;
}

- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = kGrayLineColor;
    }
    return _seperateLine;
}

@end
