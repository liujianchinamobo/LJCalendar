//
//  NSDate+Calendar.m
//  111
//
//  Created by liujian on 16/1/8.
//  Copyright © 2016年 Chinamobo. All rights reserved.
//

#import "NSDate+Calendar.h"
#import "NSDateFormatter+Calendar.h"

@implementation NSDate (Calendar)
-(BOOL)today
{
    NSDate *today = [NSDate date];
    
    NSDateFormatter *formatter = [NSDateFormatter yearMonthDayFormatter];
    
    NSString *today1 = [formatter stringFromDate:today];
    NSString *self1 = [formatter stringFromDate:self];
    
    return [today1 isEqualToString:self1];
}


@end
