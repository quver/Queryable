//
//  Queryable.swift
//  Queryable
//
//  Created by Pawel Bednorz on 16.07.2016.
//  Copyright © 2016 Quver.net. All rights reserved.
//

import Foundation
import RealmSwift

public protocol Queryable: class {}

public extension Queryable where Self: Object {

  typealias Completion = () -> ()
  typealias Transaction = () -> ()

  /// Fetch all object from database
  ///
  /// - returns: Array of objects
  static func allObjects() -> [Self] {
    return QueryManager.getObjects(of: Self.self)
  }

  /// Fetch objects with filter
  ///
  /// - parameter filter: Same syntax as in pure Realm
  ///
  /// - returns: Array of objects
  static func filtred(_ filter: String) -> [Self] {
    return QueryManager.getObjects(of: Self.self, filter: filter)
  }

  /// Add self to database
  ///
  /// - returns: Status of write transaction
  func add() -> Bool {
    return QueryManager.add(object: self)
  }

  /// Remove self from database
  ///
  /// - returns: Status of write transaction
  func remove() -> Bool {
    return QueryManager.remove(object: self)
  }

  /// Update object in database. All changes must be performed in write transaction closure.
  ///
  /// - parameter transaction: Closure for performing changes
  /// - parameter completion:  Completion callback for UI update
  ///
  /// - returns: Status of write transaction
  func update(transaction: @escaping Transaction, completion: Completion?) -> Bool {
    let result = QueryManager.update { transaction() }
    completion?()

    return result
  }
  
}
