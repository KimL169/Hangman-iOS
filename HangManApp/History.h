//
//  History.h
//  HangManApp
//
//  Created by Kim on 29/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScore.h"
#import "MatchScore.h"

@interface History : NSObject <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSMutableArray *highScores;


@property (nonatomic)NSInteger score;
@property (nonatomic)NSInteger difficulty;
@property (nonatomic)NSInteger matchCount;

- (BOOL)newHighScore: (NSInteger)score
          difficulty:(NSInteger)difficulty
          matchCount:(NSInteger)matchCount;

- (void)createScore;
- (NSArray *)fetchScores;

- (void)deleteAllScores;

@end


