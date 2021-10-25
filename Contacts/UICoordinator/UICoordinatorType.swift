//
//  UICoordinatorType.swift
//  Contacts
//
//  Created by SongWei Chuah on 24/10/21.
//

import Foundation
import UIKit

protocol UICoordinatorType: AnyObject {
    var rootVC: UIViewController { get }

    /// This will be triggered when if the rootVC was presented modally and has been dismissed
    var rootVCDidDismissCallback: (() -> Void)? { get set }
}
