# RxGitLabKit
[![Build Status](https://travis-ci.org/Qase/RxGitLabKit.svg?branch=master)](https://travis-ci.org/Qase/RxGitLabKit)
[![codebeat badge](https://codebeat.co/badges/d7306f5e-9328-45a0-bbed-1abab3e8b5b2)](https://codebeat.co/projects/github-com-qase-rxgitlabkit-master)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS-lightgrey.svg)](https://qase.github.io/RxGitLabKit/)
[![pod](https://img.shields.io/cocoapods/v/RxGitLabKit.svg)](https://cocoapods.org/)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

## Description
Swift Reactive [GitLab API](https://gitlab.com/help/api/README.md) v4 client using
[RxSwift](https://github.com/ReactiveX/RxSwift/blob/master/README.md)

This library currently supports these endpoint groups:
  - [Users](https://docs.gitlab.com/ee/api/users.html)
  - [Projects](https://docs.gitlab.com/ee/api/projects.html)
  - [Repositories](https://docs.gitlab.com/ee/api/repositories.html)
  - [Commits](https://docs.gitlab.com/ee/api/commits.html)
  - [Group and Project members](https://docs.gitlab.com/ee/api/members.html)

The HTML documentation generated using [Jazzy](https://github.com/realm/jazzy) can be found on GitHub pages [here](https://qase.github.io/RxGitLabKit/).

Before running the demo app or the tests, download the dependencies using:
```bash
$ carthage update
```

## Usage
### Authorization
Using a private/ OAuth token or login using `username` and `password`
```swift
import RxGitLabKit

// Host URL
let hostURL = URL(string: "http://example.gitlab.server.com")!
// Using private token
let client = RxGitLabAPIClient(with: hostURL, privateToken: "PRIVATE_TOKEN")

// Using an OAuth token
let client = RxGitLabAPIClient(with: hostURL, oAuthToken: "OAUTH_TOKEN")

// Authorize using username and password
let client = RxGitLabAPIClient(with: hostURL)
client.logIn(username: "USERNAME", password: "PASSWORD")
```
### Basic usage
```swift
import RxGitLabKit

let hostURL = URL(string: "http://example.gitlab.server.com")!

let client = RxGitLabAPIClient(with: hostURL, privateToken: "PRIVATE_TOKEN")

// Get projects
let projects: Observable<[Project]> = client.users
  .getProjects(parameters: ["order_by" : "id", "sort" : "asc"],
    page: 2,
    perPage: 20)
projects.subscribe(onNext: { projects in
    // do something with projects
  },
  onError: { error in
    // Do something with the error
  }
)
```

### Paginator
Some endpoints return a `Paginator` which handles the pagination of the objects. The paginator uses subscripts for loading the desired pages.
```swift
import RxGitLabKit

// Get the paginator
let projectsPaginator: Paginator<Project> = client.users
  .getProjects(parameters: ["order_by" : "id", "sort" : "asc"])

// Load page 2
projectsPaginator[2].subscribe(onNext: { projects in
    // do something with projects
  },
  onError: { error in
    // Do something with the error
  }
)

// Load page 2 to 5
projectsPaginator[2...5].subscribe(onNext: { projects in
    // do something with projects
  },
  onError: { error in
    // Do something with the error
  }
)

// Load all pages
projectsPaginator.loadAll().subscribe(onNext: { projects in
    // do something with projects
  },
  onError: { error in
    // Do something with the error
  }
)
```

## Requirements

* Xcode 10.0
* Swift 4.2

## Integration

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

**Tested with `pod --version`: `1.5.3`**

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
  pod 'RxGitLabKit'
end
\end{minted}
```

Replace `YOUR_TARGET_NAME` and then run this command:

```bash
$ pod install
```

### [Carthage](https://github.com/Carthage/Carthage)

**Tested with `carthage version`: `0.31.2`**

Add this to `Cartfile`

```
  git "https://github.com/Qase/RxGitLabKit.git"
```
and run:
```bash
$ carthage update
```
Then link the built `RxGitLabKit.framework` it the "Linked Frameworks and Libraries" section of the target.

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

**Tested with `swift build --version`: `Apple Swift Package Manager - Swift 4.2.0 (swiftpm-14460.2)`**

Create a `Package.swift` file.

```swift
// swift-tools-version:4.2
import PackageDescription

let package = Package(
  name: "YOUR_PROJECT_NAME",
  dependencies: [
    .package(url: "https://github.com/Qase/RxGitLabKit.git", from: "1.0.0")
  ],
  targets: [
    .target(name: "YOUR_PROJECT_NAME", dependencies: ["RxGitLabKit"], path: "SOURCE_PATH")
  ]
)
```
replace `YOUR_PROJECT_NAME` and `SOURCE_PATH` and run
```bash
$ swift build
```
and then
```bash
$ swift package generate-xcodeproj
```
## Licence

[MIT](https://github.com/Qase/RxGitLabKit/blob/master/LICENSE)
