//
//  ForecastView.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "ForecastView.h"

@implementation ForecastView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    self.timeLabel.text = self.time;
    self.iconLabel.text = self.icon;
    self.temperatureLabel.text= self.temperature;
}

@end
