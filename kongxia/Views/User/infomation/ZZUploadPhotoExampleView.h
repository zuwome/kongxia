//
//  ZZUploadPhotoExampleView.h
//  kongxia
//
//  Created by qiming xiao on 2019/7/31.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PhotoExampleType) {
    PhotoUserInfo,
    PhotoUserSkill,
};

@interface ZZUploadPhotoExampleView : UIView

+ (instancetype)showPhotos:(PhotoExampleType)type showin:(UIView *)view;

- (void)show;

- (void)hide;

@end

@interface ZZUploadPhotoExampleTopView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIImageView *exampleImageView;

@property (nonatomic, strong) UIView *seperateline;

- (instancetype)initWithType:(PhotoExampleType)type;

@end

@interface ZZUploadPhotoExampleBottomView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *example1ImageView;

@property (nonatomic, strong) UILabel *exampleTitle1Label;

@property (nonatomic, strong) UIImageView *example2ImageView;

@property (nonatomic, strong) UILabel *exampleTitle2Label;

@property (nonatomic, strong) UIImageView *example3ImageView;

@property (nonatomic, strong) UILabel *exampleTitle3Label;

@property (nonatomic, strong) UIImageView *example4ImageView;

@property (nonatomic, strong) UILabel *exampleTitle4Label;

- (instancetype)initWithType:(PhotoExampleType)type;

@end
