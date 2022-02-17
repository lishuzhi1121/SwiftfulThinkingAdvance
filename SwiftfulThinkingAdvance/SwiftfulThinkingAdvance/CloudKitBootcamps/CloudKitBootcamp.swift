//
//  CloudKitBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2022/2/15.
//

import SwiftUI
import CloudKit

class CloudKitBootcampViewModel: ObservableObject {
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var permissionStatus: Bool = false
    @Published var userName: String = ""
    
    init() {
        // 1. 检查iCloud当前可用状态
        getiCloudStatus()
        // 2. 请求iCloud授权
        requestiCloudPermission()
        // 3. 查询用户信息
        fetchiCloudUserRecordID()
    }
    
    private func getiCloudStatus() {
        CKContainer.default().accountStatus { [weak self] status, error in
            DispatchQueue.main.async {
                switch status {
                case .available:
                    self?.isSignedInToiCloud = true
                case .noAccount:
                    self?.isSignedInToiCloud = false
                    self?.error = CloudKitError.iCloudAccountNotFound.rawValue
                case .couldNotDetermine:
                    self?.isSignedInToiCloud = false
                    self?.error = CloudKitError.iCloudAccountNotDetermine.rawValue
                case .restricted:
                    self?.isSignedInToiCloud = false
                    self?.error = CloudKitError.iCloudAccountRestricted.rawValue
                default:
                    self?.isSignedInToiCloud = false
                    self?.error = CloudKitError.iCloudAccountUnknown.rawValue
                }
            }
        }
    }
    
    enum CloudKitError: String, LocalizedError {
        case iCloudAccountNotFound
        case iCloudAccountNotDetermine
        case iCloudAccountRestricted
        case iCloudAccountUnknown
    }
    
    func requestiCloudPermission() {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { [weak self] permissionStatus, error in
            DispatchQueue.main.async {
                switch permissionStatus {
                case .granted:
                    self?.permissionStatus = true
                case .denied:
                    self?.permissionStatus = false
                default:
                    break
                }
            }
        }
    }
    
    
    func fetchiCloudUserRecordID() {
        CKContainer.default().fetchUserRecordID {[weak self] recordID, error in
            if let id = recordID {
                self?.discoveriCloudUser(id: id)
            }
        }
    }
    
    private func discoveriCloudUser(id: CKRecord.ID) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] userIdentity, error in
            DispatchQueue.main.async {
                if let name = userIdentity?.nameComponents?.givenName {
                    self?.userName = name
                }
                // 通过什么方式查询用户信息,lookupInfo里就只有对应的属性有值,其他的为空
                // 例如上面代码通过UserRecordID查询的,则lookupInfo里就只有userRecordID有值
                // 其他的 emailAddress/phoneNumber 为空
                //userIdentity?.lookupInfo?.userRecordID
                //userIdentity?.lookupInfo?.emailAddress
                //userIdentity?.lookupInfo?.phoneNumber
            }
        }
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
