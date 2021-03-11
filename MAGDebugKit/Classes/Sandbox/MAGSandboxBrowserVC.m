#import "MAGSandboxBrowserVC.h"
@import WebKit;


static NSString *const sandboxBrowserCellId = @"sandboxBrowserCellId";


@interface MAGSandboxBrowserVC () <UIDocumentInteractionControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic) NSFileManager *fm;
@property (nonatomic) NSURL *url;
@property (nonatomic) UIDocumentInteractionController *documentInteractor;
@property (nonatomic) NSArray <NSURL *> *items;
@property (nonatomic) NSArray <NSURL *> *filteredItems;
@property (strong,nonatomic)UISearchController * searchController;
@property (strong) NSString* searchText;

@end


@implementation MAGSandboxBrowserVC

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [self initWithURL:nil];
	return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [self initWithURL:nil];
	return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
	self = [self initWithURL:nil];
	return self;
}

- (instancetype)initWithURL:(NSURL *)url {
	self = [super initWithStyle:UITableViewStylePlain];
	if (!self) {
		return nil;
	}

	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.delegate = self;
	self.searchController.searchBar.delegate = self;
	[self.searchController.searchBar sizeToFit];
	self.searchController.searchResultsUpdater = self;
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.definesPresentationContext = YES;
	self.tableView.tableHeaderView = self.searchController.searchBar;

	_fm = [NSFileManager defaultManager];

	if (!url) {
		url = [NSURL fileURLWithPath:NSHomeDirectory()];
	}

	_url = url;

	[self reloadItems];

	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = self.url.path.lastPathComponent;
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Private methods

- (void)reloadItems {
	NSError *__autoreleasing error = nil;
	NSArray <NSURL *> *items = [self.fm contentsOfDirectoryAtURL:self.url includingPropertiesForKeys:@[]
		options:0 error:&error];

	self.items = [items sortedArrayUsingComparator:^NSComparisonResult(NSURL*  _Nonnull obj1, NSURL*  _Nonnull obj2) {
		return [obj1.lastPathComponent compare:obj2.lastPathComponent];
	}];

	if (!self.items) {
		NSLog(@"Error while getting directory contents: %@", error);
	}

	if (self.searchText == nil || self.searchText.length == 0) {
		self.filteredItems = self.items;
	} else {
		NSArray * searchResults = [self.items filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
			BOOL result = NO;
			if ([((NSURL *)evaluatedObject).lastPathComponent.lowercaseString containsString:self.searchText.lowercaseString]) {
				result = YES;
			}

			return result;
		}]];

		self.filteredItems = searchResults;
	}
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.filteredItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sandboxBrowserCellId];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
			reuseIdentifier:sandboxBrowserCellId];
	}

	NSURL *item = self.filteredItems[indexPath.row];
	NSDictionary *attributes = [self.fm attributesOfItemAtPath:item.path error:nil];

	NSString *fileSize = [NSByteCountFormatter stringFromByteCount:attributes.fileSize
		countStyle:NSByteCountFormatterCountStyleFile];

	static NSDateFormatter *df = nil;
	if (!df) {
		df = [[NSDateFormatter alloc] init];
		df.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
		df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	}

	NSString *editDate = [df stringFromDate:attributes.fileModificationDate];

	cell.textLabel.text = item.lastPathComponent;
	cell.textLabel.numberOfLines = 0;

	BOOL isDirectory = [attributes.fileType isEqualToString:NSFileTypeDirectory];
	if (isDirectory) {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"directory, edited %@", editDate];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, edited %@", fileSize, editDate];
		cell.accessoryType = UITableViewCellAccessoryDetailButton;
	}

	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

	if (editingStyle != UITableViewCellEditingStyleDelete) {
		return;
	}

	NSURL *item = self.filteredItems[indexPath.row];
	NSError *__autoreleasing error = nil;
	BOOL removed = [self.fm removeItemAtURL:item error:&error];
	if (removed) {
		[self reloadItems];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	} else {
		NSLog(@"Error while removing file from sandbox: %@", error);
	}
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	NSURL *item = self.filteredItems[indexPath.row];
	NSDictionary *attributes = [self.fm attributesOfItemAtPath:item.path error:nil];
	BOOL isDirectory = [attributes.fileType isEqualToString:NSFileTypeDirectory];
	if (isDirectory) {
		MAGSandboxBrowserVC *vc = [[MAGSandboxBrowserVC alloc] initWithURL:item];
		[self.navigationController pushViewController:vc animated:YES];
	} else {
		UIViewController *vc = [[UIViewController alloc] init];

		WKWebView *view = [[WKWebView alloc] initWithFrame:vc.view.bounds];
		[vc.view addSubview:view];
		view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		[view loadFileURL:item allowingReadAccessToURL:self.url];
		[self.navigationController pushViewController:vc animated:YES];

		// Use QLPreviewController ???
	}
}

- (void)tableView:(UITableView *)tableView
	accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

	NSURL *item = self.filteredItems[indexPath.row];
	NSDictionary *attributes = [self.fm attributesOfItemAtPath:item.path error:nil];
	BOOL isDirectory = [attributes.fileType isEqualToString:NSFileTypeDirectory];
	if (isDirectory) {
		MAGSandboxBrowserVC *vc = [[MAGSandboxBrowserVC alloc] initWithURL:item];
		[self.navigationController pushViewController:vc animated:YES];
	} else {
		self.documentInteractor = [UIDocumentInteractionController
			interactionControllerWithURL:item];
		[self.documentInteractor presentOptionsMenuFromRect:[tableView rectForRowAtIndexPath:indexPath]
			inView:tableView animated:YES];
	}
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {

	return self.navigationController;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
}

#pragma mark - UISearchResultUpdating
//Do real search,this is up to you
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
	NSString * searchtext = searchController.searchBar.text;
	self.searchText = searchtext;
	[self reloadItems];
	[self.tableView reloadData];
}

-(void) didPresentSearchController:(UISearchController *)searchController {
	[self fnResizeTableViewHeaderHeight];
}

-(void) didDismissSearchController:(UISearchController *)searchController {
	[self fnResizeTableViewHeaderHeight];
}

-(void) fnResizeTableViewHeaderHeight {
	CGFloat height = [self.searchController.searchBar systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

	UIView *headerView = self.tableView.tableHeaderView;

	CGRect frame = headerView.frame;

	frame.size.height = height;
	headerView.frame = frame;

	self.tableView.tableHeaderView = headerView;
}

@end
