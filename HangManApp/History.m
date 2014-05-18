//
//  History.m
//  HangManApp
//
//  Created by Kim on 29/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import "AppDelegate.h"
#import "History.h"
#import "GameScore.h"
#import "MatchScore.h"

@implementation History


- (BOOL) newHighScore: (NSInteger)score
          difficulty:(NSInteger)difficulty
          matchCount:(NSInteger)matchCount {
    
    self.score = score;
    self.difficulty = difficulty;
    self.matchCount = matchCount;
    
    //fetch the current highScores
    NSArray *highScores = [self fetchScores];
    
    //bool for return value.
    BOOL newHighScore = NO;
    
    //check if the new score is higher than the highest score yet achieved.
    NSNumber *currentHighestScore = [[highScores lastObject] gameScore];
    
    //if the score is higher, save the new score.
    if (score > [currentHighestScore intValue]) {
        [self createScore];
        newHighScore = YES;
    }

    //if there are more than 10 scores, delete the lowest score.
    if (highScores.count > 9) {
        //delete lowest score
        [self deleteLastScore];

    }
    
    //return whether or not a new high score was achieved.
    return newHighScore;
}

//return the managedObjectContext from the AppDelegate.
- (NSManagedObjectContext *)managedObjectContext {
    return  [(AppDelegate *)[[UIApplication sharedApplication]delegate]managedObjectContext];
}

- (void) createScore {
    //get the managed Object context
    
    NSManagedObjectContext *context = [self managedObjectContext];

    GameScore *gameScore = [NSEntityDescription insertNewObjectForEntityForName:@"GameScore" inManagedObjectContext:context];
    
    NSNumber *newScore = [NSNumber numberWithInteger:self.score];
    NSNumber *newDifficulty = [NSNumber numberWithInteger:self.difficulty];
    NSNumber *newMatchCount = [NSNumber numberWithInteger:self.matchCount];
    gameScore.gameScore = newScore;
    gameScore.difficulty = newDifficulty;
    gameScore.numberOfMatches = newMatchCount;
    
    MatchScore *matchScore = [NSEntityDescription insertNewObjectForEntityForName:@"MatchScore" inManagedObjectContext:context];
    matchScore.word = @"word";

    
    [gameScore addMatchscoresObject:matchScore];

    //save the score
    NSError *error = nil;
    if ([self.managedObjectContext hasChanges]){
        if (![self.managedObjectContext save: &error]) {//save failed
            NSLog(@"Save failed: %@", [error localizedDescription]);
        } else {
            NSLog(@"Save succesfull");
        }
    }
}

- (void) deleteLastScore {

    NSManagedObject *object = [[self fetchScores]firstObject];
    NSManagedObjectContext *context = [object managedObjectContext];
    //delete the last object from the database.
    [context deleteObject:object];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error Deleting score: %@", error);
    }

}

- (void) deleteAllScores {
    NSArray *historyObjects = [self fetchScores];
    NSError *error;
    for ( id s in historyObjects) {
        //get the context of the object and delete the object
        NSManagedObjectContext *context = [s managedObjectContext];
        [context deleteObject:s];
        
        //check if successfully deleted.
        if (![context save:&error]) {
            NSLog(@"Error deleting all high scores: %@", error);
        }
    }
    
}

- (NSArray *)fetchScores {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GameScore" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];

    //sort based on score, descending.
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"gameScore" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sort, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"something went wrong fetching from database: %@", error);
    }
    
    return fetchedObjects;
}
@end
