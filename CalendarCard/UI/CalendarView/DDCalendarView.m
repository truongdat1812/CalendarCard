//
//  DDCalendarView.m
//  DDCalendarView
//
//  Created by Truong Dat on 8/5/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import "DDCalendarView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DDCalendarView
@synthesize backgroundImage;
@synthesize templateType;
@synthesize delegate;
@synthesize monthTitleColor;
@synthesize weekTitleColor;
@synthesize dayTitleColor;
@synthesize hasBorder;

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate {
	if ((self = [super initWithFrame:frame])) {
		self.delegate = theDelegate;
		
		//Initialise vars
        calendarFontName = fontName;
		calendarWidth = frame.size.width;
		calendarHeight = frame.size.height;
		cellWidth = frame.size.width / 7.0f;
		cellHeight = frame.size.height / 8.0f;
		
		//View properties
//		UIColor *bgPatternImage = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_tem1"]];
//		self.backgroundColor = bgPatternImage;
//		[bgPatternImage release];
//		backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_tem1"]];
//        backgroundImage.frame = self.frame;
//        [self addSubview:backgroundImage];
        self.backgroundColor = [UIColor clearColor];
        
		//Set up the calendar header
		UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[prevBtn setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];
		prevBtn.frame = CGRectMake(0, 0, cellWidth, cellHeight);
		[prevBtn addTarget:self action:@selector(prevBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[nextBtn setImage:[UIImage imageNamed:@"right-arrow.png"] forState:UIControlStateNormal];
		nextBtn.frame = CGRectMake(calendarWidth - cellWidth, 0, cellWidth, cellHeight);
		[nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		CGRect monthLabelFrame = CGRectMake(cellWidth, 0 - 10, calendarWidth - 2*cellWidth, cellHeight);
		monthLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
		monthLabel.font = [UIFont fontWithName:calendarFontName size:25];
		monthLabel.textAlignment = NSTextAlignmentCenter;
		monthLabel.backgroundColor = [UIColor clearColor];
		monthLabel.textColor = [UIColor blackColor];
		
		//Add the calendar header to view		
		[self addSubview: prevBtn];
		[self addSubview: nextBtn];
		[self addSubview: monthLabel];
		
		//Add the day labels to the view
		char *days[7] = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};
		for(int i = 0; i < 7; i++) {
			CGRect dayLabelFrame = CGRectMake(i*cellWidth, cellHeight, cellWidth, cellHeight);
            
            if (hasBorder)
            {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(dayLabelFrame.origin.x, dayLabelFrame.origin.y, i<6?(dayLabelFrame.size.width + 2):dayLabelFrame.size.width, dayLabelFrame.size.height)];
                [view setBackgroundColor:[UIColor clearColor]];
                [self addSubview:view];
                view.layer.borderWidth = 2;
                view.layer.borderColor = [UIColor lightGrayColor].CGColor;
                [view release];
            }
			
            UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayLabelFrame];
			dayLabel.text = [NSString stringWithFormat:@"%s", days[i]];
			dayLabel.textAlignment = NSTextAlignmentCenter;
			dayLabel.backgroundColor = [UIColor clearColor];
			dayLabel.font = [UIFont fontWithName:calendarFontName size:25];
			dayLabel.textColor = [UIColor darkGrayColor];
			
			[self addSubview:dayLabel];
			[dayLabel release];
		}
		
		[self drawDayButtons];
		
		//Set the current month and year and update the calendar
		calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		
		NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
		NSDateComponents *dateParts = [calendar components:unitFlags fromDate:[NSDate date]];
		currentMonth = [dateParts month];
		currentYear = [dateParts year];
		
		[self updateCalendarForMonth:currentMonth forYear:currentYear];
		
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate andType:(NSInteger) type {
    if ((self = [super initWithFrame:frame])) {
		self.delegate = theDelegate;
		
		//Initialise vars
        templateType = type;
        calendarFontName = fontName;
		calendarWidth = frame.size.width;
		calendarHeight = frame.size.height;
		cellWidth = frame.size.width / 7.0f;
		cellHeight = frame.size.height / 8.0f;
		
		//View properties
        //		UIColor *bgPatternImage = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_tem1"]];
        //		self.backgroundColor = bgPatternImage;
        //		[bgPatternImage release];
        //		backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_tem1"]];
        //        backgroundImage.frame = self.frame;
        //        [self addSubview:backgroundImage];
        self.backgroundColor = [UIColor clearColor];
        if (type == 2) {
            self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
            [self.layer setCornerRadius:10.0f];
            [self.layer setMasksToBounds:YES];
        }
        if (type == 0) {
            UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [prevBtn setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];
            prevBtn.frame = CGRectMake(0, 0, cellWidth, cellHeight);
            [prevBtn addTarget:self action:@selector(prevBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [nextBtn setImage:[UIImage imageNamed:@"right-arrow.png"] forState:UIControlStateNormal];
            nextBtn.frame = CGRectMake(calendarWidth - cellWidth, 0, cellWidth, cellHeight);
            [nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview: prevBtn];
            [self addSubview: nextBtn];
        }
		//Set up the calendar header

		
		CGRect monthLabelFrame = CGRectMake(cellWidth, 0 - 10, calendarWidth - 2*cellWidth, cellHeight);
		monthLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
		monthLabel.font = [UIFont fontWithName:calendarFontName size:25];
		monthLabel.textAlignment = NSTextAlignmentCenter;
		monthLabel.backgroundColor = [UIColor clearColor];
		monthLabel.textColor = [UIColor blackColor];

		//Add the calendar header to view
		[self addSubview: monthLabel];
		
		//Add the day labels to the view
		char *days[7] = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};
		for(int i = 0; i < 7; i++) {
			CGRect dayLabelFrame = CGRectMake(i*cellWidth, cellHeight, cellWidth, cellHeight);
            
            if (hasBorder)
            {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(dayLabelFrame.origin.x, dayLabelFrame.origin.y, i<6?(dayLabelFrame.size.width + 2):dayLabelFrame.size.width, dayLabelFrame.size.height)];
                [view setBackgroundColor:[UIColor clearColor]];
                [self addSubview:view];
                view.layer.borderWidth = 2;
                view.layer.borderColor = [UIColor lightGrayColor].CGColor;
                [view release];
            }
            
			UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayLabelFrame];
			dayLabel.text = [NSString stringWithFormat:@"%s", days[i]];
			dayLabel.textAlignment = NSTextAlignmentCenter;
			dayLabel.backgroundColor = [UIColor clearColor];
			dayLabel.font = [UIFont fontWithName:calendarFontName size:25];
			dayLabel.textColor = [UIColor darkGrayColor];
			[self addSubview:dayLabel];
			[dayLabel release];
		}
		
		[self drawDayButtons];
		
		//Set the current month and year and update the calendar
		calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		
		NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
		NSDateComponents *dateParts = [calendar components:unitFlags fromDate:[NSDate date]];
		currentMonth = [dateParts month];
		currentYear = [dateParts year];
		
		[self updateCalendarForMonth:currentMonth forYear:currentYear];
		
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate andType:(NSInteger) type monthHeadingColor:(UIColor *)mColor weekHeadingColor:(UIColor *)wColor dayHeadingColor:(UIColor *)dColor{
    if ((self = [super initWithFrame:frame])) {
		self.delegate = theDelegate;
		
		//Initialise vars
        templateType = type;
        calendarFontName = fontName;
		calendarWidth = frame.size.width;
		calendarHeight = frame.size.height;
		cellWidth = frame.size.width / 7.0f;
		cellHeight = frame.size.height / 8.0f;
		
		//View properties
        //		UIColor *bgPatternImage = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_tem1"]];
        //		self.backgroundColor = bgPatternImage;
        //		[bgPatternImage release];
        //		backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_tem1"]];
        //        backgroundImage.frame = self.frame;
        //        [self addSubview:backgroundImage];
        self.backgroundColor = [UIColor clearColor];
//        if (type == 2) {
//            self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
//            [self.layer setCornerRadius:10.0f];
//            [self.layer setMasksToBounds:YES];
////            self.layer.borderWidth = 3;
////            self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//        }
        
        if (type == 0) {
            UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [prevBtn setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];
            prevBtn.frame = CGRectMake(0, 0, cellWidth, cellHeight);
            [prevBtn addTarget:self action:@selector(prevBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [nextBtn setImage:[UIImage imageNamed:@"right-arrow.png"] forState:UIControlStateNormal];
            nextBtn.frame = CGRectMake(calendarWidth - cellWidth, 0, cellWidth, cellHeight);
            [nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview: prevBtn];
            [self addSubview: nextBtn];
        }
		//Set up the calendar header
        
		
		CGRect monthLabelFrame = CGRectMake(cellWidth, 0 - 10, calendarWidth - 2*cellWidth, cellHeight);
		monthLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
		monthLabel.font = [UIFont fontWithName:calendarFontName size:25];
		monthLabel.textAlignment = NSTextAlignmentCenter;
		monthLabel.backgroundColor = [UIColor clearColor];
		monthLabel.textColor = mColor;
        
		//Add the calendar header to view
		[self addSubview: monthLabel];
		
		//Add the day labels to the view
		char *days[7] = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};
		for(int i = 0; i < 7; i++) {
			CGRect dayLabelFrame = CGRectMake(i*cellWidth, cellHeight, cellWidth, cellHeight);
            
            if (hasBorder)
            {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(dayLabelFrame.origin.x, dayLabelFrame.origin.y, i<6?(dayLabelFrame.size.width + 2):dayLabelFrame.size.width, dayLabelFrame.size.height)];
                [view setBackgroundColor:[UIColor clearColor]];
                [self addSubview:view];
                view.layer.borderWidth = 2;
                view.layer.borderColor = [UIColor lightGrayColor].CGColor;
                [view release];
            }
            
			UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayLabelFrame];
			dayLabel.text = [NSString stringWithFormat:@"%s", days[i]];
			dayLabel.textAlignment = NSTextAlignmentCenter;
			dayLabel.backgroundColor = [UIColor clearColor];
			dayLabel.font = [UIFont fontWithName:calendarFontName size:25];
            if (type == 5) {
                dayLabel.font = [UIFont fontWithName:calendarFontName size:18];
            }
			dayLabel.textColor = wColor;
			[self addSubview:dayLabel];
			[dayLabel release];
		}
		monthTitleColor = mColor;
        weekTitleColor = wColor;
        dayTitleColor = dColor;
		[self drawDayButtons];
		
		//Set the current month and year and update the calendar
		calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		
		NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
		NSDateComponents *dateParts = [calendar components:unitFlags fromDate:[NSDate date]];
		currentMonth = [dateParts month];
		currentYear = [dateParts year];
		
		[self updateCalendarForMonth:currentMonth forYear:currentYear];
		
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate andType:(NSInteger) type monthHeadingColor:(UIColor *)mColor weekHeadingColor:(UIColor *)wColor dayHeadingColor:(UIColor *)dColor withBorder:(BOOL) border{
    if ((self = [super initWithFrame:frame])) {
		self.delegate = theDelegate;
		self.hasBorder = border;
		//Initialise vars
        templateType = type;
        calendarFontName = fontName;
		calendarWidth = frame.size.width;
		calendarHeight = frame.size.height;
		cellWidth = frame.size.width / 7.0f;
		cellHeight = frame.size.height / 8.0f;
		
		//View properties
        //		UIColor *bgPatternImage = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_tem1"]];
        //		self.backgroundColor = bgPatternImage;
        //		[bgPatternImage release];
        //		backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_tem1"]];
        //        backgroundImage.frame = self.frame;
        //        [self addSubview:backgroundImage];
        self.backgroundColor = [UIColor clearColor];
//        if (type == 2) {
//            self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
//            [self.layer setCornerRadius:10.0f];
//            [self.layer setMasksToBounds:YES];
//            //            self.layer.borderWidth = 3;
//            //            self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//        }
        
        if (type == 0) {
            UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [prevBtn setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];
            prevBtn.frame = CGRectMake(0, - 10, cellWidth, cellHeight);
            [prevBtn addTarget:self action:@selector(prevBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [nextBtn setImage:[UIImage imageNamed:@"right-arrow.png"] forState:UIControlStateNormal];
            nextBtn.frame = CGRectMake(calendarWidth - cellWidth, 0 - 10, cellWidth, cellHeight);
            [nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview: prevBtn];
            [self addSubview: nextBtn];
        }
		//Set up the calendar header
        
		
		CGRect monthLabelFrame = CGRectMake(cellWidth, 0 - 10, calendarWidth - 2*cellWidth, cellHeight);
		monthLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
		monthLabel.font = [UIFont fontWithName:calendarFontName size:16];
		monthLabel.textAlignment = NSTextAlignmentCenter;
		monthLabel.backgroundColor = [UIColor clearColor];
		monthLabel.textColor = mColor;
        
		//Add the calendar header to view
		[self addSubview: monthLabel];
		
		//Add the day labels to the view
		char *days[7] = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};
		for(int i = 0; i < 7; i++) {
			CGRect dayLabelFrame = CGRectMake(i*cellWidth, cellHeight - 10, cellWidth, cellHeight);
            if (templateType == 0) {
                dayLabelFrame = CGRectMake(i*cellWidth, cellHeight - 12, cellWidth, cellHeight);
            }
            if (hasBorder)
            {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(dayLabelFrame.origin.x, dayLabelFrame.origin.y, i<6?(dayLabelFrame.size.width + 2):dayLabelFrame.size.width, dayLabelFrame.size.height)];
                [view setBackgroundColor:[UIColor clearColor]];
                [self addSubview:view];
                view.layer.borderWidth = 2;
                view.layer.borderColor = [UIColor lightGrayColor].CGColor;
                [view release];
            }
            
			UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayLabelFrame];
			dayLabel.text = [NSString stringWithFormat:@"%s", days[i]];
			dayLabel.textAlignment = NSTextAlignmentCenter;
			dayLabel.backgroundColor = [UIColor clearColor];
			dayLabel.font = [UIFont fontWithName:calendarFontName size:16];
            if (type == 5) {
                dayLabel.font = [UIFont fontWithName:calendarFontName size:18];
            }
			dayLabel.textColor = wColor;
			[self addSubview:dayLabel];
			[dayLabel release];
		}
		monthTitleColor = mColor;
        weekTitleColor = wColor;
        dayTitleColor = dColor;
		[self drawDayButtons];
		
		//Set the current month and year and update the calendar
		calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		
		NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
		NSDateComponents *dateParts = [calendar components:unitFlags fromDate:[NSDate date]];
		currentMonth = [dateParts month];
		currentYear = [dateParts year];
		
		[self updateCalendarForMonth:currentMonth forYear:currentYear];
		
    }
    return self;
}

- (void)drawDayButtons {
	dayButtons = [[NSMutableArray alloc] initWithCapacity:42];
	for (int i = 0; i < 6; i++) {
		for(int j = 0; j < 7; j++) {
            CGRect buttonFrame = CGRectMake(j*cellWidth - 40, (i+2)*cellHeight, cellWidth, cellHeight);
            if (templateType == 5 || templateType == 7) {
                buttonFrame = CGRectMake(j*cellWidth - 5, (i+2)*cellHeight, cellWidth, cellHeight);
            }
            
            if (templateType == 0 || templateType == 2) {
                 buttonFrame = CGRectMake(j*cellWidth, (i+2)*cellHeight - 13, cellWidth, cellHeight);
            }
            if (templateType == 3 || templateType == 9) {
                buttonFrame = CGRectMake(j*cellWidth - 15, (i+2)*cellHeight, cellWidth, cellHeight);
            }
            
            if (hasBorder)
            {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(buttonFrame.origin.x, buttonFrame.origin.y, j<6?(buttonFrame.size.width + 2):buttonFrame.size.width, i < 5?(buttonFrame.size.height + 2):buttonFrame.size.height)];
                [view setBackgroundColor:[UIColor clearColor]];
                [self addSubview:view];
                view.layer.borderWidth = 2;
                view.layer.borderColor = [UIColor lightGrayColor].CGColor;
                [view release];
            }
            
            DayButton *dayButton = [[DayButton alloc] buttonWithFrame:buttonFrame];
            dayButton.titleLabel.font = [UIFont fontWithName:calendarFontName size:30];
            [dayButton setTitleColor:dayTitleColor forState:UIControlStateNormal];
            
            if (templateType == 0) {
                dayButton.titleLabel.font = [UIFont fontWithName:calendarFontName size:16];
            }
            if (templateType == 2) {
                dayButton.titleLabel.font = [UIFont fontWithName:calendarFontName size:25];
            }
            
            if (templateType == 5) {
                dayButton.titleLabel.font = [UIFont fontWithName:calendarFontName size:18];
            }
            
			dayButton.delegate = self;
			
//            if (templateType == 0) {
//                NSDate *today = [NSDate date];
//                
//                NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
//                mmddccyy.timeStyle = NSDateFormatterNoStyle;
//                mmddccyy.dateFormat = @"MM/dd/yyyy";
//                NSString *dateString = [mmddccyy stringFromDate:today];
//                NSArray *chunks = [dateString componentsSeparatedByString:@"/"];
//                int month1 = [chunks[0] integerValue];
//                int day1 = [chunks[1] integerValue];
//                int year1 = [chunks[2] integerValue];
//                
//                NSString *dateString2 = [mmddccyy stringFromDate:dayButton.buttonDate];
//                NSArray *chunks2 = [dateString2 componentsSeparatedByString:@"/"];
//                int month2 = [chunks2[0] integerValue];
//                int day2 = [chunks2[1] integerValue];
//                int year2 = [chunks2[2] integerValue];
//                
//                if (day1 == day2 && month1 == month2 && year1 == year2) {
//                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(buttonFrame.origin.x, buttonFrame.origin.y, j<6?(buttonFrame.size.width + 2):buttonFrame.size.width, i < 5?(buttonFrame.size.height + 2):buttonFrame.size.height)];
//                    [view setBackgroundColor:[UIColor lightGrayColor]];
//                    [self addSubview:view];
//                    view.layer.borderWidth = 2;
//                    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
//                    [view release];
//                }
//                
//                [mmddccyy release];
//            }
            
			[dayButtons addObject:dayButton];
			[dayButton release];
			
			[self addSubview:[dayButtons lastObject]];
		}
	}
}
			 
- (void)updateCalendarForMonth:(int)month forYear:(int)year {
	char *months[12] = {"January", "Febrary", "March", "April", "May", "June",
		"July", "August", "September", "October", "November", "December"};
	monthLabel.text = [NSString stringWithFormat:@"%s %d", months[month - 1], year];
	
	//Get the first day of the month
	NSDateComponents *dateParts = [[NSDateComponents alloc] init];
	[dateParts setMonth:month];
	[dateParts setYear:year];
	[dateParts setDay:1];
	NSDate *dateOnFirst = [calendar dateFromComponents:dateParts];
	[dateParts release];
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:dateOnFirst];
	int weekdayOfFirst = [weekdayComponents weekday];	
	
	//Map first day of month to a week starting on Monday
	//as the weekday component defaults to 1->Sun, 2->Mon...
	if(weekdayOfFirst == 1) {
		weekdayOfFirst = 7;
	} else {
		--weekdayOfFirst;
	}

	int numDaysInMonth = [calendar rangeOfUnit:NSDayCalendarUnit 
										inUnit:NSMonthCalendarUnit 
											forDate:dateOnFirst].length;
	
	int day = 1;
	for (int i = 0; i < 6; i++) {
		for(int j = 0; j < 7; j++) {
			int buttonNumber = i * 7 + j;
			
			DayButton *button = [dayButtons objectAtIndex:buttonNumber];
			
			button.enabled = NO; //Disable buttons by default
			[button setTitle:nil forState:UIControlStateNormal]; //Set title label text to nil by default
			[button setButtonDate:nil];
			
			if(buttonNumber >= (weekdayOfFirst - 1) && day <= numDaysInMonth) {
				[button setTitle:[NSString stringWithFormat:@"%d", day] 
												forState:UIControlStateNormal];
				
				NSDateComponents *dateParts = [[NSDateComponents alloc] init];
				[dateParts setMonth:month];
				[dateParts setYear:year];
				[dateParts setDay:day];
				NSDate *buttonDate = [calendar dateFromComponents:dateParts];
				[dateParts release];
				[button setButtonDate:buttonDate];
				
				button.enabled = YES;
				++day;
			}
		}
	}
}

- (void)prevBtnPressed:(id)sender {
	if(currentMonth == 1) {
		currentMonth = 12;
		--currentYear;
	} else {
		--currentMonth;
	}
	
	[self updateCalendarForMonth:currentMonth forYear:currentYear];
	
	if ([self.delegate respondsToSelector:@selector(prevButtonPressed)]) {
		[self.delegate prevButtonPressed];
	}
}

- (void)nextBtnPressed:(id)sender {
	if(currentMonth == 12) {
		currentMonth = 1;
		++currentYear;
	} else {
		++currentMonth;
	}
	
	[self updateCalendarForMonth:currentMonth forYear:currentYear];
	
	if ([self.delegate respondsToSelector:@selector(nextButtonPressed)]) {
		[self.delegate nextButtonPressed];
	}
}

- (void) backgroundChanged:(UIImage *)image{
    
}

- (void)dayButtonPressed:(id)sender {
	DayButton *dayButton = (DayButton *) sender;
	[self.delegate dayButtonPressed:dayButton];
}

- (void)dealloc {
	[calendar release];
	[dayButtons release];
    [super dealloc];
}


@end
