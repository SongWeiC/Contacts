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
    func getContactDetailVC() -> ContactDetailViewController
    func getEditContactDetailVC() -> EditContactDetailViewController
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
        containerVC = dependencyProvider.getCANavigationViewController()
        homeVC = dependencyProvider.getHomeVC()
        homeVC.delegate = self
        containerVC.viewControllers = [homeVC]
    }
}

extension HomeUICoordinator: HomeViewControllerDelegateType {
    func showContactDetail() {
        let contactDetailVC = dependencyProvider.getContactDetailVC()
        contactDetailVC.delegate = self
        if let rootVC = rootVC as? CANavigationViewController {
            rootVC.pushViewController(contactDetailVC, animated: true)
        }
    }
}

extension HomeUICoordinator: ContactDetailVCDelegateType {
    func userDidTapEdit() {
        let editContactDetailsVC = dependencyProvider.getEditContactDetailVC()
        editContactDetailsVC.modalPresentationStyle = .fullScreen
//        editContactDetailsVC.delegate = self
        if let rootVC = rootVC as? CANavigationViewController {
            rootVC.present(editContactDetailsVC, animated: true, completion: nil)
//            rootVC.shouldShowNavigationBar = true
        }
    }
}
