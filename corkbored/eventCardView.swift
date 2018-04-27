//
//  eventCardView.swift
//  corkbored
//
//  Created by Jackson Meyer on 4/24/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//
import UIKit

@IBDesignable
class eventCardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 5
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 2
    @IBInspectable var shadowColor: UIColor? = UIColor.gray
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}
