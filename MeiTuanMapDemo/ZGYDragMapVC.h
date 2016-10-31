//
//  ZGYDragMapVC.h
//  MeiTuanMapDemo
//
//  Created by 张桂源 on 16/9/23.
//  Copyright © 2016年 800best. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoiResultListViewController.h"

@interface ZGYDragMapVC : UIViewController

@property (nonatomic, copy) void (^zgyDrapMapBlock)(PoiModel *model);

@end
