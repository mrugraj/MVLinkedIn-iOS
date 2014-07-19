//
//  MVLinkedinPermission.m
//  MVLinkedin
//
//  Created by indianic on 19/07/14.
//  Copyright (c) 2014 Indianic. All rights reserved.
//

#import "MVLinkedinPermission.h"



@implementation MVLinkedinPermission{
    NSMutableArray* mutArrPermissions;
    NSArray *arrStandardPermissions;
}

-(id)init{
    self= [super init];
    [self initArray];
    return self;
}

-(id)initWithPermissions:(NSArray*)permissions{
    self=[self init];
    if(!mutArrPermissions){
        mutArrPermissions = [NSMutableArray array];
    }
    [mutArrPermissions addObjectsFromArray:permissions];
    return self;
}

-(void)initArray{
    arrStandardPermissions  = [NSArray arrayWithObjects:kMVPermissionAnalytics,kMVPermissionBasicProfile,kMVPermissionConnections,kMVPermissionContactInfo,kMVPermissionDetailProfile,kMVPermissionEmail,kMVPermissionGroups,kMVPermissionMessages,kMVPermissionNetworkUpdates,nil];    
}

-(NSString *)getPermissionString{
    NSMutableString *mutableString = [NSMutableString string];
    
    for (NSString* strPermission in mutArrPermissions) {
        [mutableString appendString:[NSString stringWithFormat:@" %@",strPermission]];
    }
    
    return [mutableString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
-(void)addPermission:(NSString *)permission{
    if(!mutArrPermissions){
        mutArrPermissions = [NSMutableArray array];
    }
    [mutArrPermissions addObject:permission];
}
@end
