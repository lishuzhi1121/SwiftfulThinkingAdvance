//
//  CloudKitBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2022/2/15.
//

import SwiftUI
import Combine

class CloudKitBootcampViewModel: ObservableObject {
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var permissionStatus: Bool = false
    @Published var userName: String = ""
    var cancellables = Set<AnyCancellable>()
    
    init() {
        // 1. 检查iCloud当前可用状态
        getiCloudStatus()
        // 2. 请求iCloud授权
        requestiCloudPermission()
        // 3. 查询用户信息
        getiCloudCurrentUserIdentity()
    }
    
    private func getiCloudStatus() {
        CloudKitUtility.getiCloudStatus()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] compeltion in
                switch compeltion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] status in
                self?.isSignedInToiCloud = status
            }
            .store(in: &cancellables)
    }
    
    func requestiCloudPermission() {
        CloudKitUtility.requestiCloudPermission()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            } receiveValue: { [weak self] permission in
                self?.permissionStatus = permission
            }
            .store(in: &cancellables)
    }
    
    func getiCloudCurrentUserIdentity() {
        CloudKitUtility.discoveriCloudUserIdentity()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] name in
                self?.userName = name
            }
            .store(in: &cancellables)
    }
    
}


struct CloudKitBootcamp: View {
    
    @StateObject private var vm = CloudKitBootcampViewModel()
    
    var body: some View {
        VStack {
            Text("IS SIGNED IN: \(vm.isSignedInToiCloud.description.uppercased())")
            if !vm.error.isEmpty {
                Text("ERROR: \(vm.error)")
            }
            Text("Permission Status: \(vm.permissionStatus.description)")
            Text("USER NAME: \(vm.userName) ")
        }
    }
}

struct CloudKitBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitBootcamp()
    }
}
