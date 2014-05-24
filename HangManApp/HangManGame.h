//
//  hangManGame.h
//  HangManApp
//
//  Created by Kim on 25/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//


/********************************
 * Class Description
 * 
 * This class implements the game play of the hangman game.
 * The MainViewController will initialize a HangManGame.
 * The HangManGame stores user high scores through the History model.
 *
 ********************************/

#import <Foundation/Foundation.h>
#import "History.h"
#import "GameScore.h"
#import "MatchScore.h"
#import "Match.h"

@interface HangManGame : NSObject

@property (strong, nonatomic) History *history;
@property (strong, nonatomic) Match *hangmanMatch;

@property (nonatomic)NSInteger gameScore;
@property (nonatomic) NSUInteger currentMatchNumber;
@property (nonatomic) NSUInteger gameMode; //gamemode 1 = default(difficulty), 2 = custom.

@property (nonatomic) BOOL newHighScore;

@property (nonatomic) NSUInteger incorrectGuessesSetting;
@property (nonatomic) NSInteger difficultyRating;
@property (nonatomic) NSInteger wordLengthMaximum;
@property (nonatomic, strong) NSString *filteredLetters;
@property (nonatomic, strong) NSMutableCharacterSet *validCharacterSet;

//check the user guessed letter for a match with the word to guess.
- (void) checkLetter: (NSString *) letterToCheck;

//setup a new match with a new word. A game contains many matches.
- (void) setupNewMatch;

//check the unique characters in contained in a word
//to calculate base score and retreive words from the dictionary according to difficulty.
- (NSInteger) checkUniqueCharactersInWord: (NSString *)word;


//return the correct amount of incorrectGuesses the user can make according to difficulty.
- (NSUInteger) returnIncorrectGuessesAccordingToDifficulty;

//returns random word depending on the user settings.
- (NSString *) returnRandomWord;

//designated innitializer
- (instancetype) init;

@end
