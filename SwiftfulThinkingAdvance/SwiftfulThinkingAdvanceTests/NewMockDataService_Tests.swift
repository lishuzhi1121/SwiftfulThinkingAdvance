//
//  NewMockDataService_Tests.swift
//  SwiftfulThinkingAdvanceTests
//
//  Created by SandsLee on 2022/1/26.
//

import XCTest
@testable import SwiftfulThinkingAdvance
import Combine


class NewMockDataService_Tests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables.removeAll()
    }
    
    func test_NewDataService_init_doesSetValueCorrectly() {
        // Give
        let items: [String]? = nil
        let items2: [String]? = []
        let items3: [String]? = [UUID().uuidString, UUID().uuidString]
        
        // When
        let dataService = NewMockDataService(items: items)
        let dataService2 = NewMockDataService(items: items2)
        let dataService3 = NewMockDataService(items: items3)
        
        // Then
        XCTAssertFalse(dataService.items.isEmpty)
        XCTAssertTrue(dataService2.items.isEmpty)
        XCTAssertFalse(dataService3.items.isEmpty)
        XCTAssertEqual(dataService3.items.count, items3?.count)
    }
    
    func test_NewDataService_downloadItemsWithEscaping_doesReturnItems() {
        // Give
        let dataService = NewMockDataService(items: nil)
        
        // When
        var returnedItems: [String] = []
        let expectation = XCTestExpectation(description: "Should return items")
        
        dataService.downloadItemsWithEscaping { items in
            returnedItems = items
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertFalse(dataService.items.isEmpty)
        XCTAssertEqual(dataService.items.count, returnedItems.count)
    }
    
    func test_NewDataService_downloadItemsWithCombine_doesReturnItems() {
        // Give
        let dataService = NewMockDataService(items: nil)
        
        // When
        var returnedItems: [String] = []
        let expectation = XCTestExpectation(description: "Should return items")
        
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                    break
                case .failure:
                    XCTFail()
                    break
                }
            } receiveValue: { items in
                returnedItems = items
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertFalse(dataService.items.isEmpty)
        XCTAssertEqual(dataService.items.count, returnedItems.count)
    }
    
    func test_NewDataService_downloadItemsWithCombine_doesError() {
        // Give
        let dataService = NewMockDataService(items: [])
        
        // When
        var returnedItems: [String] = []
        let expectation = XCTestExpectation(description: "Does throw an error")
        let expectation2 = XCTestExpectation(description: "Does throw URLError.badServerResponse")
        
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail() // 不应该走到finished里
                    break
                case .failure(let error):
                    expectation.fulfill()
                    let urlError = error as? URLError
//                    XCTAssertEqual(urlError, URLError(.badServerResponse))
                    if urlError == URLError(.badServerResponse) {
                        expectation2.fulfill()
                    }
                    break
                }
            } receiveValue: { items in
                returnedItems = items
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation, expectation2], timeout: 5)
        XCTAssertEqual(dataService.items.count, returnedItems.count)
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

}
