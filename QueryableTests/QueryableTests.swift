//
//  QueryableTests.swift
//  QueryableTests
//
//  Created by Pawel Bednorz on 02.12.2016.
//  Copyright © 2016 Quver.net. All rights reserved.
//

import Quick
import Nimble
import RealmSwift
@testable import Queryable

class TestEntity: Object, Queryable {

  typealias Model = TestEntity

  dynamic var number = 0
  dynamic var text = ""

}

class QueryableTests: QuickSpec {

  private let someNumber = 1
  private let someString = "Lorem ipsum"

  private let otherNumber = 2
  private let otherString = "Love Swift"

  private func someObject() -> TestEntity {
    let object = TestEntity()
    object.number = someNumber
    object.text = someString

    return object
  }

  private func otherObject() -> TestEntity {
    let object = TestEntity()
    object.number = otherNumber
    object.text = otherString

    return object
  }

  override func spec() {
    beforeEach {
      QueryManager.removeAll()
    }

    context("add object") {
      it("is containing it") {
        let someObject = self.someObject()
        someObject.add()

        expect(TestEntity.arrayOfObject).to(contain(someObject))
      }

      it("is not containing other") {
        let otherObject = self.otherObject()
        let someObject = self.someObject()
        someObject.add()

        expect(TestEntity.arrayOfObject).notTo(contain(otherObject))
      }

      it("has only one object") {
        let someObject = self.someObject()
        someObject.add()

        expect(TestEntity.arrayOfObject).to(haveCount(1))
      }
    }

    context("edit object") {
      it("change property") {
        let someObject = self.someObject()
        someObject.add()
        someObject.update(transaction: {
          someObject.text = self.otherString
          }, completion: nil)

        expect(TestEntity.arrayOfObject.first!.text).to(equal(self.otherString))
      }

      it("has only one object") {
        let someObject = self.someObject()
        someObject.add()
        someObject.update(transaction: {
          someObject.text = self.otherString
          }, completion: nil)

        expect(TestEntity.arrayOfObject).to(haveCount(1))
      }
    }

    context("remove object") {
      it("one left") {
        let someObject = self.someObject()
        someObject.add()

        let otherObject = self.otherObject()
        otherObject.add()

        someObject.remove()

        expect(TestEntity.arrayOfObject).to(contain(otherObject))
      }
    }

    context("get objects") {
      beforeEach {
        self.someObject().add()
        self.otherObject().add()
      }

      context("to array") {
        it("all objects") {
          expect(TestEntity.arrayOfObject).to(haveCount(2))
        }

        it("with filter") {
          let filtered = TestEntity.filtredArray("text == '\(self.otherString)'")

          expect(filtered.first!.text).to(equal(self.otherString))
        }
      }

      context("to result") {
        it("all objects") {
          expect(TestEntity.resultsOfObject).to(haveCount(2))
        }

        it("with filter") {
          let filtered = TestEntity.filtredResults("text == '\(self.otherString)'")

          expect(filtered.first!.text).to(equal(self.otherString))
        }
      }
    }
  }

}

