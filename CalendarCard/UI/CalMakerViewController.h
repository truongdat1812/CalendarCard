//
//  CalMakerViewController.h
//  CalendarCard
//
//  Created by Truong Dat on 9/4/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDCalendarView.h"
#import "TwitterUtils.h"
#import "WYPopoverController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "SelectedActionViewController.h"

@interface CalMakerViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UIScrollViewDelegate,UIActionSheetDelegate,WYPopoverControllerDelegate,ActionDelegate>{
    DDCalendarView *calendarView;
    UIImageView *backgroundImage;
    TwitterUtils *_mTwitter;
    IBOutlet UIView *settingView;
    IBOutlet UIImageView *ownPhoto;
    UIActionSheet *menuAction;
    UIDatePicker *datePicker;
    UIScrollView *mScrollView;
    UIImage *shareImage;
    UIAlertView *guideAlertView;
}
@property (readwrite) NSInteger templateType;
@property (nonatomic, retain) UIColor *monthTitleColor;
@property (nonatomic, retain) UIColor *weekTitleColor;
@property (nonatomic, retain) UIColor *dayTitleColor;
@property (readwrite) NSInteger month;
@property (readwrite) NSInteger year;

- (void)setBacgroundImage:(UIImage *)image;
- (IBAction)selectedAction:(id)sender;
- (IBAction)cancelSetting:(id)sender;
- (IBAction)doneSetting:(id)sender;
- (IBAction)choosePhoto:(id)sender;
- (IBAction)selectMonth:(id)sender;
- (IBAction)backBtnClick:(id)sender;
@end
