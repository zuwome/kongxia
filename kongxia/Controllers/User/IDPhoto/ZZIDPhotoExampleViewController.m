//
//  ZZIDPhotoExampleViewController.m
//  zuwome
//
//  Created by qiming xiao on 2019/1/3.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZIDPhotoExampleViewController.h"

@interface ZZIDPhotoExampleViewController ()

@property (nonatomic, strong) UIImageView *exampleImageView;

@end

@implementation ZZIDPhotoExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layout];
    [self createNavigationLeftButton];
}

#pragma mark - UI
- (void)layout {
    [self.view addSubview:self.exampleImageView];
    [_exampleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(0);
    }];
}

#pragma mark - Setter&Getter
- (UIImageView *)exampleImageView {
    if (!_exampleImageView) {
        _exampleImageView = [[UIImageView alloc] init];
        _exampleImageView.image = [UIImage imageNamed:@"IDPhotoExample"];
        _exampleImageView.backgroundColor = UIColor.blackColor;
        _exampleImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _exampleImageView;
}
@end
