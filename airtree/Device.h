//
//  Device.h
//  airtree
//
//  Created by Bin Shen on 5/29/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject

@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, assign) int status;

@end
