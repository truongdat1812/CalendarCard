//
//  CropImageViewController.h
//  CalendarCard
//
//  Created by Truong Dat on 9/4/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleAndMoveObject.h"

@interface CropImageViewController : UIViewController<SPUserResizableViewDelegate>
{
    UIImageView *imageCropView;
    ScaleAndMoveObject *cropView;
    CGRect imageFrame;
    IBOutlet UIButton *actionBtn;
    BOOL isNeedDismiss;
    UIImage *imageToCrop;
}

@property (readwrite) NSInteger templateType;
@property (nonatomic, retain) UIColor *monthTitleColor;
@property (nonatomic, retain) UIColor *weekTitleColor;
@property (nonatomic, retain) UIColor *dayTitleColor;
@property (nonatomic, retain) NSDate *calDate;

- (void)setCropImage:(UIImage *)image;
- (void) setImageFrame:(CGRect )frame;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)cropAndDone:(id)sender;
@end
