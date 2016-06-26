//
//  ContactPhoneModel.h
//  通讯录获取
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 JS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactPhoneModel : NSObject


@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *phone;

@property (nonatomic , assign) BOOL isSelct;

@end
