//
//  HighScoreTableViewController.h
//  HangManApp
//
//  Created by Kim on 16/05/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "History.h"
#import "GameScore.h"
#import "HighScoreDetailTableViewController.h"

@interface HighScoreTableViewController : UITableViewController 

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
