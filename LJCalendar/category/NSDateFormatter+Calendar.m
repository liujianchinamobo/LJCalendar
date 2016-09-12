
//
//  NSDateFormatter+Calendar.m
//  000
//
//  Created by liujian on 16/1/5.
//  Copyright © 2016年 liujian. All rights reserved.
//

#import "NSDateFormatter+Calendar.h"

@implementation NSDateFormatter (Calendar)
static NSDateFormatter *dateFormatter = nil;
+(NSDateFormatter *)defaultFormatter
{
    if (!dateFormatter) {
         dateFormatter = [[NSDateFormatter alloc] init];
    }
    return dateFormatter;
}

+(NSDateFormatter *)yearMonthFormatter
{
    NSDateFormatter *formatter = [self defaultFormatter];
    [formatter setDateFormat:@"YYYY年MM月"];
    return dateFormatter;
}

+(NSDateFormatter *)yearMonthDayFormatter
{
    NSDateFormatter *formatter = [self defaultFormatter];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    return dateFormatter;
}

+(NSDateFormatter *)detailTimeFormatter
{
    NSDateFormatter *formatter = [self defaultFormatter];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return dateFormatter;
}



@end
