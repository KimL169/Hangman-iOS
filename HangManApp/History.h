//
//  History.h
//  HangManApp
//
//  Created by Kim on 29/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface History : NSManagedObject


@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSNumber *numberOfMatches;
@property (nonatomic, retain) NSArray *matchWordsAndScoresInGame; //array of arrays.

@end
