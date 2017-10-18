//
//  SelectedActionViewController.m
//  CalendarCreator
//
//  Created by Truong Dat on 8/13/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import "SelectedActionViewController.h"
//#import <FacebookSDK/FacebookSDK.h>

@interface SelectedActionViewController ()
//<FBLoginViewDelegate>

@end

@implementation SelectedActionViewController
@synthesize delegate;

- (void)dealloc{
    [delegate release];
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil)
    //{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    //}
    NSString *imgName = @"";
    if (indexPath.row == 0) {
        imgName = @"picture.png";
    }
    if(indexPath.row == 1) {
        if (!isLogined) {
//            FBLoginView *loginview = [[FBLoginView alloc] init];
//
//            loginview.frame = CGRectOffset(loginview.frame, 0, 0);
//            loginview.delegate = self;
//
//            [cell.contentView addSubview:loginview];
//
//            [loginview sizeToFit];
        }
        imgName = @"facebook-icon";
    }
    if(indexPath.row == 2) {
        imgName = @"twitter_icon";
    }
    if(indexPath.row == 3) {
        imgName = @"mail";
    }
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    [imgView setFrame:CGRectMake(5, 3 , 39, 39)];
    if(indexPath.row != 0){
        [imgView setFrame:CGRectMake(5, 5 , 30, 30)];
    }
    
    if (indexPath.row == 1 && !isLogined) {
        imgView.hidden = YES;
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:imgView];
    [imgView release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
    if (indexPath.row == 0) {
        label.text = @"Save to Photos";
    }
    if (indexPath.row == 1) {
        label.text = @"Share to Facebook";
    }
    if (indexPath.row == 2) {
        label.text = @"Share to Twitter";
    }
    if (indexPath.row == 3) {
        label.text = @"Send via email";
    }
    
    if (indexPath.row == 1 && !isLogined) {
        label.hidden = YES;
    }
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:label];
    [label release];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.delegate saveToPhoto];
    }
//    
    if (indexPath.row == 1) {
        [self.delegate shareToFacebook];
    }
//    
    if (indexPath.row == 2) {
        [self.delegate shareToTwitter];
    }
//    
    if (indexPath.row == 3) {
        [self.delegate setting];
    }
}

#pragma mark - FBLoginViewDelegate

//- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
//    // first get the buttons set for login mode
//    
//    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
//    isLogined = YES;
//    [listActionTable reloadData];
//}
//
//- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
//                            user:(id<FBGraphUser>)user {
//
//}
//
//- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
//    // test to see if we can use the share dialog built into the Facebook application
//    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
//    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
//#ifdef DEBUG
//    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
//#endif
//    //BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
//    //BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
//}
//
//- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
//    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
//    // our policy here is to let the login view handle errors, but to log the results
//    NSLog(@"FBLoginView encountered an error=%@", error);
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
