#  HW#48 - App Store 

## Key Components
### Constants
* largetTitle: Title for the navigation bar.
* freeAppStoreUrl and paidAppStoreUrl: URLs to fetch top free and paid apps.

### Variables
* freeAppsData and paidAppsData: Hold the data for free and paid apps.
* activityIndicator: Shows loading status.
* paidAppPrice: Holds the price information for paid apps.

## UI Elements
* segmenteControl: Segmented control to switch between free and paid apps.

<p align="center">
<img src="https://github.com/dwhao84/HW48-App-store/blob/main/HW48-App%20store/Supporting%20FIles/Assets.xcassets/Demo%20Gif/HW48_AppStore_SegmentedControl_switched.dataset/HW48_AppStore_SegmentedControl_switched.gif" width="385" height="800"/>
</p>


* freeAppTableView and paidAppTableView: Table views to display free and paid apps respectively.
* allAppBtn: Button to show all apps.
* refreshControl: Allows pull-to-refresh functionality.

## Life Cycle Methods
#### viewDidLoad()
* Sets up UI components and fetches initial data for free and paid apps.

## UI Setup Methods
#### setupUI()
* Initializes and configures the UI elements.
* Fetches app data using fetchFreeAppsData and fetchPaidAppsData.

#### setNavigationView()
* Configures the navigation bar appearance.

#### configFreeTableView() and configPaidTableView()
* Configure the properties of the table views.

## Data Fetching Methods

#### fetchFreeAppsData(url:completion:) and fetchPaidAppsData(url:completion:)
* Fetch data from the provided URLs.
* Handle and decode JSON responses.
#### fetchITunesData()
* Fetch additional iTunes data for paid apps.

## User Interaction Methods
#### segmentedControlValueChanged(_:)
* Switches between free and paid app views based on the selected segment.

#### refreshControlActivited(_:)
* Ends refreshing animation when the user pulls to refresh.
#### allAppsBtn(_:)
* Prints a debug statement when the "All Apps" button is pressed.

## Table View Delegate and Data Source Methods
#### tableView(_:numberOfRowsInSection:)
* Returns the number of rows in each table view based on the available data.

#### tableView(_:cellForRowAt:)
* Configures and returns the cell for each row in the table views.

#### tableView(_:didSelectRowAt:)
* Handles the selection of a row in the table views.
* Presents the selected app in the _SKStoreProductViewController_.

## Extensions
##### The class conforms to _UITableViewDelegate_, _UITableViewDataSource_, and _SKStoreProductViewControllerDelegate_ to handle table view operations and d displaying app details.

