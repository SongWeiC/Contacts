//
//  CANavigationViewController.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation
import UIKit

class CANavigationViewController: UIViewController {
    private var baseNavigationController: UINavigationController!
    
    var viewDidCloseCallback: (() -> Void)?
    
    var viewControllers: [UIViewController] {
        set {
            baseNavigationController.viewControllers = newValue
        }

        get {
            return baseNavigationController.viewControllers
        }
    }
    
    init() {
        self.baseNavigationController = UINavigationController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(baseNavigationController.view)
        self.addChild(baseNavigationController)
        baseNavigationController.didMove(toParent: self)
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        baseNavigationController.pushViewController(viewController, animated: animated)
    }
}
