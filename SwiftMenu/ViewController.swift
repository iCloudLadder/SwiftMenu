//
//  ViewController.swift
//  SwiftMenu
//
//  Created by syweic on 14/10/23.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let bgColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let menuView1 = MenuView(frame: CGRectMake(10, 30, 50, 50), homeView: self.creatHomeView(), buttons: self.creatButtons())
        self.view.addSubview(menuView1)
    }
    
    // MARK: -创建label
    
    func creatHomeView() -> UILabel{
        var homeLable = UILabel(frame: CGRectMake(0, 0, 50, 50))
        homeLable.text = "Tap"
        homeLable.textAlignment = NSTextAlignment.Center
        homeLable.layer.cornerRadius = CGRectGetWidth(homeLable.frame)/2
        homeLable.clipsToBounds = true
        homeLable.backgroundColor = bgColor
        homeLable.userInteractionEnabled = true
        return homeLable
    }
    
    // MARK: -创建button
    
    func creatButtons() -> NSArray {
        var buttons = NSMutableArray()
        
        let width = CGFloat(30)
        
        let titles: NSArray = ["A","B","C","D","E","F"]
        let count = titles.count
        
        for idx in 1...count{
            var title = titles[idx-1] as? String
            buttons .addObject(self.creatButton(idx, width: width, title: title))
        }
        return buttons
    }
    
    func creatButton(tag: Int, width: CGFloat, title: String?) -> UIButton{
        var button = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        button!.tag = tag
        button!.setTitle(title, forState: UIControlState.Normal)
        button!.frame = CGRectMake(0, 0, width, width)
        button!.backgroundColor = bgColor
        button!.layer.cornerRadius = width/2
        button!.clipsToBounds = true
        button!.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button!
    }
    
    func buttonClicked(sender: UIButton){
        println("\(sender.tag)th button be clicked")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

