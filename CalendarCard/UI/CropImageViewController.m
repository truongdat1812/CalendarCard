//
//  CropImageViewController.m
//  CalendarCard
//
//  Created by Truong Dat on 9/4/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import "CropImageViewController.h"
#import "CalMakerViewController.h"

@interface CropImageViewController ()

@end

@implementation CropImageViewController
@synthesize templateType;
@synthesize monthTitleColor;
@synthesize weekTitleColor;
@synthesize dayTitleColor;
@synthesize calDate;

- (void)dealloc
{
    [monthTitleColor release];
    [weekTitleColor release];
    [dayTitleColor release];
    [calDate release];
    [imageCropView release];
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

- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageCropView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"template_4.jpg"]];
    [self.view addSubview:imageCropView];
    
    int deltaY = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        deltaY = 20;
    }
    
    UIImageView *tabBarIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_bg"]];
    [tabBarIV setFrame:CGRectMake(0, deltaY, 320, 44)];
    [self.view addSubview:tabBarIV];
	[tabBarIV release];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setFrame:CGRectMake(260,5 + deltaY,54,33)];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"crop"] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(cropAndDone:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTag:200];
    [self.view addSubview:doneBtn];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(10,5 + deltaY,54,33)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"tool_back_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTag:201];
    [self.view addSubview:backBtn];
    
    UIImageView *title = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crop_title"]];
    title.frame = CGRectMake(112, 9, 102, 26);
    [self.view addSubview:title];
    [title release];
    
    imageCropView.frame = CGRectMake((self.view.frame.size.width - imageCropView.frame.size.width)/2, (self.view.frame.size.height - imageCropView.frame.size.height)/2 + 44 + deltaY, imageCropView.frame.size.width, imageCropView.frame.size.height);
    
    // Do any additional setup after loading the view from its nib.
    CGSize frameSize;
    switch (templateType) {
        case 1:
            frameSize = CGSizeMake(748*2.5, 480*2.5);
            break;
        case 2:
            frameSize = CGSizeMake(250, 270);
            break;
        case 3:
            frameSize = CGSizeMake(444/1.5, 450/1.5);
            break;
        case 4:
            frameSize = CGSizeMake(720/2.3, 465/2.3);
            break;
        case 5:
            frameSize = CGSizeMake(353/1.2, 400/1.2);
            break;
        case 6:
            frameSize = CGSizeMake(570/1.8, 340/1.8);
            break;
        case 7:
            frameSize = CGSizeMake(402/1.3, 550/1.3);
            break;
        case 8:
            frameSize = CGSizeMake(540/1.8, 360/1.8);
            break;
        case 9:
            frameSize = CGSizeMake(264, 180);
            break;
        default:
            frameSize = CGSizeMake(200, 360);
            break;
    }
    
    CGRect gripFrame = CGRectMake((self.view.frame.size.width - frameSize.width)/2, (self.view.frame.size.height - frameSize.height + 44)/2, frameSize.width, frameSize.height);
    imageFrame = gripFrame;
    ScaleAndMoveObject *userResizableView = [[ScaleAndMoveObject alloc] initWithFrame:gripFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:gripFrame];
    [contentView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8]];
    userResizableView.contentView = contentView;
    userResizableView.delegate = self;
    [userResizableView showEditingHandles];
    cropView = [userResizableView retain];
    [self.view addSubview:userResizableView];
    [contentView release];
    [userResizableView release];
}

- (void)viewDidAppear:(BOOL)animated{
    if (isNeedDismiss) {
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
    isNeedDismiss = NO;
}
// Called when the resizable view receives touchesBegan: and activates the editing handles.
- (void)userResizableViewDidBeginEditing:(ScaleAndMoveObject *)userResizableView{
    
}

// Called when the resizable view receives touchesEnded: or touchesCancelled:
- (void)userResizableViewDidEndEditing:(ScaleAndMoveObject *)userResizableView
{
    imageFrame = cropView.contentView.frame;
}

- (IBAction)donekBtnClick:(id)sende{
    CalMakerViewController *viewController = [[CalMakerViewController alloc] initWithNibName:@"CalMakerViewController" bundle:nil];
    viewController.templateType = templateType;
    viewController.monthTitleColor = monthTitleColor;
    viewController.weekTitleColor = weekTitleColor;
    viewController.dayTitleColor = dayTitleColor;
    //viewController.calDate = calDate;
    
    [self presentViewController:viewController animated:YES completion:^{
    }];
    
    [viewController setBacgroundImage:imageCropView.image];
    
    [viewController release];
    isNeedDismiss = YES;
}
- (IBAction)backBtnClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)cropAndDone:(id)sender{
    if (cropView.isHidden) {
        [self donekBtnClick:nil];
    }else{
        [self crop:nil];
        UIButton *btn = (UIButton *)[self.view viewWithTag:200];
        [btn setBackgroundImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    }
}
- (IBAction)crop:(id)sender{
    // UIImage *output = [self resizeToSize:imageCropView.frame.size thenCropWithRect:imageFrame withImage:imageCropView.image];
    CGImageRef   imageRef;
    imageFrame = CGRectMake(cropView.frame.origin.x - imageCropView.frame.origin.x, cropView.frame.origin.y - imageCropView.frame.origin.y, cropView.frame.size.width, cropView.frame.size.height);
    NSLog(@"Crop image in rect (%f, %f, %f, %f)" ,imageFrame.origin.x,imageFrame.origin.y,imageFrame.size.width, imageFrame.size.height);
    
    if ( ( imageRef = CGImageCreateWithImageInRect( imageCropView.image.CGImage, CGRectMake(imageFrame.origin.x + 5, imageFrame.origin.y + 5, imageFrame.size.width - 10, imageFrame.size.height - 10)) ) )
    {
        imageCropView.image = [[[UIImage alloc] initWithCGImage: imageRef] autorelease];
    }
    
    imageCropView.frame = CGRectMake(imageFrame.origin.x + imageCropView.frame.origin.x + 5,imageFrame.origin.y +imageCropView.frame.origin.y + 5,imageFrame.size.width - 10,imageFrame.size.height - 10);
    cropView.hidden = YES;
}

- (void) setImageFrame:(CGRect )frame{
    imageFrame = frame;
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setCropImage:(UIImage *)image{
//    if (image.size.width > self.view.frame.size.width) {
//        float scale = self.view.frame.size.width/image.size.width;
//        image = [UIImage imageWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
//        //image = [self imageWithImage:image scaledToSize:CGSizeMake(self.view.frame.size.width, (self.view.frame.size.height - 44)/scale)];
//    }
//    
//    if (image.size.height > self.view.frame.size.height - 44) {
//        float scale = self.view.frame.size.height/image.size.height;
//        image = [UIImage imageWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
//        //image = [self imageWithImage:image scaledToSize:CGSizeMake(self.view.frame.size.width/scale, self.view.frame.size.height - 44)];
//    }
    
    image = [self imageWithImage:image scaledToSize:CGSizeMake(image.size.width , image.size.height)];
    
    //imageToCrop = [image retain];
    
    imageCropView.image = image;
    imageCropView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    
//    if (cropView.frame.size.width > imageCropView.frame.size.width) {
//        float scale = cropView.frame.size.width/imageCropView.frame.size.width;
//        [cropView setFrame:CGRectMake(imageCropView.frame.origin.x, imageCropView.frame.origin.y, imageCropView.frame.size.width, cropView.frame.size.height/scale)];
//    }
//    
//    if (cropView.frame.size.height > imageCropView.frame.size.height) {
//        float scale = cropView.frame.size.height/imageCropView.frame.size.height;
//        [cropView setFrame:CGRectMake(imageCropView.frame.origin.x, imageCropView.frame.origin.y, cropView.frame.size.width/scale, imageCropView.frame.size.height)];
//    }
    
    NSLog(@"setCropImage %f, %f",image.size.width,image.size.height);
}

- (UIImage *) resizeToSize:(CGSize) newSize thenCropWithRect:(CGRect) cropRect withImage:(UIImage *)image{
    CGContextRef                context;
    CGImageRef                  imageRef;
    CGSize                      inputSize;
    UIImage                     *outputImage = nil;
    CGFloat                     scaleFactor, width;
    
    // resize, maintaining aspect ratio:
    
    inputSize = image.size;
    scaleFactor = newSize.height / inputSize.height;
    width = roundf( inputSize.width * scaleFactor );
    
    if ( width > newSize.width ) {
        scaleFactor = newSize.width / inputSize.width;
        newSize.height = roundf( inputSize.height * scaleFactor );
    } else {
        newSize.width = width;
    }
    
    UIGraphicsBeginImageContext( newSize );
    
    context = UIGraphicsGetCurrentContext();
    CGContextDrawImage( context, CGRectMake( 0, 0, newSize.width, newSize.height ), image.CGImage );
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    inputSize = newSize;
    
    // constrain crop rect to legitimate bounds
    if ( cropRect.origin.x >= inputSize.width || cropRect.origin.y >= inputSize.height ) return outputImage;
    if ( cropRect.origin.x + cropRect.size.width >= inputSize.width ) cropRect.size.width = inputSize.width - cropRect.origin.x;
    if ( cropRect.origin.y + cropRect.size.height >= inputSize.height ) cropRect.size.height = inputSize.height - cropRect.origin.y;
    
    // crop
    if ( ( imageRef = CGImageCreateWithImageInRect( outputImage.CGImage, cropRect ) ) ) {
        outputImage = [[[UIImage alloc] initWithCGImage: imageRef] autorelease];
        CGImageRelease( imageRef );
    }
    
    return outputImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

