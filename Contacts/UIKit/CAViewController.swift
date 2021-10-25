//
//  CAViewController.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import Foundation
import UIKit

protocol CAViewControllerInitDataProviderType {
    associatedtype CustomInitData

    var customInitData: CustomInitData { get }
}

public protocol NibLoadable {
    static func nibNameAndBundle() -> (String, Bundle)
}

class CAViewController<CustomInitData>: UIViewController {
    
    
    required init<T>(initDataProvider: T) where T: CAViewControllerInitDataProviderType, T.CustomInitData == CustomInitData {

        if let nibLoaddable = Self.self as? NibLoadable.Type {
            let data = nibLoaddable.nibNameAndBundle()
            super.init(nibName: data.0, bundle: data.1)
        } else {
            super.init(nibName: nil, bundle: nil)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
