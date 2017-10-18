//
//    Copyright (c) 2013 yuyak
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.
//

#import "YKImageCropperViewController.h"
#import "CalMakerViewController.h"
#import "YKImageCropperView.h"

@interface YKImageCropperViewController ()

@property (nonatomic, strong) YKImageCropperView *imageCropperView;

@end

@implementation YKImageCropperViewController
@synthesize templateType;
@synthesize monthTitleColor;
@synthesize weekTitleColor;
@synthesize dayTitleColor;
@synthesize month;
@synthesize year;

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Crop Photo", @"");
        self.imageCropperView = [[YKImageCropperView alloc] initWithImage:image];
        self.imageCropperView.frame = CGRectMake(self.imageCropperView.frame.origin.x, self.imageCropperView.frame.origin.y + 40, self.imageCropperView.frame.size.width, self.imageCropperView.frame.size.height);
        [self.view addSubview:self.imageCropperView];

        int deltaY = 0;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            deltaY = 20;
        }
        
        UIImageView *tabBarIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_bg"]];
        [tabBarIV setFrame:CGRectMake(0, 0 + deltaY, 320, 44)];
        [self.view addSubview:tabBarIV];
        [tabBarIV release];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneBtn setFrame:CGRectMake(260,5 + deltaY,54,33)];
        [doneBtn setBackgroundImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        [doneBtn setTag:200];
        [self.view addSubview:doneBtn];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(10,5 + deltaY,54,33)];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"tool_back_btn.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setTag:201];
        [self.view addSubview:backBtn];
        
        UIImageView *title = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crop_title"]];
        title.frame = CGRectMake(112, 9 + deltaY, 102, 26);
        [self.view addSubview:title];
        [title release];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                              target:self
//                                                                                              action:@selector(cancelAction)];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                                                                               target:self
//                                                                                               action:@selector(doneAction)];
//
//        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                                                               target:nil
//                                                                               action:nil];
//        UIBarButtonItem *constrainButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Constrain", @"")
//                                                                            style:UIBarButtonItemStyleBordered
//                                                                           target:self
//                                                                           action:@selector(constrainAction)];
//        UIBarButtonItem *revertButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset", @"")
//                                                                            style:UIBarButtonItemStyleBordered
//                                                                           target:self.imageCropperView
//                                                                           action:@selector(reset)];
//
//        self.toolbarItems = @[space, constrainButton, space, revertButton, space];
    }
    return self;
}

- (IBAction)backBtnClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)viewDidLoad{
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController setToolbarHidden:NO animated:NO];
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    if (isNeedDismiss) {
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
    isNeedDismiss = NO;
    [super viewDidAppear:animated];
}
- (void)constrainAction {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Square", @""),
                                                                      NSLocalizedString(@"3 x 2", @""),
                                                                      NSLocalizedString(@"4 x 3", @""),
                                                                      NSLocalizedString(@"16 x 9", @""),
                                                                      nil];
    [actionSheet showInView:self.view.window];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) return;

    switch (buttonIndex) {
        case 0:
            [self.imageCropperView setConstrain:CGSizeMake(1, 1)];
            break;

        case 1:
            [self.imageCropperView setConstrain:CGSizeMake(3, 2)];
            break;

        case 2:
            [self.imageCropperView setConstrain:CGSizeMake(4, 3)];
            break;

        case 3:
            [self.imageCropperView setConstrain:CGSizeMake(16, 9)];
            break;
    }
}

- (void)cancelAction {
    if (self.cancelHandler)
        self.cancelHandler();
}

- (void)doneAction {
    if (self.doneHandler)
    {
        //self.doneHandler([self.imageCropperView editedImage]);
        CalMakerViewController *viewController = [[CalMakerViewController alloc] initWithNibName:@"CalMakerViewController" bundle:nil];
        viewController.templateType = templateType;
        viewController.monthTitleColor = monthTitleColor;
        viewController.weekTitleColor = weekTitleColor;
        viewController.dayTitleColor = dayTitleColor;
        viewController.month = month;
        viewController.year = year;
        
        [self presentViewController:viewController animated:YES completion:^{
        }];
        
        [viewController setBacgroundImage:[self.imageCropperView editedImage]];
        
        [viewController release];
        isNeedDismiss = YES;
    }
}

@end