//
//  AlertView.h
//  DianJiaMS
//
//  Created by 张桂源 on 16/7/26.
//  Copyright © 2016年 800best. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger){
    CANCLEBTN = 0,
    ENTERBTN,
    
}AlertViewBtnIndex;

typedef void(^AlertViewSselectBlock)(AlertViewBtnIndex index);


@interface ZGYAlertView : NSObject<UIAlertViewDelegate>


@property (nonatomic, copy) AlertViewSselectBlock block;



- (void)showAlertViewMessage:(NSString *)msg Title:(NSString *)title cancleItem:(NSString *)cancle andOtherItem:(NSString *)other viewController:(UIViewController *)controller onBlock:(void (^)(AlertViewBtnIndex))alertViewBlock;

@end
