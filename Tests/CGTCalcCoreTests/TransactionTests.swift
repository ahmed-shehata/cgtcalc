//
//  TransactionTests.swift
//  CGTCalcCoreTests
//
//  Created by Matt Galloway on 19/06/2020.
//

@testable import CGTCalcCore
import XCTest

class TransactionTests: XCTestCase {
  func testGrouped() throws {
    let transactionA = ModelCreation.transaction(.Buy, "01/01/2020", "Foo", "10", "1", "5")
    let transactionB = ModelCreation.transaction(.Buy, "01/01/2020", "Foo", "20", "1.6", "10")
    try transactionA.groupWith(transaction: transactionB)
    XCTAssertEqual(transactionA.amount, Decimal(string: "30")!)
    XCTAssertEqual(transactionA.price, Decimal(string: "1.4")!)
    XCTAssertEqual(transactionA.expenses, Decimal(string: "15")!)
  }

  func testGroupedMultiple() throws {
    let transactionA = ModelCreation.transaction(.Buy, "01/01/2020", "Foo", "10", "1", "5")
    let transactionB = ModelCreation.transaction(.Buy, "01/01/2020", "Foo", "20", "1.6", "10")
    let transactionC = ModelCreation.transaction(.Buy, "01/01/2020", "Foo", "30", "1.8", "100")
    try transactionA.groupWith(transactions: [transactionB, transactionC])
    XCTAssertEqual(transactionA.amount, Decimal(string: "60")!)
    XCTAssertEqual(transactionA.price, Decimal(string: "1.6")!)
    XCTAssertEqual(transactionA.expenses, Decimal(string: "115")!)
  }

  func testGroupedDifferentKind() throws {
    let transactionA = ModelCreation.transaction(.Buy, "01/01/2020", "Foo", "10", "1", "5")
    let transactionB = ModelCreation.transaction(.Sell, "01/01/2020", "Foo", "20", "1.6", "10")
    XCTAssertThrowsError(try transactionA.groupWith(transaction: transactionB))
  }

  func testGroupedDifferentDate() throws {
    let transactionA = ModelCreation.transaction(.Buy, "01/01/2020", "Foo", "10", "1", "5")
    let transactionB = ModelCreation.transaction(.Buy, "02/01/2020", "Foo", "20", "1.6", "10")
    XCTAssertThrowsError(try transactionA.groupWith(transaction: transactionB))
  }

  func testGroupedDifferentAsset() throws {
    let transactionA = ModelCreation.transaction(.Buy, "01/01/2020", "Foo", "10", "1", "5")
    let transactionB = ModelCreation.transaction(.Buy, "01/01/2020", "Bar", "20", "1.6", "10")
    XCTAssertThrowsError(try transactionA.groupWith(transaction: transactionB))
  }

  func testEquality() throws {
    let a = ModelCreation.transaction(.Buy, "01/01/2020", "Foo", "10", "1", "5")
    let b = ModelCreation.transaction(.Buy, "01/01/2020", "Foo", "10", "1", "5")
    let c = a
    XCTAssertNotEqual(a, b)
    XCTAssertNotEqual(b, c)
    XCTAssertEqual(a, c)
  }

  func testHashable() throws {
    let a = ModelCreation.transaction(.Buy, "01/01/2020", "Foo", "10", "1", "5")
    let b = ModelCreation.transaction(.Buy, "01/01/2020", "Foo", "10", "1", "5")
    let c = a
    let set = Set<Transaction>([a, b, c])
    XCTAssertEqual(set.count, 2)
    XCTAssertTrue(set.contains(a))
    XCTAssertTrue(set.contains(b))
  }
}
