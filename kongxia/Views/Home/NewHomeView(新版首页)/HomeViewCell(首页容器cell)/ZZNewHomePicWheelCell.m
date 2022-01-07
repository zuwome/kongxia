//
//  ZZNewHomePicWheelCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewHomePicWheelCell.h"
#import "ZZHomeModel.h"
#import "ESMaskBanner.h"
#import "ESBannerModel.h"

@interface ZZNewHomePicWheelCell ()

@property (nonatomic, strong) ESMaskBanner *maskBanner;

@end

@implementation ZZNewHomePicWheelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)createView {
    self.contentView.backgroundColor = kBGColor;
    
    [self.contentView addSubview:self.maskBanner];
}

- (void)setBannerArray:(NSArray *)bannerArray {
    [super setBannerArray:bannerArray];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (ZZHomeBannerModel *bannerModel in self.bannerArray) {
        NSDictionary *bannerDict = @{@"bannerImage":bannerModel.img,
                                     @"backImage":bannerModel.background};
        ESBannerModel *model = [[ESBannerModel alloc] initWithDictionary:bannerDict];
        [tmpArray addObject:model];
    }
    self.maskBanner.bannerArray = [tmpArray copy];
}

- (ESMaskBanner *)maskBanner {
    if (nil == _maskBanner) {
        WeakSelf
        _maskBanner = [[ESMaskBanner alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
        _maskBanner.pageControlSelectColor = kGoldenRod;
        _maskBanner.pageControlUnselectColor = [kBlackColor colorWithAlphaComponent:0.3];
        _maskBanner.showPageControl = YES;
        [_maskBanner setDidClickBannerAtIndex:^(NSInteger index) {
            !weakSelf.didSelectAtIndex ? : weakSelf.didSelectAtIndex(index);
        }];
    }
    return _maskBanner;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
