//
//  ZZTaskLiskesCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskLiskesCell.h"
#import "ZZTaskModel.h"
#import "ZZHeadImageView.h"
#import "ZZTaskLikeModel.h"
@interface ZZTaskLiskesCell ()

@property (nonatomic, strong) UILabel *likesLabel;

@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, copy) NSArray<ZZHeadImageView *> *headImageViewArray;

@property (nonatomic, assign) CGFloat headSize;

@end

@implementation ZZTaskLiskesCell

+ (NSString *)cellIdentifier {
    return @"ZZTaskLiskesCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    if ([_item isKindOfClass: [TaskLikesItem class]]) {
        TaskLikesItem *item = (TaskLikesItem *)_item;
        
        _likesLabel.text = [NSString stringWithFormat:@"%ld人点赞",item.task.task.like];
        
        [_headImageViewArray enumerateObjectsUsingBlock:^(ZZHeadImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (item.task.task.likedUsers.count == 0) {
                obj.hidden = YES;
            }
            else {
                if (idx < item.task.task.likedUsers.count) {
                    obj.hidden = NO;
                    ZZTaskLikeModel *likedUser = item.task.task.likedUsers[idx];
                    [obj setUser:likedUser.like_user width:_headSize vWidth:10];
                }
                else {
                    obj.hidden = YES;
                }
            }
        }];
        
    }
}

- (void)userIconTouchWithTag:(NSInteger)tag {
    if (tag <= _item.task.task.likedUsers.count - 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showLikedUserInfoWith:)]) {
            [self.delegate cell:self showLikedUserInfoWith:_item.task.task.likedUsers[tag].like_user];
        }
    }
}

- (void)selectedUser:(UITapGestureRecognizer *)recognizer {
    [self userIconTouchWithTag:recognizer.view.tag];
}

- (void)showMore {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showMoreUsers:)]) {
        [self.delegate cell:self showMoreUsers:(TaskLikesItem *)_item];
    }
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.likesLabel];
    [self addSubview:self.moreBtn];
    _likesLabel.frame = CGRectMake(15.0, 15.0, 100, _likesLabel.font.lineHeight);
    CGFloat distanceLWidth = [NSString findWidthForText:_moreBtn.normalTitle havingWidth:200 andFont:CustomFont(13)];
    _moreBtn.frame = CGRectMake(self.width, 15.0, distanceLWidth, CustomFont(13).lineHeight);
    
    CGFloat offsetX = 15.0;
    CGFloat offsetYT = 8.0;
//    CGFloat offsetYB = 15.0;
    CGFloat offsets = 5.0;
    
    NSInteger itemsPerLine = ISiPhone5 ? 6 : 7;
    CGFloat imageSize = (SCREEN_WIDTH - offsetX * 2 - offsets * 6) / itemsPerLine;
    _headSize = imageSize;
    NSMutableArray *array = @[].mutableCopy;
    for (int i = 0; i < itemsPerLine; i++) {
        ZZHeadImageView *imageView = [[ZZHeadImageView alloc] init];
        imageView.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedUser:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
        imageView.frame = CGRectMake(offsetX + (imageSize + offsets) * (i % itemsPerLine), _likesLabel.bottom + offsetYT, imageSize, imageSize);
        
        [array addObject:imageView];
    }
    
    _headImageViewArray = array.copy;
}

#pragma mark - Getter&Setter
- (void)setItem:(TaskItem *)item {
    _item = item;
    [self configureData];
}

- (UILabel *)likesLabel {
    if (!_likesLabel) {
        _likesLabel = [[UILabel alloc] init];
        _likesLabel.font = [UIFont systemFontOfSize:14];
        _likesLabel.text = @"0人觉得赞";
        _likesLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _likesLabel;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton new];
        [_moreBtn setTitle:@"更多 >" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = CustomFont(13);
        [_moreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

@end
