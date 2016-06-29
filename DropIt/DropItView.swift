//
//  DropItView.swift
//  DropIt
//
//  Created by Zeng Qiang on 6/28/16.
//  Copyright © 2016 Zeng Qiang. All rights reserved.
//

import UIKit

class DropItView: NamedBezierPathsView, UIDynamicAnimatorDelegate
{
    
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()

    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeCompleteRow()
    }
    
    private let dropBehavoir = FallingObjectBehavior()
    var animating: Bool = false {
        didSet {
            if animating {
                animator.addBehavior(dropBehavoir)
                
            } else {
                animator.removeBehavior(dropBehavoir)
                
            }
        }
    }
    
    private var attachment: UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment!)
                bizierPaths[PathNames.AttachMent] = nil
            }
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment!)
                attachment?.action = { [unowned self] in
                    if let attachedDop = self.attachment!.items.first as? UIView {
                        self.bizierPaths[PathNames.AttachMent] = UIBezierPath.lineFrom(self.attachment!.anchorPoint, to: attachedDop.center)
                    }
                }
            }
        }
    }
    
    
    
    private struct PathNames {
        static let MiddleBarrier = "MiddleBarrier"
        static let AttachMent = "AttachMent"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(ovalInRect: CGRect(origin: bounds.mid, size: dropSize))
        dropBehavoir.addBarrier(path, named: PathNames.MiddleBarrier)
        bizierPaths[PathNames.MiddleBarrier] = path
    }
    
    
    private let dropsPerRow = 10
    
    private var dropSize: CGSize {
        let size = bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    
    func grabDrop(recognizer: UIPanGestureRecognizer) {
        let gesturePoint = recognizer.locationInView(self)
        
        switch recognizer.state {
        case .Began:
            if let dropToAttachTo = lastDrop where dropToAttachTo.superview != nil{
                attachment = UIAttachmentBehavior(item: dropToAttachTo, attachedToAnchor: gesturePoint)
                lastDrop = nil
            }
        case .Changed:
            attachment?.anchorPoint = gesturePoint
        default:
            attachment = nil
        }
    }

    private func removeCompleteRow()
    {
        var dropsToRemove = [UIView]()
        var hitTestRect = CGRect(origin: bounds.lowerLeft, size: dropSize)
        repeat {
            hitTestRect.origin.x = bounds.minX
            hitTestRect.origin.y -= dropSize.height
            var dropTested = 0
            var dropFound = [UIView]()
            
            while dropTested < dropsPerRow {
                if let hitView = hitTest(hitTestRect.mid) where hitView.superview == self {
                    dropFound.append(hitView)
                } else {
                    break
                }
                hitTestRect.origin.x += dropSize.width
                dropTested += 1
            }
            if dropTested == dropsPerRow {
                dropsToRemove += dropFound
            }
            
        }while dropsToRemove.count == 0 && hitTestRect.origin.y > bounds.minY
        
        for drop in dropsToRemove {
            dropBehavoir.removeItem(drop)
            drop.removeFromSuperview()
        }
    }
    
    private var lastDrop: UIView?
    
    func addDrop()
    {
        var frame = CGRect(origin: CGPoint.zero,size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        
        let drop = UIView(frame: frame)
        drop.backgroundColor  = UIColor.random
        
        addSubview(drop)
        dropBehavoir.addItem(drop)
        lastDrop = drop
    }
}
