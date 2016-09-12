//
//  LJCalendarView.h
//  000
//
//  Created by liujian on 16/1/6.
//  Copyright © 2016年 liujian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LJCalendarView;

@protocol LJCalendarDelegate <NSObject>
/**
 *  能够选择日期
 *
 *  @param calendarView 日期view
 *  @param date         将要选择的日期
 *
 *  @return 当前日期是否可选
 */
-(BOOL)LJCalendarView:(LJCalendarView *)calendarView shouldSelectDate:(NSDate *)date;

/**
 *  选择日期后
 *
 *  @param calendarView 日期view
 *  @param date         选择的日期
 */
-(void)LJCalendarView:(LJCalendarView *)calendarView didSelectDate:(NSDate *)date;
@end

typedef void(^dateSelectedBlock) (NSDate * date);


@interface LJCalendarView : UIView
/**
 *  快速实例化一个日历组件,可以直接使用选择日期后回调，也可以用常规方法实例化，使用代理来处理选择日期事件
 *
 *  @param frame 大小
 *  @param block 选择日期后回调
 *
 *  @return 日历对象
 */
-(instancetype)initWithFrame:(CGRect)frame dateSelectedCallBack:(dateSelectedBlock)block;
@property (nonatomic, weak) id delegate;

@end
