//
//  GradientButton.swift
//  CryptoKeeper
//
//  Created by Denny on 01.12.2022.
//

import UIKit

final class GradientButton: UIButton {
    var title: String = ""
    var size: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, size: CGFloat) {
        self.init(frame: .zero)
        self.title = title
        self.size = size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont(name: "BrandonGrotesque-Light", size: size)
        gradientLayer.frame = bounds
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
    }

    lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemPurple.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradient)
        return gradient
    }()
}
