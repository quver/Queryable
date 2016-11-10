import Quick
import Nimble
import Queryable
import RealmSwift

class TestEntity: Object, Queryable {

  typealias Model = TestEntity

  dynamic var number = 0
  dynamic var text = ""

}

class TableOfContentsSpec: QuickSpec {

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
      _ = QueryManager.removeAll()
    }

    context("add object") {
      it("is containing it") {
        let someObject = self.someObject()
        _ = someObject.add()

        expect(TestEntity.allObjects).to(contain(someObject))
      }

      it("is not containing other") {
        let otherObject = self.otherObject()
        let someObject = self.someObject()
        _ = someObject.add()

        expect(TestEntity.allObjects).notTo(contain(otherObject))
      }

      it("has only one object") {
        let someObject = self.someObject()
        _ = someObject.add()

        expect(TestEntity.allObjects.count).to(equal(1))
      }
    }

    context("edit object") {
      it("change property") {
        let someObject = self.someObject()
        _ = someObject.add()
        _ = someObject.update(transaction: {
          someObject.text = self.otherString
          }, completion: nil)

        expect(TestEntity.allObjects.first!.text).to(equal(self.otherString))
      }

      it("has only one object") {
        let someObject = self.someObject()
        _ = someObject.add()
        _ = someObject.update(transaction: {
          someObject.text = self.otherString
          }, completion: nil)

        expect(TestEntity.allObjects.count).to(equal(1))
      }
    }

    context("remove object") {
      it("one left") {
        let someObject = self.someObject()
        _ = someObject.add()

        let otherObject = self.otherObject()
        _ = otherObject.add()
        
        _ = someObject.remove()

        expect(TestEntity.allObjects).to(contain(otherObject))
      }
    }

    context("get objects") {
      it("filter object") {
        let someObject = self.someObject()
        _ = someObject.add()

        let otherObject = self.otherObject()
        _ = otherObject.add()

        let filtered = TestEntity.filtred("text == '\(self.otherString)'")

        expect(filtered.first).to(equal(otherObject))
      }
    }
  }
  
}
