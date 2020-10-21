# FlickrSearch
* 面試前測驗題目 for 群禧 Ltd.

## 主題
* 利用 Flickr API 做出 Demo APP
    * 完成的 Project 放在 github 上,並獨立一個 repo 做存放
    * 請用 Swift 4.0 以上 語言做開發
    * 請在作業完成後,在 README 備註使用什麼架構進行此次作業
    * 架構會是影響評分的關鍵
* 使用的API
    * flickr.photos.search
    * [document](https://www.flickr.com/services/api/flickr.photos.search.html)
    * [testing](https://www.flickr.com/services/api/explore/flickr.photos.search)

## 功能
* 第一頁 (搜尋輸入頁)
    - [x] 有兩個輸入框
    - [x] 第一個是搜尋文字的輸入匡(Text)
    - [x] 第二個是每頁要呈現的數量的輸入匡(Per Page)
    - [x] 此兩個輸入匡都要填寫,button 才可以點擊
    - [x] 不可點擊的 button 和可點擊的 button 用不同顏色區別
    - [x] 點擊button會轉跳(push)到第二頁(搜尋結果頁)
* 第二頁 (搜尋結果頁)
    - [x] 顯示Flickr回傳的API結果,並且固定一行兩個 cell
    - [ ] 此頁可下拉重新更新
    - [ ] 此列表可上拉看到下一頁內容(可無限上拉)
    - [x] Cell 會顯示圖片(photo),與標題,Cell為正方形
* 進階題
    - [x] tabbar 多一個分頁
    - [x] 在搜尋結果頁的每一個 cell 加上加入收藏的按鈕
    - [x] 當按加入收藏,到我的最愛頁面,可以看到該 photo 被加入
    - [x] 重開 APP 依然可以看到被加入的收藏

## 架構
* 主要使用 MCV 架構編寫
    * 共有三個畫面，此三畫面的 model 分別是 `FSInfoVC.xib`(搜尋資訊輸入畫面)、`FSResultVC.xib`(搜尋結果顯示畫面)、`FSResultVC.xib`(我的最愛畫面)
        * 其中 `FSResultVC.xib` 繼承自 `FSResultVC.xib`
    * controller 分別為三個畫面對應的 ViewController 物件
* 架構其他說明
    * Flickr api 的部分主要於 `FlickrApi` 進行處理，response 資料分別於欲使用的物件進行解析
    * `FSPhoto` 物件為單筆 data 對應的資料結構，再以 NSMutableArray 集合、傳遞於各個物件之間
    * 進階題的部分使用 SQLite 儲存資料於本地端，並以 `DataManager` 物件作為 SQLite 的介面
        * Objective-C 的部分使用 SQLite3
        * Swift 的部分使用 SQLite.swift (by CocoaPods)

## usage
* Objective-C
    * open `Objective-C/FlickrSearch.xcodeproj` to build & run
* Swift
    * open `Swift/FlickrSearch.xcworkspace` to build & run