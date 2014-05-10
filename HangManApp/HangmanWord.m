//
//  HangmanWord.m
//  HangMan
//
//  Created by Kim on 24/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import "HangmanWord.h"

@implementation HangmanWord

//designated initializer.
- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        // load the dictionary into an array
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"words" withExtension:@"plist"];
        self.wordList = [NSArray arrayWithContentsOfURL:url];
    }
    return self;
}


@end
