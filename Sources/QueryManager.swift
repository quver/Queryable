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
  
  typealias Transaction = (_ realm: Realm)->()

  /// Get objects of entity with optional filter predicate
  ///
  /// - parameter entity: Entity class name
  /// - parameter filter: Predicate filter
  ///
  /// - returns: Array of objects, could return empty array
  public class func getObjects<T: Object>(of entity: T.Type, filter: String? = nil) -> [T] {
    guard let realm = try? Realm() else { return [] }

    var results = realm.objects(entity)

    if let filter = filter {
      results = results.filter(filter)
    }

    return Array(results)
  }

  /// Generic adding object to entity
  ///
  /// - parameter object: Object which inherit from RealmSwift.Object
  ///
  /// - returns: Status of write transaction
  public class func add(object: Object) -> Bool {
    return genericWrite { realm in
      realm.add(object)
    }
  }

  /// Generic update object of entitiy
  ///
  /// - parameter transaction: closure with object changes
  ///
  /// - returns: Status of write transaction
  public class func update(transaction: @escaping ()->()) -> Bool {
    return genericWrite { _ in
      transaction()
    }
  }


  /// Generic remove all object from Realm
  ///
  /// - returns: Status of write transaction
  public class func removeAll() -> Bool {
    return genericWrite { realm in
      realm.deleteAll()
    }
  }

  /// Generic remove object of entity
  ///
  /// - parameter object: Object which should be removed
  ///
  /// - returns: Status of write transaction
  public class func remove(object: Object) -> Bool {
    return genericWrite { realm in
      realm.delete(object)
    }
  }

  private class func genericWrite(transaction: @escaping Transaction) -> Bool {
    guard let realm = try? Realm() else { return false }

    do {
      try realm.write {
        transaction(realm)
      }

      return true
    } catch {
      return false
    }
  }

}
