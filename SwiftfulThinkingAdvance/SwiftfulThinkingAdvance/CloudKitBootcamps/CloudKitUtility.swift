//
//  CloudKitUtility.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2022/2/23.
//

import Foundation
import Combine
import CloudKit

protocol CloudKitableProtocol {
    init?(record: CKRecord)
    var record: CKRecord { get }
}



class CloudKitUtility {
    
    enum CloudKitError: String, LocalizedError {
        case iCloudAccountNotFound
        case iCloudAccountNotDetermine
        case iCloudAccountRestricted
        case iCloudAccountUnknown
        case iCloudPermissionNotGranted
        case iCloudCanNotFetchUserRecordID
        case iCloudCanNotDiscoverUser
        case iCloudCanNotSaveRecord
        case iCloudCanNotDeleteRecord
    }
    
    
}

// MARK: - USER FUNCTIONS
extension CloudKitUtility {
    
    static func getiCloudStatus() -> Future<Bool, Error> {
        Future { promise in
            CloudKitUtility.getiCloudStatus { result in
                promise(result)
            }
        }
    }
    
    private static func getiCloudStatus(completion: @escaping (Result<Bool, Error>) -> ()) {
        CKContainer.default().accountStatus { status, error in
            switch status {
            case .available:
                completion(.success(true))
            case .noAccount:
                completion(.failure(CloudKitError.iCloudAccountNotFound))
            case .couldNotDetermine:
                completion(.failure(CloudKitError.iCloudAccountNotDetermine))
            case .restricted:
                completion(.failure(CloudKitError.iCloudAccountRestricted))
            default:
                completion(.failure(CloudKitError.iCloudAccountUnknown))
            }
        }
    }
    
    static func requestiCloudPermission() -> Future<Bool, Error> {
        Future { promise in
            CloudKitUtility.requestiCloudPermission { result in
                promise(result)
            }
        }
    }
    
    private static func requestiCloudPermission(completion: @escaping (Result<Bool, Error>) -> ()) {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { permissionStatus, error in
            if permissionStatus == .granted {
                completion(.success(true))
            } else {
                completion(.failure(CloudKitError.iCloudPermissionNotGranted))
            }
        }
    }
    
    static func discoveriCloudUserIdentity() -> Future<String, Error> {
        Future { promise in
            CloudKitUtility.discoveriCloudUserIdentity { result in
                promise(result)
            }
        }
    }
    
    private static func discoveriCloudUserIdentity(completion: @escaping (Result<String, Error>) -> ()) {
        fetchiCloudUserRecordID { fetchResult in
            switch fetchResult {
            case .success(let recordID):
                discoveriCloudUser(id: recordID, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func fetchiCloudUserRecordID(completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        CKContainer.default().fetchUserRecordID { recordID, returnedError in
            if let id = recordID {
                completion(.success(id))
            } else if let error = returnedError {
                completion(.failure(error))
            } else {
                completion(.failure(CloudKitError.iCloudCanNotFetchUserRecordID))
            }
        }
    }
    
    private static func discoveriCloudUser(id: CKRecord.ID, completion: @escaping (Result<String, Error>) -> ()) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { userIdentity, returnedError in
            if let name = userIdentity?.nameComponents?.givenName {
                completion(.success(name))
            } else if let error = returnedError {
                completion(.failure(error))
            } else {
                completion(.failure(CloudKitError.iCloudCanNotDiscoverUser))
            }
        }
    }
    
}

// MARK: - CRUD FUNCTIONS

extension CloudKitUtility {
    
    // MARK: - D
    static func delete<T: CloudKitableProtocol>(item: T) -> Future<CKRecord.ID, Error> {
        Future { promise in
            delete(item: item, completion: promise)
        }
    }
    
    private static func delete<T: CloudKitableProtocol>(item: T, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        // get record
        let record = item.record
        // save to cloudkit
        delete(record: record, completion: completion)
    }
    
    private static func delete(record: CKRecord, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) { returnedRecordID, returnedError in
            if let error = returnedError {
                completion(.failure(error))
            } else if let recordId = returnedRecordID {
                completion(.success(recordId))
            } else {
                completion(.failure(CloudKitError.iCloudCanNotDeleteRecord))
            }
        }
    }
    
    // MARK: - U
    static func update<T: CloudKitableProtocol>(item: T) -> Future<CKRecord, Error> {
        add(item: item)
    }
    
    // MARK: - C
    static func add<T: CloudKitableProtocol>(item: T) -> Future<CKRecord, Error> {
        Future { promise in
            add(item: item) { result in
                promise(result)
            }
        }
    }
    
    private static func add<T: CloudKitableProtocol>(item: T, completion: @escaping (Result<CKRecord, Error>) -> ()) {
        // get record
        let record = item.record
        // save to cloudkit
        save(record: record, completion: completion)
    }
    
    private static func save(record: CKRecord, completion: @escaping (Result<CKRecord, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.save(record) { returnedRecord, returnedError in
            if let error = returnedError {
                completion(.failure(error))
            } else if let record = returnedRecord {
                completion(.success(record))
            } else {
                completion(.failure(CloudKitError.iCloudCanNotSaveRecord))
            }
        }
    }
    
    // MARK: - R
    static func fetch<T: CloudKitableProtocol>(
        recordType: CKRecord.RecordType,
        predicate: NSPredicate,
        sortDescriptors: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil) -> Future<[T], Error> {
            Future { promise in
                fetch(recordType: recordType, predicate: predicate, sortDescriptors: sortDescriptors, resultsLimit: resultsLimit) { (items: [T]) in
                    promise(.success(items))
                }
            }
        }
    
    private static func fetch<T: CloudKitableProtocol>(
        recordType: CKRecord.RecordType,
        predicate: NSPredicate,
        sortDescriptors: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil,
        completion: @escaping (_ items: [T]) -> ()) {
            // create operation
            let operation = createQueryOperation(recordType: recordType, predicate: predicate, sortDescriptors: sortDescriptors, resultsLimit: resultsLimit)
            // get items in query
            var returnedItems: [T] = []
            // add matched block
            addRecordMatchedBlock(operation: operation) { item in
                returnedItems.append(item)
            }
            // add result block
            addQueryResultBlock(operation: operation) { finished in
                completion(returnedItems)
            }
            // excute operation
            add(operation: operation)
        }
    
    
    private static func createQueryOperation(
        recordType: CKRecord.RecordType,
        predicate: NSPredicate,
        sortDescriptors: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil) -> CKQueryOperation {
            let query = CKQuery(recordType: recordType, predicate: predicate)
            query.sortDescriptors = sortDescriptors
            let queryOperation = CKQueryOperation(query: query)
            if let limit = resultsLimit {
                queryOperation.resultsLimit = limit
            }
            return queryOperation
        }
    
    private static func addRecordMatchedBlock<T: CloudKitableProtocol>(operation: CKQueryOperation, completion: @escaping (_ item: T) -> ()) {
        if #available(iOS 15.0, *) {
            operation.recordMatchedBlock = { (recordID, recordResult) in
                switch recordResult {
                case .success(let record):
                    guard let item = T(record: record) else { return }
                    completion(item)
                case .failure(let error):
                    print("Error recordMatchedBlock: \(error)")
                }
            }
        } else {
            operation.recordFetchedBlock = { fetchedRecord in
                guard let item = T(record: fetchedRecord) else { return }
                completion(item)
            }
        }
    }
    
    private static func addQueryResultBlock(operation: CKQueryOperation, completion: @escaping (_ finished: Bool) -> ()) {
        if #available(iOS 15.0, *) {
            operation.queryResultBlock = { operationResult in
                print("RESULT queryResultBlock: \(operationResult)")
                completion(true)
            }
        } else {
            operation.queryCompletionBlock = { (returnedCursor, returnedError) in
                if let error = returnedError {
                    print("RESULT queryCompletionBlock: \(error)")
                    completion(false)
                } else {
                    print("RESULT queryCompletionBlock: \(returnedCursor?.description ?? "")")
                    completion(true)
                }
                
            }
        }
    }
    
    private static func add(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
}

// MARK: - SUBSCRIBE FUNCTIONS

extension CloudKitUtility {
    
    // MARK: - subscribe
    
    static func subscribe(
        recordType: CKRecord.RecordType,
        predicate: NSPredicate,
        subscriptionID: CKSubscription.ID,
        options: CKQuerySubscription.Options,
        title: String,
        body: String? = nil) -> Future<Bool, Error> {
            Future { promise in
                subscribe(recordType: recordType,
                          predicate: predicate,
                          subscriptionID: subscriptionID,
                          options: options,
                          title: title,
                          body: body,
                          completion: promise)
            }
        }
    
    private static func subscribe(
        recordType: CKRecord.RecordType,
        predicate: NSPredicate,
        subscriptionID: CKSubscription.ID,
        options: CKQuerySubscription.Options,
        title: String,
        body: String? = nil,
        completion: @escaping (Result<Bool, Error>) -> ()) {
            // create subscription
            let subscription = CKQuerySubscription(recordType: recordType, predicate: predicate, subscriptionID: subscriptionID, options: options)
            let notificationInfo = CKSubscription.NotificationInfo()
            notificationInfo.title = title
            if let body = body {
                notificationInfo.alertBody = body
            }
            notificationInfo.soundName = "default"
            subscription.notificationInfo = notificationInfo
            // excute subscribe
            save(subscription: subscription, completion: completion)
        }
    
    
    private static func save(subscription: CKSubscription, completion: @escaping (Result<Bool, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    
    // MARK: - unsubscribe
    
    static func unsubscribe(subscriptionID: CKSubscription.ID) -> Future<Bool, Error> {
        Future { promise in
            delete(subscriptionID: subscriptionID, completion: promise)
        }
    }
    
    private static func delete(subscriptionID: CKSubscription.ID, completion: @escaping (Result<Bool, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: subscriptionID) { returnedSubscriptionId, returnedError in
            if let error = returnedError {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
}
