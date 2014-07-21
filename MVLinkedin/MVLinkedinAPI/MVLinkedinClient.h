//
//  MVLinkedinClient.h
//  MVLinkedin
//
//  Created by indianic on 19/07/14.
//  Copyright (c) 2014 Indianic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVLinkedinPermission.h"

//AUTHORIZATION
@protocol MVAuthorizationDelegate <NSObject>

-(void)authorizationClientDidCancel;
-(void)authorizationClientDidReceiveAccessCode:(NSString *)accessCode;
-(void)authorizationClientDidReceiveAccessToken:(NSString*)accessToken;
-(void)authorizationClientDidFailWithError:(NSError*)error;

@end

//BASIC PROFILE API
@protocol MVBasicProfileDelegate <NSObject>
-(void)basicProfileFetchDidFinished:(NSDictionary*)profileInfo;
-(void)basicProfileFetchDidFail:(NSError*)error;
@end

//DETAIL PROFILE
@protocol MVDetailProfileDelegate <NSObject>
-(void)detailProfileFetchDidFinished:(NSDictionary*)profileInfo;
-(void)detailProfileFetchDidFail:(NSError*)error;
-(void)profilePicFetchDidFinished:(NSDictionary*)profilePicUrl;
-(void)profilePicFetchDidFailed:(NSError*)error;
@end


@interface MVLinkedinClient : NSObject
@property(strong,nonatomic)UIWebView            *webView;
@property(strong,nonatomic,readonly) NSString   *accessToken;

@property(nonatomic,strong)id <MVBasicProfileDelegate> basicProfileDelegate;
@property(nonatomic,strong)id <MVAuthorizationDelegate> authorizationDelegate;
@property(nonatomic,strong)id <MVDetailProfileDelegate> detailProfileDelegate;

+(id)linkedinClient;
-(void)authorizeWithWebview:(UIWebView *)webView
                     apiKey:(NSString *)apiKey
                     secret:(NSString *)secret
                      state:(NSString *)stateString
                redirectUrl:(NSString*)redirectUrl
                permissions:(NSArray*)permissions
               authDelegate:(id)delegate;

//API Calls
-(void)getBasicProfile:(id)delegate;
-(void)getDetailProfile:(NSString*)linkedInId delegate:(id)delegate;
-(void)getProfilePic:(NSString*)linkedInId delegate:(id)delegate;
@end
