//
//  WBProgressViewHUD.swift
//  WBLoadingView
//
//  Created by zwb on 2017/6/26.
//  Copyright © 2017年 HengSu Co., LTD. All rights reserved.
//

import UIKit

///  加载中的动画，默认为视图中心，大小为(100, 100)
open class WBProgressViewHUD: UIView {
    
    /// 视图的动画类型
    ///
    /// - single: 单线条
    /// - fishHook: 标准八卦形
    /// - gossip: 类八卦形
    public enum HUDType {
        case single, fishHook, gossip
    }
    
    /// 线条颜色，默认为 UIColor.white
    public var lineColor: UIColor?
    {
        didSet {
            if lineColor ==  oldValue { return }
            guard let newColor = lineColor else { return }
            setNewLayerColor(newColor)
        }
    }
    
    /// 动画内圈运动的时长，默认为1s
    public var inDuration: CFTimeInterval = 1.0
    
    /// 动画外圈运动的时长，默认为1.5s
    public var outDuration: CFTimeInterval = 1.5
    
    private var _inLayer: CALayer?   // 最内部一层
    private var _outLayer: CALayer?  // 最外部一层
    
    private var _inGradientLayer: CAGradientLayer?  // 内层渐变层
    private var _outGradientLayer: CAGradientLayer?  // 外层渐变层
    
    private var _inShapeLayer: CAShapeLayer?  // 内圈模板
    private var _outShapeLayer: CAShapeLayer?  // 外圈模板
    
    private var _type: HUDType = .single  // 旋转动画的类型, 默认为 .single
    
    fileprivate static let defaultWidth: CGFloat = 50
    private let loadingWidth = WBProgressViewHUD.defaultWidth // 默认大小
    private let s_w = UIScreen.main.bounds.size.width
    private let s_h = UIScreen.main.bounds.size.height
    
    // MARK:  -  Clicye Life
    
    /// 初始化HUD
    ///
    /// - Parameters:
    ///   - frame: 视图frame，默认中心为屏幕中心，大小为 (50, 50)
    ///   - type: 动画的类型
    ///   - lineColor: 线条颜色，默认为 [UIColor whiteColor]
    public convenience init(frame: CGRect, type: HUDType = .single, lineColor: UIColor? = nil) {
        self.init(frame: frame)
        
        self.lineColor = lineColor
        if lineColor == nil {
            self.lineColor = .white
        }
        _type = type
        
        initializeInterface()
    }
    
    private func initializeInterface() {
        
        if frame == .zero {
            frame = CGRect(x: (s_w - loadingWidth) / 2, y: (s_h - loadingWidth) / 2, width: loadingWidth, height: loadingWidth)
        }
        layer.cornerRadius = 5.0
        backgroundColor = UIColor(white: 0.0, alpha: 0.95)

        _inLayer = CALayer()
        _inLayer?.backgroundColor = UIColor.clear.cgColor
        _inLayer?.frame = bounds
        layer.addSublayer(_inLayer!)
        _inGradientLayer = createGradientLayer(true)
        _inShapeLayer = createMaskShapeLayer(true)
        _inLayer?.addSublayer(_inGradientLayer!)
        _inLayer?.mask = _inShapeLayer
        
        _outLayer = CALayer()
        _outLayer?.backgroundColor = UIColor.clear.cgColor
        _outLayer?.frame = bounds
        layer.addSublayer(_outLayer!)
        _outGradientLayer = createGradientLayer()
        _outShapeLayer = createMaskShapeLayer()
        _outLayer?.addSublayer(_outGradientLayer!)
        _outLayer?.mask = _outShapeLayer
    }
    
    /// 创建渐变层
    ///
    /// - Parameter isInOrOut: 是否在内圈还是外圈
    /// - Returns: 创建好的渐变层
    private func createGradientLayer(_ isInOrOut: Bool = false) -> CAGradientLayer {
        let _gradientLayer = CAGradientLayer()
        _gradientLayer.frame = bounds
        _gradientLayer.colors = [UIColor.clear.cgColor, (lineColor ?? .white).cgColor]
        switch _type {
        case .gossip:
            _gradientLayer.startPoint = isInOrOut ? CGPoint(x: 0.5, y: 1.0) : CGPoint(x: 1.0, y: 0.5)
            _gradientLayer.endPoint = isInOrOut ? CGPoint(x: 0.5, y: 0.0) : CGPoint(x: 0.0, y: 0.5)
        case .fishHook:
            _gradientLayer.startPoint = isInOrOut ? CGPoint(x: 0.5, y: 1.0) : CGPoint(x: 0.5, y: 0.0)
            _gradientLayer.endPoint = isInOrOut ? CGPoint(x: 0.5, y: 0.0) : CGPoint(x: 0.5, y: 1.0)
        case .single:
            _gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            _gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        return _gradientLayer
    }
    
    /// 通过是否为内圈初始化遮罩CAShapeLayer
    ///
    /// - Parameter isInOrOut: 是否为内圈
    /// - Returns: CAShapeLayer
    private func createMaskShapeLayer(_ isInOrOut: Bool = false) -> CAShapeLayer {
        let width = bounds.size.width
        let height = bounds.size.height
        let lineWidth = width / 15 // 线宽
        let theCenter = CGPoint(x: width / 2, y: height / 2)  // 视图中心点
        
        var path = UIBezierPath()
        // 绘制贝塞尔曲线
        switch _type {
        case .gossip:
            if isInOrOut {
                path.move(to: theCenter)
                // 第一个半圆
                let firstPoint = CGPoint(x: width / 2, y: height / 8 * 3)
                path.append(UIBezierPath(arcCenter: firstPoint, radius: width / 8, startAngle: .pi / 2, endAngle: .pi / 2 * 3, clockwise: true))
                path.append(UIBezierPath(arcCenter: theCenter, radius: width / 4, startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: true))
                let secondPoint = CGPoint(x: width / 2, y: height / 8 * 5)
                path.append(UIBezierPath(arcCenter: secondPoint, radius: width / 8, startAngle: .pi / 2, endAngle: -.pi / 2, clockwise: false))
                path.close()
            }else{
                path.move(to: CGPoint(x: 0, y: height / 2))
                // 第二个半圆
                let firstPoint = CGPoint(x: width / 8, y: height / 2)
                path.append(UIBezierPath(arcCenter: firstPoint, radius: width / 8, startAngle: .pi, endAngle: 2 * .pi, clockwise: true))
                let secondPoint = CGPoint(x: width / 8 * 5, y: height / 2)
                path.append(UIBezierPath(arcCenter: secondPoint, radius: width / 8 * 3, startAngle: .pi, endAngle: 0, clockwise: false))
                path.append(UIBezierPath(arcCenter: theCenter, radius: width / 2, startAngle: 0, endAngle: .pi, clockwise: true))
                path.close()
            }
        case .fishHook:
            if isInOrOut {
                path.move(to: theCenter)
                // 第一个半圆
                let firstPoint = CGPoint(x: width / 2, y: height / 4 * 3)
                path.append(UIBezierPath(arcCenter: firstPoint, radius: width / 4, startAngle: .pi / 2 * 3, endAngle: .pi / 2, clockwise: false))
                path.append(UIBezierPath(arcCenter: theCenter, radius: width / 2, startAngle: .pi / 2, endAngle: .pi / 2 * 3, clockwise: true))
                let secondPoint = CGPoint(x: width / 2, y: height / 4)
                path.append(UIBezierPath(arcCenter: secondPoint, radius: width / 4, startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: true))
                path.close()
            }else{
                path.move(to: theCenter)
                // 第二个半圆
                let firstPoint = CGPoint(x: width / 2, y: height / 4 * 3)
                path.append(UIBezierPath(arcCenter: firstPoint, radius: width / 4, startAngle: .pi / 2 * 3, endAngle: .pi / 2, clockwise: false))
                path.append(UIBezierPath(arcCenter: theCenter, radius: width / 2, startAngle: .pi / 2, endAngle: -.pi / 2, clockwise: false))
                let secondPoint = CGPoint(x: width / 2, y: height / 4)
                path.append(UIBezierPath(arcCenter: secondPoint, radius: width / 4, startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: true))
                path.close()
            }
        case .single:
            if isInOrOut {
                path = UIBezierPath(arcCenter: theCenter, radius: width / 6, startAngle: 0, endAngle: .pi, clockwise: true)
            }else{
                path = UIBezierPath(arcCenter: theCenter, radius: width / 4, startAngle: .pi, endAngle: 2 * .pi, clockwise: true)
            }
        }
        let _shapeLayer = CAShapeLayer()
        _shapeLayer.lineCap = kCALineCapRound
        _shapeLayer.path = path.cgPath
        if _type == .single {
            _shapeLayer.lineWidth = lineWidth
            _shapeLayer.fillColor = UIColor.clear.cgColor
            _shapeLayer.strokeColor = lineColor?.cgColor
        }
        return _shapeLayer
    }
    
    /// 重置线条颜色
    ///
    /// - Parameter color: 颜色
    private func setNewLayerColor(_ color: UIColor) {
        // 重置颜色
        _inGradientLayer?.colors = [UIColor.clear.cgColor, color.cgColor]
        _outGradientLayer?.colors = [UIColor.clear.cgColor, color.cgColor]
        // 对单线条模板进行二次处理
        if _type == .single {
            _inShapeLayer?.strokeColor = color.cgColor
            _outShapeLayer?.strokeColor = color.cgColor
        }
    }
    
    // MARK: - Start Animations
    open func start() {
        
        // 有动画，直接返回
        if let _ = _inLayer?.animationKeys() { return }
        
        // 旋转动画
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.fromValue = 2 * CGFloat.pi
        animation.toValue = 0
        animation.duration = inDuration
        animation.isCumulative = true
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        
        if _type == .fishHook {
            animation.fromValue = 0
            animation.toValue = 2 * CGFloat.pi
            _inLayer?.add(animation, forKey: "inLayer_animation")
            _outLayer?.add(animation, forKey: "outLayer_animation")
            return
        }
        // 内圈动画
        _inLayer?.add(animation, forKey: "inLayer_animation")
        
        // 外圈动画
        animation.fromValue = 0
        animation.toValue = 2 * CGFloat.pi
        animation.duration = outDuration
        _outLayer?.add(animation, forKey: "outLayer_animation")
    }
    
    // MARK: - Stop Animations
    open func stop() {
        _inLayer?.removeAllAnimations()
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
}

 // MARK: - Show To View
extension WBProgressViewHUD {
    
    /// 添加到指定的View视图上
    ///
    /// - Parameters:
    ///   - toView: 需要添加的view
    ///   - isAnimated: 是否开启动画
    @discardableResult
    open class func show(_ toView: UIView, type hudType: WBProgressViewHUD.HUDType = .single, animated isAnimated: Bool = true) -> WBProgressViewHUD {
        let rect = CGRect(x: (toView.bounds.size.width - WBProgressViewHUD.defaultWidth) / 2, y: (toView.bounds.size.height - WBProgressViewHUD.defaultWidth) / 2, width: WBProgressViewHUD.defaultWidth, height: WBProgressViewHUD.defaultWidth)
        let hud = WBProgressViewHUD(frame: rect, type: hudType, lineColor: nil)
        hud.backgroundColor = UIColor(white: 0.0, alpha: 0.95)
        for subView in toView.subviews {
            if subView is WBProgressViewHUD {
                if !isAnimated {
                    (subView as! WBProgressViewHUD).stop()
                }else{
                    (subView as! WBProgressViewHUD).start()
                }
                return subView as! WBProgressViewHUD
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
