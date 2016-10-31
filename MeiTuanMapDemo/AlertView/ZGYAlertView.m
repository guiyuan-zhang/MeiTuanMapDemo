//
//  AlertView.m
//  DianJiaMS
//
//  Created by 张桂源 on 16/7/26.
//  Copyright © 2016年 800best. All rights reserved.
//

#import "ZGYAlertView.h"
//判断手机系统
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)


@interface ZGYAlertView (){
    AlertViewSselectBlock _alertViewBlock;
}

@end

@implementation ZGYAlertView


- (void)showAlertViewMessage:(NSString *)msg Title:(NSString *)title cancleItem:(NSString *)cancle andOtherItem:(NSString *)other viewController:(UIViewController *)controller onBlock:(void (^)(AlertViewBtnIndex))alertViewBlock{
    if (iOS8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        if (cancle != nil) {
            [alert addAction:[UIAlertAction actionWithTitle:cancle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                alertViewBlock(CANCLEBTN);
            }]];
        }
        if (other != nil) {
            [alert addAction:[UIAlertAction actionWithTitle:other style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                alertViewBlock(ENTERBTN);
                
            }]];
        }
        
        
        [controller presentViewController:alert animated:YES completion:nil];
        
    }else{
        UIAlertView *goHomePage = [[UIAlertView alloc]initWithTitle:title message:msg delegate:controller cancelButtonTitle:cancle otherButtonTitles:other, nil];
        [goHomePage show];
        _alertViewBlock = alertViewBlock;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    _alertViewBlock(buttonIndex);
}

@end
