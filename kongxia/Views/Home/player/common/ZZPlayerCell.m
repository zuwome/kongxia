//
//  ZZPlayerCell.m
//  zuwome
//
//  Created by angBiu on 2016/12/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZPlayerCell.h"
#import "ZZReportViewController.h"

#import "ZZPlayerCommentCell.h"
#import "ZZMenuView.h"
#import "ZZReportModel.h"
#import "ZZPlayerBottomContentView.h"//话题
#import "ZZPlayerHeaderView.h"
#import "ZZPlayerCellHeaderView.h"
#import "ZZPlayerHelper.h"
#import "ZZChatBaseModel.h"

@interface ZZPlayerCell ()<TTTAttributedLabelDelegate>

@property (nonatomic, copy) NSString *readString;
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, strong) ZZCommentModel *currentModel;
@property (nonatomic, strong) ZZMenuView *menuView;
@property (nonatomic, assign) BOOL canLoadMore;
@property (nonatomic, assign) CGFloat cellCurrentHeight;
@property (nonatomic, assign) BOOL isFullScreen;//是否全屏显示

@property (nonatomic, strong)ZZPlayerBottomContentView* topicView;
@property (nonatomic, strong)UIVisualEffectView *effectview;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic,strong)  ZZPlayerCellHeaderView *currentHeaderView;
@property (nonatomic,assign) CGFloat topicHeight;

@end

@implementation ZZPlayerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cellCurrentHeight = frame.size.height;
//        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.tableView];
        [self setUIConstraint];
    }
    return self;
}

//短视频的处理方式
- (void)setIsLongVideo:(BOOL)isLongVideo {
    _isLongVideo = isLongVideo;
}

- (void)setData:(ZZFindVideoModel *)model {
    if (model.sk.id) {
        self.skDataModel = model.sk;
    }
    else {
        self.mMDDataModel = model.mmd;
    }
}

- (void)setChatBaseModel:(ZZChatBaseModel *)chatBaseModel {
    if (_chatBaseModel == chatBaseModel) {
        return;
    }
    
    _chatBaseModel = chatBaseModel;
    if (![_chatBaseModel.message.content isKindOfClass: [RCSightMessage class]]) {
        return;
    }
    
    RCSightMessage *message = (RCSightMessage *)_chatBaseModel.message.content;
    
    
    _chatBaseModel = chatBaseModel;
    _isMMD = NO;
    _imgView.contentMode =  UIViewContentModeScaleAspectFill ;
    
//    if (!isNullString(message.localPath)) {
//
//    }
//    else {
        if (!isNullString(message.remoteUrl)) {
            self.playerUrlStr = message.remoteUrl;
        }
//    }
    
    _imgView.image = message.thumbnailImage;
    

   _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT);
   _effectview.hidden = YES;
   _imgView.contentMode = UIViewContentModeScaleAspectFill;

   self.playerTopicView.hidden = YES;
}

- (void)setSkDataModel:(ZZSKModel *)skDataModel {
    if (_skDataModel == skDataModel) {
        return;
    }
    _skDataModel = skDataModel;
    _isMMD = NO;
    _skId = skDataModel.id;
    _imgView.contentMode =  UIViewContentModeScaleAspectFill ;
    
    self.isDarenVideo = [ZZPlayerHelper whenWatchDaRenVideoBacKIsFillScreen:self withModel:skDataModel];
    if (self.isBaseVideo&&self.isDarenVideo ==NO) {
        _imgView.contentMode =UIViewContentModeScaleAspectFit;
        self.tableView.backgroundColor = HEXCOLOR(0x010101);
        self.contentView.backgroundColor = HEXCOLOR(0x010101);

    }
    self.playerUrlStr = skDataModel.video.video_url;
    WS(weakSelf);
    __block CGFloat currentImageWidth ;
    __block CGFloat currentImageHeight ;

    [_imgView sd_setImageWithURL:[NSURL URLWithString:skDataModel.video.cover_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        currentImageWidth = image.size.width > 0 ?: SCREEN_WIDTH;
        currentImageHeight = (SCREEN_WIDTH * image.size.height) / currentImageWidth;
        if (weakSelf.isBaseVideo && self.isDarenVideo == NO) {
            [weakSelf.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(weakSelf.tableHeaderView);
                make.width.mas_equalTo(currentImageWidth);
                make.height.mas_equalTo(currentImageHeight);
            }];
        }
    }];
    
    if (self.isBaseVideo) {
        if ([skDataModel.user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
            _isMySelf = YES;
        }
        else {
            _isMySelf = NO;
        }
        return;
    }
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT);
    _effectview.hidden = YES;
    _imgView.contentMode = UIViewContentModeScaleAspectFit;

    CGFloat imageWidth = skDataModel.video.width;
    if (imageWidth<=0) {
        imageWidth = currentImageWidth;
        if (imageWidth<=0) {
            imageWidth = 540;//服务端没有返回视频的高度,获取图片的第一帧还是没有  就强制为540*960
        }
    }

    CGFloat   imageHeight =ceilf((SCREEN_WIDTH * skDataModel.video.height) / imageWidth);
    if (skDataModel.video.height<=0) {
        if (currentImageHeight<=0) {
            currentImageHeight = 960;
        }
       imageHeight =ceilf((SCREEN_WIDTH * currentImageHeight) / imageWidth);
    }
    
    if (imageHeight >= SCREEN_HEIGHT) {
        self.isFullScreen = YES;
        imageHeight = SCREEN_HEIGHT;
        self.isLongVideo = YES;

    }else{
        self.isLongVideo = YES;
        //iPhone X 上面对于短视频增加黑边的导航处理
        if (isIPhoneX) {
            _tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, self.height -NAVIGATIONBAR_HEIGHT);
            if (imageHeight<= SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 55 -SafeAreaBottomHeight) {
                self.isLongVideo = NO;
                _tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, self.height -NAVIGATIONBAR_HEIGHT- 55 -SafeAreaBottomHeight);
            }
            else {
                imageHeight = self.height -NAVIGATIONBAR_HEIGHT;
            }
            _effectview.hidden = NO;
        }
        else{
            if (imageHeight<= SCREEN_HEIGHT - 55) {
                self.isLongVideo = NO;
            }
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height - 55);
        }
        self.isFullScreen = NO;
       
    }
    self.tableHeaderView.height = imageHeight;
    _tableView.tableHeaderView  =  self.tableHeaderView ;
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];

    if (_tableView.tableHeaderView.height>=SCREEN_HEIGHT) {
        _processLineView.frame = CGRectMake(0,SCREEN_HEIGHT - 3, 0, 3);
    }else{
        _processLineView.frame = CGRectMake(0, _tableView.tableHeaderView.height - 2, 0, 2);
    }
 
    _readString = [NSString stringWithFormat:@"%ld人看过",skDataModel.browser_count];
    _timeString = [NSString stringWithFormat:@"%@",skDataModel.created_at_text];
    if ([skDataModel.user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        _isMySelf = YES;
    } else {
        _isMySelf = NO;
    }
    if (self.firstInto) {
        self.firstInto(_isLongVideo);
    }
    self.playerTopicView.hidden = YES;
}
- (void)setMMDDataModel:(ZZMMDModel *)mMDDataModel {
    if (_mMDDataModel == mMDDataModel) {
        return;
    }
    _effectview.hidden = YES;

    _mMDDataModel = mMDDataModel;
    _isMMD = YES;
    _mid = _mMDDataModel.mid;
    ZZMMDAnswersModel *answerModel = _mMDDataModel.answers[0];
    _imgView.contentMode =  UIViewContentModeScaleAspectFill ;
    __block CGFloat currentImageWidth ;
    __block CGFloat currentImageHeight ;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:answerModel.video.cover_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        currentImageWidth  =  image.size.width;
        currentImageHeight =  image.size.height;
        
    }];
    
    CGFloat imageWidth = answerModel.video.width;
    CGFloat  imageHeight = ceilf((SCREEN_WIDTH * answerModel.video.height) / imageWidth);
    
    if (imageWidth<=0) {
        imageWidth = currentImageWidth;
        if (currentImageWidth<=0) {
            imageWidth = 540;
        }
    }
    
    if (answerModel.video.height<=0) {
        if (currentImageHeight<=0) {
            currentImageHeight = 960;
        }
        imageHeight =ceilf((SCREEN_WIDTH * currentImageHeight) / imageWidth);
    }
    self.playerUrlStr = answerModel.video.video_url;
    if (self.isBaseVideo) {
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.offset(0);
        }];
        return;
    }
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT);
    if (imageHeight >= SCREEN_HEIGHT) {
        self.isFullScreen = YES;
        imageHeight = SCREEN_HEIGHT;
        self.isLongVideo = YES;
        
    }else{
        
        self.isLongVideo = YES;
        if (isIPhoneX) {
            _tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, self.height -NAVIGATIONBAR_HEIGHT);
            if (imageHeight<= SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 55 -SafeAreaBottomHeight) {
                self.isLongVideo = NO;
                _tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, self.height -NAVIGATIONBAR_HEIGHT- 55 -SafeAreaBottomHeight);
            }else{
                imageHeight = self.height -NAVIGATIONBAR_HEIGHT;
            }
            _effectview.hidden = NO;
        }else{
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height - 55);
            if (imageHeight<= SCREEN_HEIGHT - 55) {
                self.isLongVideo = NO;
            }
        }
        self.isFullScreen = NO;
        
    }
    
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.equalTo(@(imageHeight));
    }];
    
    self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, imageHeight);
    self.tableView.tableHeaderView = self.tableHeaderView ;
    [_imgView layoutIfNeeded];
    if (_tableView.tableHeaderView.height>=SCREEN_HEIGHT) {
        _processLineView.frame = CGRectMake(0,SCREEN_HEIGHT - 3, 0, 3);
    }else{
        _processLineView.frame = CGRectMake(0, _tableView.tableHeaderView.height - 2, 0, 2);
    }
    if (self.firstInto) {
        self.firstInto(_isLongVideo);
    }
    _readString = [NSString stringWithFormat:@"%ld人看过",(long)_mMDDataModel.browser_count];
    _timeString = [NSString stringWithFormat:@"%@",answerModel.created_at_text];
    
    /***话题**/
    if (!isNullString(mMDDataModel.content) ||mMDDataModel.groups.count>0) {
        NSString *content = mMDDataModel.content;
        if (mMDDataModel.groups.count>0) {
            ZZMemedaTopicModel *topicModel = mMDDataModel.groups[0];
            content = [NSString stringWithFormat:@"%@%@",content,topicModel.content];
        }
        if (!isNullString(content)) {
            float currentPlayerTopicHeight = [ZZUtils heightForCellWithText:content fontSize:15 labelWidth:SCREEN_WIDTH - 30 -37 -5]+20;
            if (currentPlayerTopicHeight<=37+20) {
                currentPlayerTopicHeight = 37+20;
            }
            [self.playerTopicView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(currentPlayerTopicHeight+55+SafeAreaBottomHeight);
            }];
            self.playerTopicView.mmdModel = mMDDataModel;
            self.playerTopicView.hidden = NO;
        }
    }else{
        self.playerTopicView.hidden = YES;
    }
    /***话题**/
    
    
    
    if ([_mMDDataModel.to.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        _isMySelf = YES;
    } else {
        _isMySelf = NO;
    }
}

- (void)setCommentArray:(NSMutableArray *)array contributions:(NSMutableArray *)contributions noMoreData:(BOOL)noMoreData
{
    WeakSelf;
    [self removeMenuView];
    if (array) {
        if (noMoreData) {
            self.tableView.mj_footer = nil;
            _canLoadMore = NO;
        } else {
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
                [weakSelf loadMoreData];
            }];
            _canLoadMore = YES;
        }
        self.commentArray = array;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)loadMoreData
{
    if (_loadMore) {
        _loadMore();
    }
}

- (void)setProcess:(CGFloat)process
{
    CGFloat width = SCREEN_WIDTH * process;
    if (isnan(width)) {
        width = 0;
    }
    if (width == 0) {
        _processLineView.width = 0.1;
    } else {
        _processLineView.width = width;
    }
}

- (void)removeMenuView
{
    [self.menuView removeFromSuperview];
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        static NSString *identifier = @"comment";
        
        ZZPlayerCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZPlayerCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [self setupCell:cell indexPath:indexPath];
        
        return cell;

}

- (void)setupCell:(ZZPlayerCommentCell *)cell indexPath:(NSIndexPath *)indexPath
{
    cell.lineView.hidden = NO;
  
    ZZCommentModel *model = nil;

        if (indexPath.row >= self.commentArray.count) {
            return;
        }
        model = self.commentArray[indexPath.row];

        [cell setData:model];
        if (indexPath.row == self.commentArray.count - 1) {
            cell.lineView.hidden = YES;
        }

    WeakSelf;
    cell.touchHead = ^{
        if (weakSelf.touchHead) {
            weakSelf.touchHead(model.reply.user.uid);
        }
    };
    cell.cellLongPress = ^(UIView *targetView) {
        [weakSelf showMenuInView:targetView indexPath:indexPath];
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf;
    return [tableView fd_heightForCellWithIdentifier:@"comment" cacheByIndexPath:indexPath configuration:^(id cell) {
        [weakSelf setupCell:cell indexPath:indexPath];
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return  30+_topicHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZZPlayerCellHeaderView *headerView = (ZZPlayerCellHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ZZPlayerCellHeaderViewID"];
    headerView.topicModel = _topicModel;
    [headerView setReadLabtitle:_readString andTimeLab:_timeString];
    self.currentHeaderView = headerView;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ZZPlayerHeaderView *footView = (ZZPlayerHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ZZPlayerHeaderViewID"];
        if (_canLoadMore) {
             footView.titleLab.text = @"";
        } else if (self.commentArray.count == 0) {
             footView.titleLab.text = @"快来发表你的看法吧";
        } else {
             footView.titleLab.text =@"我是有底线的";
        }
    return footView;
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeMenuView];
    if (indexPath.row == 0 && self.contributionArray.count != 0) {
        
    } else {
        if (self.contributionArray.count != 0) {
            if (_touchComment) {
                _touchComment(self.commentArray[indexPath.row - 1]);
            }
        } else {
            if (_touchComment) {
                _touchComment(self.commentArray[indexPath.row]);
            }
        }
    }
}

- (void)setTopicModel:(id)topicModel {
    if (_topicModel ==topicModel) {
        return;
    }
    _topicModel = topicModel;
     _topicHeight = 0;
    if ([_topicModel isKindOfClass:[ZZSKModel class]]) {
        ZZSKModel *skModel = (ZZSKModel*)topicModel;
        NSString *content = skModel.content;
        if (skModel.groups.count>0) {
            ZZMemedaTopicModel *topicModel = skModel.groups[0];
            content = [NSString stringWithFormat:@"%@%@",content,topicModel.content];
        }
        if (content ==nil&&skModel.loc_name==nil) {
         return;
        }
        
        if (!isNullString(skModel.loc_name)) {
            _topicHeight = [ZZUtils heightForCellWithText:skModel.loc_name fontSize:17 labelWidth:SCREEN_WIDTH - 30 -37 -5];
            if (_topicHeight<=AdaptedWidth(20)) {
                _topicHeight = 20;
            }
            skModel.loca_name_height = _topicHeight;
            _topicHeight = _topicHeight+15;
        }
        if (isNullString(content)) {
            return;
        }
       _topicHeight = [ZZUtils heightForCellWithText:content fontSize:17 labelWidth:SCREEN_WIDTH - 30 -37 -5]+28+_topicHeight;
    }
    else if ([_topicModel isKindOfClass:[ZZMMDModel class]]){
        ZZMMDModel *mmdModel = (ZZMMDModel *)topicModel;
        if (mmdModel.answers.count<=0) {
            return;
        }
        ZZMMDAnswersModel *answersModel = (ZZMMDAnswersModel *)mmdModel.answers[0];

        if (!isNullString(answersModel.loc_name)) {
            _topicHeight = [ZZUtils heightForCellWithText:answersModel.loc_name fontSize:17 labelWidth:SCREEN_WIDTH - 30 -37 -5];
            if (_topicHeight<=AdaptedWidth(20)) {
                _topicHeight = _topicHeight+8;
            }
            answersModel.loca_name_height = _topicHeight;
            _topicHeight = _topicHeight+10;
        }
        NSString *content = answersModel.content;
        if (isNullString(content)) {
            return;
        }
        _topicHeight = [ZZUtils heightForCellWithText:content fontSize:17 labelWidth:SCREEN_WIDTH - 30 -37 -5]+15+_topicHeight;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     CGPoint point=scrollView.contentOffset;
    
    if (_viewScroll) {
        if (_isLongVideo) {//新版的只有长视频才回调
            _viewScroll(point.y,_isLongVideo);
        }
    }
    [self updateTableViewFrameWithOffset:point.y];

}


- (void)updateTableViewFrameWithOffset:(CGFloat)offset {
    if (offset>=(10)) {
        if (_isFullScreen) {
//            //全屏状态且滑动超过评论
            self.isFullScreen = NO;
            [self setTableViewInsetsWithBottomValue:55+SafeAreaBottomHeight];
        }
    }else if (offset<(10)){
        if (_isFullScreen == NO) {
            self.isFullScreen = YES;
            [self setTableViewInsetsWithBottomValue:0];
        }
    }
}
- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom
{
    if (!_isLongVideo) {
        //短视频就不管了
        return;
    }
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets.bottom = bottom;
    
    return insets;
}


- (void)tapPlayView
{
    if (_touchPlayView) {
        _touchPlayView();
    }
}

- (void)doubleClickPlayView
{
    if (_doubleClick) {
        _doubleClick();
    }
}

#pragma mark -

//显示菜单
- (void)showMenuInView:(UIView *)showInView indexPath:(NSIndexPath *)indexPath
{
    ZZPlayerCommentCell *cell = (ZZPlayerCommentCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (self.contributionArray.count == 0) {
        _currentModel = self.commentArray[indexPath.row];
    } else {
        _currentModel = self.commentArray[indexPath.row - 1];
    }
    
    [self removeMenuView];
    [self.tableView addSubview:self.menuView];
    if ([_currentModel.reply.user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        self.menuView.type = 0;
    } else if (_isMySelf) {
        self.menuView.type = 1;
    } else {
        self.menuView.type = 2;
    }
    CGFloat width = [self.menuView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.centerX.mas_equalTo(cell.mas_centerX);
        make.bottom.mas_equalTo(cell.mas_top).offset(-5);
    }];
}

- (void)deleteClick
{
    if (!_isMMD) {
        [ZZSKModel deleteComentWithSkId:_skId replyId:_currentModel.reply.replyId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"删除成功"];
                [self.commentArray removeObject:_currentModel];
                [_tableView reloadData];
            }
        }];
    } else {
        ZZMemedaModel *model = [[ZZMemedaModel alloc] init];
        [model deleteMemedaComment:_mid replyId:_currentModel.reply.replyId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"删除成功"];
                [self.commentArray removeObject:_currentModel];
                [_tableView reloadData];
            }
        }];
    }
}

- (void)reportClick
{
    NSMutableDictionary *param = [@{@"content":_currentModel.reply.content} mutableCopy];
    if (!_isMMD) {
        [param setObject:@"sk" forKey:_skId];
        [param setObject:@"sk_rid" forKey:_currentModel.reply.replyId];
    } else {
        [param setObject:@"mid" forKey:_mid];
        [param setObject:@"rid" forKey:_currentModel.reply.replyId];
    }
    
    [ZZReportModel reportWithParam:param uid:_currentModel.reply.user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            [ZZHUD showSuccessWithStatus:@"谢谢您的举报，我们将在2个工作日解决!"];
        } else {
            [ZZHUD showErrorWithStatus:error.message];
        }
    }];
}

#pragma mark - lazyload
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellCurrentHeight) style:UITableViewStyleGrouped];
        [_tableView registerClass:[ZZPlayerCommentCell class] forCellReuseIdentifier:@"comment"];
        [_tableView registerClass:[ZZPlayerHeaderView class] forHeaderFooterViewReuseIdentifier:@"ZZPlayerHeaderViewID"];
        [_tableView registerClass:[ZZPlayerCellHeaderView class] forHeaderFooterViewReuseIdentifier:@"ZZPlayerCellHeaderViewID"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
       self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellCurrentHeight)];
        _tableView.tableHeaderView = self.tableHeaderView;
        [self.tableHeaderView addSubview:self.imgView];
        [self.imgView addSubview:self.playerTopicView];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.tableHeaderView);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.equalTo(@(_cellCurrentHeight));
        }];
        [self.tableHeaderView addSubview:self.processLineView];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectview.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
        _effectview.hidden = YES;
        [self addSubview:_effectview];
        
        _tableView.backgroundColor = UIColor.blackColor;
    }
    return _tableView;
}

- (NSMutableArray *)commentArray {
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        _imgView.translatesAutoresizingMaskIntoConstraints = NO;
        _imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlayView)];
        [_imgView addGestureRecognizer:recognizer];
        UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClickPlayView)];
        doubleRecognizer.numberOfTapsRequired = 2;
        [_imgView addGestureRecognizer:doubleRecognizer];
    }
    return _imgView;
}


- (UIView *)processLineView {
    if (!_processLineView) {
        _processLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _cellCurrentHeight - 2, 0, 2)];
        _processLineView.backgroundColor = kYellowColor;
    }
    return _processLineView;
}

- (ZZMenuView *)menuView {
    WeakSelf;
    if (!_menuView) {
        _menuView = [[ZZMenuView alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
        _menuView.touchDelete = ^{
            [weakSelf deleteClick];
        };
        _menuView.touchReport = ^{
            [weakSelf reportClick];
        };
    }
    return _menuView;
}

- (ZZPlayerTopicView *)playerTopicView {
    if (!_playerTopicView) {
        _playerTopicView = [[ZZPlayerTopicView alloc]initWithFrame:CGRectZero];
        _playerTopicView.hidden = YES;
    }
    return _playerTopicView;
}

//TODO:设置约束,么么哒视屏提问的约束
- (void)setUIConstraint {
    [self.playerTopicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.offset(0);
        make.height.equalTo(@40);
    }];
}
@end
