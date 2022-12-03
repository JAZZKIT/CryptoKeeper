//
//  UIView+.swift
//  CryptoKeeper
//
//  Created by Denny on 01.12.2022.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
