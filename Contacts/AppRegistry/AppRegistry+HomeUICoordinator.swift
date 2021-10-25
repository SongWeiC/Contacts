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
        return HomeViewController()
    }
}
