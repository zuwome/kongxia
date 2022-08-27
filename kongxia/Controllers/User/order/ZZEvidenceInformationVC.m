//
//  ZZEvidenceInformationVC.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/30.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZEvidenceInformationVC.h"
#import "TYAttributedLabel.h"
#import "ZZRefundHelper.h"
#import "ZZOrderArCheckEvidenceNickCell.h"
#import "ZZOrderARCheckEVidenceReasonCell.h"
#import "ZZOrderArCheckEvidenceDetailPhoneCell.h"
#import "ZZChatServerViewController.h"

@interface ZZEvidenceInformationVC ()<UITableViewDelegate,UITableViewDataSource,TYAttributedLabelDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *footView;

@end

@implementation ZZEvidenceInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"证据信息";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.bottom.equalTo(@(-SafeAreaBottomHeight));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model.refuse_photos.count<=0) {
        //达人必须传图片证据,达人没有图片说明是达人直接同意退款
        return 1;
    }else{
        //代表的是查看双方证据
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ZZRefundHelper numberOfRowSectionWithSection:section model:self.model];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    ZZOrderARCheckEvidenceBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZRefundHelper identifierWithIndexPath:indexPath model:self.model]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell setShowTitle:indexPath.section>0?@"拒绝理由":@"退款理由" detailTitle:[ZZRefundHelper titleOfSectionWithIndexPath:indexPath model:self.model] dataArray:[ZZRefundHelper arrayOfSectionWithIndexPath:indexPath model:self.model] viewController:self];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return [tableView fd_heightForCellWithIdentifier:[ZZRefundHelper identifierWithIndexPath:indexPath model:self.model] cacheByIndexPath:indexPath configuration:^(ZZOrderARCheckEvidenceBaseCell* cell) {
        [cell setShowTitle:nil detailTitle:[ZZRefundHelper titleOfSectionWithIndexPath:indexPath model:self.model] dataArray:[ZZRefundHelper arrayOfSectionWithIndexPath:indexPath model:self.model] viewController:self];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 8;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ZZOrderArCheckEvidenceNickCell class] forCellReuseIdentifier:@"ZZOrderArCheckEvidenceNickCellID"];
        [_tableView registerClass:[ZZOrderARCheckEVidenceReasonCell class] forCellReuseIdentifier:@"ZZOrderARCheckEVidenceReasonCellID"];
        [_tableView registerClass:[ZZOrderArCheckEvidenceDetailPhoneCell class] forCellReuseIdentifier:@"ZZOrderArCheckEvidenceDetailPhoneCellID"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        _tableView.tableFooterView = self.footView;
    }
    return _tableView;
}

- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    
        TYAttributedLabel *moreInstructionLab = [[TYAttributedLabel alloc]initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH-30, 20)];
     
        moreInstructionLab.textColor = kBlackColor;
        moreInstructionLab.font = CustomFont(12);
        moreInstructionLab.lineBreakMode = kCTLineBreakByCharWrapping;
        NSString *string =@"温馨提示：请核实证据图片，如有异议可联系";
        NSString *instruction = @"温馨提示：";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];;
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, instruction.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:kBlackColor range:NSMakeRange(instruction.length, string.length-instruction.length)];

        moreInstructionLab.backgroundColor = HEXCOLOR(0xf5f5f5);
        [moreInstructionLab setAttributedText:attributedString];
        moreInstructionLab.delegate = self;
        moreInstructionLab.linkColor = RGBCOLOR(74, 144, 226);
        [moreInstructionLab appendLinkWithText:@"在线客服" linkFont:[UIFont systemFontOfSize:12 ]linkData:@"在线客服"];

        [_footView addSubview:moreInstructionLab];
    
        
        
    }
    return _footView;
}


#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isEqualToString:@"在线客服"]) {
            [self jumpGoToKeFuChat];
        }
    }
}



//跳转到在线客服
- (void)jumpGoToKeFuChat {
    [ZZServerHelper showServer];
//    ZZChatServerViewController *chatService = [[ZZChatServerViewController alloc] init];
//    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
//    chatService.targetId = kCustomerServiceId;
//    chatService.title = @"客服";
//    chatService.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController :chatService animated:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
