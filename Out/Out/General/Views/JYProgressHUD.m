//
//  OutProgressHUD.m
//  Out
//
//  Created by Jolie_Yang on 16/9/11.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// Thinking LIST:
// 1. 在changeToTextHUD跟showTextHUD时，其实可以整在一个方法中，但会出现其实是显示同一个HUD,

#import "JYProgressHUD.h"

@implementation JYProgressHUD

+ (instancetype)showIndicatorHUDWithDetailString:(NSString *)detailString AddedTo:(UIView *)view animated:(BOOL)animated {
    JYProgressHUD *hud = [super showHUDAddedTo:view animated:animated];
    hud.detailsLabel.text = detailString;
    [self configIndicatorHUD:hud];
    
    return hud;
}

+ (void)changeToTextHUDWithDetailString:(NSString *)string AddedTo:(UIView *)view completion:(JYProgressHUDCompletion)completion {
    MBProgressHUD *hud = [self HUDForView:view];
    if (!hud) {
        hud = [super showHUDAddedTo:view animated:YES];
    }
    if (hud.mode != MBProgressHUDModeText) {
        hud.detailsLabel.text = string;
        [self configTextHUD:hud];
    }
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [super hideHUDForView:view animated:YES];
        completion();
    });
}

// 显示HUD不会自动消失
+ (instancetype)showTextHUDWithDetailString:(NSString *)string AddedTo:(UIView *)view {
    JYProgressHUD *hud = [self showTextHUDWithDetailContent:string AddedTo:view Duration:0.0 Completion:nil];
    
    return hud;
}
+ (instancetype)showNormalTextHUDWithDetailContent:(NSString *)content AddedTo:(UIView *)view completion:(JYProgressHUDCompletion)completion {
    JYProgressHUD *hud = [self showTextHUDWithDetailContent:content AddedTo:view Duration:1.0 Completion:completion];
    
    return hud;
}
+ (instancetype)showQuicklyTextHUDWithDetailContent:(NSString *)content AddedTo:(UIView *)view completion:(JYProgressHUDCompletion)completion {
    JYProgressHUD *hud = [self showTextHUDWithDetailContent:content AddedTo:view Duration:0.6 Completion:completion];
    
    return hud;
}

+ (instancetype)showLongerTextHUDWithContent:(NSString *)content AddedTo:(UIView *)view completion:(JYProgressHUDCompletion)completion {
    JYProgressHUD *hud = [self showTextHUDWithDetailContent:content AddedTo:view Duration:3.0 Completion:completion];
    
    return hud;
}

+ (instancetype)showTextHUDWithDetailContent:(NSString *)content AddedTo:(UIView *)view Duration:(NSTimeInterval)duration Completion:(void (^)())completion {
    JYProgressHUD *hud = [super showHUDAddedTo:view animated:YES];
    hud.detailsLabel.text = content;
    [self configTextHUD:hud];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
    if (popTime) {
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [super hideHUDForView:view animated:YES];
            if (completion) {
                completion();
            }
        });
    }
    
    return hud;
}
// 定制Out's HUD
+ (void)configIndicatorHUD:(MBProgressHUD *)hud {
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.margin = 10.0;// default is '20.0'
    hud.bezelView.layer.cornerRadius = 7;
    hud.square = YES;
    [self configDarkHUD:hud];
}
+ (void)configTextHUD:(MBProgressHUD *)hud {
    hud.mode = MBProgressHUDModeText;
    hud.margin = 14.0;
    hud.detailsLabel.font = [UIFont fontWithName:@"Thonburi" size:14.0];
    hud.square = NO;
    [self configDarkHUD:hud];
}

+ (void)configDarkHUD:(MBProgressHUD *)hud {
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.alpha = 0.7;
    hud.contentColor = [UIColor whiteColor];
}

@end
