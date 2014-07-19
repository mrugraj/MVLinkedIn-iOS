//
//  MVLinkedinPermission.h
//  MVLinkedin
//
//  Created by indianic on 19/07/14.
//  Copyright (c) 2014 Indianic. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMVPermissionBasicProfile   @"r_basicprofile"
#define kMVPermissionDetailProfile  @"r_fullprofile"
#define kMVPermissionEmail          @"r_emailaddress"
#define kMVPermissionConnections    @"r_network"
#define kMVPermissionContactInfo    @"r_contactinfo"
#define kMVPermissionNetworkUpdates @"rw_nus"
#define kMVPermissionAnalytics      @"rw_company_admin"
#define kMVPermissionGroups         @"rw_groups"
#define kMVPermissionMessages       @"w_messages"

@interface MVLinkedinPermission : NSObject

-(NSString*)getPermissionString;
-(id)initWithPermissions:(NSArray*)permissions;
-(void)addPermission:(NSString*)permission;
@end
