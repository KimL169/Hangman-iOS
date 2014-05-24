//
//  HistoryTestCase.m
//  HangManApp
//
//  Created by Kim on 17/05/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "History.h"
#import "GameScore.h"
#import "HangManGame.h"

@interface HistoryTestCase : XCTestCase

@end

@implementation HistoryTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testHighScoresShouldBeDeleted {
    History *history = [[History alloc]init];
    //set a new record.
    [history newHighScore:1000 difficulty:1 matchCount:10];
    //first empty the database
    [history deleteAllScores];
    //fetch the database
    NSArray *array1 = [history fetchGameScores];
    
    XCTAssertEqual([array1 count], 0, @"contents of array1 should be 0");
}

- (void) testHighScoreShouldBeSaved {
    History *history = [[History alloc]init];
    
    //first empty the database
    [history deleteAllScores];
    //fetch the database
    NSArray *array1 = [history fetchGameScores];
    
    [history newHighScore:400 difficulty:6 matchCount:9];
    
    NSArray *array2 = [history fetchGameScores];
    
    NSInteger one = [array1 count];
    NSInteger two = [array2 count];
    
    XCTAssertEqual(one +1,two , @"should be one more than before");
}

- (void) testHighScoreShouldBeFetched {
    
    History *history = [[History alloc]init];
    //set a new record.
    [history newHighScore:1000 difficulty:1 matchCount:10];
    
    //fetch from the database
    NSArray *array1 = [history fetchGameScores];
    
    XCTAssertNotEqual([array1 count], 0, @"fetched array should not be empty");
}

- (void) testHighScoreShouldBeCorrectScore {
    History *history = [[History alloc]init];
    
    //first empty the database
    [history deleteAllScores];
    //make a new score
    [history newHighScore:400 difficulty:6 matchCount:9];
    
    NSArray *array1 = [history fetchGameScores];
    
    //get the score from database.
    GameScore *score = [array1 objectAtIndex:0];
    
    XCTAssertEqual([score.gameScore intValue], 400, @"score should be equal to 400");
}

- (void) testHighScoreShouldBeCorrectNumberOfWords {
    History *history = [[History alloc]init];
    
    //first empty the database
    [history deleteAllScores];
    //make a new score
    [history newHighScore:400 difficulty:6 matchCount:9];
    
    NSArray *array1 = [history fetchGameScores];
    
    //get the score from database.
    GameScore *score = [array1 objectAtIndex:0];
    
    XCTAssertEqual([score.numberOfMatches intValue], 9, @"Number of matches should be correct");
}

- (void) testHighScoreShouldBeCorrectDifficulty {
    History *history = [[History alloc]init];
    
    //first empty the database
    [history deleteAllScores];
    //make a new score
    [history newHighScore:400 difficulty:6 matchCount:9];
    
    NSArray *array1 = [history fetchGameScores];
    
    //get the score from database.
    GameScore *score = [array1 objectAtIndex:0];
    
    XCTAssertEqual([score.difficulty intValue], 6, @"difficulty should be correct");
}

- (void) testHighScoresShouldNotBeTooMany {
    
    History *history = [[History alloc]init];
    
    //first empty the database
    [history deleteAllScores];
    
    //make more than 10 new scores
    for (int i = 1; i< 15; i++) {
        [history newHighScore:i difficulty:7 matchCount:i];
    }
    
    //fetch the scores
    NSArray *array1 = [history fetchGameScores];
    
    //should return 10 results, not 14
    XCTAssertEqual([array1 count], 10, @"should return correct number of save games (10)");
}

- (void) testMatchScoreStorage {
    History *history = [[History alloc]init];
    [history deleteAllScores];
    [history newMatchScore:10 word:@"pop" incorrectGuesses:10];
    NSArray *array1 = [history fetchMatchScores];
    
    XCTAssertEqual([array1 count], 1, @"should be saved");
}

- (void) testMatchScoreShouldBeDeleted {
    HangManGame *game = [[HangManGame alloc]init];
    [game.history deleteAllScores];
    [game.history newMatchScore:10 word:@"pop" incorrectGuesses:10];
    [game.history newMatchScore:10 word:@"pop" incorrectGuesses:10];
    [game.history newMatchScore:10 word:@"pop" incorrectGuesses:10];
    game.gameScore = 100;
    
    [game newHighScore];
    [game.history deleteAllScores];
    NSArray *array1 = [game.history fetchMatchScores];
    
    XCTAssertEqual([array1 count], 0, @"should be 0");
    
}

@end
