//
//  ZZMemedaModel.h
//  zuwome
//
//  Created by angBiu on 16/8/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZMemedaTopicModel.h"

@protocol ZZMMDTipsModel
@end
/**
 *  贡献榜
 */
@interface ZZMMDTipsModel : JSONModel

@property (nonatomic, assign) CGFloat price;
@property (nonatomic, strong) ZZUser *from;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, assign) BOOL is_anonymous;

@end

@interface ZZMMDVideoModel : JSONModel

@property (nonatomic, strong) NSString *cover_url;//缩略图
@property (nonatomic, strong) NSString *cover_url_share;
@property (nonatomic, strong) NSString *video_url;//视频
@property (nonatomic, assign) CGFloat time;
@property (nonatomic, assign) NSUInteger width;//视频宽(可用作封面)
@property (nonatomic, assign) NSUInteger height;//视频高(可用作封面)


@end

@protocol ZZMMDAnswersModel
@end
/**
 *  回复内容model
 */
@interface ZZMMDAnswersModel : JSONModel

@property (nonatomic, strong) NSString *answerId;
@property (nonatomic, strong) ZZMMDVideoModel *video;
@property (nonatomic, strong) NSString *version;//1旧么么答 2新么么答
@property (nonatomic, assign) BOOL can_re_answer;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *created_at_text;
@property (nonatomic, strong) NSString *loc_name;//视频的地点
@property (nonatomic, strong) NSString *content;//回答么么哒后发布的心情
@property (nonatomic, assign) float loca_name_height;//发布么么哒,回复
@end

@protocol ZZMMDModel
@end
@interface ZZMMDModel : JSONModel

@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) ZZUser *from;//发起问题的人
@property (nonatomic, strong) ZZUser *to;//回答问题的人
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSMutableArray<ZZMemedaTopicModel> *groups;//标签
@property (nonatomic, strong) NSMutableArray<ZZMMDAnswersModel> *answers;//回答
@property (nonatomic, assign) CGFloat total_price;
@property (nonatomic, assign) CGFloat to_price;//扣除佣金后的价钱
@property (nonatomic, assign) NSInteger browser_count;//浏览数
@property (nonatomic, assign) NSInteger reply_count;//回复数
@property (nonatomic, assign) NSInteger like_count;//点赞数
@property (nonatomic, assign) NSInteger tip_count;//打赏数
@property (nonatomic, strong) NSString *status;//paying,wait_answer,answered,expired
@property (nonatomic, assign) BOOL is_anonymous;//是否是匿名
@property (nonatomic, strong) NSString *status_text;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *created_at_text;
@property (nonatomic, assign) BOOL can_del;//是否可以删除
@property (nonatomic, strong) NSString *del_msg;//删除提示语
@property (nonatomic, strong) NSString *expired_at;//么么答过期时间
@property (nonatomic, strong) NSString *expired_at_text;//私信红包过期时间
@property (nonatomic, strong) NSString *answer_at_text;//私信
@property (assign, nonatomic) BOOL need_yj;//true代表这单有抽用
@property (assign, nonatomic) double yj_price;//佣金
@property (assign, nonatomic) NSInteger content_check_status;//1:正常  2:涉黄涉政

@end

/**
 *  么么答model
 */
@interface ZZMemedaModel : JSONModel

@property (nonatomic, assign) BOOL like_status;//是否点赞了
@property (nonatomic, assign) BOOL can_see_answer;//答案是否可以看到
@property (nonatomic, strong) ZZMMDModel *mmd;
@property (nonatomic, strong) NSString *sort_value;
@property (nonatomic, strong) NSString *sort_value1;
@property (nonatomic, strong) NSString *sort_value2;
@property (nonatomic, strong) NSMutableArray<ZZMMDTipsModel> *mmd_tips;//悬赏榜（3个人）

/**
 *  我的么么答列表
 *
 *  @param param query_type://"from" 我问，"to" 我答，"seen" 我看 sort_value://最有一个sort_value
 *  @param next  回调
 */
- (void)getUserMemedaList:(NSDictionary *)param next:(requestCallback)next;

/**
 *  个人详情页－动态
 *
 *  @param param sort_value://最后一个sort_value
 *  @param next  回调
 */
- (void)getDynamicList:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next;

/**
 *  分享后回调
 *
 *  @param param 分享后返回的值
 *  @param mid   么么答id
 *  @param next  回调
 */
- (void)shareCallBack:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next;

/**
 *  获取某个么么答详情
 *
 *  @param mid  么么答id
 *  @param next 回调
 */
+ (void)getMemedaDetaiWithMid:(NSString *)mid next:(requestCallback)next;

/**
 *  么么答－付款
 *
 *  @param param channel://wallet alipay wx
 *  @param mid   么么答id
 *  @param next  回调
 */
- (void)payMemedaWithParam:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next;

/**
 *  么么答－打赏
 *
 *  @param param tip_price://打赏金额 浮点数 channel://付款渠道 wallet alipay wx
 *  @param mid   么么答id
 *  @param next  回调
 */
- (void)dashangMememdaWithParam:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next;

/**
 *  新增问题/api/mmd/to/:uid/add
 *
 *  @param param content//内容 字符串 groups://标签id的数组 数组 如： [{"id":"56ca154c6ae1450848c76375"}]                                         
                 total_price://金额 浮点数
 *  @param uid   uid
 *  @param next  回调
 */
- (void)addMemedaWithParam:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next;

/**
 *  么么答－回答问题
 *
 *  @param param    {
                    "video":{
                                "cover_url":"/999.png",//封面图片
                                "video_url":"/2.mov"
                            }
                    }
 *  @param mid   么么答id
 *  @param next  回调
 */
- (void)answerMemedaParam:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next;

/**
 *  么么答－重新录制么么答
 *
 *  @param param    {
                        "video":{
                                    "cover_url":"/999.png",//封面图片
                                    "video_url":"/2.mov"
                                }
                    }
 *  @param mid   么么答id
 *  @param next  回调
 */
- (void)updateAnswerMemedaParam:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next;

/**
 *  么么答－评论
 *
 *  @param param content:评论内容  reply_which_reply:回复id
 *  @param mid   么么答id
 *  @param next  回调
 */
- (void)commentMememdaParam:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next;

/**
 *  获取某个么么答的评论
 *
 *  @param param 分页： sort_value
 *  @param next  回调
 */
+ (void)getMemedaCommentList:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next;

/**
 *  删除某个么么答的某一条评论
 *
 *  @param mid     么么答id
 *  @param replyId 回复的消息id
 *  @param next    回调
 */
- (void)deleteMemedaComment:(NSString *)mid replyId:(NSString *)replyId next:(requestCallback)next;

/**
 *  点赞么么答
 *
 *  @param model
 *  @param next  回调
 */
+ (void)zanMemeda:(ZZMMDModel *)model next:(requestCallback)next;

/**
 *  取消点赞么么答
 *
 *  @param model
 *  @param next  回调
 */
+ (void)unzanMemeda:(ZZMMDModel *)model next:(requestCallback)next;

/**
 *  获取某个人热门的么么答
 *
 *  @param mid  么么答id
 *  @param next 回调
 */
- (void)getHotMemedaUid:(NSString *)uid next:(requestCallback)next;

#pragma mark - 发现

/**
 *  发现－最新么么答
 *
 *  @param param type:"latest" 分页传：sort_value
 *  @param next  回调
 */
- (void)getFindNewMemeda:(NSDictionary *)param next:(requestCallback)next;

/**
 *  发现－最新么么答 (需要登录)
 *
 *  @param param type:"latest" 分页传：sort_value
 *  @param next  回调
 */
- (void)getFindNewMemedaNeedLogin:(NSDictionary *)param next:(requestCallback)next;

/**
 *  发现－热门么么答
 *
 *  @param param type:"hot"
 *  @param next  分页传： sort_value1 和 sort_value2
 */
- (void)getFindHotMemeda:(NSDictionary *)param next:(requestCallback)next;

/**
 *  发现－热门么么答
 *
 *  @param param type:"hot"
 *  @param next  分页传： sort_value1 和 sort_value2
 */
- (void)getFindHotMemedaNeedLogin:(NSDictionary *)param next:(requestCallback)next;

+ (void)deleteMemeda:(NSString *)mid next:(requestCallback)next;

@end
