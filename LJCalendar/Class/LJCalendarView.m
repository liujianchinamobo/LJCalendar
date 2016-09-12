//
//  LJCalendarView.m
//  000
//
//  Created by liujian on 16/1/6.
//  Copyright © 2016年 liujian. All rights reserved.
//

#import "LJCalendarView.h"
#import "LJCalendarCell.h"
#import "NSDateFormatter+Calendar.h"

#define TitleHeight 30

@interface LJCalendarView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSArray * weekdayArray;
@property (nonatomic, strong) NSDate * currentDate;
@property (nonatomic, assign) NSInteger  firstWeekday;
@property (nonatomic, strong) UILabel * titleDateLabel;
@property (nonatomic, strong) dateSelectedBlock  callBackBlock;

@end


@implementation LJCalendarView


-(instancetype)initWithFrame:(CGRect)frame dateSelectedCallBack:(dateSelectedBlock)block
{
    self = [self initWithFrame:frame];
    self.callBackBlock = block;
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTitle];
        [self setupCalendarView];
        [self addSwipe];
    }
    return self;
}

/**设置标题内容*/
-(void)setupTitle
{
    CGFloat width = CGRectGetWidth(self.bounds);
    
    // 上个月按钮
    UIButton *previousMonth = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, TitleHeight)];
    [previousMonth setImage:[UIImage imageNamed:@"jiantou-orange left"] forState:UIControlStateNormal];
    [self addSubview:previousMonth];
    // 下个月按钮
    UIButton *nextMonth = [[UIButton alloc] initWithFrame:CGRectMake(width - 20, 0, 20, TitleHeight)];
    [nextMonth setImage:[UIImage imageNamed:@"jiantou-orange"] forState:UIControlStateNormal];
    [self addSubview:nextMonth];
        
    [nextMonth addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
    [previousMonth addTarget:self action:@selector(previousMonth) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentDate = [NSDate date];
    self.firstWeekday = [self firstWeekdayInMonth:self.currentDate];
    self.titleDateLabel.text = [self dateStringFromDate:self.currentDate];

}

/**设置日历视图*/
-(void)setupCalendarView
{
    CGFloat calendarWidth = CGRectGetWidth(self.bounds);
    CGFloat calendarHeight = CGRectGetHeight(self.bounds) - TitleHeight;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    layout.itemSize = CGSizeMake((calendarWidth-7)/7, (calendarHeight-6)/7);
    
    CGRect rect = CGRectMake(0, TitleHeight,calendarWidth ,calendarHeight) ;
    UICollectionView *view = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    view.backgroundColor = [UIColor whiteColor];
    view.scrollEnabled = NO;
    
    view.dataSource = self;
    view.delegate = self;
    [view registerClass:[LJCalendarCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView = view;
    [self addSubview:view];

}

-(UILabel *)titleDateLabel
{
    if (!_titleDateLabel) {
        _titleDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), TitleHeight)];
        [_titleDateLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleDateLabel];
    }
    
    return _titleDateLabel;
}

-(NSString *)dateStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter yearMonthFormatter];
    return [formatter stringFromDate:date];
    
}


#pragma mark - UICollectionViewDateSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSInteger daycount = [self dayCountInMonth:self.currentDate];
//    NSInteger firstweekday = [self firstWeekday];
//    NSInteger totalItem = daycount + firstweekday;
    return !section?7:142;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LJCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"%ld",(long)indexPath.row);
    }
    
    if (indexPath.section) // 日期
    {
        cell.label.textColor = [UIColor whiteColor];
        
        if (indexPath.row < self.firstWeekday) { // 上个月
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *com = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self.currentDate];
            com.month --;
            [com setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            NSDate *preDate = [calendar dateFromComponents:com];
            NSInteger preTotalDays = [self dayCountInMonth:preDate];
            NSInteger current = preTotalDays - self.firstWeekday + indexPath.row + 1;
            cell.label.text = [NSString stringWithFormat:@"%ld",(long)current];
            cell.label.backgroundColor = [UIColor orangeColor];
            
        }else if(indexPath.row >= ([self dayCountInMonth:self.currentDate]+self.firstWeekday)) // 下个月
        {
            NSInteger current = indexPath.row - ([self dayCountInMonth:self.currentDate]+self.firstWeekday) + 1;
             cell.label.text = [NSString stringWithFormat:@"%ld",(long)current];
            
            cell.label.backgroundColor = [UIColor orangeColor];
        }
        else // 当月
        {
            NSInteger day = indexPath.row-self.firstWeekday+1;
            cell.label.text = [NSString stringWithFormat:@"%ld",(long)day];
            cell.label.backgroundColor = [UIColor greenColor];
            
            NSDate *date = [self transformDateFromDay:day];
            if ([date today]) {
                cell.label.backgroundColor = [UIColor redColor];
            }

        }
        
    }else // 星期日 ~ 星期六
    {
        NSString *weekday = self.weekdayArray[indexPath.row];
        cell.label.textColor = [UIColor whiteColor];
        cell.label.backgroundColor = [UIColor redColor];

        cell.label.text = weekday;
    }
    return cell;
}


#pragma mark - UICollectionDelegate
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *selectDate = nil;
    
    if (indexPath.row < self.firstWeekday) { // 上个月
        NSDateComponents *com = [self componentsFromDate:self.currentDate];
        com.month --;
        NSInteger day = [self dayFromIndexPath:indexPath];
        selectDate = [self transformDateFromMonth:com.month Day:day];
        
    }else if(indexPath.row >= ([self dayCountInMonth:self.currentDate]+self.firstWeekday)) // 下个月
    {
        NSDateComponents *com = [self componentsFromDate:self.currentDate];
        com.month ++;
        NSInteger day = [self dayFromIndexPath:indexPath];
        selectDate = [self transformDateFromMonth:com.month Day:day];
        
    }else // 当月
    {
        selectDate = [self transformDateFromIndexPath:indexPath];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(LJCalendarView:shouldSelectDate:)]) {
        return [self.delegate LJCalendarView:self shouldSelectDate:selectDate];
    }
    return YES;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!indexPath.section) {
        return;
    }
    
    NSDate *selectDate = nil;
    
    if (indexPath.row < self.firstWeekday) { // 上个月
        NSDateComponents *com = [self componentsFromDate:self.currentDate];
        com.month --;
        NSInteger day = [self dayFromIndexPath:indexPath];
        selectDate = [self transformDateFromMonth:com.month Day:day];
        
    }else if(indexPath.row >= ([self dayCountInMonth:self.currentDate]+self.firstWeekday)) // 下个月
    {
        NSDateComponents *com = [self componentsFromDate:self.currentDate];
        com.month ++;
        NSInteger day = [self dayFromIndexPath:indexPath];
        selectDate = [self transformDateFromMonth:com.month Day:day];

    }else // 当月
    {
        selectDate = [self transformDateFromIndexPath:indexPath];
    }
    
    
   
    if (self.callBackBlock) {
        self.callBackBlock(selectDate);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(LJCalendarView:didSelectDate:)]) {
        [self.delegate LJCalendarView:self didSelectDate:selectDate];
    }
}

-(NSDateComponents *)componentsFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *com = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [com setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    return com;
}

-(NSDate *)dateFromNSDateComponents:(NSDateComponents *)com
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateFromComponents:com];
}

-(NSInteger)dayFromIndexPath:(NSIndexPath *)indexPath
{
    LJCalendarCell *cell = (LJCalendarCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    return [cell.label.text integerValue];

}

-(NSDate *)transformDateFromIndexPath:(NSIndexPath *)indexPath
{
    NSInteger day = [self dayFromIndexPath:indexPath];
    return  [self transformDateFromDay:day];

}

-(NSDate *)transformDateFromMonth:(NSInteger)month Day:(NSInteger)day
{
    NSDateComponents *com = [self componentsFromDate:self.currentDate];
    [com setDay:day];
    [com setMonth:month];
    return [self dateFromNSDateComponents:com];
}


-(NSDate *)transformDateFromDay:(NSInteger)day
{
    NSDateComponents *com = [self componentsFromDate:self.currentDate];
    return [self transformDateFromMonth:com.month Day:day];
}

/**滑动手势*/
-(void)addSwipe
{
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextMonth)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousMonth)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:right];
}

#pragma mark - 加载下个月
-(void)nextMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *com = [self componentsFromDate:self.currentDate];
    
    com.month ++;
    
    self.currentDate = [calendar dateFromComponents:com];
    [self reloadDate];
}

#pragma mark - 加载上个月
-(void)previousMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *com = [self componentsFromDate:self.currentDate];
    com.month --;
    
    self.currentDate = [calendar dateFromComponents:com];
    [self reloadDate];
}

/**刷新数据*/
-(void)reloadDate
{
    self.firstWeekday = [self firstWeekdayInMonth:self.currentDate];
    self.titleDateLabel.text = [self dateStringFromDate:self.currentDate];
    [self.collectionView reloadData];
}

-(NSArray *)weekdayArray
{
    return @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
}

#pragma mark - 计算日期
/**该月的第一天是星期几*/
-(NSInteger)firstWeekdayInMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *com = [self componentsFromDate:date];
    com.day = 1;
    NSDate *newdate = [self dateFromNSDateComponents:com];
    
    NSInteger weekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:newdate];
    
    return weekday - 1;
}

/**该月共有几天*/
-(NSInteger)dayCountInMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}


@end
