# Flickr
Flickr is a simple iOS application, it retrieves photos from free API and display it for the user, and allow the user to view photo as a full screen.

Using [Flickr API](https://www.flickr.com/services/api/)

## Don't Forget To Install Pods

```swift
pod install
```

## Used In The APP

- SWIFT
- Alamofire-based Network Layer
- MVVM Architecture Pattern
- Coordinator Pattern For Handling Navigation
- RxSwift, RxCocoa For Data Binding
- Kingfisher For Images Downloading and Caching
- XIB Files
- Core Data For Caching photos using

## TODO:-

- [ ] Code Refactoring
- [ ] Use Repository Pattern
- [ ] Dark Mode Support
- [ ] Unit Tests
- [ ] UI Tests
- [ ] Connect to AppCenter to deploy
- [ ] Enhance UI/UX


## Screenshots

- Launch Screen
<img src="/Screenshots/LaunchScreen.png" width="200" height="400">

- Photos List [Recent]
<img src="/Screenshots/RecentPhotos.png" width="200" height="400">

- Search Results
<img src="/Screenshots/Search.png" width="200" height="400">

- Full Screen [Ad Banner]
<img src="/Screenshots/KoinzFullScreen.png" width="200" height="400">

- Full Screen
<img src="/Screenshots/MoSalahFullScreen.png" width="200" height="400">


## App Structure:
* Common
   * Application
      * Core
      * Coordinator
   * Configuration
   * Resources
   * Extensions
      * UI
      * Utils
      * LIbraries
   
* Externals
   * Networking
   * DataPersistence
      * CoreDataManager

* Scenes
   * PhotossList
      * Model
      * View
      * ViewModel
      * Coordinator
      * Interactor      

## Authors:
Created by 
- Taha Mahmoud [LinkedIn](https://www.linkedin.com/in/engtahamahmoud/)

Please don't hesitate to ask any clarifying questions about the project if you have any.
