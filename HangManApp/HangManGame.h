//
//  hangManGame.h
//  HangManApp
//
//  Created by Kim on 25/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HangManGame : NSObject

@property (nonatomic) NSInteger matchScore;
@property (nonatomic) NSInteger gameScore;
@property (nonatomic) NSInteger gamesPlayed;
@property (nonatomic) NSUInteger matchCount;
@property (nonatomic) NSUInteger currentMatchNumber;

@property (nonatomic) BOOL match;
@property (nonatomic) BOOL gameStarted;
@property (nonatomic) BOOL gameWon;
@property (nonatomic) BOOL matchWon;

@property (nonatomic, retain) NSString *correctWord;
@property (nonatomic, strong) NSString *wrongLetters;
@property (nonatomic) NSUInteger incorrectGuessesLeft;
@property (nonatomic) NSUInteger incorrectGuessesSetting;
@property (nonatomic, retain) NSString *updatedWordToGuess;

- (void) checkLetter: (NSString *) letterToCheck;
- (void) setupNewWord: (NSString *) newWord;
- (void) setupScore;

- (NSString *) returnRandomWord;

//designated innitializer
- (instancetype)init;

@end
