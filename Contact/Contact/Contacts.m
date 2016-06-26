//
//  Contacts.m
//  通讯录获取
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 JS. All rights reserved.
//

#import "Contacts.h"
#import <UIKit/UIKit.h>


@implementation Contacts

+(void)getContactsSucess:(void(^)(NSMutableArray *contacts))successBlock fail:(void (^)(NSString *error))failBlock
{
    Contacts *cn = [[Contacts alloc] init];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 9.0)
    {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        
        switch (status) {
            case kABAuthorizationStatusNotDetermined:
            
            case kABAuthorizationStatusRestricted:
            {
                
                ABAddressBookRef book =   ABAddressBookCreateWithOptions(NULL, NULL);
                
                //申请授权
                
                ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) {
                    
                    if (granted) {
                        if (successBlock) {
                            successBlock([cn getContacts]);
                        };

                        
                        
                    }else{
                        
                        if (failBlock) {
                            failBlock(@"授权失败");
                        }
                        
                    }
                    
                });
            }
                break;
            case kABAuthorizationStatusDenied:
            {
                if (failBlock) {
                    failBlock(@"没有权限");
                }
            }
                break;
                
                /**
                 *  已经授权
                 */
            case kABAuthorizationStatusAuthorized:
            {
                
                if (successBlock) {
                    successBlock([cn getContacts]);
                };

            }
                break;
                
            default:
                break;
        }
        
       

    }
    else
    {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        
        //如果没有授权过需要请求用户的授权
        
        CNContactStore *store = [[CNContactStore alloc]init];
        
        cn.store = store;
        
        
        switch (status) {
            case CNAuthorizationStatusNotDetermined:
            
            case CNAuthorizationStatusRestricted:
            {
                //请求授权
                
                [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    
                    
                    
                    if (granted) {
                        
                        if (successBlock) {
                            successBlock([cn ios9GetContacts]);
                        };
                        
                        
                    }else{
                        
                        if (failBlock) {
                            failBlock(@"授权失败");
                        }
                        
                    }
                    
                    
                    
                }];
            }
                break;
            case CNAuthorizationStatusDenied:
            {
                if (failBlock) {
                    failBlock(@"没有权限");
                }
            }
                break;
                //已经授权
            case CNAuthorizationStatusAuthorized:
            {
                if (successBlock) {
                    successBlock([cn ios9GetContacts]);
                };

            }
                break;
                
            default:
                break;
        }
        
        
        
    }
}



- (NSMutableArray *)getContacts
{
    //获取联系人 信息
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
    
    ABAddressBookRef book =   ABAddressBookCreateWithOptions(NULL, NULL);
    
    CFArrayRef  allpeople =  ABAddressBookCopyArrayOfAllPeople(book);
    
    CFIndex count =  CFArrayGetCount(allpeople);
    
    for (CFIndex i = 0; i <count ; i++) {
        
        ABRecordRef record =   CFArrayGetValueAtIndex(allpeople, i);
        
        CFStringRef strFirst =   ABRecordCopyValue(record, kABPersonFirstNameProperty);
        
        CFStringRef strmdills =   ABRecordCopyValue(record, kABPersonMiddleNameProperty);
        
        CFStringRef strfamily =   ABRecordCopyValue(record, kABPersonLastNameProperty);
        
        NSString *str =[NSString stringWithFormat:@"%@%@%@",(__bridge_transfer NSString *)strfamily,(__bridge_transfer NSString *)strmdills,(__bridge_transfer NSString *)strFirst];
        
//        NSLog(@"%@",str);
        
        //电话号码
        
        ABMultiValueRef multivalue =  ABRecordCopyValue(record, kABPersonPhoneProperty);
        
       
        NSMutableArray *phoneMut = [[NSMutableArray alloc] init];
        
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(multivalue); i++) {
            
            CFStringRef phoneStr =   ABMultiValueCopyValueAtIndex(multivalue, i);
            
//            NSLog(@"phoneStr = %@",phoneStr);
            
            NSString *phone = (__bridge_transfer  NSString *)(phoneStr);
            
           NSString *aamyphone =  [Contacts formatPhoneNumber:phone];
            
//            if ([UityTools isMobileNumber:aamyphone]) {
            
                ContactPhoneModel *phone1 = [[ContactPhoneModel alloc] init];
                phone1.name = str;
                
                phone1.phone = aamyphone;
                [phoneNumbers addObject:phone1];

                
//            }
            //            NSLog(@"格式化：%@",aamyphone);
//            NSLog(@"%@",phone);
            CFRelease(phoneStr);
        }
        CFRelease(strfamily);
        CFRelease(strmdills);
        CFRelease(strFirst);
        
        
        
        
    }
    CFRelease(allpeople);
    
    
    
    return phoneNumbers;
}

//去除号码格式
+ (NSString *)formatPhoneNumber:(NSString*)number
{
    number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSInteger len = number.length;
    if (len < 6)
    {
        return number;
    }
    
    if ([[number substringToIndex:2] isEqualToString:@"86"])
    {
        number = [number substringFromIndex:2];
    }
    else if ([[number substringToIndex:3] isEqualToString:@"+86"])
    {
        number = [number substringFromIndex:3];
    }
    else if ([[number substringToIndex:4] isEqualToString:@"0086"])
    {
        number = [number substringFromIndex:4];
    }
    else if ([[number substringToIndex:5] isEqualToString:@"12593"])
    {
        number = [number substringFromIndex:5];
    }
    else if ([[number substringToIndex:5] isEqualToString:@"17951"])
    {
        number = [number substringFromIndex:5];
    }
    else if (len == 16 && [[number substringToIndex:6] isEqualToString:@"125201"])
    {
        number = [number substringFromIndex:5];
    }
    
    return number;
}

- (NSMutableArray *)ios9GetContacts
{
    //name  phone
    
    //根据需要增加查询类型
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactGivenNameKey,CNContactPhoneNumbersKey,CNContactMiddleNameKey,CNContactFamilyNameKey]];
    
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
    
    //参数1  封装查询请求
    
    [self.store enumerateContactsWithFetchRequest: request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        
        
        
        
        
        for (CNLabeledValue * labeledValue in contact.phoneNumbers) {
            
            CNPhoneNumber *num = labeledValue.value;
            
//            NSLog(@"num = %@",num.stringValue);
//            
//            NSLog(@"num111 = %@",[num valueForKey:@"digits"]);
            
            
//            if ([UityTools isMobileNumber:[Contacts formatPhoneNumber:num.stringValue]]) {
                ContactPhoneModel *phone = [[ContactPhoneModel alloc] init];
                phone.name =[NSString stringWithFormat:@"%@%@%@" ,contact.familyName,contact.middleName,contact.givenName];
                phone.phone =  [Contacts formatPhoneNumber:num.stringValue];
                
                [phoneNumbers addObject:phone];

//            }
            
            
        }
        
        
    }];
    
    return phoneNumbers;
}

@end
