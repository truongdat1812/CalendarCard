//
//  SelectedActionViewController.h
//  CalendarCreator
//
//  Created by Truong Dat on 8/13/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ActionDelegate<NSObject>
@required
- (void) saveToPhoto;
- (void) shareToFacebook;
- (void) shareToTwitter;
- (void) setting;
@end

@interface SelectedActionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    id<ActionDelegate> delegate;
    BOOL isLogined;
    IBOutlet UITableView *listActionTable;
}

@property (nonatomic, assign) id delegate;
@end
