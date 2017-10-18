//
//  HomeViewController.m
//  CalendarCard
//
//  Created by Truong Dat on 9/3/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TemplateViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)dealloc{
    [calendarView release];
    [imageV release];
    [calView release];
    [monthView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [imageV.layer setCornerRadius:5.0f];
    [imageV.layer setMasksToBounds:YES];
    imageV.layer.borderWidth = 2;
    imageV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [calView.layer setCornerRadius:10.0f];
    [calView.layer setMasksToBounds:YES];
    calView.layer.borderWidth = 2;
    calView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIColor *bgPatternImage = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"frame_0.png"]];
    monthView.backgroundColor = bgPatternImage;

    calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(monthView.frame.origin.x, monthView.frame.origin.y + 33, monthView.frame.size.width, monthView.frame.size.height - 30 ) fontName:@"AmericanTypewriter" delegate:self andType:0 monthHeadingColor:[UIColor blackColor] weekHeadingColor:[UIColor darkGrayColor] dayHeadingColor:[UIColor darkGrayColor] withBorder:YES];
    
    [monthView addSubview:calendarView];

    
}

- (void)dayButtonPressed:(DayButton *)button {
	//For the sake of example, we obtain the date from the button object
	//and display the string in an alert view
    //	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    //	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
    //	NSString *theDate = [dateFormatter stringFromDate:button.buttonDate];
    //	[dateFormatter release];
    //
    //	UIAlertView *dateAlert = [[UIAlertView alloc]
    //                              initWithTitle:@"Date Pressed"
    //                              message:theDate
    //                              delegate:self
    //                              cancelButtonTitle:@"Ok"
    //                              otherButtonTitles:nil];
    //	[dateAlert show];
    //	[dateAlert release];
}

- (void)nextButtonPressed {
	NSLog(@"Next...");
}

- (void)prevButtonPressed {
	NSLog(@"Prev...");
}

- (IBAction)createNew:(id)sender{
    TemplateViewController *viewController = [[TemplateViewController alloc] initWithNibName:@"TemplateViewController" bundle:nil];
    [self presentViewController:viewController animated:YES completion:^{}];
    [viewController release];
}

- (IBAction)infomation:(id)sender{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
