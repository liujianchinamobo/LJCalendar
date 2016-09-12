
//
//  LJCalendarCell.m
//  000
//
//  Created by liujian on 16/1/6.
//  Copyright © 2016年 liujian. All rights reserved.
//

#import "LJCalendarCell.h"

@implementation LJCalendarCell
-(UILabel *)label
{
    if (!_label) {
        
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_label];
        
    }
    return _label;
}

@end
