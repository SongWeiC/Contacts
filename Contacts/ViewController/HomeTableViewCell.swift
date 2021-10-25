//
//  HomeTableViewCell.swift
//  Contacts
//
//  Created by SongWei Chuah on 25/10/21.
//

import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {

    var childView: UIView? {
        didSet {
            if let v = childView {
                self.contentView.addSubview(v) ///It use to be self.addSubview(v), but the problem is if we add a childview directly, all user interaction will be eat up by the view, unless we are using contentView OR, we do the interaction handling in driver class later

                v.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        clipsToBounds = true
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        /**
         We need to check if this view is childView.superview as we create all carousels and hero tiles at the start (as there are not many). That means a carousel might be added as a child view to anoter MyTableViewCell.
         */
        if let v = childView, v.superview == self {
            v.removeFromSuperview()
        }
        for v in self.contentView.subviews {v.removeFromSuperview()}
        
        childView = nil
    }

}
