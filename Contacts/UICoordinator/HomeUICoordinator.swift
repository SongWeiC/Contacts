//
//  HomeUICoordinator.swift
//  Contacts
//
//  Created by SongWei Chuah on 24/10/21.
//

import Foundation
import UIKit

protocol HomeUICoordinatorDependencyProviderType: AnyObject {
    func getCANavigationViewController() -> CANavigationViewController
    func getHomeVC() -> HomeViewController
}

class HomeUICoordinator: UICoordinatorType {
    var rootVC: UIViewController {
        return containerVC
    }
    
    var rootVCDidDismissCallback: (() -> Void)?
    
    private var dependencyProvider: HomeUICoordinatorDependencyProviderType
    
    private var containerVC: CANavigationViewController
    
    private var homeVC: HomeViewController
    
    init(dependencyProvider: HomeUICoordinatorDependencyProviderType) {
        self.dependencyProvider = dependencyProvider
        self.containerVC = dependencyProvider.getCANavigationViewController()
        self.homeVC = dependencyProvider.getHomeVC()
        containerVC.viewControllers = [homeVC]
    }
}
