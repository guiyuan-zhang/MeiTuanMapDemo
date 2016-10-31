//
//  PoiResultCell.h
//  DianJiaManageSystem
//
//  Created by 张桂源 on 2016/10/14.
//  Copyright © 2016年 800best. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoiModel.h"

@interface PoiResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic,strong)PoiModel *model;

@end
