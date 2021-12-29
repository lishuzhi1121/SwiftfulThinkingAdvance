//
//  DependencyInjectionBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/28.
//

import SwiftUI
import Combine

/**
 {
 "userId": 1,
 "id": 1,
 "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
 "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
 }
 */
struct PostsModel: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

protocol DataServiceProtocol {
    func getData() -> AnyPublisher<[PostsModel], Error>
}

/**
 PROBLEMS WITH SINGLETON
 1. Singleton's are GLOBAL
 2. Can't custom the init
 3. Can't swap out dependecies
 */
class ProductionDataService: DataServiceProtocol {
    // Singleton
//    static let instance = ProductionDataService()
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func getData() -> AnyPublisher<[PostsModel], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [PostsModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

class MockDataService: DataServiceProtocol {
    
    let testData: [PostsModel]
    
    init(data: [PostsModel]?) {
        self.testData = data ?? [
            PostsModel(userId: 1, id: 1, title: "ONE", body: "one"),
            PostsModel(userId: 2, id: 2, title: "TWO", body: "two")
        ]
    }
    
    func getData() -> AnyPublisher<[PostsModel], Error> {
        Just(testData)
            .tryMap({ $0 })
            .eraseToAnyPublisher()
    }
    
}


class DependencyInjectionViewModel: ObservableObject {
    @Published var dataArray: [PostsModel] = []
    var cancellable = Set<AnyCancellable>()
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        
        loadPosts()
    }
    
    private func loadPosts() {
        dataService.getData()
            .sink { completion in
                
            } receiveValue: { [weak self] returnedPosts in
                self?.dataArray = returnedPosts
            }
            .store(in: &cancellable)

    }
}


struct DependencyInjectionBootcamp: View {
    @StateObject private var vm:DependencyInjectionViewModel
    
    init(dataService: DataServiceProtocol) {
        _vm = StateObject(wrappedValue: DependencyInjectionViewModel(dataService: dataService))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(vm.dataArray) { item in
                    HStack {
                        Text(item.title)
                            .lineLimit(nil)
                            .background(Color.blue)
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }
    }
}

struct DependencyInjectionBootcamp_Previews: PreviewProvider {
    
    static let dataService = ProductionDataService(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
    
//    static let dataService = MockDataService(data: [
//        PostsModel(userId: 3, id: 3, title: "THREE", body: "three"),
//        PostsModel(userId: 4, id: 4, title: "FOUR", body: "four")
//    ])
    
    static var previews: some View {
        DependencyInjectionBootcamp(dataService: dataService)
    }
}
