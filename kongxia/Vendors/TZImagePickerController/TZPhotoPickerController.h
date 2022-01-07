//
//  TZPhotoPickerController.h
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TZAlbumModel;
@interface TZPhotoPickerController : UIViewController

@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, strong) TZAlbumModel *model;
@property (nonatomic, assign) BOOL isFromChat;
@property (nonatomic, assign) BOOL chatShouldPay;
- (void)fetchAssetModels:(BOOL)isFirstTime;

@end


@interface TZCollectionView : UICollectionView

@end


@interface TZPhotoPickerTitleView : UIView

- (void)configureAlbumName:(NSString *)albumName;

- (void)showUp;

- (void)showDown;

@end
