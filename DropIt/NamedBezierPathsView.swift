//
//  NamedBezierPathsView.swift
//  DropIt
//
//  Created by Zeng Qiang on 6/29/16.
//  Copyright © 2016 Zeng Qiang. All rights reserved.
//

import UIKit

class NamedBezierPathsView: UIView {

    var bizierPaths = [String:UIBezierPath]() { didSet { setNeedsDisplay() } }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        for (_,path) in bizierPaths {
            path.stroke()
        }
    }
 

}
