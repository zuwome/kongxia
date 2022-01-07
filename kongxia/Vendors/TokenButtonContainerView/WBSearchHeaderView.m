//
//  WBSearchHeaderView.m
//  Cosmetic
//
//  Created by 余天龙 on 16/6/22.
//  Copyright © 2016年 YuTianLong. All rights reserved.
//

#import "WBSearchHeaderView.h"
#import "Masonry.h"

@interface WBSearchHeaderView () <WBInputViewDelegate>

@property (nonatomic, strong) NSMutableArray<WBInputView *> *inputViews;
@property (nonatomic, weak, readwrite) WBInputView *currentSelectInputView;

@end

@implementation WBSearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.inputViews = [NSMutableArray arrayWithCapacity:4];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self notifyHeightChangeBlockIfNeeded];
}

- (void)setHeaderView:(UIView *)headerView {
    [_headerView removeFromSuperview];
    if (_headerView == headerView) {
        [headerView removeConstraints:headerView.constraints];
    }
    _headerView = headerView;
    
    if (headerView) {
        [self insertSubview:headerView atIndex:0];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.leading.and.trailing.equalTo(@0);
            make.height.greaterThanOrEqualTo(@0);
            make.width.equalTo(self.mas_width);
        }];
    }
    
    if (self.window != nil) {
        [self notifyHeightChangeBlockIfNeeded];
    }
}

- (void)setFooterView:(UIView *)footerView {
    [_footerView removeFromSuperview];
    if (_footerView == footerView) {
        [footerView removeConstraints:footerView.constraints];
    }
    _footerView = nil;
    UIView *lastView = [self findLastView];
    
    _footerView = footerView;
    
    if (footerView) {
        [self addSubview:footerView];
        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.trailing.equalTo(@0);
            make.height.equalTo(@(footerView.height));
            make.width.equalTo(self.mas_width);
            make.top.equalTo(lastView.mas_bottom);
        }];
    }
    
    [self notifyHeightChangeBlockIfNeeded];
}

- (WBInputView *)insertInputViewWithTitle:(NSString *)title
                needsToAutoRecognizeToken:(BOOL)needsToAutoRecognizeToken
                                      tag:(NSUInteger)tag {
    WBInputView *inputView = [WBInputView new];
    inputView.leftViewCaption = title;
    inputView.autoRecognizeToken = needsToAutoRecognizeToken;
    inputView.isEditable = self.editable;
    inputView.delegate = self;
    inputView.tag = tag;
//    [inputView addBottomBorder];
    [self addSubview:inputView];
    
    WEAK_SELF();
    WEAK_OBJECT(inputView, weakInputView);
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        
        WBInputView *lastInputView = [weakSelf.inputViews lastObject];
        if (lastInputView) {
            make.top.equalTo(lastInputView.mas_bottom);
        } else if (_headerView) {
            make.top.equalTo(_headerView.mas_bottom);
        } else {
            make.top.equalTo(@0);
        }
        make.height.equalTo(@([weakInputView preferedHeight]));
    }];
    
    [inputView setTextChangedBlock:^(NSString *text) {
        BLOCK_SAFE_CALLS(weakSelf.contentDidChangeBlock, weakInputView, NO);
    }];
    
    [inputView setHeightChangedBlock:^(CGFloat preferedHeight) {
        if (weakInputView.hidden == NO) {
            [weakInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(preferedHeight));
            }];
            
            if (weakSelf.window != nil) {
                [weakSelf setNeedsLayout];
                [weakSelf layoutIfNeeded];
            }
            [weakSelf notifyHeightChangeBlockIfNeeded];
        }
    }];
    
    [inputView setTokenButtonDidRemoveBlock:^{
        BLOCK_SAFE_CALLS(weakSelf.contentDidChangeBlock, weakInputView, YES);
    }];
    
    [inputView setTokenButtonTouchBlock:^(NSString *uid) {
        BLOCK_SAFE_CALLS(weakSelf.tokenDidTouchBlock, uid);
    }];
    
    [self.inputViews addObject:inputView];
    
    [self notifyHeightChangeBlockIfNeeded];
    
    return inputView;
}

- (WBInputView *)inputViewWithTag:(NSUInteger)tag {
    return [self viewWithTag:tag];
}

- (void)notifyHeightChangeBlockIfNeeded {
    CGSize size = CGSizeMake(0, [self findLastView].bottom + 10);
    if (size.height != self.height) {
        BLOCK_SAFE_CALLS(self.heightChangeBlock, size.height);
    }
}

- (UIView *)findLastView {
    if (self.footerView) {
        return self.footerView;
    }
    
    UIView *lastView = self.inputViews.lastObject;
    if (lastView == nil) {
        return _headerView;
    } else {
        return lastView;
    }
}

#pragma mark - WBInputViewDelegate methods

- (void)inputViewDidBeginEditing:(WBInputView *)inputView {
    self.currentSelectInputView = inputView;
}

- (void)inputViewDidEndEditing:(WBInputView *)inputView {
    self.currentSelectInputView = nil;
}

@end
