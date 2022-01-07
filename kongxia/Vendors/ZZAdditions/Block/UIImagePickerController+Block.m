//
//  UIImagePickerController+Block.m
//  Pods
//
//  Created by wlsy on 16/1/24.
//
//


#import "UIImagePickerController+Block.h"
#import <objc/runtime.h>

static char finalizationBlockKey;
static char cancelationBlockKey;

@interface UIImagePickerController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end

@implementation UIImagePickerController (Block)

#pragma mark - Getter methods

- (UIImagePickerControllerFinalizationBlock)finalizationBlock
{
    return objc_getAssociatedObject(self, &finalizationBlockKey);
}

- (UIImagePickerControllerCancellationBlock)cancellationBlock
{
    return objc_getAssociatedObject(self, &cancelationBlockKey);
}


#pragma mark - Setter methods

- (void)setFinalizationBlock:(UIImagePickerControllerFinalizationBlock)block
{
    if (!block) {
        return;
    }
    
    self.delegate = self;
    objc_setAssociatedObject(self, &finalizationBlockKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setCancellationBlock:(UIImagePickerControllerCancellationBlock)block
{
    if (!block) {
        return;
    }
    
    self.delegate = self;
    objc_setAssociatedObject(self, &cancelationBlockKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.finalizationBlock) {
        self.finalizationBlock(self, info);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.cancellationBlock) {
        self.cancellationBlock(self);
    }
}

@end
