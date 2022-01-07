//
//  ZZSystemMessageModel.h
//  zuwome
//
//  Created by angBiu on 16/8/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZSystemMessageDetailModel : JSONModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, assign) NSInteger media_type;//1纯文字 2文字＋链接 3文字＋图片＋链接 4文字+图片+跳转到个人详情
@property (nonatomic, strong) NSString *type;//
// 18年1月20  type增加 video_hot -->设置热门 video_hide全站隐藏 idphotounpass证件照上传失败

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *created_at_text;
@property (nonatomic, strong) NSString *cover_url;//缩略图
@end

/**
 *  系统消息model
 */
@interface ZZSystemMessageModel : JSONModel

@property (nonatomic, strong) NSString *sort_value;
@property (nonatomic, strong) ZZSystemMessageDetailModel *message;

/**
 *  获取系统消息
 *
 *  @param param 分页： sort_value
 *  @param next  回调
 */
- (void)getSystemMessageList:(NSDictionary *)param next:(requestCallback)next;

@end
