//
//  ViewController.m
//  MeiTuanMapDemo
//
//  Created by 张桂源 on 16/9/23.
//  Copyright © 2016年 800best. All rights reserved.
//

#import "ViewController.h"
#import "ZGYDragMapVC.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *longitudeAndLatitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)selectedLocation:(id)sender {
    ZGYDragMapVC *vc = [[ZGYDragMapVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    __weak ViewController *weaSelf = self;
    [vc setZgyDrapMapBlock:^(PoiModel *model) {
       
        weaSelf.longitudeAndLatitudeLabel.text = [NSString stringWithFormat:@"%lf,%lf",model.lat,model.lon];
        weaSelf.detailAddressLabel.text = [NSString stringWithFormat:@"%@ %@",model.city,model.address];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
