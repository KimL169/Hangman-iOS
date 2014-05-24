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

- (instancetype)init {
    self = [super init];
    if (self) {
        
        if (!_gameScore) {
            _gameScore = [NSEntityDescription insertNewObjectForEntityForName:@"GameScore" inManagedObjectContext:self.managedObjectContext];
        }
    }
    return self;
}

- (BOOL) newHighScore: (NSInteger)score
          difficulty:(NSInteger)difficulty
          matchCount:(NSInteger)matchCount {

    self.score = score;
    self.difficulty = difficulty;
    self.matchCount = (matchCount - 1); //substract 1 because the last match was lost and thus not counted.
    
    //fetch the current highScores
    NSArray *highScores = [self fetchGameScores];
    
    //bool for return value.
    BOOL newHighScore = NO;
    
    //check if the new score is higher than the highest score yet achieved.
    NSNumber *currentHighestScore = [[highScores lastObject] gameScore];
    
    //if the score is higher, save the new score.
    if (score > [currentHighestScore intValue]) {
        [self createHighScore];
        newHighScore = YES;
    }

    //if there are more than 10 scores, delete the lowest score.
    if (highScores.count > 9) {
        //delete lowest score
        [self deleteLastScore];

    }
    
    //if no new highscore is set, roll back the transactions.
    //so the match scores won't be saved.
    if (newHighScore == NO) {
        [self.managedObjectContext rollback];
    }
    
    //return whether or not a new high score was achieved.
    return newHighScore;
}

//return the managedObjectContext from the AppDelegate.
- (NSManagedObjectContext *)managedObjectContext {
    return  [(AppDelegate *)[[UIApplication sharedApplication]delegate]managedObjectContext];
}

- (void) newMatchScore:(NSInteger)score
                  word:(NSString *)word
      incorrectGuesses:(NSInteger)incorrectGuesses {
    
    //create a managed object and fill in the parameters.
    MatchScore *matchScore = [NSEntityDescription insertNewObjectForEntityForName:@"MatchScore" inManagedObjectContext:self.managedObjectContext];
    matchScore.incorrectGuesses = [NSNumber numberWithInteger:incorrectGuesses];
    matchScore.word = word;
    matchScore.matchScore = [NSNumber numberWithInteger:score];
    
    //set relationship to the current gamescore.
    matchScore.gamescore = self.gameScore;
    [self.gameScore addMatchscoresObject:matchScore];
    
}

- (void) createHighScore {
    //get the managed Object context

    
    NSNumber *newScore = [NSNumber numberWithInteger:self.score];
    NSNumber *newDifficulty = [NSNumber numberWithInteger:self.difficulty];
    NSNumber *newMatchCount = [NSNumber numberWithInteger:self.matchCount];
    self.gameScore.gameScore = newScore;
    self.gameScore.difficulty = newDifficulty;
    self.gameScore.numberOfMatches = newMatchCount;
    
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

    NSManagedObject *object = [[self fetchGameScores]firstObject];
    NSManagedObjectContext *context = [object managedObjectContext];
    //delete the last object from the database.
    [context deleteObject:object];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error Deleting score: %@", error);
    }

}

- (void) deleteAllScores {
    //delete all the game scores.
    NSArray *gameScores = [self fetchGameScores];
    NSError *error;
    for ( id s in gameScores) {
        //get the context of the object and delete the object
        NSManagedObjectContext *context = [s managedObjectContext];
        [context deleteObject:s];
        
        //check if successfully deleted.
        if (![context save:&error]) {
            NSLog(@"Error deleting all high scores: %@", error);
        }
    }
    //delete all the match scores
    NSArray *matchScores = [self fetchMatchScores];
    for (id s in matchScores) {
        //get the context of the object and delete the object
        NSManagedObjectContext *context = [s managedObjectContext];
        [context deleteObject:s];
        
        //check if successfully deleted.
        if (![context save:&error]) {
            NSLog(@"Error deleting all high scores: %@", error);
        }
    }
    
}

- (NSArray *) fetchMatchScores {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MatchScore" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];

    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"something went wrong fetching from database: %@", error);
    }
    
    return fetchedObjects;
}

- (NSArray *) fetchGameScores {
    
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
