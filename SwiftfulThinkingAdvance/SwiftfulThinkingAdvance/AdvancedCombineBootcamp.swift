//
//  AdvancedCombineBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2022/2/10.
//

import SwiftUI
import Combine

class AdvancedCombineDataService {
//    @Published var basicPublisher: String = "Zero"
    let currentValuePublisher = CurrentValueSubject<String, Error>("Zero")
    let passThroughPublisher = PassthroughSubject<Int, Error>()
    let boolPublisher = PassthroughSubject<Bool, Error>()
    let intPublisher = PassthroughSubject<Int, Error>()
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        let items: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        for x in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(x)) {
//                self.basicPublisher = items[x]
//                self.currentValuePublisher.send(items[x])
//                self.passThroughPublisher.send(items[x])
//                self.boolPublisher.send(items[x] > 5)
                if (x > 4 && x < 8) {
                    self.passThroughPublisher.send(items[x])
                    self.boolPublisher.send(true)
                    self.intPublisher.send(99999)
                } else {
                    self.boolPublisher.send(false)
                    self.passThroughPublisher.send(items[x])
                }
                if x == items.indices.last {
                    self.passThroughPublisher.send(completion: .finished)
                }
            }
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            self.passThroughPublisher.send(1)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.passThroughPublisher.send(2)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.passThroughPublisher.send(3)
//        }
        
    }
    
}


class AdvancedCombineViewModel: ObservableObject {
    @Published var data: [String] = []
    @Published var dataBools: [Bool] = []
    @Published var error: String = ""
    var cancellables = Set<AnyCancellable>()
    let dataService = AdvancedCombineDataService()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        //dataService.passThroughPublisher
        
            // Sequence Operations
            /*
            //.first()
            //.first(where: { $0 > 4 })
            //.tryFirst(where: { value in
            //    if value == 3  {
            //        throw URLError(.badServerResponse)
            //    }
            //    return value > 1
            //})
            //.last()
            //.last(where: { $0 < 4 })
            //.tryLast(where: { value in
            //    if value == 61  {
            //        throw URLError(.badServerResponse)
            //    }
            //    return value < 3
            //})
            //.dropFirst()
            //.dropFirst(3)
            //.drop(while: { $0 < 4 }) // 一旦闭包返回false,就会将剩余的元素输出
            //.tryDrop(while: { value in
            //    if value == 5 {
            //        throw URLError(.badServerResponse)
            //    }
            //    return value < 8
            //})
            //.prefix(4)
            //.prefix(while: { $0 < 5 }) // 闭包返回的结果决定publisher是否继续,一旦闭包返回false,就会结束
            //.tryPrefix(while: )
            //.output(at: 2)
            //.output(in: 3..<6)
        */
        
            // Mathematic Operations
            /*
            //.max()
            //.max(by: { value1, value2 in
            //    return value1 < value2
            //})
            //.tryMax(by: )
            //.min()
            //.min(by: )
            //.tryMin(by: )
        */
        
            // Filter / Reducing Operations
            /*
            //.map({ String($0) })
            //.tryMap({ value in
            //    if value == 5 {
            //        throw URLError(.badServerResponse)
            //    }
            //    return String(value)
            //})
            //.compactMap({ value in // compact: 紧凑,压缩. compactMap:自动过滤nil元素
            //    if value == 5 {
            //        return nil
            //    }
            //    return String(value)
            //})
            //.tryCompactMap()
            //.filter({ ($0 > 4) && ($0 < 8) })
            //.tryFilter()
            //.removeDuplicates() //只会丢弃相邻的多个重复元素
            //.removeDuplicates(by: { value1, value2 in
            //    return value1 == value2
            //})
            //.replaceNil(with: 0)
            //.replaceEmpty(with: [])
            //.replaceError(with: "DEFAULT VALUE")
            //.scan(0, { existingValue, newValue in
            //    return existingValue + newValue
            //})
            //.scan(0, { $0 + $1 })
            //.scan(0, +)
            //.tryScan(, )
            //.reduce(0, { $0 + $1 })
            //.reduce(0, +)
            
            //.map({ String($0) })
            //.collect()
            //.collect(3)
            
            //.allSatisfy({ $0 > 0 })
            //.tryAllSatisfy()
        */
        
            // Timing Operations
            /*
            //.debounce(for: .seconds(0.75), scheduler: DispatchQueue.main) // debounce: 去抖动,即从接收到一个信号开始等待x秒(第一个参数)如果没有新的信号过来,则publish最近接收到的信号,如果有新的信号过来,则重置等待时间并覆盖最近接收到的信号
            //.delay(for: .seconds(2), scheduler: DispatchQueue.main)
        
            //.measureInterval(using: DispatchQueue.main)
            //.map({ stride in
            //    return "\(stride.timeInterval)"
            //})
            
            //.throttle(for: 5, scheduler: DispatchQueue.main, latest: true)
            //.retry(3)
            //.timeout(0.5, scheduler: DispatchQueue.main)
        */
        
            // Multiple Publishers/Subscribers
            /*
            //.combineLatest(dataService.boolPublisher)
            //.compactMap({ $1 ? "\($0)" : nil })
            //.removeDuplicates()
            //.combineLatest(dataService.boolPublisher, dataService.intPublisher)
            //.compactMap({ (int1, bool, int2) in
            //    return bool ? "\(int1)" : "N/A"
            //})
            //.removeDuplicates()
            //.merge(with: dataService.intPublisher)
            //.zip(dataService.boolPublisher)
            //.map({ tuple in
            //    return "\(tuple.0)" + tuple.1.description
            //})
            //.tryMap({ value in
            //    if value == 5 {
            //        throw URLError(.badServerResponse)
            //    }
            //    return value
            //})
            //.catch({ error in
            //    return self.dataService.intPublisher
            //})
        */
        
        let sharePublisher = dataService.passThroughPublisher
            .dropFirst(2)
            .share()
            //.multicast {
            //    PassthroughSubject<Int, Error>()
            //}
        
        sharePublisher
            .map({ String($0) })
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = "ERROR: \(error.localizedDescription)"
                    break
                }
            } receiveValue: { [weak self] returnedValue in
//                self?.data = returnedValue
//                self?.data.append(contentsOf: returnedValue)
                self?.data.append(returnedValue)
            }
            .store(in: &cancellables)
        
        sharePublisher
            .map({ $0 > 5 })
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = "ERROR: \(error.localizedDescription)"
                    break
                }
            } receiveValue: { [weak self] returnedValue in
//                self?.data = returnedValue
//                self?.data.append(contentsOf: returnedValue)
                self?.dataBools.append(returnedValue)
            }
            .store(in: &cancellables)
        
    }
    
}


struct AdvancedCombineBootcamp: View {
    @StateObject private var vm = AdvancedCombineViewModel()
    
    var body: some View {
        ScrollView {
            
            HStack {
                VStack {
                    ForEach(vm.data, id:\.self) {
                        Text($0)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                    if !vm.error.isEmpty {
                        Text(vm.error)
                    }
                }
                
                VStack {
                    ForEach(vm.dataBools, id:\.self) {
                        Text($0.description)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                }
            }
        }
    }
}

struct AdvancedCombineBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedCombineBootcamp()
    }
}
