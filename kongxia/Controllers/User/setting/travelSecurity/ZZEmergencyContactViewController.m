//
//  ZZEmergencyContactViewController.m
//  zuwome
//
//  Created by angBiu on 2017/8/21.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZEmergencyContactViewController.h"

#import "ZZEmergencyContactCell.h"
#import "ZZContactAuthorityAlert.h"

#import "PPGetAddressBook.h"
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>

@interface ZZEmergencyContactViewController () <UITableViewDelegate,UITableViewDataSource,CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, strong) ZZContactAuthorityAlert *alert;

@end

@implementation ZZEmergencyContactViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_alert) {
        [_alert removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"紧急联系人";
    
    [self createViews];
}

- (void)createViews
{
    _user = [ZZUserHelper shareInstance].loginer;
    self.tableView.hidden = NO;
}

#pragma mark - UITabelViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _user.emergency_contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    
    ZZEmergencyContactCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZEmergencyContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    ZZEmergencyContactModel *model = _user.emergency_contacts[indexPath.row];
    cell.titleLabel.text = model.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = [ZZUtils setLineSpace:@"为了保障您的行程安全\n紧急联系人将用于紧急求助功能" space:5 fontSize:15 color:kBlackTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.top.mas_equalTo(headView.mas_top).offset(15);
    }];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textColor = HEXCOLOR(0xa5a5a5);
    countLabel.font = [UIFont systemFontOfSize:13];
    countLabel.text = @"最多添加5位";
    [headView addSubview:countLabel];
    
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView.mas_left).offset(15);
        make.bottom.mas_equalTo(headView.mas_bottom).offset(-5);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLineViewColor;
    [headView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(headView);
        make.height.mas_equalTo(@0.5);
    }];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 28, SCREEN_WIDTH - 30, 50)];
    addBtn.backgroundColor = kYellowColor;
    addBtn.layer.cornerRadius = 3;
    [addBtn setTitle:@"添加紧急联系人" forState:UIControlStateNormal];
    [addBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:addBtn];
    
    return footView;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        [UIAlertView showWithTitle:@"删除联系人" message:@"确定删除该紧急联系人吗？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self deleteContact:indexPath];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIButtonMethod

- (void)addBtnClick
{
    if (_user.emergency_contacts.count > 5) {
        [ZZHUD showErrorWithStatus:@"最多添加5位联系人"];
        return;
    }
    WeakSelf;
    [[PPAddressBookHandle sharedAddressBookHandle] requestAuthorizationWithSuccessBlock:^(BOOL granted) {
        if (granted) {
            [weakSelf gotoContactView];
        } else {
            if ([[UIDevice currentDevice].systemVersion integerValue] < 8) {
                [UIAlertView showWithTitle:NSLocalizedString(@"通讯录功能未开启", nil)
                                   message:NSLocalizedString(@"您尚未开启通讯录功能，请在设置-通知中心中，找到“空虾”并打开通讯录来获取最完整的服务。",nil)
                         cancelButtonTitle:NSLocalizedString(@"确定", nil)
                         otherButtonTitles:nil
                                  tapBlock:nil];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.view.window addSubview:weakSelf.alert];
                });
            }
        }
    }];
}

- (void)gotoContactView
{
    if (IOS9_OR_LATER) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
            // 2.设置代理
            contactVc.delegate = self;
            // 3.弹出控制器
            [self presentViewController:contactVc animated:YES completion:nil];
        });
    } else {
        ABPeoplePickerNavigationController *controller = [[ABPeoplePickerNavigationController alloc] init];
        controller.peoplePickerDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - CNContactPickerDelegate

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *phone;
        for (CNLabeledValue *value in contact.phoneNumbers) {
            phone = ((CNPhoneNumber *)value.value).stringValue; //电话
            break;
        }
        [self addContactWithName:[NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName] phone:phone];
    }];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0)
{
    [self getPerson:person];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self getPerson:person];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)getPerson:(ABRecordRef)person
{
    NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex phoneCount = ABMultiValueGetCount(phones);
    NSString *phoneValue;
    for (int i = 0; i < phoneCount; i++) {
        phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
        break;
    }
    
    CFRelease(phones);
    
    [self addContactWithName:[NSString stringWithFormat:@"%@%@",lastName,firstName] phone:phoneValue];
}

#pragma mark - 添加删除联系人

- (void)addContactWithName:(NSString *)name phone:(NSString *)phone
{
    if (isNullString(name)) {
        [ZZHUD showErrorWithStatus:@"联系人姓名不能为空"];
        return;
    }
    if (isNullString(phone)) {
        [ZZHUD showErrorWithStatus:@"联系人手机不能为空"];
        return;
    }
    BOOL haveContact = NO;
    for (ZZEmergencyContactModel *contactModel in _user.emergency_contacts) {
        if ([contactModel.name isEqualToString:name]) {
            haveContact = YES;
            break;
        }
    }
    if (haveContact) {
        [ZZHUD showErrorWithStatus:@"该联系人已存在"];
        return;
    }
    [ZZRequest method:@"POST"
                 path:@"/api/user/emergency_contact/add"
               params:@{@"name":name,
                        @"phone":phone}
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                     if (error) {
                         [ZZHUD showErrorWithStatus:error.message];
                     } else {
                         ZZEmergencyContactModel *model = [[ZZEmergencyContactModel alloc] init];
                         model.name = name;
                         model.phone = phone;
                         if (!_user.emergency_contacts) {
                             NSMutableArray<ZZEmergencyContactModel> *array = [NSMutableArray array];
                             _user.emergency_contacts = array;
                         }
                         [_user.emergency_contacts addObject:model];
                         [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self.tableView reloadData];
                             if (_updateCallBack) {
                                 _updateCallBack();
                             }
                         });
                     }
                   }];
}

- (void)deleteContact:(NSIndexPath *)indexPath
{
    ZZEmergencyContactModel *model = _user.emergency_contacts[indexPath.row];
    [ZZRequest method:@"POST" path:@"/api/user/emergency_contact/del" params:@{@"phone":model.phone} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [_user.emergency_contacts removeObject:model];
            [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            if (_updateCallBack) {
                _updateCallBack();
            }
        }
    }];
}

#pragma mark - lazyload

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return _tableView;
}

- (ZZContactAuthorityAlert *)alert
{
    if (!_alert) {
        _alert = [[ZZContactAuthorityAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _alert;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
