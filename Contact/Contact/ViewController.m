//
//  ViewController.m
//  Contact
//
//  Created by mac on 16/6/26.
//  Copyright © 2016年 JS. All rights reserved.
//

#import "ViewController.h"
#import "Contacts.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic , strong) NSArray *dataArr;/**< <#describe#>*/

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTableView.rowHeight = 80;
    
    
    __weak ViewController *myControl = self;
    
    [Contacts getContactsSucess:^(NSMutableArray *contacts) {
        
        
        myControl.dataArr = contacts;
        [myControl.myTableView reloadData];
        
    } fail:^(NSString *error) {
        
        if ([error isEqualToString:@"没有权限"]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有通讯录权限，请到设置里面打开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alter show];
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    ContactPhoneModel *phone = self.dataArr[indexPath.row];
    
    cell.textLabel.text =[NSString stringWithFormat:@"姓名：%@",phone.name] ;
    cell.detailTextLabel.text =[NSString stringWithFormat:@"电话号码：%@",phone.phone] ;
    
    
    
    return cell;
}

@end
