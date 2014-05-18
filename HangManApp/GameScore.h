//
//  GameScore.h
//  HangManApp
//
//  Created by Kim on 18/05/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MatchScore;

@interface GameScore : NSManagedObject

@property (nonatomic, retain) NSNumber * difficulty;
@property (nonatomic, retain) NSNumber * gameScore;
@property (nonatomic, retain) NSNumber * numberOfMatches;
@property (nonatomic, retain) NSSet *matchscores;
@end

@interface GameScore (CoreDataGeneratedAccessors)

- (void)addMatchscoresObject:(MatchScore *)value;
- (void)removeMatchscoresObject:(MatchScore *)value;
- (void)addMatchscores:(NSSet *)values;
- (void)removeMatchscores:(NSSet *)values;

@end
