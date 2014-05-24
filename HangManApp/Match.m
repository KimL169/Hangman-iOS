//
//  Match.m
//  HangManApp
//
//  Created by Kim on 20/05/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import "Match.h"


@implementation Match

- (instancetype)initWithCorrectWord:(NSString *)correctWord
            incorrectGuessesSetting:(NSInteger)guessesSetting {
    self = [super init];
    
    if (self) {
        
        self.incorrectGuessesSetting = guessesSetting;
        self.correctWord = correctWord;
        self.matchScore = [self setupBaseScore:[self checkUniqueCharactersInWord:self.correctWord]];
        self.updatedWordToGuess = [[NSString alloc]init];
        //to fill the wordLabel up with '-'* the length of the word to be quessed
        for (int i =0; i <correctWord.length; i++) {
            self.updatedWordToGuess = [self.updatedWordToGuess stringByAppendingString: @"-"];
        }
        self.incorrectGuessesLeft = self.incorrectGuessesSetting;
        self.wrongLetters = @"";
        self.matchWon = NO;
        self.matchLost = NO;
        self.match = NO;
    }
    return self;
}

#pragma mark - score

- (NSInteger) setupBaseScore: (NSInteger)charactersInWord { return charactersInWord * 30; }

- (void) updateMatchScore {
    if (self.matchScore > 0) {
        self.matchScore -= 5;
    }
}

#pragma mark - letter check

- (void) checkLetter:(NSString *)letterToCheck {
    
    self.match = NO;
    NSRange letterRange;
    
    // check each letter in the word for a match.
    char check = [letterToCheck characterAtIndex:0];
    for (int i=0; i < self.correctWord.length; i++) {
        char temp = [self.correctWord characterAtIndex:i];
        
        //if match is found add matching letter to updatedWordToGuess in order to update the associated UILabel.
        if (check == temp) {
            
            self.match = YES;
            letterRange = NSMakeRange(i, 1);//location, length
            
            //update the word to guess.
            self.updatedWordToGuess = [self.updatedWordToGuess stringByReplacingCharactersInRange:letterRange
                                                                                       withString:letterToCheck];
        }
    }
    //if match is NO: update the wrongletter variable, the incorrect guesses left and the match score.
    if (self.match == NO) {
        
        // if it wasn't a match and there was only 1 guess left, the match has been lost.
        if (self.incorrectGuessesLeft == 1) {
            self.matchLost = YES;
        }
        
        //remore the occurence of the character in the wrong letter string if it already exists then append wrong letter.
        self.wrongLetters = [self.wrongLetters stringByReplacingOccurrencesOfString:letterToCheck withString:@""];
        self.wrongLetters = [self.wrongLetters stringByAppendingString:letterToCheck];
        
        //update the guesses the player has left and the matchscore
        self.incorrectGuessesLeft = self.incorrectGuessesSetting - [self.wrongLetters length];
        [self updateMatchScore];
        
    } else {
        //check if the the match is won.
        if ([self.correctWord isEqualToString:self.updatedWordToGuess]) {
            self.matchWon = YES;
        }
    }
}

#pragma mark - utility functions.

//returns the number of unique characters in a word.
- (NSInteger) checkUniqueCharactersInWord: (NSString *)word {
    //get all the unique characters in a string.
    NSString *uniqueCharactersInWord = [[NSString alloc]init];
    
    for (int i = 0; i<word.length; i++) {
        char correctChar = [word characterAtIndex:i];
        bool match = NO;
        
        for (int j = 0; j<uniqueCharactersInWord.length; j++) {
            char uniqueChar = [uniqueCharactersInWord characterAtIndex:j];
            if (uniqueChar == correctChar) {
                match = YES;
            }
        }
        //if the letter is not already encountered: append to uniqueCharactersInWord.
        if (match == NO) {
            NSString *str = [NSString stringWithFormat:@"%c", correctChar];
            uniqueCharactersInWord = [uniqueCharactersInWord stringByAppendingString:str];
        }
    }
    //return the number of unique characters.
    return [uniqueCharactersInWord length];;
}


@end
