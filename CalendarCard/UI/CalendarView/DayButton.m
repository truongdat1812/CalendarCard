//
//  DayButton.m
//  DDCalendarView
//
//  Created by Truong Dat on 8/5/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import "DayButton.h"


@implementation DayButton
@synthesize delegate, buttonDate;

- (id)buttonWithFrame:(CGRect)buttonFrame {
	self = [DayButton buttonWithType:UIButtonTypeCustom];
	
	self.frame = buttonFrame;
	self.titleLabel.textAlignment = NSTextAlignmentRight;
	self.backgroundColor = [UIColor clearColor];
	[self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	
	[self addTarget:delegate action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	UILabel *titleLabel = [self titleLabel];
	CGRect labelFrame = titleLabel.frame;
	int framePadding = 4;
	labelFrame.origin.x = self.bounds.size.width - labelFrame.size.width - framePadding;
	labelFrame.origin.y = framePadding;
	
	[self titleLabel].frame = labelFrame;
}

- (void)dealloc {
    [super dealloc];
}


@end
