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

  typealias Completion = () -> Void
  typealias Transaction = () -> Void

  /// Fetch all object from database
  ///
  /// - returns: Array of objects
  static var arrayOfObject: [Self] {
    return QueryManager.array(of: Self.self)
  }

  /// Fetch all object from database
  ///
  /// - returns: Results object
  static var resultsOfObject: Results<Self> {
    return QueryManager.results(of: Self.self)
  }

  /// Fetch objects with filter
  ///
  /// - parameter filter: Same syntax as in pure Realm
  ///
  /// - returns: Results object
  @discardableResult static func filtredResults(_ filter: String) -> [Self] {
    return QueryManager.array(of: Self.self, filter: filter)
  }

  /// Fetch objects with filter
  ///
  /// - parameter filter: Same syntax as in pure Realm
  ///
  /// - returns: Results of objects
  @discardableResult static func filtredArray(_ filter: String) -> [Self] {
    return QueryManager.array(of: Self.self, filter: filter)
  }

  /// Add self to database
  ///
  /// - returns: Status of write transaction
  @discardableResult func add() -> Bool {
    return QueryManager.add(object: self)
  }

  /// Remove self from database
  ///
  /// - returns: Status of write transaction
  @discardableResult func remove() -> Bool {
    return QueryManager.remove(object: self)
  }

  /// Update object in database. All changes must be performed in write transaction closure.
  ///
  /// - parameter transaction: Closure for performing changes
  /// - parameter completion:  Completion callback for UI update
  ///
  /// - returns: Status of write transaction
  @discardableResult func update(transaction: @escaping Transaction, completion: Completion?) -> Bool {
    let result = QueryManager.update { transaction() }
    completion?()

    return result
  }
  
}
