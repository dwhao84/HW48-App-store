#  HW#48 - App Store 

這次的練習，主要是練習如何串接App store的API，顯示App store榜上25個熱門的Apps，再利用Segmented Control切換付費版以及免費版的內容。

### 功能和畫面需求:
* 利用 segmented control 切換 Free Apps / Paid Apps 列表
* 從 RSS Feed Generator API 取得 App 排行榜
* 點選列表的 App 後顯示 App 的詳細頁面，串接 iTunes Search API
* 利用 SKStoreProductViewController 顯示 App 的購買頁面
* 支援Dark Mode

### 利用 segmented control 切換 Free Apps / Paid Apps 列表:
* 先建立兩個tableView，分別為freeTableView & paidTableView。


   ˋ var freeAppTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    } () ˋ

   ˋ var paidAppTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    } () ˋ






* segmenteControl: Segmented control to switch between free and paid apps.
<p align="center">
<img src="https://github.com/dwhao84/HW48-App-store/blob/main/HW48-App%20store/Supporting%20FIles/Assets.xcassets/Demo%20Gif/HW48_AppStore_SegmentedControl_switched.dataset/HW48_AppStore_SegmentedControl_switched.gif" width="385" height="800"/>
</p>


## Library:
* [KingFisher](https://github.com/onevcat/Kingfisher.git)
