//
//  GithubUsers.m
//  GitHubClient
//
//  Created by Gabriel Targon on 11/10/16.
//  Copyright © 2016 gabrieltargon. All rights reserved.
//

#import "GithubUsers.h"
#import "AFHTTPRequestOperationManager.h"
#import "GithubRepoSearchSettings.h"

@interface GithubUsers ()
@end

@implementation GithubUsers

static NSString * const kReposUrl = @"https://api.github.com/search/users";
static NSString * const kClientId = nil;
static NSString * const kClientSecret = nil;

- (void)initializeWithDictionary:(NSDictionary *)jsonResult {
    self.login = jsonResult[@"login"];
    self.userAvatarURL = jsonResult[@"avatar_url"];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    GithubUsers *copy = [[[self class] alloc] init];
    
    if (copy) {
        copy.login = self.login;
        copy.userAvatarURL = self.userAvatarURL;
    }
    
    return copy;
}

+ (void)fetchRepos:(GithubRepoSearchSettings *)settings successCallback:(void(^)(NSArray *))successCallback {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (kClientId) {
        [params setObject:kClientId forKey:@"client_id"];
    }
    if (kClientSecret) {
        [params setObject:kClientSecret forKey:@"client_secret"];
    }
    
    NSMutableString *query = [[NSMutableString alloc] initWithString:@""];
    if (settings.searchString) {
        [query appendString:settings.searchString];
    }
    
    [params setObject:query forKey:@"q"];
    [params setObject:@"stars" forKey:@"sort"];
    [params setObject:@"desc" forKey:@"order"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager GET:kReposUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *results = responseObject[@"items"];
        if (results) {
            NSMutableArray *repos = [[NSMutableArray alloc] init];
            for (NSDictionary *result in results) {
                GithubUsers *repo = [[GithubUsers alloc] init];
                [repo initializeWithDictionary:result];
                [repos addObject:repo];
            }
            successCallback(repos);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure while trying to fetch repos");
    }];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n\tName: %@\n\tAvatar: %@\n\t",
            self.login,
            self.userAvatarURL];
}

@end
