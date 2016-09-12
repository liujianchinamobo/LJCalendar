//
//  NSDateFormatter+Calendar.h
//  000
//
//  Created by liujian on 16/1/5.
//  Copyright © 2016年 liujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Calendar.h"

@interface NSDateFormatter (Calendar)
+(NSDateFormatter *)defaultFormatter;
+(NSDateFormatter *)yearMonthFormatter;
+(NSDateFormatter *)yearMonthDayFormatter;
+(NSDateFormatter *)detailTimeFormatter;


@end
