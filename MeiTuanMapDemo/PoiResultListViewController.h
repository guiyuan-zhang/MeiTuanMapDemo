//
//  PoiResultListViewController.h
//  MeiTuanMapDemo
//
//  Created by 张桂源 on 2016/9/28.
//  Copyright © 2016年 800best. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoiModel.h"
@interface PoiResultListViewController : UIViewController

@property (nonatomic,strong)NSArray *resultListArray;

@property (nonatomic,copy) void(^poiListBlock)(PoiModel *model);

@end
