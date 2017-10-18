//
//  DayButton.h
//  DDCalendarView
//
//  Created by Truong Dat on 8/5/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DayButtonDelegate <NSObject>
- (void)dayButtonPressed:(id)sender;
@end

@interface DayButton : UIButton {
	id <DayButtonDelegate> delegate;
	NSDate *buttonDate;
}

@property (nonatomic, assign) id <DayButtonDelegate> delegate;
@property (nonatomic, copy) NSDate *buttonDate;

- (id)buttonWithFrame:(CGRect)buttonFrame;

@end
