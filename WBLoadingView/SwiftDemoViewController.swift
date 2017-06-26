//
//  SwiftDemoViewController.swift
//  WBLoadingView
//
//  Created by zwb on 2017/6/26.
//  Copyright © 2017年 HengSu Co., LTD. All rights reserved.
//

import UIKit

public class SwiftDemoViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "WBHUD-Swift"
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        let rect1 = CGRect(x: 50, y: 20, width: 50, height: 50)
        let hud1 = WBLoadingViewHUD(frame: rect1)
        view.addSubview(hud1)
        hud1.start()
        
//        let hud = WBLoadingViewHUD.show(view, animated: true)
//        hud.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
//        hud.lineColor = .blue
        
        let rect2 = CGRect(x: 150, y: 20, width: 50, height: 50)
        let hud2 = WBProgressViewHUD(frame: rect2, type: .single, lineColor: nil)
        view.addSubview(hud2)
        hud2.start()
        
        let rect3 = CGRect(x: 250, y: 20, width: 50, height: 50)
        let hud3 = WBProgressViewHUD(frame: rect3, type: .gossip, lineColor: .orange)
        hud3.lineColor = .cyan
        view.addSubview(hud3)
        hud3.start()
        
        let rect4 = CGRect(x: 50, y: 120, width: 50, height: 50)
        let hud4 = WBProgressViewHUD(frame: rect4, type: .fishHook, lineColor: nil)
        view.addSubview(hud4)
        hud4.start()
        
        let rect5 = CGRect(x: 150, y: 120, width: 50, height: 50)
        let hud5 = WBRoundViewHUD(frame: rect5, type: .uniform, roundColor: nil)
        hud5.duration = 1
        hud5.roundColor = .green
        view.addSubview(hud5)
        hud5.start()
        
        let rect6 = CGRect(x: 250, y: 120, width: 50, height: 50)
        let hud6 = WBRoundViewHUD(frame: rect6, type: .gradient, roundColor: nil)
        hud6.duration = 2.0
        hud6.roundColor = .orange
        view.addSubview(hud6)
        hud6.start()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
