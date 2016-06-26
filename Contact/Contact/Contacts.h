//
//  Contacts.h
//  通讯录获取
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 JS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import "ContactPhoneModel.h"

@interface Contacts : NSObject
@property (nonatomic, strong) CNContactStore *store;

+(void)getContactsSucess:(void(^)(NSMutableArray *contacts))successBlock fail:(void (^)(NSString *error))failBlock;


@end
