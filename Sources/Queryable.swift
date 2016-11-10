//
//  Queryable.swift
//  Queryable
//
//  Created by Pawel Bednorz on 16.07.2016.
//  Copyright © 2016 Quver.net. All rights reserved.
//

import Foundation
import RealmSwift

public protocol Queryable: class {

  typealias Completion = () -> ()
  typealias Transaction = () -> ()

  /// Class must implement assiociatedtype
  associatedtype Model: Object

  /// all object of entity
  static var allObjects: [Model] { get }

  /// Add self to database
  ///
  /// - returns: Status of write transaction
  func add() -> Bool

  /// Remove self from database
  ///
  /// - returns: Status of write transaction
  func remove() -> Bool


  /// Update object in database. All changes must be performed in write transaction closure.
  ///
  /// - parameter transaction: Closure for performing changes
  /// - parameter completion:  Completion callback for UI update
  func update(transaction: @escaping Transaction, completion: Completion?)

  static func filtred(_ filter: String) -> [Model]

}

public extension Queryable where Self: Object {

  static var allObjects: [Model] {
    return QueryManager.getObjects(of: Model.self)
  }

  func add() -> Bool {
    return QueryManager.add(object: self)
  }

  func remove() -> Bool {
    return QueryManager.remove(object: self)
  }

  func update(transaction: @escaping Transaction, completion: Completion?) {
    _ = QueryManager.update { transaction() }
    completion?()
  }

  static func filtred(_ filter: String) -> [Model] {
    return QueryManager.getObjects(of: Model.self, filter: filter)
  }

}
