//
//  MasterViewController.m
//  Every.Do.2
//
//  Created by asu on 2015-09-16.
//  Copyright © 2015 asu. All rights reserved.
//

#import "Constants.h"
#import "EDMasterViewController.h"
#import "EDDetailViewController.h"
#import "EDDataStack.h"
#import "EDToDoTask.h"
#import  "NSDate+FormattedDate.h"

@interface EDMasterViewController () <NSFetchedResultsControllerDelegate>

@property NSMutableArray *objects;
@property (nonatomic) EDDataStack *stack;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation EDMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(promptForTitle)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (EDDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.stack = [[EDDataStack alloc] init];
   
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EDToDoTask *object = self.objects[indexPath.row];
        EDDetailViewController *controller = (EDDetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.sections[ section ] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    EDToDoTask *toDoTask = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = toDoTask.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Complete by: %@",
                                 [toDoTask.completeBy dateStringWithFormat:@"dd-MMM-YYYY h:mm:ss a"] ];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:MASTER_VIEW_SORT_KEY] description];
}

#pragma mark - Fetched Results Controller
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:MASTER_VIEW_ENTITY_NAME inManagedObjectContext:self.stack.context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:MASTER_VIEW_SORT_KEY ascending:NO];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.stack.context
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:@"Master"];
    fetchedResultsController.delegate = self;
    self.fetchedResultsController = fetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


#pragma mark - private

-(void)promptForTitle{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Enter a short description of the task"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   NSString* text = ((UITextField*)alertController.textFields.firstObject).text;
                                                   [self insertNewObjectWithTitle:text];
                                               }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {

                                                   }];
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [alertController addTextFieldWithConfigurationHandler:nil];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)insertNewObjectWithTitle:(NSString*)text {
    
    EDToDoTask *toDoTask = [NSEntityDescription
                            insertNewObjectForEntityForName:MASTER_VIEW_ENTITY_NAME
                            inManagedObjectContext:self.stack.context];
    
    toDoTask.title = text;
    toDoTask.taskDescription = @"Nom nom nom nom nom";
    toDoTask.priority = @100;
    toDoTask.completeBy = [NSDate dateWithTimeInterval:SECONDS_PER_DAY * 2 sinceDate:[NSDate date]];
    toDoTask.createdOn = [NSDate date];
    toDoTask.completed = NO;
    
    NSError *saveError = nil;
    
    if (![self.stack.context save:&saveError]) {
        NSLog(@"Save failed! %@", saveError);
    }
    
    
}

@end
