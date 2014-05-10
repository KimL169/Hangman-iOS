//
//  HighScoreViewController.m
//  HangManApp
//
//  Created by Kim on 29/04/14.
//  Copyright (c) 2014 Kim. All rights reserved.
//

#import "HighScoreViewController.h"

@interface HighScoreViewController () {
    NSMutableArray *highscores;
}


@property (weak, nonatomic) IBOutlet UILabel *gamesPlayedLabel;
@property (weak, nonatomic) IBOutlet UILabel *gamesWonLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchesPlayedLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchesWonLabel;

@property (weak, nonatomic) IBOutlet UITableView *highScoreTable;

@end

@implementation HighScoreViewController

- (IBAction)return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
