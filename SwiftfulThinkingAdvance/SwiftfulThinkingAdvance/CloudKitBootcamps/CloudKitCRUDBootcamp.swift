//
//  CloudKitCRUDBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2022/2/15.
//

import SwiftUI
import CloudKit

struct FruitModel: Hashable {
    let name: String
    let record: CKRecord
}

class CloudKitCRUDBootcampViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var fruits: [FruitModel] = [
        FruitModel(name: "Apple", record: CKRecord(recordType: "Fruits")),
        FruitModel(name: "Orange", record: CKRecord(recordType: "Fruits")),
        FruitModel(name: "Bananer", record: CKRecord(recordType: "Fruits")),
    ]
    
    func addButtonPressed() {
        guard !text.isEmpty else { return }
        addItem(name: text)
    }
    
    /// 增
    /// - Parameter name: 名称
    private func addItem(name: String) {
        let newFruit = CKRecord(recordType: "Fruits")
        newFruit["name"] = name
        saveItem(record: newFruit)
    }
    
    private func saveItem(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { [weak self] returnedRecord, error in
            print("RECORD: \(returnedRecord?.description ?? "")")
            print("ERROR: \(error?.localizedDescription ?? "")")
            
            DispatchQueue.main.async {
                self?.text = ""
                self?.fetchItems()
            }
        }
    }
    
    /// 查
    func fetchItems() {
        var returnedItems: [FruitModel] = []
        // 1. 构建查询操作
//        let predicate = NSPredicate(value: true)
        let predicate = NSPredicate(format: "name = %@", argumentArray: ["Apple"])
        let query = CKQuery(recordType: "Fruits", predicate: predicate)
        // 设置查询结果排序方式
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let queryOperation = CKQueryOperation(query: query)
        // 设置查询条数限制
//        queryOperation.resultsLimit = 3
        
        // 2. 设置查询操作回调block
        if #available(iOS 15.0, *) {
            queryOperation.recordMatchedBlock = { (recordID, recordResult) in
                switch recordResult {
                case .success(let record):
                    //record.creationDate
                    guard let fruit = record["name"] as? String else { return }
                    let model = FruitModel(name: fruit, record: record)
                    returnedItems.append(model)
                case .failure(let error):
                    print("Error recordMatchedBlock: \(error)")
                }
            }
        } else {
            queryOperation.recordFetchedBlock = { fetchedRecord in
                guard let fruit = fetchedRecord["name"] as? String else { return }
                let model = FruitModel(name: fruit, record: fetchedRecord)
                returnedItems.append(model)
            }
        }
        // 3. 设置查询操作完成结果回调block
        if #available(iOS 15.0, *) {
            queryOperation.queryResultBlock = { [weak self] operationResult in
                print("RESULT queryResultBlock: \(operationResult)")
                DispatchQueue.main.async {
                    self?.fruits = returnedItems
                }
            }
        } else {
            queryOperation.queryCompletionBlock = { [weak self] (returnedCursor, returnedError) in
                print("RESULT queryCompletionBlock: \(returnedCursor?.description ?? "")")
                DispatchQueue.main.async {
                    self?.fruits = returnedItems
                }
            }
        }
        
        // 4. 将查询操作添加到队列中
        addOperation(operation: queryOperation)
    }
    
    private func addOperation(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    /// 改
    /// - Parameter fruit: 记录模型对象
    func updateItem(fruit: FruitModel, name: String) {
        let record = fruit.record
        record["name"] = name
        saveItem(record: record)
    }
    
    
    /// 删
    /// - Parameter indexSet: 下标
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let fruit = fruits[index]
        let record = fruit.record
        CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) { [weak self] returnedRecordID, returnedError in
            guard returnedError == nil else { return }
            DispatchQueue.main.async {
                self?.fruits.remove(at: index)
            }
        }
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
                textField
                addButton
                
                List {
                    ForEach(vm.fruits, id: \.self) { fruitModel in
                        Text(fruitModel.name)
                            .onTapGesture {
                                self.currentSelectModel = fruitModel
                                self.isPresented.toggle()
                            }
                    }
                    .onDelete(perform: vm.deleteItem)
                }
                .listStyle(.plain)
                .zzTextFieldAlert(isPresented: $isPresented,
                                  alertModel: ZZTextFieldAlertModel(title: "UPDATE FRUIT NAME", text: currentSelectModel?.name, acceptTitle: "UPDATE", action: { text in
                    guard let name = text, let fruit = currentSelectModel else { return }
                    print("Current Fruit: \(fruit.name), New Name: \(name)")
//                    vm.updateItem(fruit: fruit, name: name)
                }))
            }
            .padding()
            .navigationBarHidden(true)
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
    
}
