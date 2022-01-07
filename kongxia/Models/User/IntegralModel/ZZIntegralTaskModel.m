//
//  ZZIntegralTaskModel.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZIntegralTaskModel.h"

@implementation ZZIntegralTaskModel
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
- (NSString *)imageName {
    if (!_imageName) {
   
        switch ([self.type intValue]) {
            case 2:
                //上传真实头像
                _imageName = @"icPhotoXsrwWd";
                break;
            case 3:
                //发布一条视频
                _imageName = @"icVideoXsrwWdjf";

                break;
            case 4:
                //绑定微博
                _imageName = @"icWbXsrwWdjf";

                break;
            case 5:
                //关注公众号
                _imageName = @"icGzhXsrwWdjf";

                break;
            case 6:
                //实名认证
                _imageName = @"icSmrzXsrwWdjf";

                break;
            
            case 7:
                //分享快照
                _imageName = @"icKzRcrwWdjf";

                break;
            case 8:
                //评论视频
                _imageName = @"icPlspRcrwWdjf";

                break;
            case 9:
                //点赞视频
                _imageName = @"icDzspRcrwWdjf";

                break;
            case 10:
                //查看微信号
                _imageName = @"icCkwxRcrwWdjf";

                break;
            case 11:
                //完成线下邀约
                _imageName = @"icYaoyueRcrwWdjf";

                break;
            default:
                _imageName = @"";
                break;
        }
    }
    return _imageName;
}
@end
