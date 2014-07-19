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
#import "OAConsumer.h"
#import "OAToken.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"

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

#pragma mark - Basic Profile Fetch
-(void)getBasicProfile:(id)delegate{
    NSString *aStrTokenString = [NSString stringWithFormat:@"oauth2_access_token=%@",self.accessToken];
    OAToken *accessToken = [[OAToken alloc] initWithHTTPResponseBody:aStrTokenString];
    OAConsumer *consumer = [[OAConsumer alloc]initWithKey:strApiKey secret:strSecret realm:@"http://api.linkedin.com/"];
    
   //    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~:(first-name,last-name,headline,public-profile-url,id,connections,email-address,educations,last-modified-timestamp,picture-url,languages,skills)"];
    
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~:(first-name,last-name,headline,public-profile-url,id,email-address,educations,last-modified-timestamp,picture-url,languages,skills)"];
    
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:consumer
                                       token:accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];

    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(profileApiCallResult:didFinish:)
                  didFailSelector:@selector(profileApiCallResult:didFail:)];
    
}
- (void)profileApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    
    NSMutableDictionary *profile = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
    if ( profile )
    {
        
    }
}

-(void)profileApiCallResult:(OAServiceTicket *)ticket didFail:(NSData*)errror
{
    
}
@end
