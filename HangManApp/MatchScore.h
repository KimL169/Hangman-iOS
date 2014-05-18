//
//  MatchScore.h
//  HangManApp
//
//  Created by Kim on 18/05/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GameScore;

@interface MatchScore : NSManagedObject

@property (nonatomic, retain) NSNumber * matchScore;
@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSNumber * incorrectGuesses;
@property (nonatomic, retain) GameScore *gamescore;

@end
