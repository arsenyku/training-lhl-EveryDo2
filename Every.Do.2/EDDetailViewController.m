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

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;


@property (assign, nonatomic) BOOL clearTaskDescriptionPlaceholder;
@property (assign, nonatomic) BOOL isEditing;
@property (strong, nonatomic) EDDataStack *stack;

@end


@implementation EDDetailViewController

static int const PickerWrapCount = 5;

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
        
        
        self.taskTitle.userInteractionEnabled = self.isEditing;
        self.taskDescriptionTextView.userInteractionEnabled = self.isEditing;
        self.priorityPicker.userInteractionEnabled = self.isEditing;
        self.completeByPicker.userInteractionEnabled = self.isEditing;

        if (self.isEditing){
            self.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                          target:self
                                                          action:@selector(saveToDo)];
            
            self.navigationItem.leftBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                          target:self
                                                          action:@selector(cancelChanges)];
            
        } else {
            self.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                          target:self
                                                          action:@selector(editToDo)];
            
            self.navigationItem.leftBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(backToPreviousView)];

        }

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.taskDescriptionTextView.delegate = self;
    self.clearTaskDescriptionPlaceholder = YES;
    self.isEditing = NO;
    
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
    
    [self.priorityPicker selectRow:(PickerWrapCount * NUMBER_OF_PRIORITIES)/2 inComponent:0 animated:NO];

    [self configureView];
}

#pragma mark - Button events

-(void)editToDo{
    self.isEditing = YES;
    [self configureView];
}

-(void)saveToDo{
    self.isEditing = NO;

    
    self.detailItem.title = self.taskTitle.text;
    self.detailItem.taskDescription = self.taskDescriptionTextView.text;
    self.detailItem.completeBy = [self.completeByPicker date];
    self.detailItem.priority = [ NSNumber numberWithLong:[self.priorityPicker selectedRowInComponent:0]+1 ];

    NSError *error = nil;
    if ( ! [self.stack.context save:&error] )
        NSLog(@"Error while saving edits: %@", error);
    
    [self configureView];
}

-(void)backToPreviousView{
    self.isEditing = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelChanges{
    self.isEditing = NO;
    [self configureView];
}


#pragma mark - <UIPickerViewDataSource>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return PickerWrapCount * NUMBER_OF_PRIORITIES;
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

