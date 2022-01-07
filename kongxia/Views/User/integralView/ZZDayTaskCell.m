//
//  ZZDayTaskCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZDayTaskCell.h"
#import "ZZDayTaskDetailCell.h"
@interface ZZDayTaskCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UILabel *daytaskLab;
@property (nonatomic,strong) UIImageView *daytaskImageView;
@property (nonatomic,strong) UITableView *tableView;
@end
@implementation ZZDayTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.daytaskImageView];
        [self.contentView addSubview:self.daytaskLab];
        [self.contentView addSubview:self.tableView];
    }
    return self;
}
#pragma mark  - 懒加载

- (UILabel *)daytaskLab {
    if (!_daytaskLab) {
        _daytaskLab = [[UILabel alloc]init];
        _daytaskLab.text = @"日常任务";
        _daytaskLab.textColor = kBlackColor;
        _daytaskLab.textAlignment = NSTextAlignmentCenter;
        _daytaskLab.font = ADaptedFontMediumSize(17);
    }
    return _daytaskLab;
}

- (UIImageView *)daytaskImageView {
    if (!_daytaskImageView) {
        _daytaskImageView = [[UIImageView alloc]init];
        _daytaskImageView.contentMode = UIViewContentModeScaleAspectFit;
        _daytaskImageView.image = [UIImage imageNamed:@"icRcrwWdjf"];
    }
    return _daytaskImageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
        _tableView.rowHeight = 77;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ZZDayTaskDetailCell class] forCellReuseIdentifier:@"ZZDayTaskDetailCellID"];
    }
    return _tableView;
}

#pragma  mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.day_task.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZDayTaskDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZDayTaskDetailCellID"];
    cell.dayTaskModel = self.model.day_task[indexPath.row];
    cell.gotoCompleteBlock = self.gotoComplete ;
    return cell;
}



#pragma mark - 约束

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.daytaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        if (self.model.rookie_task.count<=0) {
            make.top.offset(19);
        }else{
            make.top.offset(2);
        }
        make.size.mas_equalTo(CGSizeMake(16.5, 16.5));
    }];
    
    [self.daytaskLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.daytaskImageView.mas_centerY);
        make.left.equalTo(self.daytaskImageView.mas_right).offset(6);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.daytaskLab.mas_bottom).offset(1.5);
        make.bottom.offset(-SafeAreaBottomHeight);
    }];
}


@end
