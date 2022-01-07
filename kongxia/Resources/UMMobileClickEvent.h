//
//  UMMobileClickEvent.h
//  zuwome
//
//  Created by angBiu on 16/7/8.
//  Copyright © 2016年 zz. All rights reserved.
//

#ifndef UMMobileClickEvent_h
#define UMMobileClickEvent_h

/**
 *  友盟自定义事件统计
 *
 *  @return 统计事件字符串
 */
#define Event_go_user_detail                    @"go_user_detail"   //查看用户详情
#define Event_click_chat_kefu                   @"click_chat_kefu"  //点击聊天客服
#define Event_pay_deposit_success               @"pay_deposit_success"//订金付款成功
#define Event_click_home_tab                    @"click_home_tab"   //点击首页tab
#define Event_click_chat_tab                    @"click_chat_tab"   //点击聊天tab
#define Event_click_me_tab                      @"click_me_tab"     //点击我tab
#define Event_click_me_setting                  @"click_me_setting" //点击我页面的设置
#define Event_click_me_icon                     @"click_me_icon"    //点击我页面的头像
#define Event_click_me_order_ing                @"click_me_order_ing"//点击我页面的进行中订单
#define Event_click_me_order_commenting         @"click_me_order_commenting"//点击我页面的订单待评价
#define Event_click_me_order_completed          @"click_me_order_completed"//点击我页面的订单已结束
#define Event_click_me_money                    @"click_me_money"   //点击我页面的钱包
#define Event_click_me_realname                 @"click_me_realname"//点击我页面的实名认证
#define Event_click_me_rent                     @"click_me_rent"    //点击我页面的我要出租
#define Event_click_money_transfer              @"click_money_transfer"//点击提现
#define Event_click_money_recharge              @"click_money_recharge"//点击充值
#define Event_click_realname_confirm            @"click_realname_confirm"//点击实名认证提交
#define Event_click_home_choose_city            @"click_home_choose_city"//点击选择城市
#define Event_click_home_search                 @"click_home_search"//点击筛选
#define Event_search_man                        @"search_man"//查询男
#define Event_search_woman                      @"search_woman"//搜索女
#define Event_search_account                    @"search_account"//用户名查询
#define Event_add_order                         @"add_order"//下单
#define Event_chat_order                        @"chat_order"//订单聊天
#define Event_cancel_order                      @"cancel_order"//取消订单
#define Event_modify_order                      @"modify_order"//修改订单
#define Event_refuse_order                      @"refuse_order"//拒绝订单
#define Event_accept_order                      @"accept_order"//接受订单
#define Event_phone_order                       @"phone_order"//拨打电话
#define Event_refund_order                      @"refund_order"//申请退款
#define Event_refund_yes_order                  @"refund_yes_order"//同意退款
#define Event_refund_no_order                   @"refund_no_order"//不同意退款
#define Event_comment_order                     @"comment_order"//评价订单
#define Event_from_click_met_order              @"from_click_met_order"//男方点击已见面
#define Event_to_click_met_order                @"to_click_met_order"//女方点击已见面
#define Event_click_user_detail_more            @"click_user_detail_more"//点击用户详情上面的more按钮
#define Event_click_report                      @"click_report"//点击举报按钮
#define Event_click_order_detail_more           @"click_order_detail_more"//点击帖子详情上面的more按钮
#define Event_click_add_to_blacklist            @"click_add_to_blacklist"//点击拉黑按钮
#define Event_click_change_password             @"click_change_password"//点击设置－修改密码
#define Event_click_shield_phone_contact        @"click_shield_phone_contact"//点击屏蔽手机联系人
#define Event_click_about                       @"click_about"//点击设置－关于
#define Event_click_logout                      @"click_logout"//点击设置－退出登录
#define Event_pay_order                         @"pay_order"//去付余款
#define Event_share_to_qq                       @"share_to_qq"//分享到qq
#define Event_share_to_wechat                   @"share_to_wechat"//分享到微信
#define Event_share_to_friendcircle             @"share_to_friendcircle"//分享到朋友圈
#define Event_share_to_weibo                    @"share_to_weibo"//分享到微博
#define Event_chuzu_apply                       @"chuzu_apply"//出租提交申请
#define Event_chuzu_down                        @"chuzu_down"//出租用户点下架
#define Event_chuzu_up                          @"chuzu_up"//出租用户点上架
#define Event_chuzu_share_perfect               @"chuzu_share_perfect"//申请出租后分享页完善资料
#define Event_chuzu_share_cancel                @"chuzu_share_cancel"//申请出租后分享页右上角关闭
#define Event_search_price                      @"search_price"//搜索时薪
#define Event_search_time                       @"search_time"//搜索档期
#define Event_click_hot_mmd                     @"click_hot_mmd"//点击热门问答
#define Event_click_latest_mmd                  @"click_latest_mmd"//点击最新问答
#define Event_click_hot_user                    @"click_hot_user"//点击红人榜单
#define Event_click_system_message              @"click_system_message"//点击系统消息
#define Event_click_dynamic_message             @"click_dynamic_message"//点击动态通知
#define Event_click_dynamic_self                @"click_dynamic_self"//点击我的动态
#define Event_click_dynamic_following           @"click_dynamic_following"//点击关注人的动态
#define Event_click_zhichikefu                  @"click_zhichikefu"//点击智齿客服
#define Event_user_detail_follow                @"user_detail_follow"//点击个人详情页的关注
#define Event_user_detail_info_tab              @"user_detail_info_tab"//点击个人详情页的资料tab
#define Event_user_detail_mmd_tab               @"user_detail_mmd_tab"//点击个人详情页的么么答tab
#define Event_user_detail_following_tab         @"user_detail_following_tab"//点击个人详情页的关注tab
#define Event_user_detail_follower_tab          @"user_detail_follower_tab"//点击个人详情页的粉丝tab
#define Event_user_detail_chat                  @"user_detail_chat"//点击个人详情页的聊天按钮
#define Event_user_detail_add_mmd               @"user_detail_add_mmd"//点击个人详情页的向TA提问
#define Event_user_detail_add_order             @"user_detail_add_order"//点击个人详情页的马上预约
#define Event_my_mmd_ask                        @"my_mmd_ask"//点击我问的么么答
#define Event_my_mmd_answer                     @"my_mmd_answer"//点击我答的么么答
#define Event_my_mmd_seen                       @"my_mmd_seen"//点击我看的么么答
#define Event_click_discovery_tab               @"click_discovery_tab"//发现tab
#define Event_mmd_detail_tip                    @"mmd_detail_tip"//么么答详情的打赏
#define Event_click_me_mmd                      @"click_me_mmd"//点击我的么么答
#define Event_click_mmm_detail_more             @"click_mmm_detail_more"//点击么么答详情右上角的more按钮
#define Event_click_mmm_detail_play_tip         @"click_mmm_detail_play_tip"//么么答打赏观看
#define Event_click_mmm_detail_play_share       @"click_mmm_detail_play_share"//么么答分享免费看
#define Event_click_message_comment             @"click_message_comment"//点击消息列表页页评论
#define Event_click_message_notification        @"click_message_notification"//点击消息列表页通知
#define Event_click_video_record                @"click_video_record"//点击视频录制
#define Event_click_video_re_record             @"click_video_re_record"//点击视频重新录制
#define Event_click_video_choose_cover          @"click_video_choose_cover"//选择视频封面
#define Event_click_setting_sucure              @"click_setting_sucure"//点击设置页账户和安全
#define Event_click_setting_notification        @"click_setting_notification"//点击设置页新消息提醒
#define Event_click_setting_privacy             @"click_setting_privacy"//点击设置页隐私
#define Event_click_setting_currency            @"click_setting_currency"//点击设置页通用
#define Event_click_setting_helpAndFeedback     @"click_setting_helpAndFeedback"//点击设置页帮助与反馈
#define Event_click_setting_protocol            @"click_setting_protocol"//么点击设置页免责声明
#define Event_click_setting_comment             @"click_setting_comment"//点击设置页应用评分
#define Event_click_setting_clear               @"click_setting_clear"//点击设置页清除缓存
#define Event_click_bind_account                @"click_bind_account"//点击账号绑定
#define Event_click_notification_private_on     @"click_notification_private_on"//开启新消息提醒私信
#define Event_click_notification_private_off    @"click_notification_private_off"//关闭新消息提醒私信
#define Event_click_notification_attent_on      @"click_notification_attent_on"//开启新消息提醒关注
#define Event_click_notification_attent_off     @"click_notification_attent_off"//关闭新消息提醒关注
#define Event_click_notification_comment_on     @"click_notification_comment_on"//开启新消息提醒评论
#define Event_click_notification_comment_off    @"click_notification_comment_off"//关闭新消息提醒评论
#define Event_click_notification_zan_on         @"click_notification_zan_on"//开启新消息提醒点赞
#define Event_click_notification_zan_off        @"click_notification_zan_off"//关闭新消息提醒点赞
#define Event_click_notification_tip_on         @"click_notification_tip_on"//开启新消息提醒打赏
#define Event_click_notification_tip_off        @"click_notification_tip_off"//关闭新消息提醒打赏
#define Event_click_notification_redpacket_on   @"click_notification_redpacket_on"//开启新消息提醒红包消息
#define Event_click_notification_redpacket_off  @"click_notification_redpacket_off"//关闭新消息提醒红包消息
#define Event_click_notification_weiChat_pay   @"click_notification_weiChat_pay"//微信公众号充值从app后台点击推送
#define Event_click_notification_sysmsg_on   @"click_notification_sysmsg_on"//开启新消息提醒系统消息
#define Event_click_notification_sysmsg_off  @"click_notification_sysmsg_off"//关闭新消息提醒系统消息
#define Event_click_notification_mmd_following_on         @"click_notification_mmd_following_on"//开启新消息提醒么么答推送
#define Event_click_notification_mmd_following_off        @"click_notification_mmd_following_off"//关闭新消息提醒么么答推送
#define Event_click_notification_sound_on         @"click_notification_sound_on"//开启新消息声音提醒
#define Event_click_notification_sound_off        @"click_notification_sound_off"//关闭新消息声音提醒
#define Event_click_notification_shake_on         @"click_notification_shake_on"//开启新消息振动提醒
#define Event_click_notification_shake_off        @"click_notification_shake_off"//关闭新消息振动提醒
#define Event_click_notification_arredpacket_on         @"click_notification_arredpacket_on"//开启新消息提醒派发ar红包
#define Event_click_notification_arredpacket_off        @"click_notification_arredpacket_off"//关闭新消息提醒派发ar红包
#define Event_click_notification_sk_on          @"click_notification_sk_on"//开启新消息提醒发布瞬间
#define Event_click_notification_sk_off         @"click_notification_sk_off"//关闭新消息提醒发布瞬间
#define Event_click_notification_nopush_on          @"click_notification_nopush_on"//开启消息免打扰
#define Event_click_notification_nopush_off         @"click_notification_nopush_off"//关闭消息免打扰
#define Event_click_notification_sayhi_on          @"click_notification_sayhi_on"//开启打招呼推送
#define Event_click_notification_sayhi_off         @"click_notification_sayhi_off"//关闭打招呼推送
#define Event_click_notification_pushhidename_on   @"click_notification_pushhidename_on"//开启隐藏昵称
#define Event_click_notification_pushhidename_off  @"click_notification_pushhidename_off"//关闭隐藏昵称
#define Event_click_notification_smspush_on         @"click_notification_smspush_on"//开启短信通知
#define Event_click_notification_smspush_off        @"click_notification_smspush_off"//关闭短信通知
#define Event_click_privacy_contact_on          @"click_privacy_contact_on"//开启屏蔽手机联系人
#define Event_click_privacy_contact_off         @"click_privacy_contact_off"//屏蔽手机联系人
#define Event_click_privacy_contact_block       @"click_privacy_contact_block"//手机联系人列表屏蔽
#define Event_click_privacy_contact_unblock     @"click_privacy_contact_unblock"//手机联系人列表不屏蔽
#define Event_click_privacy_black               @"click_privacy_black"//点击设置隐私黑名单管理
#define Event_click_currency_wifi_on            @"click_currency_wifi_on"//开启仅wifi播放
#define Event_click_currency_wifi_off           @"click_currency_wifi_off"//关闭仅wifi播放
#define Event_click_helpAndFeedback_feedback    @"click_helpAndFeedback_feedback"//点击帮助和反馈中的意见反馈
#define Event_click_find_banner                 @"click_find_banner"//点击发现banner
#define Event_click_mmm_detail_ask              @"click_mmm_detail_ask"//点击么么答详情页的向ta提问
#define Event_click_mmd_detai_delete            @"click_mmd_detai_delete"//么么答删除按钮
#define Event_click_choose_countrycode          @"click_choose_countrycode"//国际号码选择
#define Event_click_user_detail_codeshare       @"click_user_detail_codeshare"//个人详情页二维码分享
#define Event_click_user_detail_chuzu_up        @"click_user_detail_chuzu_up"//个人主页的立即上架
#define Event_click_user_detail_chuzu_apply     @"click_user_detail_chuzu_apply"//个人主页的立即出租
#define Event_click_launchad_skip              @"click_launchad_skip"//启动页广告跳过按钮
#define Event_click_activity_right_share        @"click_activity_right_share"//活动界面右上角的分享
#define Event_choose_rent_quickly              @"choose_rent_quickly"//预约时间选择中的尽快选项
#define Event_click_find_record             @"click_find_record"//点击发现页的录制按钮
#define Event_click_player_attent           @"click_player_attent"//点击播放页的关注按钮
#define Event_click_player_comment          @"click_player_comment"//点击播放页的评论一发按钮
#define Event_click_player_zan              @"click_player_zan"//点击播放页的点赞按钮
#define Event_click_player_packet           @"click_player_packet"//点击播放页的红包按钮
#define Event_click_player_more             @"click_player_more"//点击播放页的更多按钮
#define Event_click_player_cancel           @"click_player_cancel"//点击播放页的取消按钮
#define Event_click_player_doubleclick      @"click_player_doubleclick"//播放页双击点赞事件
#define Event_click_menu_tab      @"click_menu_tab"//点击中间菜单tab
#define Event_click_menu_scan      @"click_menu_scan"//点击菜单栏扫一扫
#define Event_click_menu_record      @"click_menu_record"//点击菜单栏发瞬间
#define Event_click_menu_arpacket      @"click_menu_arpacket"//点击菜单栏发红包
#define Event_click_record_topic      @"click_record_topic"//点击录制界面添加话题
#define Event_click_record_topic_location      @"click_record_topic_location"//点击录制界面添加地理位置

#define Event_click_record_filter      @"click_record_filter"//点击录制界面选择滤镜
#define Event_click_record_sticker      @"click_record_sticker"//点击录制界面贴纸
#define Event_click_record_changecamera      @"click_record_changecamera"//点击录制界面镜头切换
#define Event_click_record_down      @"click_record_down"//点击录制界面下载
#define Event_click_record_delete      @"click_record_delete"//点击录制界面删除
#define Event_click_record_publish      @"click_record_publish"//点击录制界面发布
#define Event_click_arpacket_hide      @"click_arpacket_hide"//点击ar红包的藏红包按钮
#define Event_click_arpacket_get      @"click_arpacket_get"//点击ar红包的领红包按钮
#define Event_click_arpacket_raiders      @"click_arpacket_raiders"//点击ar红包的攻略按钮
#define Event_click_arpacket_mypacket      @"click_arpacket_mypacket"//点击ar红包的我的红包
#define Event_click_arpacket_mypacket_findtab      @"click_arpacket_mypacket_findtab"//点击我的红包找到的tab
#define Event_click_arpacket_mypacket_hidetab      @"click_arpacket_mypacket_hidetab"//点击我的红包藏起的tab
#define Event_click_arpacket_mypacket_get      @"click_arpacket_mypacket_get"//点击我的红包找到类别空白时的获取红包
#define Event_click_arpacket_mypacket_hide      @"click_arpacket_mypacket_hide"//点击我的红包藏起类别空白时的藏红包
#define Event_click_arpacket_mypacket_share      @"click_arpacket_mypacket_share"//点击我的红包藏起类别空白时的分享红包
#define Event_click_arpacket_hide_rule      @"click_arpacket_hide_rule"//点击藏红包界面的规则按钮
#define Event_click_arpacket_hide_changetype      @"click_arpacket_hide_changetype"//点击藏红包界面的切换支付方式按钮
#define Event_click_arpacket_hide_hide      @"click_arpacket_hide_hide"//点击藏红包界面的藏红包按钮
#define Event_click_home_systempacket      @"click_home_systempacket"//点击首页系统红包按钮
#define Event_click_home_nearpacket      @"click_home_nearpacket"//点击首页附近红包按钮
#define Event_click_userpage_packet      @"click_userpage_packet"//点击个人页红包按钮
#define Event_rent_choose_skill         @"rent_choose_skill"//下单选择任一主题
#define Event_rent_choose_time          @"rent_choose_time"//下单选择开始时间
#define Event_rent_choose_hours         @"rent_choose_hours"//下单选择时长
#define Event_rent_choose_location      @"rent_choose_location"//下单选择公共场合
#define Event_click_ask_private         @"click_ask_private"//点击私信提问
#define Event_click_ask_public          @"click_ask_public"//点击视频问答
#define Event_click_ask_ask             @"click_ask_ask"//点击他的么么答页红包提问
#define Event_click_record_record_memeda        @"click_record_record_memeda"//点击录制界面开始录制么么答
#define Event_click_record_record_sk            @"click_record_record_sk"//点击录制界面开始录制时刻
#define Event_click_record_publish_memda        @"click_record_publish_memda"//点击发布么么答
#define Event_click_record_publish_sk           @"click_record_publish_sk"//点击发布时刻
#define Event_click_home_recommend_video        @"click_home_recommend_video"//点击首页推荐视频
#define Event_click_home_recommend_video_more   @"click_home_recommend_video_more"//点击首页推荐视频更多
#define Event_click_login_login        @"click_login_login"//点击登录界面的登录按钮
#define Event_click_login_wx   @"click_login_wx"//点击登录界面的微信登录按钮
#define Event_click_login_wb        @"click_login_wb"//点击登录界面的微博登录按钮
#define Event_click_login_qq   @"click_login_qq"//点击登录界面的QQ登录按钮
#define Event_click_login_register   @"click_login_register"//点击登录界面的注册按钮
#define Event_click_login_codelogin        @"click_login_codelogin"//点击登录界面的验证码登录按钮
#define Event_click_login_forget   @"click_login_forget"//点击登录界面的忘记密码按钮
#define Event_click_register_getcode        @"click_register_getcode"//点击注册界面的发送按钮
#define Event_click_register_next   @"click_register_next"//点击注册界面的下一步按钮
#define Event_click_code_next        @"click_code_next"//点击设置密码的下一步按钮
#define Event_click_scan_starts   @"click_scan_starts"//点击人脸识别开始扫脸界面
#define Event_click_infomation_uploadhead        @"click_infomation_uploadhead"//点击完善资料上传图片按钮


/** 3.5.0 积分*/
#define Event_click_user_my_sign_in @"click_user_my_sign_in" //右上角签到

#define Event_click_myIntegral @"click_myIntegral" //我的积分
#define Event_click_myIntegral_exChange @"click_myIntegral_exChange"//积分兑换
#define Event_click_myIntegral_sign_in @"click_myIntegral_sign_in"//我的积分界面_签到
#define Event_click_dayTask_share @"click_dayTask_share"// 我的积分任务_分享快照
#define Event_click_dayTask_comments @"click_dayTask_comments"//我的积分任务_评论视频
#define Event_click_dayTask_giveLike @"click_dayTask_giveLike" //我的积分任务_点赞视频
#define Event_click_dayTask_lookWeiXin @"click_dayTask_lookWeiXin" //我的积分任务_查看微信号
#define Event_click_dayTask_invitation @"click_dayTask_invitation"//我的积分任务_线下邀约
#define Event_click_newTask_uploadHeaderImg @"click_newTask_uploadHeaderImg"//我的积分任务_上传真实头像
#define Event_click_newTask_publish @"click_newTask_publish"//我的积分任务_发布视频
#define Event_click_newTask_binding @"click_newTask_binding"//我的积分任务_绑定微博
#define Event_click_newTask_attention @"click_newTask_attention"//我的积分_关注微信公众号
#define Event_click_newTask_realName @"click_newTask_realName"//我的积分_实名认证
#define Event_click_integralExChange_100 @"click_integralExChange_100"//积分兑换_100积分
#define Event_click_integralExChange_300 @"click_integralExChange_300"//积分兑换_300积分
#define Event_click_integralExChange_1000 @"click_integralExChange_1000"//积分兑换_1000积分
#define Event_click_integralExChange_2000 @"click_integralExChange_2000"//积分兑换2000
#define Event_click_integralExChange_5000 @"click_integralExChange_5000"//积分兑换5000
#define Event_click_integralExChange_customNumber @"click_integralExChange_customNumber"//积分兑换自定义数量
#define Event_click_choose_bank @"click_choose_bank"//银行卡选择银行卡
#define Event_click_withdraw_next @"click_withdraw_next"//我的钱包提现下一步
#define Event_click_withdraw_sure @"click_withdraw_sure"// 银行卡确认提现





#define Event_click_infomation_complete   @"click_infomation_complete"//点击完善资料完成按钮
#define Event_click_codelogin_getcode        @"click_codelogin_getcode"//点击验证码登录界面的发送按钮
#define Event_click_codelogin_login         @"click_codelogin_login"//点击验证码登录界面的验证并登录按钮
#define Event_click_home_ad                 @"click_home_ad"//点击首页广告
#define Event_click_home_ad_cancel          @"click_home_ad_cancel"//点击首页广告x按钮
#define Event_click_home_refresh_cancel     @"click_home_refresh_cancel"//点击首页新鲜x按钮
#define Event_click_userpage_wx_copy        @"click_userpage_wx_copy"//点击个人页微信复制
#define Event_click_userpage_wx_check       @"click_userpage_wx_check"//点击个人页微信查看
#define Event_click_userpage_IDPhoto_check  @"click_userpage_IDPhoto_check"//点击个人页证件照查看
#define Event_click_userpage_wx_buy         @"click_userpage_wx_buy"//点击个人页微信购买
#define Event_click_userpage_IDPhoto_buy    @"click_userpage_IDPhoto_buy"//点击个人页证件照购买
#define Event_click_chat_wx                 @"click_chat_wx"//点击聊天窗口查看微信
#define Event_click_usercenter_wx           @"click_usercenter_wx"//点击我的微信
#define Event_click_usercenter_video        @"click_usercenter_video"//点击我的视频
#define Event_click_changepwd               @"click_changepwd"//点击修改密码
#define Event_click_changephone             @"click_changephone"//点击更换手机号
#define Event_click_bind_qq                 @"click_bind_qq"//点击QQ绑定
#define Event_click_bind_wx                 @"click_bind_wx"//点击微信绑定
#define Event_click_bind_wb                 @"click_bind_wb"//点击新浪微博绑定
#define Event_click_setting_security        @"click_setting_security"//点击设置页行程安全
#define Event_click_edit_IDPhoto            @"click_edit_IDPhoto"//点击编辑资料上传证件照
#define Event_click_edit_uploadimage        @"click_edit_uploadimage"//点击编辑资料上传照片
#define Event_click_edit_name               @"click_edit_name"//点击编辑资料用户名
#define Event_click_edit_age                @"click_edit_age"//点击编辑资料年龄
#define Event_click_edit_location           @"click_edit_location"//点击编辑资料常住地
#define Event_click_edit_height             @"click_edit_height"//点击编辑资料身高
#define Event_click_edit_weight             @"click_edit_weight"//点击编辑资料体重
#define Event_click_edit_work               @"click_edit_work"//点击编辑资料职业
#define Event_click_edit_introduce          @"click_edit_introduce"//点击编辑资料自我介绍
#define Event_click_edit_personlabel        @"click_edit_personlabel"//点击编辑资料个人标签
#define Event_click_edit_interest           @"click_edit_interest"//点击编辑资料兴趣爱好
#define Event_click_edit_videoask           @"click_edit_videoask"//点击编辑资料达人问答
#define Event_click_record_record           @"click_record_record"//点击录制视频录制按钮
#define Event_click_record_submit           @"click_record_submit"//点击录制视频的提交按钮
#define Event_click_player_wx               @"click_player_wx"//点击播放页查看微信按钮
#define Event_click_publish                 @"click_publish"//闪租发任务
#define Event_click_snatch_task             @"click_snatch_task"//抢任务
#define Event_click_Nav_shanzu              @"click_Nav_shanzu"//点击导航栏上的闪租
#define Event_click_Apply_talent            @"click_Apply_talent"//点击录制达人视频（闪租页面成为达人）
#define Event_click_Video_see_wx            @"click_Video_see_wx"//播放视频时查看微信
#define Event_click_detail_Apply_talent     @"click_detail_Apply_talent"//个人详情页录制达人视频
#define Event_click_Record_video            @"click_Record_video"//达人视频页，第一次点 + 号录制

#define Event_click_FastChat                @"click_FastChat"//主页-推荐-闪聊点击
#define Event_click_Open_FastChat           @"click_Open_FastChat"//申请开通闪聊
#define Event_click_other_Detail            @"click_other_Detail"//闪聊列表-达人
#define Event_click_other_Detail_FastCaht   @"click_other_Detail_FastCaht"//闪聊列表-达人-1v1视频
#define Event_click_other_Detail_Rent       @"click_other_Detail_Rent"//闪聊列表-达人-马上预约
#define Event_click_FastChat_Set_Switch     @"click_FastChat_Set_Switch"//闪聊-设置-开启闪聊开关
#define Event_click_PayChat_Set_Switch     @"click_PayChat_Set_Switch"//闪聊-设置-私聊收费开关
#define Event_click_PayChat_Set_Switch_ChuZhu     @"Event_click_PayChat_Set_Switch_ChuZhu"//闪聊-设置-私聊收费开关

#define Event_click_FastChat_CallRecords    @"click_FastChat_CallRecords"//闪聊-通话记录
#define Event_click_FastChat_VideoConnect   @"click_FastChat_VideoConnect"//闪聊-视频拨打
#define Event_click_FastChat_VideoCompleted @"click_FastChat_VideoCompleted"//闪聊列表-视频拨打-立即视频
#define Event_click_FastChat_VideoRefused   @"click_FastChat_VideoRefused"//闪聊列表-视频拨打-拒绝视频
#define Event_click_FastChat_TopUp          @"click_FastChat_TopUp"//闪聊列表-拨打视频-么币不足充值
#define Event_click_OneToOneChat_TopUp          @"click_OneToOneChatChat_TopUp"//1V1视频-拨打视频-么币不足充值

#define Event_click_Video_TopUp             @"click_Video_TopUp"//视频中，点击充值按钮
#define Event_click_Video_Appraise          @"click_Video_Appraise"//视频评价-匿名评价按钮点击
#define Event_click_Video_Close_Lens        @"click_Video_Close_Lens"//视频等待页面、连麦页面、关闭镜头操作
#define Event_click_Video_Report            @"click_Video_Report"//1V1举报按钮
#define Event_click_HomePage_Small_Banner   @"click_HomePage_Small_Banner"//点击主页-推荐页-小banner
#define Event_click_ServiceCharge_Open      @"click_ServiceCharge_Open"//点击平台审核服务费-开通按钮
#define Event_click_MeBi_TopUp              @"click_MeBi_TopUp"//么币-充值按钮
#define Event_click_User_Video_Cancel       @"click_User_Video_Cancel"//用户点击连麦等待界面-取消按钮
#define Event_click_Other_Video_Through     @"click_Other_Video_Through"//达人点击连麦等待界面-接通按钮
#define Event_click_Other_Video_Refused     @"click_Other_Video_Refused"//达人点击连麦等待界面-拒接按钮

#endif /* UMMobileClickEvent_h */
