//
//  ContactDetailViewController.m
//  ContactsDemo2
//
//  Created by penddy on 16/1/3.
//  Copyright © 2016年 penddy. All rights reserved.
//

#import "ContactDetailViewController.h"

@interface ContactDetailViewController ()

@end

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    ContactItem *item = self.item;
    self.nameLabel.text = item.name;
    self.phoneLabel.text = item.phone;
    self.popoLabel.text = item.popo;
    self.qqLabel.text = item.qq;
    self.extNumberLabel.text = item.extNumber;
//    self.levelLabel.text = item.level;
    self.managerLabel.text =  item.manager;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
