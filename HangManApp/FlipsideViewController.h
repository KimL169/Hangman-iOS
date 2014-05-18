//
//  FlipsideViewController.h
//  HangManApp
//
//  Created by Kim on 24/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "History.h"


@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

@property (nonatomic, strong) History *currentHistory;

- (IBAction)done:(id)sender;

@end
