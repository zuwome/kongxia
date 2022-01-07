//
//  TZAlbumView.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/4.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "TZAlbumView.h"
#import "TZImageManager.h"
#import "TZAssetCell.h"

@interface TZAlbumView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *albumsTableView;

@property (nonatomic, strong) NSMutableArray *albumArr;

@end

@implementation TZAlbumView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)show {
    if (_albumArr.count == 0) {
        [self fetchAlbums];
    }
    else {
        [_albumsTableView reloadData];
    }
}

- (void)fetchAlbums {
    if (![[TZImageManager manager] authorizationStatusAuthorized]) {
        return;
    }
    
    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[TZImageManager manager] getAllAlbums:imagePickerVc.allowPickingVideo allowPickingImage:imagePickerVc.allowPickingImage needFetchAssets:NO completion:^(NSArray<TZAlbumModel *> *models) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_albumArr = [NSMutableArray arrayWithArray:models];
                [_albumsTableView reloadData];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(view:didSelectAlbum:isTheFirstTime:)]) {
                    [self.delegate view:self didSelectAlbum:models.firstObject isTheFirstTime:YES];
                }
            });
        }];
    });
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TZAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZAlbumCell" forIndexPath:indexPath];
    cell.model = _albumArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TZAlbumModel *model = _albumArr[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:didSelectAlbum:isTheFirstTime:)]) {
        [self.delegate view:self didSelectAlbum:model isTheFirstTime:NO];
    }
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.albumsTableView];
    [_albumsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - getters and setters
- (UITableView *)albumsTableView {
    if (!_albumsTableView) {
        _albumsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _albumsTableView.rowHeight = 70.0;
        _albumsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _albumsTableView.dataSource = self;
        _albumsTableView.delegate = self;
        [_albumsTableView registerClass:[TZAlbumCell class] forCellReuseIdentifier:@"TZAlbumCell"];\
    }
    return _albumsTableView;
}

@end
