# Queryable
Realm Query Extension

[![Build Status](https://travis-ci.org/quver/Queryable.svg?branch=master)](https://travis-ci.org/quver/Queryable)
[![codecov](https://codecov.io/gh/quver/Queryable/branch/master/graph/badge.svg)](https://codecov.io/gh/quver/Queryable)
[![codebeat badge](https://codebeat.co/badges/b3ce6404-16e5-448e-9445-eaa20ab51461)](https://codebeat.co/projects/github-com-quver-queryable)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/quver/queryable)](http://clayallsopp.github.io/readme-score?url=https://github.com/quver/queryable)

## Requirements

* iOS 8.0+ / macOS 10.9+ / tvOS / watchOS
* Xcode 8.0+
* Swift 3.0+

## Contribute

* If you want to add something feels free to add pull request
* If you find bug or suggestion, please create issue
* Thanks for all starts

## Installation

### CocoaPods

CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

Then go to your project directory and run:

```bash
$ pod init
```

in `Podfile` add:

```ruby
use_frameworks!

target '<Target Name>' do
    pod 'Queryable'
end
```

## Usage

### Migration from 1.x to 2.x
* `typealias Model` is removed and no longer needed

* `allObjects` static property is now `allObjects()` static method

### CUD operations

```swift
// Simple class
class Foo: Object {
	dynamic var bar = ""
}

// Conform to protocol
extension Foo: Queryable {}

// Create simple object
let foo = Foo()
foo.bar = "something"

// Save objec
_ = foo.add()

// Update object
_ = foo.update(transaction: {
    foo.bar = "something other"
}, completion: nil)

// Remove object
_ = foo.remove()
```

### Fetching objects

```swift
// Fetch all objects
_ = Foo.allObjects()

// Fetch filtred objects
_ = Foo.filtred("bar == 'something'")
```

### DBManager

Queryable has also DBManger which provides generic methods

```swift
// Fetching objects
public class func getObjects<T: Object>(of entity: T.Type, filter: String? = nil) -> [T]

// Add
public class func add(object: Object) -> Bool

//Update
public class func update(transaction: @escaping ()->()) -> Bool

//Remove
public class func remove(object: Object) -> Bool
```

#### Remove all from Realm

```swift
public class func removeAll() -> Bool
```
