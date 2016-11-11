//
//  RepoTableViewCell.h
//  GitHubClient
//
//  Created by Gabriel Targon on 11/10/16.
//  Copyright © 2016 gabrieltargon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleRepo;
@property (weak, nonatomic) IBOutlet UILabel *descriptionRepo;

@end
