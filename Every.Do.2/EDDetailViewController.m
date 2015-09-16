//
//  DetailViewController.m
//  Every.Do.2
//
//  Created by asu on 2015-09-16.
//  Copyright © 2015 asu. All rights reserved.
//

#import "Constants.h"
#import "EDDetailViewController.h"
#import "NSNumber+Operations.h"


@interface EDDetailViewController () <UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIDatePicker *completeByPicker;
@property (weak, nonatomic) IBOutlet UITextView *taskDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *taskTitle;
@property (weak, nonatomic) IBOutlet UIPickerView *priorityPicker;

@property (assign, nonatomic) BOOL clearTaskDescriptionPlaceholder;

@property (strong, nonatomic) EDDataStack *stack;

@end


@implementation EDDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)detailItem dataStack:(EDDataStack*)dataStack {
    
    self.detailItem = detailItem;
    self.stack = dataStack;
    
    // Update the view.
    [self configureView];
}


- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.taskTitle.text = self.detailItem.title;
        self.taskDescriptionTextView.text = self.detailItem.taskDescription;
        [self.priorityPicker selectRow:[[self.detailItem.priority minus:@1] intValue] inComponent:0 animated:YES];
        [self.completeByPicker setDate:self.detailItem.completeBy];
        
        
        self.taskTitle.userInteractionEnabled = NO;
        self.taskDescriptionTextView.userInteractionEnabled = NO;
        self.priorityPicker.userInteractionEnabled = NO;
        self.completeByPicker.userInteractionEnabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.taskDescriptionTextView.delegate = self;
    self.clearTaskDescriptionPlaceholder = YES;
    
    // Adjust the size of the UIDatePicker by scaling.
    CGAffineTransform shrink = CGAffineTransformMakeScale(0.60, 0.60);
    self.completeByPicker.transform = shrink;
    self.completeByPicker.layer.borderWidth = 0.5f;
    self.completeByPicker.layer.borderColor = [[UIColor blackColor] CGColor];
    
    
    // Make the UITextView appear like a UITextField
    [self.taskDescriptionTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.1] CGColor]];
    [self.taskDescriptionTextView.layer setBorderWidth:1.0];
    self.taskDescriptionTextView.layer.cornerRadius = 5;
    self.taskDescriptionTextView.clipsToBounds = YES;
    
    self.priorityPicker.delegate = self;
    self.priorityPicker.dataSource = self;
    self.priorityPicker.transform = shrink;
    self.priorityPicker.layer.borderWidth = 0.5f;
    self.priorityPicker.layer.borderColor = [[UIColor blackColor] CGColor];
    
    [self.priorityPicker selectRow:(5*3)-1 inComponent:0 animated:NO];
    
    
    
    [self configureView];
}



#pragma mark - <UIPickerViewDataSource>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 5 * NUMBER_OF_PRIORITIES;
}

#pragma mark - <UIPickerViewDelegate>
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%d", ((int)row % NUMBER_OF_PRIORITIES)+1];
}


#pragma mark - <UITextViewDelegate>
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.clearTaskDescriptionPlaceholder){
        self.clearTaskDescriptionPlaceholder = NO;
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

@end


//@implementation EDNewToDoViewController
//
//static int const NUMBER_OF_PRIORITIES = 10;
//
//#pragma mark - lifecycle
//

//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - control events
//
//- (IBAction)cancelAction:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (IBAction)saveNew:(id)sender {
//    EDTodo *newItem = [EDTodo new];
//    
//    newItem.title = self.taskTitle.text;
//    newItem.taskDescription = self.taskDescriptionTextView.text;
//    newItem.completeBy = self.completeByPicker.date;
//    newItem.priorityNumber = ([self.priorityPicker selectedRowInComponent:0] % NUMBER_OF_PRIORITIES) + 1;
//    
//    if (self.delegate)
//        [self.delegate receiveToDoItem:newItem];
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//@end

