//
//  TZAlbumView.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/4.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZPhotoPickerController.h"
NS_ASSUME_NONNULL_BEGIN
@class TZAlbumView;
@class TZAlbumModel;

@protocol TZAlbumViewDelegate <NSObject>

- (void)view:(TZAlbumView *)view didSelectAlbum:(TZAlbumModel *)albumModel isTheFirstTime:(BOOL)isTheFirstTime;

@end

@interface TZAlbumView : UIView

@property (nonatomic, weak) id<TZAlbumViewDelegate> delegate;

@property (nonatomic, weak) TZImagePickerController *navigationController;

- (void)fetchAlbums;

- (void)show;

@end




NS_ASSUME_NONNULL_END
