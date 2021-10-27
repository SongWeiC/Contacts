//
//  AppRegistry+HomeUICoordinator.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation

extension AppRegistry: HomeUICoordinatorDependencyProviderType {
    func getCANavigationViewController() -> CANavigationViewController {
        return CANavigationViewController()
    }
    
    func getHomeVC() -> HomeViewController {
        return HomeViewController(dataSource: contactListDataSource)
    }
    
    func getContactDetailVC() -> ContactDetailViewController {
        return ContactDetailViewController(dataSource: contactListDataSource)
    }
    
    func getEditContactDetailVC() -> EditContactDetailViewController {
        return EditContactDetailViewController(dataSource: contactListDataSource)
    }
    
    func getAddContactDetailVC() -> AddContactViewController {
        return AddContactViewController(dataSource: contactListDataSource)
    }
}
