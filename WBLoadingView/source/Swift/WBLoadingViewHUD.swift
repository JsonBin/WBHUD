//
//  WBLoadingViewHUD.swift
//  WBLoadingView
//
//  Created by zwb on 2017/6/26.
//  Copyright © 2017年 HengSu Co., LTD. All rights reserved.
//

import UIKit

///  加载中的动画，默认为视图中心，大小为(50, 50)
open class WBLoadingViewHUD: UIView {

    /// 线条颜色，默认为 UIColor.lightGray
    public var lineColor: UIColor?
    {
        didSet {
            if lineColor ==  oldValue { return }
            guard let newColor = lineColor else { return }
            setShapeLayerColor(newColor)
        }
    }
    
    /// 动画内圈运动的时长，默认为1s
    public var inDuration: CFTimeInterval = 1.0
    
    /// 动画中圈运动的时长，默认为1.25s
    public var centerDuration: CFTimeInterval = 1.25
    
    /// 动画外圈运动的时长，默认为1.5s
    public var outDuration: CFTimeInterval = 1.5
    
    private var _inLayer: CALayer?   // 最内部一层
    private var _centerLayer: CALayer?  // 中间一层
    private var _outLayer: CALayer?  // 最外部一层
    
    private var _inShapeLayer: CAShapeLayer?
    private var _centerShapeLayer: CAShapeLayer?
    private var _outShapeLayer: CAShapeLayer?
    
    private static let defaultWidth: CGFloat = 100
    private let loadingWidth = WBLoadingViewHUD.defaultWidth // 默认大小
    private let max_line:CGFloat = 5    // 一共有多少段
    private let s_w = UIScreen.main.bounds.size.width
    private let s_h = UIScreen.main.bounds.size.height
    
    // MARK:  -  Clicye Life
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initializeInterface()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeInterface()
    }
    
    private func initializeInterface() {
        
        if frame == .zero {
            frame = CGRect(x: (s_w - loadingWidth) / 2, y: (s_h - loadingWidth) / 2, width: loadingWidth, height: loadingWidth)
        }
        layer.cornerRadius = 5.0
        backgroundColor = UIColor(white: 0.0, alpha: 0.05)
        
        var radiusCoefficient: CGFloat = 10 // 半径系数
        
        _inLayer = CALayer()
        _inLayer?.backgroundColor = UIColor.clear.cgColor
        _inLayer?.frame = bounds
        layer.addSublayer(_inLayer!)
        _inShapeLayer = createShapeLayer(radiusCoefficient)
        _inLayer?.addSublayer(_inShapeLayer!)
        
        radiusCoefficient -= 4
        _centerLayer = CALayer()
        _centerLayer?.backgroundColor = UIColor.clear.cgColor
        _centerLayer?.frame = bounds
        layer.addSublayer(_centerLayer!)
        _centerShapeLayer = createShapeLayer(radiusCoefficient)
        _centerLayer?.addSublayer(_centerShapeLayer!)
        
        radiusCoefficient -= 1.75
        _outLayer = CALayer()
        _outLayer?.backgroundColor = UIColor.clear.cgColor
        _outLayer?.frame = bounds
        layer.addSublayer(_outLayer!)
        _outShapeLayer = createShapeLayer(radiusCoefficient)
        _outLayer?.addSublayer(_outShapeLayer!)
    }
    
    /// 通过半径系数初始化CAShapeLayer
    ///
    /// - Parameter radiusCoefficient: 半径系数
    /// - Returns: CAShapeLayer
    private func createShapeLayer(_ radiusCoefficient: CGFloat) -> CAShapeLayer {
        let width = bounds.size.width
        
        let lineWidth = width / 20
        
        var roundLength: CGFloat = 0 // 圈全长
        
        let theCenter = CGPoint(x: width / 2, y: bounds.size.height / 2)  // 视图中心点
        
        let path = UIBezierPath(arcCenter: theCenter, radius: width / radiusCoefficient, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        roundLength = 2 * .pi * width / radiusCoefficient
        let _shapLayer = CAShapeLayer()
        _shapLayer.path = path.reversing().cgPath
        _shapLayer.fillColor = UIColor.clear.cgColor
        _shapLayer.strokeColor = UIColor.lightGray.cgColor
        _shapLayer.lineCap = kCALineCapButt
        _shapLayer.lineWidth = lineWidth
        let dash1 = Float((roundLength - lineWidth * max_line) / max_line)
        _shapLayer.lineDashPattern = [NSNumber(value: dash1), NSNumber(value: Float(lineWidth))]
        return _shapLayer
    }
    
    /// 重置线条颜色
    ///
    /// - Parameter color: 颜色
    private func setShapeLayerColor(_ color: UIColor) {
        _inShapeLayer?.strokeColor = color.cgColor
        _centerShapeLayer?.strokeColor = color.cgColor
        _outShapeLayer?.strokeColor = color.cgColor
    }
    
    // MARK: - Start Animations
    open func start() {
        
        // 有动画，直接返回
        if let _ = _inLayer?.animationKeys() { return }
        
        // 旋转动画
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.fromValue = 0
        animation.toValue = 2 * CGFloat.pi
        animation.duration = inDuration
        animation.isCumulative = true
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        
        // 内圈动画
        _inLayer?.add(animation, forKey: "inLayer_animation")
        
        // 外圈动画
        animation.duration = outDuration
        _outLayer?.add(animation, forKey: "outLayer_animation")
        
        // 中圈动画
        animation.fromValue = 2 * CGFloat.pi
        animation.toValue = 0
        animation.duration = centerDuration
        _centerLayer?.add(animation, forKey: "centerLayer_animation")
    }
    
    // MARK: - Stop Animations
    open func stop() {
        _inLayer?.removeAllAnimations()
        _centerLayer?.removeAllAnimations()
        _outLayer?.removeAllAnimations()
    }
    
    // MARK: - Hidden
    open func hide(_ animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.1, animations: {
                self.stop()
                self.alpha = 0
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }else {
            self.stop()
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Show To View
    
    /// 添加到指定的View视图上
    ///
    /// - Parameters:
    ///   - toView: 需要添加的view
    ///   - isAnimated: 是否开启动画
    @discardableResult
    open class func show(_ toView: UIView, animated isAnimated: Bool = true) -> WBLoadingViewHUD {
        let rect = CGRect(x: (toView.bounds.size.width - WBLoadingViewHUD.defaultWidth) / 2, y: (toView.bounds.size.height - WBLoadingViewHUD.defaultWidth) / 2, width: WBLoadingViewHUD.defaultWidth, height: WBLoadingViewHUD.defaultWidth)
        let hud = WBLoadingViewHUD(frame: rect)
        hud.backgroundColor = UIColor(white: 0.0, alpha: 0.05)
        for subView in toView.subviews {
            if subView is WBLoadingViewHUD {
                if !isAnimated {
                    (subView as! WBLoadingViewHUD).stop()
                }else{
                    (subView as! WBLoadingViewHUD).start()
                }
                return subView as! WBLoadingViewHUD
            }
        }
        toView.addSubview(hud)
        toView.bringSubview(toFront: hud)
        if !isAnimated {
            hud.stop()
        }else{
            hud.start()
        }
        return hud
    }
}
