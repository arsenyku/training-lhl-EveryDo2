//
//  DetailViewController.h
//  Every.Do.2
//
//  Created by asu on 2015-09-16.
//  Copyright © 2015 asu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

