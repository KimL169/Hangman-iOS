//
//  hangManGame.m
//  HangManApp
//
//  Created by Kim on 25/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import "hangManGame.h"

@interface HangManGame()

@property (nonatomic) NSInteger wordLengthMinimum;
@property (nonatomic) NSInteger wordLengthMaximum;
@property (nonatomic) NSInteger numberOfMatchesInGame;
@property (nonatomic, strong) NSArray *wordList;
@property (nonatomic) NSInteger scoreMultiplier;
@end

@implementation HangManGame

- (instancetype)init {
    
    self = [super init]; //super's designated initializer
    
    if (self) {
        
        //check if there are User Defaults set, else use Standard Defaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if ([defaults integerForKey:@"maximumWordLength"]) {
            self.wordLengthMaximum = [defaults integerForKey:@"maximumWordLength"];
        } else {
            //Standard Default
            self.wordLengthMaximum = 15;
        }
        if ([defaults integerForKey:@"numberOfMatchesInGame"]) {
            self.matchCount = [defaults integerForKey:@"numberOfMatchesInGame"];
        } else {
            //Standard Default
            self.matchCount = 3;
        }
        if ([defaults integerForKey:@"numberOfGuessesAllowed"]) {
            self.incorrectGuessesSetting = [defaults integerForKey:@"numberOfGuessesAllowed"];
        } else {
            //Standard Default
            self.incorrectGuessesSetting = 6;
        }
        
        
        // create the wordlist.
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"words" withExtension:@"plist"];
        self.wordList = [NSArray arrayWithContentsOfURL:url];

        //set game started to NO, game will start once a Player inserts his first letter to check.
        self.gameStarted = NO;
        self.gameWon = NO;
        self.updatedWordToGuess = [[NSString alloc]init];
        self.matchScore = 0;
        self.currentMatchNumber = 0;
        
    }
    return self;
}

- (void) setupNewWord:(NSString *)newWord {
    
    //set game started to no.
    self.gameStarted = NO;
    
    //reset the wrong letters, the word to guess and guesses.
    self.gameWon = NO;
    self.matchWon = NO;
    self.match = NO;
    self.incorrectGuessesLeft = self.incorrectGuessesSetting;
    self.updatedWordToGuess = @"";
    self.correctWord = [newWord lowercaseString];
    self.wrongLetters = @"";
    self.currentMatchNumber += 1;
    
    //check unique letters in newWord to calculate score.
    [self setupScore];

    
    //fill the wordLabel up with '_'* the length of the word to be quessed
    for (int i =0; i <newWord.length; i++) {
        self.updatedWordToGuess = [self.updatedWordToGuess stringByAppendingString: @"-"];
    }
    
}

- (void) setupScore {
    
    //get all the unique characters in a string.
    NSString *uniqueCharactersInWord = [[NSString alloc]init];
    
    for (int i = 0; i<self.correctWord.length; i++) {
        char correctChar = [self.correctWord characterAtIndex:i];
        bool match = NO;
        
        for (int j = 0; j<uniqueCharactersInWord.length; j++) {
          char uniqueChar = [uniqueCharactersInWord characterAtIndex:j];
            if (uniqueChar == correctChar) {
                match = YES;
            }
        }
        
        if (match == NO) {
            NSString *str = [NSString stringWithFormat:@"%c", correctChar];
            uniqueCharactersInWord = [uniqueCharactersInWord stringByAppendingString:str];
            NSLog(@"%@",uniqueCharactersInWord);
        }
    }
    //set base score as the amount of unique characters in the word to guess.
    self.matchScore = [uniqueCharactersInWord length] * 10;

}

- (void) updateScore {
    
    if (self.matchScore > 0) {
        self.matchScore = self.matchScore - 5;
    }
}



- (void) checkLetter:(NSString *)letterToCheck {
    
    //set game started to YES to not allow user to change settings at this point.
    self.gameStarted = YES;
    self.match = NO;
    NSRange letterRange;
    
    //change the case of the letter to check to match the dictionary.

    // check each letter in the word for a match.
    char check = [letterToCheck characterAtIndex:0];
    for (int i=0; i < self.correctWord.length; i++) {
        char temp = [self.correctWord characterAtIndex:i];

        //if match is found add matching letter to letter label.
        if (check == temp) {

            self.match = YES;
            letterRange = NSMakeRange(i, 1);//location, length
            
            //update the word to guess.
            self.updatedWordToGuess = [self.updatedWordToGuess stringByReplacingCharactersInRange:letterRange
                                                                                       withString:letterToCheck];
            
        }
        
    }

    
    if (self.match == NO) {
        self.wrongLetters = [self.wrongLetters stringByReplacingOccurrencesOfString:letterToCheck withString:@""];
        self.wrongLetters = [self.wrongLetters stringByAppendingString:letterToCheck];
        
        //update the guesses the player has left
        self.incorrectGuessesLeft = self.incorrectGuessesSetting - [self.wrongLetters length];
        //update the score
        [self updateScore];

    } else {
        
        
        //check if the game is won or the match is won.
        if ([self.correctWord isEqualToString:self.updatedWordToGuess]) {
            if (self.matchCount == self.currentMatchNumber) {
                self.gameWon = YES;
            } else {
                self.matchWon = YES;
            }
        } else {
            
        }
    }
}


- (NSString *) returnRandomWord {
    
    NSString *word = [[NSString alloc]init];
    
    //get random num in range of wordList.count
    if (self.wordList) {

        while (true) {
            
            //counter to break after too many tries.
            uint32_t rnd = arc4random_uniform([self.wordList count]);
            
            word = self.wordList[rnd];
            
            //check if the word is the correct length.
            if (word.length <= self.wordLengthMaximum) {
                return word;
            }
        }
        
    }
    //return a random word from the list
    return word;
    
}



@end
