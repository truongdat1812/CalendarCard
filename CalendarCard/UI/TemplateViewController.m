//
//  TemplateViewController.m
//  CalendarCard
//
//  Created by Truong Dat on 9/3/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import "TemplateViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CropImageViewController.h"
#import "YKImageCropperViewController.h"
#import "CalMakerViewController.h"
#import "SVProgressHUD.h"
@interface TemplateViewController ()

@end

@implementation TemplateViewController

- (void)dealloc{
    [covers release];
    [coverFlow release];
    [super dealloc];
}
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"template_bg.png"]];
    
    monthArray = [[NSArray alloc] initWithObjects:@"January", @"Febrary", @"March", @"April", @"May", @"June",
                  @"July", @"August", @"September", @"October", @"November", @"December",nil];

    [SVProgressHUD showWithStatus:@"YATH"];
    
    covers = [[NSMutableArray alloc] initWithObjects:
              @"cover_1.jpg",@"cover_2.jpg",
              @"cover_3.jpg",@"cover_4.jpg",
              @"cover_5.jpg",@"cover_6.jpg",
              @"cover_7.jpg",@"cover_8.jpg",
              @"cover_9.jpeg",@"cover_10.jpg",@"cover_11.jpg",nil];
    
    coverFlow = [[CoverflowViewController alloc] init];
    [coverFlow setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    coverFlow.delegate = self;
    
    [photoChooseView.layer setCornerRadius:5.0f];
    [photoChooseView.layer setMasksToBounds:YES];
    photoChooseView.layer.borderWidth = 3;
    photoChooseView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    //Friday, August 23, 2013
    mDate = [[NSDate date] retain];
    NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
    mmddccyy.timeStyle = NSDateFormatterNoStyle;
    mmddccyy.dateFormat = @"MM/dd/yyyy";
    NSString *dateString = [mmddccyy stringFromDate:mDate];
    NSArray *chunks = [dateString componentsSeparatedByString:@"/"];
    
    //NSLog(@"chunks[0] = %@",chunks[0]);
    [mmddccyy release];
    NSInteger month = [chunks[0] integerValue];
    if (month < 0 || month > 12) {
        monthLevel.text = @"September";
        mMonth = 9;
    }else{
        mMonth = month;
        monthLevel.text = monthArray[month - 1];
    }
    currTemplate = 2;
    
    UIButton *button4 = (UIButton *)[settingView viewWithTag:108];
    button4.frame = CGRectMake(39, 204, 226, 186);
    [button4.layer setCornerRadius:5.0f];
    [button4.layer setMasksToBounds:YES];
    button4.layer.borderWidth = 3;
    button4.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToHome:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)choosePhoto:(id)sender{
    UIActionSheet* act = [[UIActionSheet alloc]
                          initWithTitle:NSLocalizedString(@"Choice photo", nil)
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                          destructiveButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"Take a photo", nil), NSLocalizedString(@"From Albums", nil), nil];
    act.tag = 101;
    [act showInView:self.view];
    [act release];
}

- (void) takePhoto{
    UIImagePickerController * picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //Select front facing camera if possible
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
            picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil] autorelease];
        picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}

- (void)loadPhoto{
    
    UIImagePickerController * picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.delegate = self;
	picker.mediaTypes = [[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil] autorelease];
	
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 610) {
        return;
    }
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self loadPhoto];
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    [photoChooseView setBackgroundImage:image forState:UIControlStateNormal];
    selectedImage = image;
    useOwnPhoto = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectMonth:(id)sender{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Select month\n\n\n\n\n\n\n\n\n\n\n"
                                                      delegate:self
                                             cancelButtonTitle:@"Done"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:nil, nil];
    menu.frame = CGRectMake(0, 0, 350, 500);
    // Add the picker
    [menu setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    //pickerView = [[UIPickerView alloc] init ];//WithFrame:CGRectMake(0, 0, 275, 500)];
    pickerView.frame = CGRectMake(0, 15, 350, 200);
    // [pickerView setFrame:CGRectMake(0, 30, 320, 200)];
    pickerView.delegate =self;
    pickerView.dataSource=self;
    
    [menu addSubview:pickerView];
    [menu showInView:self.view];
    menu.tag = 610;
    [menu release];
}
- (IBAction)monthColor:(id)sender{
    ColorPickerController *colorPicker = [[ColorPickerController alloc] initWithColor:[UIColor redColor] andTitle:@"Color Picker"];
    colorPicker.delegate = self;
    [self presentViewController:colorPicker animated:YES completion:^{}];
    typeColor = 1;
    [colorPicker release];
}

- (IBAction)weekColor:(id)sender{
    ColorPickerController *colorPicker = [[ColorPickerController alloc] initWithColor:[UIColor redColor] andTitle:@"Color Picker"];
    colorPicker.delegate = self;
    [self presentViewController:colorPicker animated:YES completion:^{}];
    typeColor = 2;
    [colorPicker release];
}

- (IBAction)dayColor:(id)sender{
    ColorPickerController *colorPicker = [[ColorPickerController alloc] initWithColor:[UIColor redColor] andTitle:@"Color Picker"];
    colorPicker.delegate = self;
    [self presentViewController:colorPicker animated:YES completion:^{}];
    typeColor = 3;
    [colorPicker release];
}

- (IBAction)coverFlow:(id)sender{
    [self presentViewController:coverFlow animated:YES completion:nil];
}
- (void)colorPickerSaved:(ColorPickerController *)controller{
    UIColor *color = [controller selectedColor];
    UIButton *button;
    switch (typeColor) {
        case 1:
            button = (UIButton *)[settingView viewWithTag:100];
            [button setBackgroundColor:color];
            break;
        case 2:
            button = (UIButton *)[settingView viewWithTag:101];
            [button setBackgroundColor:color];
            break;
        case 3:
            button = (UIButton *)[settingView viewWithTag:102];
            [button setBackgroundColor:color];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)colorPickerCancelled:(ColorPickerController *)controller{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) selectImageAtIndex:(NSInteger) index;{
    NSLog(@"selectImageAtIndex = %d",index);
    currTemplate = index + 1;
    UIButton *button1 = (UIButton *)[settingView viewWithTag:100];
    [button1 setBackgroundColor:[UIColor darkTextColor]];
    UIButton *button2 = (UIButton *)[settingView viewWithTag:101];
    [button2 setBackgroundColor:[UIColor darkGrayColor]];
    UIButton *button3 = (UIButton *)[settingView viewWithTag:102];
    [button3 setBackgroundColor:[UIColor darkGrayColor]];
    
    if (currTemplate == 5 || currTemplate == 7 || currTemplate == 6 || currTemplate == 11) {
        [button1 setBackgroundColor:[UIColor whiteColor]];
        [button2 setBackgroundColor:[UIColor whiteColor]];
        [button3 setBackgroundColor:[UIColor whiteColor]];
    }
    
    NSString *imageName = [covers objectAtIndex:index];
    //NSLog(@"imageName %@",imageName);
    UIButton *button4 = (UIButton *)[settingView viewWithTag:108];
    [button4 setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (currTemplate == 3 || currTemplate == 5 || currTemplate == 7 || currTemplate == 9)
    {
        button4.frame = CGRectMake(19, 204, 266, 186);
    }else{
        button4.frame = CGRectMake(39, 204, 226, 186);
    }
}


- (IBAction)create:(id)sender
{
    NSString *month = monthLevel.text;
    UITextField *textField = (UITextField *)[settingView viewWithTag:103];
    [textField resignFirstResponder];
    NSString *date = [NSString stringWithFormat:@"%@/%@/%@",@"10",month,textField.text];
    
    NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
    mmddccyy.timeStyle = NSDateFormatterNoStyle;
    mmddccyy.dateFormat = @"dd/MM/yyyy";
    mDate = [mmddccyy dateFromString:date];
    [mmddccyy release];
    
    if (useOwnPhoto) {
//        CropImageViewController *viewController = [[CropImageViewController alloc] initWithNibName:@"CropImageViewController" bundle:nil];
//        
//        viewController.templateType = currTemplate;
//        UIButton *button1 = (UIButton *)[settingView viewWithTag:100];
//        viewController.monthTitleColor = button1.backgroundColor;
//        
//        UIButton *button2 = (UIButton *)[settingView viewWithTag:101];
//        viewController.weekTitleColor = button2.backgroundColor;
//        
//        UIButton *button3 = (UIButton *)[settingView viewWithTag:102];
//        viewController.dayTitleColor = button3.backgroundColor;
//        viewController.calDate = mDate;
//        
//        [self presentViewController:viewController animated:YES completion:^{}];
//        [viewController setCropImage:selectedImage];
//        [viewController release];
        // Add root view controller
        UIImage *image = selectedImage;
        YKImageCropperViewController *viewController = [[YKImageCropperViewController alloc] initWithImage:image];
        viewController.cancelHandler = ^() {
            NSLog(@"* Cancel");
        };
        viewController.doneHandler = ^(UIImage *editedImage) {
            NSLog(@"* Done");
            NSLog(@"Original: %@, Edited: %@", NSStringFromCGSize(image.size), NSStringFromCGSize(editedImage.size));
            //[photoChooseView setBackgroundImage:editedImage forState:UIControlStateNormal];
        };
        
        viewController.templateType = currTemplate;
        UIButton *button1 = (UIButton *)[settingView viewWithTag:100];
        viewController.monthTitleColor = button1.backgroundColor;
       
        UIButton *button2 = (UIButton *)[settingView viewWithTag:101];
        viewController.weekTitleColor = button2.backgroundColor;
        
        UIButton *button3 = (UIButton *)[settingView viewWithTag:102];
        viewController.dayTitleColor = button3.backgroundColor;
        viewController.month = mMonth;
        UITextField *textF = (UITextField *) [settingView viewWithTag:103];
        viewController.year = [textF.text integerValue];
        
        [self presentViewController:viewController animated:YES completion:^{}];
        [viewController release];
        //useOwnPhoto = NO;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Use defaut photo? Click cancel and choose your own photo!", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        selectedImage = [UIImage imageNamed:@"default_bg.jpg"];
        [photoChooseView setBackgroundImage:selectedImage forState:UIControlStateNormal];
        useOwnPhoto = YES;
        [self create:nil];
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return monthArray.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return monthArray[row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    mMonth = row + 1;
    monthLevel.text = monthArray[row];
}

- (NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    NSString *string = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return string;
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//
//}
// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
// became first responder
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//
//}          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

//- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
// called when 'return' key pressed. return NO to ignore.

@end
