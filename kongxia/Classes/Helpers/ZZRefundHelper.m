//
//  ZZRefundHelper.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZRefundHelper.h"

@implementation ZZRefundHelper
+ (NSInteger)numberOfRowSectionWithSection:(NSInteger)section model:(ZZUploadBaseModel *)model {
    if (model.refuse_photos.count>0){
        if (section==0) {
            if (model.photos.count>0) {
                return 3;       //有图片
            }else{
                return 2;       //没有图片
            }
        }else{
            if (model.refuse_photos.count>0) {
                return 3;       //有图片
            }else{
                return 2;       //没图片
            }
        }
    }else{
        if (section==0) {
            if (model.photos.count>0) {
                return 2;       //有图片
            }else{
                return 1;       //没有图片
            }
        }else{
            if (model.refuse_photos.count>0) {
                return 2;       //有图片
            }else{
                return 1;       //没图片
            }
        }
    }

}


/**
注* 按照产品的设计要求是  只有一个区的时候只会有用户上传的证据和理由
    2个区的时候才会有达人上传的证据和理由
  appealing  申述中才有2种
 */
+ (NSString *)titleOfSectionWithIndexPath:(NSIndexPath *)indexPath  model:(ZZUploadBaseModel *)model {
    if (model.refuse_photos.count>0){
        if (indexPath.section==0) {
            switch (indexPath.row) {
                case 0:
                    return model.userName;
                    break;
        
                default:
                    return model.remarks;
                    break;
            }
        }else{
            switch (indexPath.row) {
                case 0:
                    return model.doyenNickName;
                    break;
                default:
                     return model.refuse_reason;
                    break;
            }
        }
    }else{
        if (indexPath.row == 0) {
            return model.remarks;
        }else{
            return nil;
        }
    }
}
+ (NSString *)identifierWithIndexPath:(NSIndexPath *)indexPath   model:(ZZUploadBaseModel *)model{
    if (model.refuse_photos.count>0){
        switch (indexPath.row) {
            case 0:
                return @"ZZOrderArCheckEvidenceNickCellID";//昵称
                break;
            case 1:
                return @"ZZOrderARCheckEVidenceReasonCellID";//理由
                break;
            default:
                return @"ZZOrderArCheckEvidenceDetailPhoneCellID";//详细图片
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                return @"ZZOrderARCheckEVidenceReasonCellID";//理由
                break;
            default:
                return @"ZZOrderArCheckEvidenceDetailPhoneCellID";//详细图片
                break;
        }
    }

}
+ (NSArray *)arrayOfSectionWithIndexPath:(NSIndexPath *)indexPath  model:(ZZUploadBaseModel *)model {
    if (model.refuse_photos.count>0){
        if (indexPath.section==0) {
            switch (indexPath.row) {
                case 0:
                case 1:
                    return nil;
                    break;
                default:
                    return model.photos;
                    break;
            }
        }else{
            switch (indexPath.row) {
                case 0:
                case 1:
                    return nil;
                    break;
                default:
                    return model.refuse_photos;
                    break;
            }
        }
    }else{
        switch (indexPath.row) {
            case 0:
                return nil;
                break;
            default:
                return model.photos;
                break;
        }
    }
}

@end
