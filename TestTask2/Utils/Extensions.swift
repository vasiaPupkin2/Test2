//
//  Extensions.swift
//  TestTask2
//
//  Created by leanid niadzelin on 18.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//
import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func mainGreen() -> UIColor {
        return UIColor.rgb(red: 140, green: 195, blue: 75)
    }
    
    static func mainFadeWhite() -> UIColor {
        return UIColor.rgb(red: 185, green: 220, blue: 150)
    }
    
    static func mainGray() -> UIColor {
        return UIColor.rgb(red: 200, green: 200, blue: 200)
    }
    
    static func mainLightGray() -> UIColor {
        return UIColor.rgb(red: 245, green: 245, blue: 245)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
}

extension UIView {
    @discardableResult func addRightBorder(color: UIColor, width: CGFloat) -> UIView {
        let layer = CALayer()
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.frame = CGRect(x: self.frame.size.width-width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(layer)
        return self
    }
    @discardableResult func addLeftBorder(color: UIColor, width: CGFloat) -> UIView {
        let layer = CALayer()
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(layer)
        return self
    }
    @discardableResult func addTopBorder(color: UIColor, width: CGFloat) -> UIView {
        let layer = CALayer()
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(layer)
        return self
    }
    @discardableResult func addBottomBorder(color: UIColor, width: CGFloat) -> UIView {
        let layer = CALayer()
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.frame = CGRect(x: 0, y: self.frame.size.height-width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(layer)
        return self
    }
}

extension UIImage {
    func compressImageLow() -> UIImage {
        
        let actualHeight:CGFloat = self.size.height
        let actualWidth:CGFloat = self.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 600.0
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.5
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)!
    }
    
    func compressImageHigh() -> UIImage {
        let actualHeight:CGFloat = self.size.height
        let actualWidth:CGFloat = self.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 60.0
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.5
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)!
        
    }
}

