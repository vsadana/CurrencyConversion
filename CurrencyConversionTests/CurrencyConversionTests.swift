//
//  CurrencyConversionTests.swift
//  CurrencyConversionTests
//
//  Created by Vaibhav Sadana on 29/04/23.
//

import XCTest
@testable import CurrencyConversion

final class CurrencyConversionTests: XCTestCase {

    //variables
    var vmObj : CurrencyViewModel!
    var app_id : String!
    var baseCurrency : CurrencyEnum!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        vmObj = CurrencyViewModel()
        baseCurrency = .USD
        app_id = "e6TLmv4vTmYQvjTSznm4vGqhIgpvz2tg"
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        vmObj = nil
        baseCurrency = nil
        app_id = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCurrencyData(){
        let expectation = XCTestExpectation(description: "currencyApp")
        vmObj.getCurrencyData(app_id: app_id, baseCurrency: baseCurrency.rawValue) { res in
            XCTAssertNotNil(res)
            let rates = res?["rates"] as? [String : Any]
            XCTAssertNotNil(rates)
            XCTAssertTrue(rates?.count ?? 0 > 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
