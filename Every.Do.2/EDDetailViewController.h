//
//  DetailViewController.h
//  Every.Do.2
//
//  Created by asu on 2015-09-16.
//  Copyright © 2015 asu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDDataStack.h"
#import "EDToDoTask.h"

@interface EDDetailViewController : UITableViewController

@property (strong, nonatomic) EDToDoTask *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (void)setDetailItem:(EDToDoTask*)detailItem dataStack:(EDDataStack*)dataStack ;

@end

