//
//  CloudKitCRUDBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2022/2/15.
//

import SwiftUI
import CloudKit
import Combine

struct FruitModel: Hashable, CloudKitableProtocol {
    let name: String
    let imageURL: URL?
    let record: CKRecord
    
    init?(record: CKRecord) {
        guard let name = record["name"] as? String else { return nil }
        self.name = name
        let imageAsset = record["image"] as? CKAsset
        self.imageURL = imageAsset?.fileURL
        self.record = record
    }
    
    init?(name: String, imageURL: URL?) {
        let record = CKRecord(recordType: "Fruits")
        record["name"] = name
        if let url = imageURL {
            record["image"] = CKAsset(fileURL: url)
        }
        self.init(record: record)
    }
    
    func update(newName: String) -> FruitModel? {
        let record = record
        record["name"] = newName
        return FruitModel(record: record)
    }
    
}

class CloudKitCRUDBootcampViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var fruits: [FruitModel] = [
//        FruitModel(name: "Apple", imageURL: nil, record: CKRecord(recordType: "Fruits")),
//        FruitModel(name: "Orange", imageURL: nil, record: CKRecord(recordType: "Fruits")),
//        FruitModel(name: "Bananer", imageURL: nil, record: CKRecord(recordType: "Fruits")),
    ]
    var cancellables = Set<AnyCancellable>()
    
    
    func addButtonPressed() {
        guard !text.isEmpty else { return }
        addItem(name: text)
    }
    
    /// 增
    /// - Parameter name: 名称
    private func addItem(name: String) {
        guard
            let image = UIImage(named: "background"),
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("background.png"),
            let data = image.pngData() else { return }
        
        do {
            try data.write(to: url)
            guard let item = FruitModel(name: name, imageURL: url) else { return }
            CloudKitUtility.add(item: item)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("ERROR: \(error.localizedDescription)")
                        break
                    }
                } receiveValue: { [weak self] record in
                    print("RECORD: \(record.description)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self?.text = ""
                        self?.fetchItems()
                    }
                }
                .store(in: &cancellables)
            
        } catch let error {
            print(error)
        }
    }
    
    /// 查
    func fetchItems() {
        // 1. 构建查询操作
        let predicate = NSPredicate(value: true)
        CloudKitUtility.fetch(recordType: "Fruits", predicate: predicate)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] (returnedItems: [FruitModel]) in
                self?.fruits = returnedItems
            }
            .store(in: &cancellables)
    }
    
    /// 改
    /// - Parameter fruit: 记录模型对象
    func updateItem(fruit: FruitModel, name: String) {
        guard let newFruit = fruit.update(newName: name) else { return }
        CloudKitUtility.update(item: newFruit)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] record in
                self?.fetchItems()
            }
            .store(in: &cancellables)

    }
    
    
    /// 删
    /// - Parameter indexSet: 下标
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let fruit = fruits[index]
        CloudKitUtility.delete(item: fruit)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] recordId in
                self?.fruits.remove(at: index)
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - Notifications
    
    func subscribeButtonPressed() {
        // 点击订阅时先请求通知授权
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            guard success else {
                print(error ?? "Unknow Error.")
                return
            }
            // 注册远程通知
            DispatchQueue.main.async {
                if !UIApplication.shared.isRegisteredForRemoteNotifications {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            // 订阅通知
            let predicate = NSPredicate(value: true)
            CloudKitUtility.subscribe(recordType: "Fruits",
                                      predicate: predicate,
                                      subscriptionID: "fruit_add_to_database",
                                      options: .firesOnRecordCreation,
                                      title: "There's a new fruit!",
                                      body: "Open the app to check your fruits.")
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Failed to subscription, error: \(error)")
                    }
                } receiveValue: { success in
                    print("Success to subscription.")
                }
                .store(in: &self.cancellables)
        }
    }
    
    func unsubscribeButtonPressed() {
        CloudKitUtility.unsubscribe(subscriptionID: "fruit_add_to_database")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to unsubscribe, error: \(error)")
                }
            } receiveValue: { success in
                print("Successfully unsubscribe notificaiton.")
            }
            .store(in: &cancellables)
    }
    
}

struct CloudKitCRUDBootcamp: View {
    @StateObject private var vm = CloudKitCRUDBootcampViewModel()
    @State private var isPresented: Bool = false
    @State private var currentSelectModel: FruitModel? = nil
    var body: some View {
        NavigationView {
            VStack {
                header
                HStack {
                    subscribeButton
                    Spacer()
                    unsubscribeButton
                }
                textField
                addButton
                listView
                // TODO: 当textFieldAlert嵌套在NavigationView中时,navigationBarHidden需要设置在它前面
                .navigationBarHidden(true)
                .zzTextFieldAlert(isPresented: $isPresented,
                                  alertModel: ZZTextFieldAlertModel(title: "UPDATE FRUIT NAME", text: currentSelectModel?.name, acceptTitle: "UPDATE", action: { text in
                    guard let name = text, let fruit = currentSelectModel else { return }
                    print("Current Fruit: \(fruit.name), New Name: \(name)")
//                    vm.updateItem(fruit: fruit, name: name)
                }))
            }
            .padding()
//            .navigationBarHidden(true)
        }
    }
}

struct CloudKitCRUDBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitCRUDBootcamp()
    }
}

extension CloudKitCRUDBootcamp {
    
    private var header: some View {
        Text("CloudKit CRUD ☁️☁️☁️")
            .font(.headline)
            .underline()
    }
    
    private var subscribeButton: some View {
        Button {
            vm.subscribeButtonPressed()
        } label: {
            Text("Subscribe")
                .font(.headline)
                .frame(height: 55)
        }
    }
    
    private var unsubscribeButton: some View {
        Button {
            vm.unsubscribeButtonPressed()
        } label: {
            Text("Unsubscribe")
                .font(.headline)
                .frame(height: 55)
                .foregroundColor(.red)
        }
    }
    
    private var textField: some View {
        TextField("Add something here...", text: $vm.text)
            .frame(height: 55)
            .padding(.leading)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(10)
    }
    
    private var addButton: some View {
        Button {
            vm.addButtonPressed()
        } label: {
            Text("Add")
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.pink)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private var listView: some View {
        List {
            ForEach(vm.fruits, id: \.self) { fruitModel in
                HStack {
                    Text(fruitModel.name)
                        .frame(maxHeight:.infinity)
                    
                    if let imageURL = fruitModel.imageURL,
                       let data = try? Data(contentsOf: imageURL),
                       let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    Spacer()
                }
                .frame(height: 44)
                .frame(maxWidth:.infinity)
                .background(Color.white)
                .onTapGesture {
                    self.currentSelectModel = fruitModel
                    self.isPresented.toggle()
                }
            }
            .onDelete(perform: vm.deleteItem)
        }
        .listStyle(.plain)
    }
    
}
