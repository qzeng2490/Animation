//
//  UIKit Extension.swift
//  DropIt
//
//  Created by Zeng Qiang on 6/28/16.
//  Copyright © 2016 Zeng Qiang. All rights reserved.
//

import UIKit

extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

extension UIColor {
    class var random:UIColor {
        switch arc4random()%5 {
        case 0: return UIColor.greenColor()
        case 1: return UIColor.brownColor()
        case 2: return UIColor.cyanColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        default: return UIColor.blackColor()
        }
    }
}

extension CGRect {
    var mid: CGPoint { return CGPoint(x: midX, y: midY)}
    var upperLeft: CGPoint { return CGPoint(x: midX,y: minY) }
    var lowerLeft: CGPoint { return CGPoint(x: minX,y: maxY) }
    var upperRight: CGPoint { return CGPoint(x: maxX,y: minY) }
    var lowerRight: CGPoint { return CGPoint(x: maxX,y: maxY) }
    
}
extension UIView {
    func hitTest(p: CGPoint) -> UIView? {
        return hitTest(p,withEvent: nil)
    }
}

extension UIBezierPath {
    class func lineFrom(from: CGPoint, to: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(from)
        path.addLineToPoint(to)
        return path
    }
}