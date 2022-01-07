//
//  ZZChatBoxGreetingView.m
//  zuwome
//
//  Created by MaoMinghui on 2018/9/4.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZChatBoxGreetingView.h"
#import "ZZChatBoxGreetingCell.h"
#import "ZZChatBoxGreetingEditView.h"

#import "ZZTabBarViewController.h"

#define GreetingLimitCount  10

@interface ZZChatBoxGreetingView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *completeBtn;

@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, strong) ZZChatBoxGreetingEditView *editView;

@property (nonatomic, strong) NSMutableArray *greetings;

@property (nonatomic, copy) NSString *greetingsKey; //本地取用户常用语的键

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, strong) NSIndexPath *editIndexPath;

@end

@implementation ZZChatBoxGreetingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.greetingsKey = [NSString stringWithFormat:@"Greetings-%@",[ZZUserHelper shareInstance].loginer.uid];
        [self createUI];
        [self loadGreetings];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
    }];
    
    [self addSubview:self.emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(_tableView);
    }];
    
    [self addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.leading.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 50, 50));
    }];
    
    [self addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.trailing.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self addSubview:self.completeBtn];
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@50);
    }];
    self.emptyView.hidden = YES;
    self.completeBtn.hidden = YES;
}

- (void)loadGreetings {
    NSArray *greetingArray = [ZZUserDefaultsHelper objectForDestKey:self.greetingsKey];
    if (nil == greetingArray) {
        if ([ZZUserHelper shareInstance].loginer.rent.status == 2) {    //达人方
            greetingArray = @[@"很高兴，遇见你",
                              @"你好，平时都有时间，你可以直接发起邀约",
                              @"你好，可以参考达人信息来发起邀约"];
        } else {    //用户方
            greetingArray = @[@"你好，你什么时候有时间？",
                              @"你好，能告诉我你常去的地点吗？",
                              @"你好，你平时都有哪些爱好？"];
        }
    }
    self.greetings = [NSMutableArray arrayWithArray:greetingArray];
    [self storeGreetings];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.greetings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZChatBoxGreetingCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatBoxGreetingCellId forIndexPath:indexPath];
    cell.greeting.text = self.greetings[indexPath.row];
    cell.type = self.isEdit ? GreetingTypeEdit : GreetingTypeNormal;
    [cell setClickEdit:^{
        self.editIndexPath = indexPath;
        [self showEditView:self.greetings[indexPath.row] withType:(GreetingEditTypeEdit)];
    }];
    [cell setClickDelete:^{
        [self.greetings removeObjectAtIndex:indexPath.row];
        [self storeGreetings];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isEdit) {
        return;
    }
    NSString *greeting = self.greetings[indexPath.row];
    !self.selectGreeting ? : self.selectGreeting(greeting);
}

- (void)addGreeting {
    if (self.greetings.count >= GreetingLimitCount) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"到达上限" message:@"您的常用语设置已经到达上限，请删除部分常用语后再添加" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:(UIAlertActionStyleDefault) handler:nil];
        [alert addAction:okAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    } else {
        [self showEditView:nil withType:(GreetingEditTypeAdd)];
    }
}

- (void)editGreeting {
    self.isEdit = YES;
    self.completeBtn.hidden = NO;
    [self.tableView reloadData];
}

- (void)complete {
    self.isEdit = NO;
    self.completeBtn.hidden = YES;
    [self.tableView reloadData];
}

- (void)showEditView:(NSString *)greeting withType:(GreetingEditType)type {
    if (!greeting) {
        greeting = @"";
    }
    self.editView.type = type;
    self.editView.textView.text = greeting;
    self.editView.countLab.text = [NSString stringWithFormat:@"%ld/30",greeting.length];
    [[UIApplication sharedApplication].keyWindow addSubview:self.editView];
}

- (void)saveGreeting:(NSString *)greeting {
    if (_editView.type == GreetingEditTypeEdit) {
        if (!self.editIndexPath) {
            return;     //找不到编辑的位置则不处理
        }
        [self.greetings replaceObjectAtIndex:self.editIndexPath.row withObject:greeting];
    } else {
        [self.greetings insertObject:greeting atIndex:0];
    }
    self.editIndexPath = nil;
    [self storeGreetings];
}

- (void)storeGreetings {
    [ZZUserDefaultsHelper setObject:self.greetings forDestKey:self.greetingsKey];
    [self.tableView reloadData];
    if (self.greetings.count <= 0) {
        [self complete];
        self.emptyView.hidden = NO;
    } else {
        self.emptyView.hidden = YES;
    }
}

#pragma mark -- getter
- (UITableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ZZChatBoxGreetingCell class] forCellReuseIdentifier:ChatBoxGreetingCellId];
    }
    return _tableView;
}

- (UIButton *)addBtn {
    if (nil == _addBtn) {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setBackgroundColor:kBGColor];
        [_addBtn setImage:[UIImage imageNamed:@"icGreetingAdd"] forState:(UIControlStateNormal)];
        [_addBtn setTitle:@"新增" forState:(UIControlStateNormal)];
        [_addBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_addBtn addTarget:self action:@selector(addGreeting) forControlEvents:(UIControlEventTouchUpInside)];
        _addBtn.layer.borderWidth = 0.5;
        _addBtn.layer.borderColor = kGrayLineColor.CGColor;
    }
    return _addBtn;
}

- (UIButton *)editBtn {
    if (nil == _editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn setBackgroundColor:kBGColor];
        [_editBtn setImage:[UIImage imageNamed:@"icGreetingSetting"] forState:(UIControlStateNormal)];
        [_editBtn addTarget:self action:@selector(editGreeting) forControlEvents:(UIControlEventTouchUpInside)];
        _editBtn.layer.borderWidth = 0.5;
        _editBtn.layer.borderColor = kGrayLineColor.CGColor;
    }
    return _editBtn;
}

- (UIButton *)completeBtn {
    if (nil == _completeBtn) {
        _completeBtn = [[UIButton alloc] init];
        [_completeBtn setBackgroundColor:kGoldenRod];
        [_completeBtn setTitle:@"完成" forState:(UIControlStateNormal)];
        [_completeBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [_completeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_completeBtn addTarget:self action:@selector(complete) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _completeBtn;
}

- (ZZChatBoxGreetingEditView *)editView {
    if (nil == _editView) {
        WeakSelf
        _editView = [[ZZChatBoxGreetingEditView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_editView setClickSave:^(NSString *greeting) {
            [weakSelf saveGreeting:greeting];
        }];
        [_editView setClickSend:^(NSString *greeting) {
            [weakSelf saveGreeting:greeting];
            !weakSelf.sendGreeting ? : weakSelf.sendGreeting(greeting);
        }];
    }
    return _editView;
}

- (UIView *)emptyView {
    if (nil == _emptyView) {
        _emptyView = [[UIView alloc] init];
        _emptyView.backgroundColor = [UIColor whiteColor];
        UILabel *emptyLab = [[UILabel alloc] init];
        emptyLab.numberOfLines = 2;
        emptyLab.textAlignment = NSTextAlignmentCenter;
        emptyLab.textColor = kBrownishGreyColor;
        emptyLab.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        emptyLab.text = [NSString stringWithFormat:@"设置常用语，轻松一键打招呼\n（上限%d条，不超过30字）",GreetingLimitCount];
        [_emptyView addSubview:emptyLab];
        [emptyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_emptyView);
        }];
    }
    return _emptyView;
}

@end
