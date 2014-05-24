//
//  Match.h
//  HangManApp
//
//  Created by Kim on 20/05/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//


/********************************
 * Class Description
 *
 * This class implements a Match, each HangManGame can have 
 * multiple matches.
 * A match means one word that the user has to guess right.
 * If a match is guessed right a new match is initiated in HangManGame,
 * until the player loses a match, this will end the game.
 *********************************/

#import <Foundation/Foundation.h>

@interface Match : NSObject

@property (nonatomic) BOOL match;
@property (nonatomic) BOOL matchWon;
@property (nonatomic) BOOL matchLost;

@property (nonatomic) NSInteger incorrectGuessesLeft;
@property (nonatomic) NSInteger incorrectGuessesSetting;
@property (nonatomic, strong) NSString *updatedWordToGuess;
@property (nonatomic, strong) NSString *correctWord;
@property (nonatomic, strong) NSString *wrongLetters;
@property (nonatomic) NSInteger matchScore;

- (instancetype)initWithCorrectWord:(NSString *)correctWord
            incorrectGuessesSetting:(NSInteger)guessesSetting;

- (NSInteger) setupBaseScore: (NSInteger)charactersInWord;
- (void) updateMatchScore;
- (NSInteger) checkUniqueCharactersInWord: (NSString *)word;

- (void) checkLetter:(NSString *)letterToCheck;

@end
