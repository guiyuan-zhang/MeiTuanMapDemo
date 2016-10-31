//
//  PoiResultCell.m
//  DianJiaManageSystem
//
//  Created by 张桂源 on 2016/10/14.
//  Copyright © 2016年 800best. All rights reserved.
//

#import "PoiResultCell.h"

@implementation PoiResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(PoiModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",model.city, model.address];
}


@end
