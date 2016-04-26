//
//  HamburgerButton.swift
//  Hamburger Button
//
//  Created by Robert Böhnke on 02/07/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

import CoreGraphics
import QuartzCore
import UIKit

@objc public class HamburgerButton : UIButton {
    
    let shortStroke: CGPath = {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 2, 2)
        CGPathAddLineToPoint(path, nil, 21, 2)
        
        return path
    }()
    
    let outline: CGPath = {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 8.5, 20.25)
        CGPathAddCurveToPoint(path, nil, 9.00, 20.25, 21.015, 20.25, 30, 20.25)
        CGPathAddCurveToPoint(path, nil, 41.94, 20.25, 37.8525, 1.50, 20.25, 1.5)
        CGPathAddCurveToPoint(path, nil, 9.87,  1.50,  1.50, 9.87,  1.5, 20.25)
        CGPathAddCurveToPoint(path, nil,  1.50, 30.63, 9.87, 39.00, 20.25, 39)
        CGPathAddCurveToPoint(path, nil, 30.63, 39.00, 39.00, 30.63, 39, 20.25)
        CGPathAddCurveToPoint(path, nil, 39.00, 9.87, 31.7925,  1.50, 20.25, 1.5)
        CGPathAddCurveToPoint(path, nil, 9.87, 1.50, 1.50, 9.87, 1.5, 20.25)
        
        return path
    }()
    
    let menuStrokeStart: CGFloat = 0.325
    let menuStrokeEnd: CGFloat = 0.9
    
    let hamburgerStrokeStart: CGFloat = 0.028
    let hamburgerStrokeEnd: CGFloat = 0.111
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.top.path = shortStroke
        self.middle.path = outline
        self.bottom.path = shortStroke
        
        for layer in [ self.top, self.middle, self.bottom ] {
            layer.fillColor = nil
            layer.strokeColor = UIColor.blackColor().CGColor
            layer.lineWidth = 4
            layer.miterLimit = 4
            layer.lineCap = kCALineCapRound
            layer.masksToBounds = true
            
            let strokingPath = CGPathCreateCopyByStrokingPath(layer.path, nil, 4, CGLineCap.Round, CGLineJoin.Miter, 4)
            
            layer.bounds = CGPathGetPathBoundingBox(strokingPath)
            
            layer.actions = [
                "strokeStart": NSNull(),
                "strokeEnd": NSNull(),
                "transform": NSNull()
            ]
            
            self.layer.addSublayer(layer)
        }
        
        self.top.anchorPoint = CGPointMake(28.0 / 30.0, 0.5)
        self.top.position = CGPointMake(32, 13.5)
        
        self.middle.position = CGPointMake(21, 20.25)
        self.middle.strokeStart = hamburgerStrokeStart
        self.middle.strokeEnd = hamburgerStrokeEnd
        
        self.bottom.anchorPoint = CGPointMake(28.0 / 30.0, 0.5)
        self.bottom.position = CGPointMake(32, 27)
    }
    
    public init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        
        self.top.path = shortStroke
        self.middle.path = outline
        self.bottom.path = shortStroke
        
        for layer in [ self.top, self.middle, self.bottom ] {
            layer.fillColor = nil
            layer.strokeColor = color.CGColor
            layer.lineWidth = 4
            layer.miterLimit = 4
            layer.lineCap = kCALineCapRound
            layer.masksToBounds = true
            
            let strokingPath = CGPathCreateCopyByStrokingPath(layer.path, nil, 4, CGLineCap.Round, CGLineJoin.Miter, 4)
            
            layer.bounds = CGPathGetPathBoundingBox(strokingPath)
            
            layer.actions = [
                "strokeStart": NSNull(),
                "strokeEnd": NSNull(),
                "transform": NSNull()
            ]
            
            self.layer.addSublayer(layer)
        }
        
        self.top.anchorPoint = CGPointMake(28.0 / 30.0, 0.5)
        self.top.position = CGPointMake(32, 13.5)
        
        self.middle.position = CGPointMake(21, 20.25)
        self.middle.strokeStart = hamburgerStrokeStart
        self.middle.strokeEnd = hamburgerStrokeEnd
        
        self.bottom.anchorPoint = CGPointMake(28.0 / 30.0, 0.5)
        self.bottom.position = CGPointMake(32, 27)
    }

   public var showsMenu: Bool = false {
        didSet {
            let strokeStart = CABasicAnimation(keyPath: "strokeStart")
            let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")

            if self.showsMenu {
                strokeStart.toValue = menuStrokeStart
                strokeStart.duration = 0.5
                strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)

                strokeEnd.toValue = menuStrokeEnd
                strokeEnd.duration = 0.6
                strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)
            } else {
                strokeStart.toValue = hamburgerStrokeStart
                strokeStart.duration = 0.5
                strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0, 0.5, 1.2)
                strokeStart.beginTime = CACurrentMediaTime() + 0.1
                strokeStart.fillMode = kCAFillModeBackwards

                strokeEnd.toValue = hamburgerStrokeEnd
                strokeEnd.duration = 0.6
                strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.3, 0.5, 0.9)
            }

            self.middle.ocb_applyAnimation(strokeStart)
            self.middle.ocb_applyAnimation(strokeEnd)

            let topTransform = CABasicAnimation(keyPath: "transform")
            topTransform.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, -0.8, 0.5, 1.85)
            topTransform.duration = 0.4
            topTransform.fillMode = kCAFillModeBackwards

            let bottomTransform = topTransform.copy() as! CABasicAnimation

            if self.showsMenu {
                let translation = CATransform3DMakeTranslation(-4, 0, 0)

                topTransform.toValue = NSValue(CATransform3D: CATransform3DRotate(translation, -0.7853975, 0, 0, 1))
                topTransform.beginTime = CACurrentMediaTime() + 0.25

                bottomTransform.toValue = NSValue(CATransform3D: CATransform3DRotate(translation, 0.7853975, 0, 0, 1))
                bottomTransform.beginTime = CACurrentMediaTime() + 0.25
            } else {
                topTransform.toValue = NSValue(CATransform3D: CATransform3DIdentity)
                topTransform.beginTime = CACurrentMediaTime() + 0.05

                bottomTransform.toValue = NSValue(CATransform3D: CATransform3DIdentity)
                bottomTransform.beginTime = CACurrentMediaTime() + 0.05
            }

            self.top.ocb_applyAnimation(topTransform)
            self.bottom.ocb_applyAnimation(bottomTransform)
        }
    }

    var top: CAShapeLayer! = CAShapeLayer()
    var bottom: CAShapeLayer! = CAShapeLayer()
    var middle: CAShapeLayer! = CAShapeLayer()
}

extension CALayer {
    func ocb_applyAnimation(animation: CABasicAnimation) {
        let copy = animation.copy() as! CABasicAnimation

        if copy.fromValue == nil {
            copy.fromValue = self.presentationLayer()!.valueForKeyPath(copy.keyPath!)
        }

        self.addAnimation(copy, forKey: copy.keyPath)
        self.setValue(copy.toValue, forKeyPath:copy.keyPath!)
    }
}
