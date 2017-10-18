//
//  TemplateViewController.h
//  CalendarCard
//
//  Created by Truong Dat on 9/3/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerController.h"
#import "Coverflow/CoverflowViewController.h"

@interface TemplateViewController : UIViewController<ColorPickerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    IBOutlet UIView *settingView;
    IBOutlet UIView *templateView;
    NSInteger currTemplate;
    IBOutlet UIButton *photoChooseView;
    IBOutlet UILabel *monthLevel;
    NSInteger typeColor;
    NSDate *mDate;
    BOOL useOwnPhoto;
    IBOutlet UIPickerView *pickerView;
    NSArray *monthArray;
    CoverflowViewController *coverFlow;
    NSMutableArray *covers;
    UIImage *selectedImage;
    NSInteger mMonth;
}

- (IBAction)backToHome:(id)sender;
- (IBAction)choosePhoto:(id)sender;
- (IBAction)selectMonth:(id)sender;
- (IBAction)monthColor:(id)sender;
- (IBAction)weekColor:(id)sender;
- (IBAction)dayColor:(id)sender;
- (IBAction)coverFlow:(id)sender;
- (IBAction)create:(id)sender;

@end
