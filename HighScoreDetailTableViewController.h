//
//  HighScoreDetailTableViewController.h
//  HangManApp
//
//  Created by Kim on 16/05/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameScore.h"
#import "MatchScore.h"
#import "HighScoreDetailTableViewController.h"
#import "CoreDataTableViewController.h"


@interface HighScoreDetailTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) GameScore *selectedGameScore;

@end
