//
//  ZZIDPhotoManagerViewController.h
//  zuwome
//
//  Created by qiming xiao on 2019/1/3.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class ZZIDPhotoManagerViewController;
@class ZZIDPhoto;

@protocol ZZIDPhotoManagerViewControllerDelegate <NSObject>

- (void)IDPhotoDidUpdated:(ZZIDPhotoManagerViewController *)viewController needRefresh:(BOOL)needRefresh;

@end

@interface ZZIDPhotoManagerViewController : ZZViewController

@property (nonatomic,   weak) id<ZZIDPhotoManagerViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isComingFromWebView;

@end

NS_ASSUME_NONNULL_END
