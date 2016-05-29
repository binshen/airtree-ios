//
//  Person.h
//  airtree
//
//  Created by Bin Shen on 5/29/16.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, assign) int index;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;

@end
