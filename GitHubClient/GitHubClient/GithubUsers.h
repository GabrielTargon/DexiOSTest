//
//  GithubUsers.h
//  GitHubClient
//
//  Created by Gabriel Targon on 11/10/16.
//  Copyright © 2016 gabrieltargon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GithubRepoSearchSettings;

@interface GithubUsers : NSObject <NSCopying>

@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *userAvatarURL;

+ (void)fetchRepos:(GithubRepoSearchSettings *)settings successCallback:(void(^)(NSArray *))successCallback;

@end
