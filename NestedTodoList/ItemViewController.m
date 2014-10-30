//
// Created by Chris Eidhof
//

#import "ItemViewController.h"
#import "FetchedResultsControllerDataSource.h"
#import "Store.h"
#import "Item.h"

static NSString* const selectItemSegue = @"selectItem";

@interface ItemViewController () <FetchedResultsControllerDataSourceDelegate, UITextFieldDelegate>

@property (nonatomic, readwrite) FetchedResultsControllerDataSource* fetchedResultsControllerDataSource;
@property (nonatomic, readwrite) UITextField* titleField;

@end

@implementation ItemViewController

#pragma mark - UIViewController life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add buttons
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(insertItem:)];
    
    [self setupFetchedResultsController];
    [self setupNewItemField];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.fetchedResultsControllerDataSource.paused = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.fetchedResultsControllerDataSource.paused = YES;
}


- (void)setupFetchedResultsController {
    self.fetchedResultsControllerDataSource = [[FetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    self.fetchedResultsControllerDataSource.fetchedResultsController = self.parent.childrenFetchedResultsController;
    self.fetchedResultsControllerDataSource.delegate = self;
    self.fetchedResultsControllerDataSource.reuseIdentifier = @"Cell";
}

- (void)setupNewItemField {
    self.titleField = [[UITextField alloc] init];
    self.titleField.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleField.textAlignment = NSTextAlignmentRight;
    self.titleField.delegate = self;
    self.tableView.tableHeaderView = self.titleField;
}

#pragma mark - FetchedResultsControllerDataSourceDelegate
- (void)configureCell:(id)theCell withObject:(id)object {
    UITableViewCell* cell = (UITableViewCell *) theCell;
    Item* item = object;
    cell.textLabel.text = item.title;
}

- (void)deleteObject:(id)object {
    Item* item = object;
    NSString* actionName = [NSString stringWithFormat:NSLocalizedString(@"Delete \"%@\"", @"Delete undo action name"), item.title];
    [self.undoManager setActionName:actionName];
    [item.managedObjectContext deleteObject:item];
}

#pragma mark Segues
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:selectItemSegue]) {
        [self presentSubItemViewController:segue.destinationViewController];
    }
}

- (void)presentSubItemViewController:(ItemViewController*)subItemViewController {
    Item* item = [self.fetchedResultsControllerDataSource selectedItem];
    subItemViewController.parent = item;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    NSString* title = textField.text;
    NSString* actionName = [NSString stringWithFormat:NSLocalizedString(@"add item \"%@\"", @"Undo action name of add item"), title];
    [self.undoManager setActionName:actionName];
    [Item insertItemWithTitle:title
                       parent:self.parent
       inManagedObjectContext:self.managedObjectContext];
    textField.text = @"";
    [textField resignFirstResponder];
    
    return NO;
}

- (NSManagedObjectContext*)managedObjectContext {
    return self.parent.managedObjectContext;
}

/**
 Displays the iOS keyboard by setting the property @c titleField as the first responder.
 @warning If you type with your actual computer keyboard, then the keyboard in the iOS simulator will no longer appear. To solve, navigate to to iOS Simulator > Hardware > Keyboard and uncheck "Connect Hardware Keyboard"
 @see http://stackoverflow.com/questions/24420873/xcode-6-keyboard-does-not-show-up-in-simulator#24497773
 */
- (void)insertItem:(__unused id)sender {
    NSAssert(self.titleField != nil, @"The property titleField is nil.");
    NSAssert(YES == [self.titleField becomeFirstResponder], @"The property titleField refused to become the first responder.");
}

#pragma mark - Setters
- (void)setParent:(Item *)parent {
    _parent = parent;
    self.navigationItem.title = parent.title;
}

#pragma mark Undo
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSUndoManager *)undoManager {
    return self.managedObjectContext.undoManager;
}

@end
