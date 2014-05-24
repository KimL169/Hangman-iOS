//
//  HighScoreDetailTableViewController.m
//  HangManApp
//
//  Created by Kim on 16/05/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import "HighScoreDetailTableViewController.h"
#import "AppDelegate.h"
#import "HighScoreTableViewController.h"


@interface HighScoreDetailTableViewController ()

@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;

@end

@implementation HighScoreDetailTableViewController


- (NSManagedObjectContext *)managedObjectContext {
    return  [(AppDelegate *)[[UIApplication sharedApplication]delegate]managedObjectContext];
}


#pragma mark - Fetched Results Controller section
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return  _fetchedResultsController;
    }
    
    //make a fetch request and set GameScore as the entity to fetch.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MatchScore" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gamescore == %@", self.selectedGameScore];
    [fetchRequest setPredicate:predicate];
    // Specify criteria for filtering which objects to fetch
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"matchScore" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    return _fetchedResultsController;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //load in the data
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error fetching data: %@", error);
        abort();
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return [[self.fetchedResultsController sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //ask the fetchResultsController for the sections array. Go into particular one based on the index section parameter.
    id <NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
    
    // Return the number of rows in the section.
    return [secInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //configure cell.
    MatchScore *matchScore = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [matchScore word]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Score: %d   |   Incorrect Guesses: %d",
                                 [[matchScore matchScore] intValue], [[matchScore incorrectGuesses] intValue]];
    
    
    
    //if the game has a difficulty display it

    
    return cell;
}



//make sure the user can only play the game in portrait mode
- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIInterfaceOrientationPortrait;
}

@end
