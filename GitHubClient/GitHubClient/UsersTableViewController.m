//
//  UsersTableViewController.m
//  GitHubClient
//
//  Created by Gabriel Targon on 11/10/16.
//  Copyright © 2016 gabrieltargon. All rights reserved.
//

#import "UsersTableViewController.h"
#import "UsersTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import "GithubUsers.h"
#import "GithubRepoSearchSettings.h"

@interface UsersTableViewController ()
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) GithubUsers *gitHubUsers;
@property (nonatomic, strong) GithubRepoSearchSettings *searchSettings;
@property (nonatomic, strong) NSMutableArray *users;

@end

@implementation UsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.users = [@[] mutableCopy];
    self.searchSettings = [[GithubRepoSearchSettings alloc] init];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search for users";
    [self.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchBar;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.users){
        NSLog(@"USERS_STARTEEE: %lu", (unsigned long)self.users.count);
        return self.users.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UsersTableViewCell *usersCell = (UsersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    self.gitHubUsers = self.users[indexPath.row];
    NSLog(@"USERS_FINAL: %@", self.gitHubUsers);
    
    NSURL *posterURL = [NSURL URLWithString:self.gitHubUsers.userAvatarURL];
    [usersCell.imageUser sd_setImageWithURL:posterURL placeholderImage:[UIImage imageNamed:@"No_user.png"]];
    usersCell.nameUser.text = [NSString stringWithFormat:@"%@", self.gitHubUsers.login];
    
    return usersCell;
}

#pragma mark - Search bar

- (void)doSearch {
    [GithubUsers fetchRepos:self.searchSettings successCallback:^(NSArray *repos) {
        for (GithubUsers *repo in repos) {
            [self.users addObject:repo];
            NSLog(@"%@", repo);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchSettings.searchString = searchBar.text;
    [searchBar resignFirstResponder];
    [self doSearch];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
