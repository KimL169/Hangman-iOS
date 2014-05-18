//
//  History.h
//  HangManApp
//
//  Created by Kim on 29/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

/********************************
* Class Description
*
* This class implements the functions used to retrieve, 
* save, delete and edit the High Scores the user may acheive
* High scores consist of Game Scores and Match Scores,
* A GameScore has_many MatchScores, these are stored in the
* database using Core Data.
*********************************/


#import <Foundation/Foundation.h>
#import "GameScore.h"
#import "MatchScore.h"

@interface History : NSObject <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *highScores;
@property (nonatomic)NSInteger score;
@property (nonatomic)NSInteger difficulty;
@property (nonatomic)NSInteger matchCount;


//check if a new high score was acheived if so, save it.
//make sure the database only contains 10 records and delete the lowest if necessary.
- (BOOL) newHighScore: (NSInteger)score
          difficulty:(NSInteger)difficulty
          matchCount:(NSInteger)matchCount;

//saves a new game score to the database.
- (void) createScore;

//fetch all the records from the database.
- (NSArray *) fetchScores;

//delete all records from the database.
- (void) deleteAllScores;

//delete only the last(lowest) score from the database.
- (void) deleteLastScore;

@end


