//
//  TwitterUtils.h
//  iMomeet
//
//  Created by Truong Dat on 8/5/13.
//  Copyright (c) 2013 Truong Dat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface TwitterUtils : NSObject{
    UITextView *outputTextView;
}
- (void)displayText:(NSString *)text;
- (void) sendTweetWithText:(NSString *) tweetText andViewController:(UIViewController *)viewController;
- (void) sendTweetWithImage:(NSString *) tweetText withImage:(UIImage *)image andViewController:(UIViewController *)viewController;
- (void) sendTweetWithImage:(NSString *) tweetText withLink:(NSURL *)link andViewController:(UIViewController *)viewController;
@end
