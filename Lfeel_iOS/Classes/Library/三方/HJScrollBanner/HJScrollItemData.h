//
//  HJScrollItemData.h
//  HJScrollImage
//
//  Created by hoojack on 15/8/8.
//  Copyright (c) 2015年 hoojack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJScrollItemData : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString* imageUrls;
@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* desc;
@property (nonatomic, copy) UIImage * image;
@property (nonatomic, assign, getter=isUrl) BOOL url;
@end
