//
//  NewNoteViewController.m
//  OhNote
//
//  Created by 吴伟城 on 16/2/16.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

#import "NewNoteViewController.h"
#import "OhNote-swift.h"

@interface NewNoteViewController ()
@end
@implementation NewNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHTML:@"<p>haha</p>"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
