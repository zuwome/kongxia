//
//  ZZAgeEditTableViewController.m
//  zuwome
//
//  Created by wlsy on 16/1/20.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZAgeEditTableViewController.h"
#import "ZZUser.h"

@interface ZZAgeEditTableViewController ()
{
    IBOutlet UILabel *_ageLabel;
    IBOutlet UILabel *_constellationLabel;
    BOOL    _ageChange;
}
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation ZZAgeEditTableViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createRightDoneBtn];
    
    
    if ([ZZUtils isIdentifierAuthority:_user]) {
        [self reloadWithBirthday:_defaultBirthday];
//        _datePicker.userInteractionEnabled = NO;
    }
    else {
        NSDate *date = _user.birthday;
        if (!date) {
            NSDate *currentDate = [NSDate date];
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            [comps setDay:currentDate.day];
            [comps setMonth:currentDate.month];
            [comps setYear:currentDate.year - 18];
            date = [[NSCalendar currentCalendar] dateFromComponents:comps];
        }
        _datePicker.date = date;
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
        [self reloadWithBirthday:date];
        _ageChange = YES;
    }
    _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*18];

}

- (void)createRightDoneBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 20);
    [btn setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"done"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(rightDoneClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *leftBarButon = [[UIBarButtonItem alloc]initWithCustomView:btn];
    btnItem.width = kLeftEdgeInset;
    self.navigationItem.rightBarButtonItems = @[btnItem, leftBarButon];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isChuzu?1:2;
}

- (void)reloadWithBirthday:(NSDate *)birthday {
    ZZUser *user = [[ZZUser alloc] init];
    user.birthday = birthday;
    user.age = [ZZUser ageWithBirthday:birthday];
    _ageLabel.text = [NSString stringWithFormat:@"%ld岁", (long)[ZZUser ageWithBirthday:birthday]];
    _constellationLabel.text = [self constellation:birthday];
}
- (NSString *)constellation:(NSDate *)birthday
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    NSInteger m = [birthday month];
    NSInteger d = [birthday day];
    
    if (m < 1 || m > 12 || d <1 || d > 31) {
        return @"";
    }
    
    if( m ==2 && d > 29) {
        return @"";
        
    }else if(m == 4 || m == 6 || m==9 || m==11) {
        if ( d > 30) {
            return @"";
        }
    }
    
    result = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    return [result stringByAppendingString:@"座"];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_defaultBirthday) {
        [_datePicker setDate:_defaultBirthday animated:YES];
    }
}

- (void)rightDoneClick {
    if (_ageChange) {
        if (_dateChangeBlock) {
            _dateChangeBlock(_datePicker.date);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)datePickerDidChange:(UIDatePicker *)sender {
    [self reloadWithBirthday:sender.date];
    _ageChange = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
