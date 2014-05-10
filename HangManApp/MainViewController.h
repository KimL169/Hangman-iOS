//
//  MainViewController.h
//  HangManApp
//
//  Created by Kim on 24/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import "FlipsideViewController.h"
#import "HighScoreViewController.h"
#import "History.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>


@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (nonatomic)BOOL gameStarted;

@property (nonatomic) History *currentHistory;

@end
