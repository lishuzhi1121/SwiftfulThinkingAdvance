//
//  UnitTestingBootcampViewModel_Tests.swift
//  SwiftfulThinkingAdvanceTests
//
//  Created by SandsLee on 2022/1/24.
//

import XCTest
@testable import SwiftfulThinkingAdvance
import Combine

// Name Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
// Test Structure: Give, When, Then

class UnitTestingBootcampViewModel_Tests: XCTestCase {
    
    var viewModel: UnitTestingBootcampViewModel?
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = UnitTestingBootcampViewModel(isPremium: Bool.random())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        cancellables.removeAll()
    }
    
    func test_UnitTestingBootcapmViewModel_isPremium_shouldBeTrue() {
        // Give
        let userIsPremium: Bool = true
        // When
        let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
        // Then
        XCTAssertTrue(vm.isPremium)
    }
    
    func test_UnitTestingBootcapmViewModel_isPremium_shouldBeFalse() {
        // Give
        let userIsPremium: Bool = false
        // When
        let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
        // Then
        XCTAssertFalse(vm.isPremium)
    }
    
    func test_UnitTestingBootcapmViewModel_isPremium_shouldBeInjectedValue() {
        // Give
        let userIsPremium: Bool = Bool.random()
        // When
        let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
        // Then
        XCTAssertEqual(vm.isPremium, userIsPremium)
    }
    
    func test_UnitTestingBootcapmViewModel_isPremium_shouldBeInjectedValue_stress() {
        for _ in 0..<100 {
            // Give
            let userIsPremium: Bool = Bool.random()
            // When
            let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
            // Then
            XCTAssertEqual(vm.isPremium, userIsPremium)
        }
    }
    
    func test_UnitTestingBootcapmViewModel_dataArray_shouldBeEmpty() {
        // Give
        
        // When
//        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        // Then
        XCTAssertTrue(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcapmViewModel_dataArray_shouldAddItems() {
        // Give
//        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        // Then
        XCTAssertTrue(!vm.dataArray.isEmpty)
        XCTAssertFalse(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, loopCount)
        XCTAssertNotEqual(vm.dataArray.count, 0)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcapmViewModel_dataArray_shouldNotAddBlankString() {
        // Give
//        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        // When
        vm.addItem(item: "")
        // Then
        XCTAssertTrue(vm.dataArray.isEmpty)
        XCTAssertFalse(!vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcapmViewModel_selectedItem_shouldStartsAsNil() {
        // Give
        
        // When
//        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        // Then
        XCTAssertTrue(vm.selectedItem == nil)
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_UnitTestingBootcapmViewModel_selectedItem_shouldBeNilWhenSelectingInvalidItem() {
        // Give
//        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        // When
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)
        
        vm.selectItem(item: UUID().uuidString)
        
        // Then
        XCTAssertTrue(vm.selectedItem == nil)
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_UnitTestingBootcapmViewModel_selectedItem_shouldBeSelected() {
        // Give
//        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        // When
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)
        
        // Then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, newItem)
    }
    
    func test_UnitTestingBootcapmViewModel_selectedItem_shouldBeSelected_stress() {
        // Give
//        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        var itemsArr: [String] = []
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArr.append(newItem)
        }
        
        let randomItem = itemsArr.randomElement() ?? ""
        XCTAssertFalse(randomItem.isEmpty)
        vm.selectItem(item: randomItem)
        
        // Then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, randomItem)
    }
    
    func test_UnitTestingBootcapmViewModel_saveItem_shouldThrowError_itemNotFound() {
        // Give
//        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        // Then
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString))
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should throw item not found") { error in
            let returnedError = error as? UnitTestingBootcampViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestingBootcampViewModel.DataError.itemNotFound)
        }
    }
    
    func test_UnitTestingBootcapmViewModel_saveItem_shouldThrowError_noData() {
        // Give
//        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        // Then
        XCTAssertThrowsError(try vm.saveItem(item: ""))
        XCTAssertThrowsError(try vm.saveItem(item: ""), "Should throw no data") { error in
            let returnedError = error as? UnitTestingBootcampViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestingBootcampViewModel.DataError.noData)
        }
    }
    
    func test_UnitTestingBootcapmViewModel_saveItem_shouldSaveItem() {
        // Give
//        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        var itemsArr: [String] = []
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArr.append(newItem)
        }
        
        let randomItem = itemsArr.randomElement() ?? ""
        XCTAssertFalse(randomItem.isEmpty)
        
        // Then
        XCTAssertNoThrow(try vm.saveItem(item: randomItem))
        
        do {
            try vm.saveItem(item: randomItem)
        } catch {
            XCTFail()
        }
    }
    
    func test_UnitTestingBootcapmViewModel_downloadWithEscaping_shouldReturnItems() {
        // Give
//        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        // When
        let expectation = XCTestExpectation(description: "Should return items in 3s")
        vm.$dataArray
            .dropFirst() // 第一次发出信号时数组初始化为空,丢弃
            .sink { returnedItems in
                if !returnedItems.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        vm.downloadWithEscaping()
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcapmViewModel_downloadWithCombine_shouldReturnItems() {
        // Give
//        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        // When
        let expectation = XCTestExpectation(description: "Should return items after a seconds")
        vm.$dataArray
            .dropFirst() // 第一次发出信号时数组初始化为空,丢弃
            .sink { returnedItems in
                if !returnedItems.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        vm.downloadWithCombine()
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcapmViewModel_downloadWithCombine_shouldReturnItems2() {
        // Give
        let items: [String] = [UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString]
        let dataService = NewMockDataService(items: items)
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random(), dataService: dataService)
        
        // When
        let expectation = XCTestExpectation(description: "Should return items after a seconds")
        vm.$dataArray
            .dropFirst() // 第一次发出信号时数组初始化为空,丢弃
            .sink { returnedItems in
                if !returnedItems.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        vm.downloadWithCombine()
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
        XCTAssertEqual(vm.dataArray.count, items.count)
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
