//
//  ZZUserEditHeadView.h
//  zuwome
//
//  Created by angBiu on 2017/3/8.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RACollectionViewReorderableTripletLayout.h"

typedef NS_ENUM(NSInteger, PhotoEditType) {
    EditTypeUser = 0,
    EditTypeSkill,
};

@interface ZZUserEditHeadView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,RACollectionViewDelegateReorderableTripletLayout,RACollectionViewReorderableTripletLayoutDataSource, UIImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) PhotoEditType type;

@property (nonatomic, weak) UIViewController *weakCtl;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imgArray;//临时存放的图片（链接+image）
@property (nonatomic, strong) NSMutableArray *urlArray;//最终存链接
@property (nonatomic, strong) NSMutableArray<ZZPhoto *> *photos;
@property (nonatomic, assign) BOOL isUploading;//是否有图片正在上传
@property (nonatomic, assign) BOOL isUpdate;//是否更新图片
@property (nonatomic, assign) BOOL isReplaceHead;//检测头像没过弹窗让换头像
@property (nonatomic, assign) NSInteger isAvatarManuaReviewing;
- (void)showErrorStatusImage:(NSString *)errorString;
- (void)gotoAlbum;

@end
