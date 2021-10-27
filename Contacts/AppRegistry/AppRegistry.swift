//
//  AppRegistry.swift
//  Contacts
//
//  Created by SongWei Chuah on 24/10/21.
//

import Foundation
import UIKit

class AppRegistry {
    private(set) var window: UIWindow!
    private(set) var rootUICoordinator: HomeUICoordinator?
    
    var contactListDataSource: ContactDataSourceType!
    var dataProviderService: DataProviderServiceType!
    var coreDataService: CoreDataServiceType!
    
    init(){
        self.coreDataService = CoreDataService()
        self.dataProviderService = DataProviderService(coreDataService: coreDataService)
        self.contactListDataSource = ContactDataSource(dataProviderService: dataProviderService)
    }
    
    func createAppRootViewController(window: UIWindow) {
        self.window = window
        self.window!.rootViewController = createHomeUICoordinator().rootVC
        print("as")
    }
    
    func createHomeUICoordinator() -> HomeUICoordinator {
        return HomeUICoordinator(dependencyProvider: self)
    }
}
