//
//  HangmanWord.h
//  HangMan
//
//  Created by Kim on 24/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HangmanWord : NSObject

@property (nonatomic, strong) NSArray *wordList;

- (NSString *)returnRandomWord;

@end
