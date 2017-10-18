//
//  HomeViewController.h
//  CalendarCard
//
//  Created by Truong Dat on 9/3/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCalendarView.h"

@interface HomeViewController : UIViewController<DDCalendarViewDelegate>
{
    DDCalendarView *calendarView;
    IBOutlet UIView *imageV;
    IBOutlet UIView *calView;
    IBOutlet UIView *monthView;
}

- (IBAction)createNew:(id)sender;
- (IBAction)infomation:(id)sender;

@end
