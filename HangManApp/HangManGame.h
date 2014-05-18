//
//  hangManGame.h
//  HangManApp
//
//  Created by Kim on 25/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "History.h"
#import "GameScore.h"
#import "MatchScore.h"

@interface HangManGame : NSObject

@property (strong, nonatomic) History *history;

@property (nonatomic)NSInteger matchScore;
@property (nonatomic)NSInteger gameScore;
@property (nonatomic) NSUInteger currentMatchNumber;

@property (nonatomic) NSUInteger gameMode; //gamemode 1 = default(difficulty), 2 = custom.

@property (nonatomic) BOOL match;
@property (nonatomic) BOOL gameStarted;
@property (nonatomic) BOOL newHighScore;
@property (nonatomic) BOOL matchWon;
@property (nonatomic) BOOL gameLost;

@property (nonatomic, retain) NSString *correctWord;
@property (nonatomic, strong) NSString *wrongLetters;
@property (nonatomic) NSUInteger incorrectGuessesLeft;
@property (nonatomic) NSUInteger incorrectGuessesSetting;
@property (nonatomic, retain) NSString *updatedWordToGuess;
@property (nonatomic) NSInteger difficultyRating;
@property (nonatomic) NSInteger wordLengthMaximum;

- (void) checkLetter: (NSString *) letterToCheck;
- (void) setupNewMatch: (NSString *) newWord;
- (NSInteger)checkUniqueCharactersInWord: (NSString *)word;
- (NSInteger)setupBaseScore: (NSInteger)charactersInWord;
- (NSUInteger)returnIncorrectGuessesAccordingToDifficulty;
- (NSString *)returnRandomWord;

//designated innitializer
- (instancetype)init;

@end
