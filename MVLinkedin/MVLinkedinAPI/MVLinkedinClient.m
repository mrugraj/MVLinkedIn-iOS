//
//  MVLinkedinClient.m
//  MVLinkedin
//
//  Created by indianic on 19/07/14.
//  Copyright (c) 2014 Indianic. All rights reserved.
//

#import "MVLinkedinClient.h"
#import "LROAuth2Client.h"
#import "LROAuth2Client/LROAuth2AccessToken.h"


static MVLinkedinClient *linkedinClient;
@implementation MVLinkedinClient{
    LROAuth2Client *oauthClient;
    NSString *strApiKey;
    NSString *strSecret;
    NSString *strState;
    NSString *strRedirectUrl;
}



+(id)linkedinClient{
    if(!linkedinClient){
        linkedinClient = [[MVLinkedinClient alloc]init];
    }
    return linkedinClient;
}


#pragma mark - Authorization Public Methods
-(void)authorizeWithWebview:(UIWebView *)webView
                     apiKey:(NSString *)apiKey
                     secret:(NSString *)secret
                      state:(NSString *)stateString
                redirectUrl:(NSString*)redirectUrl
                permissions:(NSArray*)permissions
               authDelegate:(id)delegate
{
    
    if(!webView || !apiKey || !secret || !stateString || !delegate){
        NSLog(@"Request Parameter Error.");
        return;
    }
    

    strApiKey=apiKey;
    strSecret=secret;
    strState=stateString;
    strRedirectUrl=redirectUrl;
    
    self.webView=webView;
    self.authorizationDelegate=delegate;
    oauthClient = [[LROAuth2Client alloc]
                   initWithClientID:strApiKey
                   secret:strSecret
                   redirectURL:[NSURL URLWithString:strRedirectUrl]];
    oauthClient.delegate = self;
    oauthClient.userURL  = [NSURL
                            URLWithString:@"https://www.linkedin.com/uas/oauth2/authorization"];
    oauthClient.tokenURL = [NSURL
                            URLWithString:@"https://api.linkedin.com/uas/oauth2/accessToken"];
    
    MVLinkedinPermission *mvPermissions = [[MVLinkedinPermission alloc]initWithPermissions:permissions];
    [oauthClient authorizeUsingWebView:self.webView additionalParameters:[self getAdditionalParameters:mvPermissions]];
}

-(NSDictionary*)getAdditionalParameters:(MVLinkedinPermission*)permissions{
    
    NSMutableDictionary *additionalParam = [NSMutableDictionary dictionary];
    [additionalParam setObject:@"code" forKey:@"response_type"];
    [additionalParam setObject:strState forKey:@"state"];
    
    if(permissions){
        NSString *aStrPermissionstring = [permissions getPermissionString];
        [additionalParam setObject:aStrPermissionstring forKey:@"scope"];
    }
    return additionalParam;
}

-(void)oauthClientDidCancel:(LROAuth2Client *)client{
    if([self.authorizationDelegate respondsToSelector:@selector(authorizationClientDidCancel)]){
        [self.authorizationDelegate authorizationClientDidCancel];
    }
}
-(void)oauthClientDidReceiveAccessCode:(LROAuth2Client *)client{
    if([self.authorizationDelegate respondsToSelector:@selector(authorizationClientDidReceiveAccessCode:)]){

    }
}
-(void)oauthClientDidReceiveAccessToken:(LROAuth2Client *)clientLinkedin{
    if([self.authorizationDelegate respondsToSelector:@selector(authorizationClientDidReceiveAccessToken:)]){
        LROAuth2AccessToken *accessToken = clientLinkedin.accessToken;
        _accessToken = accessToken.accessToken;
        dispatch_sync(dispatch_get_main_queue(), ^{
                   [self.authorizationDelegate authorizationClientDidReceiveAccessToken:accessToken.accessToken];
        });
        
    }
}
-(void)oauthClientDidRefreshAccessToken:(LROAuth2Client *)client{
    
}



#pragma mark - Public Methods API calls

-(void)getBasicProfile:(id)delegate{
    if(delegate)
        self.basicProfileDelegate = delegate;
    
    NSString *strUrl =  [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(first-name,last-name,headline,public-profile-url,id,email-address,educations,last-modified-timestamp,picture-url,languages,skills)?oauth2_access_token=%@",self.accessToken];

    [self callApi:strUrl respondTo:@selector(basicProfileFetchDidFinished:) delegate:self.basicProfileDelegate failSelector:@selector(basicProfileFetchDidFail:)];
}


-(void)getMemberProfileof:(NSString*)linkedinId delegate:(id)delegate
{
    https://api.linkedin.com/v1/people/id={id}
    if(delegate)
        self.basicProfileDelegate = delegate;
    
    NSString *strUrl =  [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/id=%@?oauth2_access_token=%@",linkedinId,self.accessToken];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, YES), ^{
        
        NSDictionary *aUserDict = [self syncGETDataforURL:strUrl];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(aUserDict && [self.basicProfileDelegate respondsToSelector:@selector(basicProfileFetchDidFinished:)]){
                
                [self.basicProfileDelegate basicProfileFetchDidFinished:aUserDict];
                
            }else if([self.basicProfileDelegate respondsToSelector:@selector(basicProfileFetchDidFail:)]){
                
                NSError *aError = [NSError errorWithDomain:@"Failed to Fetch basic Profile" code:-1 userInfo:aUserDict];
                [self.basicProfileDelegate basicProfileFetchDidFail:aError];
                
            }
            
        });
    });
}

-(void)getDetailProfile:(NSString *)linkedInId delegate:(id)delegate{
    NSString *strLinkededInId = linkedInId?[NSString stringWithFormat:@"id=%@",linkedInId] :@"~";
    self.detailProfileDelegate=delegate;
    
    NSString *strUrl =  [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/%@:(id,first-name,last-name,headline,location,industry,distance,current-status,current-status-timestamp,summary,positions,educations,member-url-resources,api-standard-profile-request,site-standard-profile-request,picture-url,email-address,formatted-name,phonetic-first-name,phonetic-last-name,formatted-phonetic-name,certifications,public-profile-url,last-modified-timestamp,interests,three-current-positions,three-past-positions,date-of-birth,honors-awards,main-address,im-accounts,group-memberships,languages,skills)?oauth2_access_token=%@",strLinkededInId,self.accessToken];
    
     [self callApi:strUrl respondTo:@selector(detailProfileFetchDidFinished:) delegate:self.detailProfileDelegate failSelector:@selector(detailProfileFetchDidFail:)];
    
}
-(void)getProfilePic:(NSString *)linkedInId delegate:(id)delegate{
    
//    http://api.linkedin.com/v1/people/~/picture-urls::(original)
    self.detailProfileDelegate=delegate;
    NSString *strUrl =  [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/picture-urls::(original)?oauth2_access_token=%@",self.accessToken];
    
    [self callApi:strUrl respondTo:@selector(profilePicFetchDidFinished:) delegate:self.detailProfileDelegate failSelector:@selector(profilePicFetchDidFailed:)];
}


#pragma mark - GET Request Method

-(void)callApi:(NSString*)strUrl respondTo:(SEL)selector delegate:(id)sender failSelector:(SEL)failedTo{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, NO), ^{
        NSDictionary *aUserDict = [self syncGETDataforURL:strUrl];

        
        if(aUserDict && [sender respondsToSelector:selector]){
            [sender performSelectorOnMainThread:selector withObject:aUserDict waitUntilDone:NO];
            
        }else if([sender respondsToSelector:failedTo]){
            
            NSError *aError = [NSError errorWithDomain:@"Failed to Fetch basic Profile" code:-1 userInfo:aUserDict];
            [sender performSelectorOnMainThread:failedTo withObject:aError waitUntilDone:NO];
            
        }
    });
}

-(NSDictionary *)syncGETDataforURL:(NSString *)strURL{
    
    NSURL *aUrl=[NSURL URLWithString:strURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:aUrl
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    
    [urlRequest setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    if(urlData){
        // Construct a Dictionary around the Data from the response
        NSDictionary *aDict=[NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:&error];
        if(error){
            NSLog(@"%@",error);
        }
        return aDict;
    }else{return nil;}
    
}

@end
