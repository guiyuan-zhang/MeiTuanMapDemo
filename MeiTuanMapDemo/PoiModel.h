//
//  PoiModel.h
//  MeiTuanMapDemo
//
//  Created by 张桂源 on 2016/9/28.
//  Copyright © 2016年 800best. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PoiModel : NSObject

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,assign)double lat;
@property (nonatomic,assign)double lon;

@end
