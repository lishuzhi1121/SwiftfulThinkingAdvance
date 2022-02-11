//
//  FuturesBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2022/2/11.
//

import SwiftUI
import Combine


class FuturesBootcampViewModel: ObservableObject {
    @Published var title: String = "DEFAULT"
    let url = URL(string: "https://chp.shadiao.app/api.php")!
    var cancellables = Set<AnyCancellable>()
    
    init() {
        download()
    }
    
    
    func download() {
//        getCombinePublisher()
//            .sink { completion in
//
//            } receiveValue: { [weak self] returnedValue in
//                self?.title = returnedValue
//            }
//            .store(in: &cancellables)
        
//        getEscapingClosure { [weak self] returnedValue, error in
//            self?.title = returnedValue
//        }
        
        getFuturePublisher()
            .sink { completion in
                
            } receiveValue: { [weak self] returnedValue in
                self?.title = returnedValue
            }
            .store(in: &cancellables)

        
    }
    
    
    func getCombinePublisher() -> AnyPublisher<String, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(3.0, scheduler: DispatchQueue.main)
            .map({ String(data: $0.data, encoding: .utf8)! })
            .eraseToAnyPublisher()
    }
    
    func getEscapingClosure(completionHandler: @escaping (_ value: String, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completionHandler(String(data: data!, encoding: .utf8)!, error)
        }
        .resume()
    }
    
    func getFuturePublisher() -> Future<String, Error> {
        Future { promise in
            self.getEscapingClosure { value, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(value))
                }
            }
        }
    }
    
    
    /*
     将闭包形式的异步操作转为Publisher的同步操作方式
     */
    func doSomethingEscaping(completion: @escaping (_ value: String) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion("3s After!")
        }
    }
    func doSomethingFuture() -> Future<String, Never> {
        Future { promise in
            self.doSomethingEscaping { value in
                promise(.success(value))
            }
        }
    }
    
    
}

struct FuturesBootcamp: View {
    @StateObject var vm: FuturesBootcampViewModel = FuturesBootcampViewModel()
    
    var body: some View {
        Text(vm.title)
    }
}

struct FuturesBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        FuturesBootcamp()
    }
}
