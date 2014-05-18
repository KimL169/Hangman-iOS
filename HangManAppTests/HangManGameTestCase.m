//
//  HangManGameTestCase.m
//  HangManApp
//
//  Created by Kim on 16/05/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HangManGame.h"

@interface HangManGameTestCase : XCTestCase



@end

@implementation HangManGameTestCase

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



- (void)testReturnsUniqueCharactersInWord {
    NSString *word = @"bo";
    HangManGame *game = [[HangManGame alloc]init];
    
   NSInteger uniqueLetterCount = [game checkUniqueCharactersInWord:word];
    
    XCTAssertEqual(uniqueLetterCount, 2, "Should have been correct number");
}

- (void)testCheckLetter {
    HangManGame *game = [[HangManGame alloc]init];
    game.correctWord = @"pop";
    game.updatedWordToGuess = @"---";
    [game checkLetter:@"p"];
    XCTAssertEqual(YES, game.match, @"should be a match");
}

- (void)testUpdatedWordToGuess {
    HangManGame *game = [[HangManGame alloc]init];
    game.correctWord = @"pop";
    game.updatedWordToGuess = @"---";
    [game checkLetter:@"p"];
    
    NSString *str = @"p-p";
    XCTAssertEqualObjects(game.updatedWordToGuess, str, @"should be a equal");
}

- (void)testUpdateMatchScore {
    HangManGame *game = [[HangManGame alloc]init];
    game.matchScore = 10;
    game.correctWord = @"pop";
    game.updatedWordToGuess = @"---";
    [game checkLetter:@"x"];
    
    XCTAssertEqual(game.matchScore, 5, @"should be correct score");
}

- (void)testIncorrectGuessesLeft {
    HangManGame *game = [[HangManGame alloc]init];
    game.matchScore = 10;
    game.correctWord = @"pop";
    game.updatedWordToGuess = @"---";
    game.incorrectGuessesSetting = 10;
    game.wrongLetters = @"x";
    [game checkLetter:@"x"];
    
    XCTAssertEqual(game.incorrectGuessesLeft, 9, @"should be correct number of incorrectguessesLeft");
}


- (void)testUpdateGameScore {
    HangManGame *game = [[HangManGame alloc]init];
    game.matchScore = 10;
    game.gameScore = 0;
    game.correctWord = @"x";
    game.updatedWordToGuess = @"-";
    [game checkLetter:@"x"];
    
    XCTAssertEqual(game.gameScore, 10, @"game score should be correct");
}

- (void)testBaseScore {
    HangManGame *game = [[HangManGame alloc]init];
    [game setupNewMatch:@"pop"];
    XCTAssertEqual(game.matchScore, 60, @"should have correct base score");
}

-(void)testReturnRandomWordShouldReturnWord {
    HangManGame *game = [[HangManGame alloc]init];
    
    NSString *word = [game returnRandomWord];
    
    XCTAssertNotNil(word, @"returned word should not be nil");
}

- (void)testReturnCorrectMaxLengthWord {
    
    HangManGame *game = [[HangManGame alloc]init];
    
    //set length to 3 and game mode to 2 so it will select a user custom wordlength.
    game.wordLengthMaximum = 3;
    game.gameMode = 2;
    
    BOOL tooLong = NO;
    //return 60 words and check length
    for (int i = 0; i<60; i++) {
        NSString *word = [game returnRandomWord];
        if (word.length > 3) {
            tooLong = YES;
        }
    }

    XCTAssertFalse(tooLong, @"should not be too long");
}

- (void)testDifficultyShouldHaveCorrectGuessesAllowed {
    
    HangManGame *game = [[HangManGame alloc]init];
    
    game.difficultyRating = 7;
    
    XCTAssertEqual([game returnIncorrectGuessesAccordingToDifficulty], 1, @"incorrect guesses left should be 1");
}

- (void)testWordToGuessLabelShouldBeCorrectLength {
    HangManGame *game = [[HangManGame alloc]init];
    
    [game setupNewMatch:@"poppy"];
    
    XCTAssertEqual([[game updatedWordToGuess] length], 5, @"should be correct length");
}

- (void)testMatchNumberShouldBeCorrectNumber {
    
    HangManGame *game = [[HangManGame alloc]init];

    [game setupNewMatch:@"adsf"];
    [game setupNewMatch:@"sdfa"];
    
    XCTAssertEqual([game currentMatchNumber], 2, @"should be the correct match number");
}




@end
