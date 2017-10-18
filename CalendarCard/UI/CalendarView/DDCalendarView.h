//
//  DDCalendarView.h
//  DDCalendarView
//
//  Created by Truong Dat on 8/5/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayButton.h"

@protocol DDCalendarViewDelegate <NSObject>
- (void)dayButtonPressed:(DayButton *)button;

@optional
- (void)prevButtonPressed;
- (void)nextButtonPressed;

@end

@interface DDCalendarView : UIView <DayButtonDelegate> {
	id <DDCalendarViewDelegate> delegate;
	NSString *calendarFontName;
	UILabel *monthLabel;
	NSMutableArray *dayButtons;
	NSCalendar *calendar;
	float calendarWidth;
	float calendarHeight;
	float cellWidth;
	float cellHeight;
	int currentMonth;
	int currentYear;
    UIImageView *backgroundImage;
}
@property (readwrite) NSInteger templateType;
@property(nonatomic, assign) id <DDCalendarViewDelegate> delegate;
@property (nonatomic, retain) UIImageView *backgroundImage;
@property (nonatomic, retain) UIColor *monthTitleColor;
@property (nonatomic, retain) UIColor *weekTitleColor;
@property (nonatomic, retain) UIColor *dayTitleColor;
@property (readwrite) BOOL hasBorder;

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate;
- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate andType:(NSInteger) type;
- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate andType:(NSInteger) type monthHeadingColor:(UIColor *)mColor weekHeadingColor:(UIColor *)wColor dayHeadingColor:(UIColor *)dColor;
- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate andType:(NSInteger) type monthHeadingColor:(UIColor *)mColor weekHeadingColor:(UIColor *)wColor dayHeadingColor:(UIColor *)dColor withBorder:(BOOL) border;
- (void)updateCalendarForMonth:(int)month forYear:(int)year;
- (void)drawDayButtons;
- (void)prevBtnPressed:(id)sender;
- (void)nextBtnPressed:(id)sender;
- (void) backgroundChanged:(UIImage *)image;
@end
