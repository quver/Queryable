//
//  QueryManager.swift
//  Queryable
//
//  Created by Pawel Bednorz on 16.07.2016.
//  Copyright © 2016 Quver.net. All rights reserved.
//

import Foundation
import RealmSwift

public final class QueryManager {

  public typealias Transaction = () -> Void
  typealias RealmTransaction = (_ realm: Realm) -> Void

  /// Get objects of entity with optional filter predicate
  ///
  /// - Parameters:
  ///   - entity: Entity class name
  ///   - filter: Predicate filter
  /// - Returns: Results object
  public class func results<T: Object>(of entity: T.Type, filter: String? = nil) -> Results<T> {
    let realm = try! Realm()
    var results = realm.objects(entity)

    if let filter = filter {
      results = results.filter(filter)
    }

    return results
  }

  /// Get objects of entity with optional filter predicate
  ///
  /// - Parameters:
  ///   - entity: Entity class name
  ///   - filter: Predicate filter
  /// - Returns: Array of objects, could return empty array
  public class func array<T: Object>(of entity: T.Type, filter: String? = nil) -> [T] {
    return Array(results(of: entity, filter: filter))
  }

  /// Generic adding object to entity
  ///
  /// - Parameter object: Object which inherit from RealmSwift.Object
  /// - Returns: Status of write transaction
  @discardableResult public class func add(object: Object) -> Bool {
    return genericWrite { realm in
      realm.add(object)
    }
  }

  /// Generic update object of entitiy
  ///
  /// - Parameter transaction: Closure with object changes
  /// - Returns: Status of write transaction
  @discardableResult public class func update(transaction: @escaping Transaction) -> Bool {
    return genericWrite { _ in
      transaction()
    }
  }

  /// Generic remove all object from Realm
  ///
  /// - Returns: Status of write transaction
  @discardableResult public class func removeAll() -> Bool {
    return genericWrite { realm in
      realm.deleteAll()
    }
  }

  /// Generic remove object of entity
  ///
  /// - Parameter object: Object which should be removed
  /// - Returns: Status of write transaction
  @discardableResult public class func remove(object: Object) -> Bool {
    return genericWrite { realm in
      realm.delete(object)
    }
  }

  private class func genericWrite(transaction: @escaping RealmTransaction) -> Bool {
    do {
      let realm = try Realm()
      try realm.write {
        transaction(realm)
      }

      return true
    } catch {
      return false
    }
  }

}
