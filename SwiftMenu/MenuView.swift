//
//  MenuView.swift
//  MenuButton
//
//  Created by syweic on 14/10/21.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

import UIKit

class MenuView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
    
    // 存放所有的buttons
    let buttons = NSMutableArray()
    // 显示的主视图
    let homeView: UIView?
    // 按钮显示状态
    var show = false
    // 子视图间的 空间
    var subSpace = CGFloat(10)
    // 主视图的 宽度
    let homeWidth = CGFloat(50)
    // 子视图的 个数
    let subCount = 0
    // 子视图的 宽度
    let subWidth = CGFloat(40)
    // 动画时间
    var animationDuration = 0.5
    
    
    
    init(frame: CGRect, homeView: UIView?, buttons:NSArray?){
        super.init(frame: frame)
        
        if let btns = buttons{
            self.buttons.addObjectsFromArray(btns)
            var subButton = self.buttons.lastObject as UIButton
            subWidth = CGRectGetWidth(subButton.frame)
            subCount = btns.count
            animationDuration = Double(subCount)*0.1
        }
        
        if let view = homeView{
            self.homeView = view
            homeWidth = CGRectGetWidth(view.frame)
        }
        
        // self.backgroundColor =  UIColor.greenColor()// UIColor(red: 0, green: 0.5, blue: 0, alpha: 0.5)
        self.userInteractionEnabled = true
        // 添加子视图
        self.addButtons()
        // 添加homeView
        self.addHomeView()
        // 添加点击手势
        self.addTapGR()
        
    }
    
    func setAttribute(){
    
    }
    
    // MARK: -添加 子视图
    
    func addButtons(){
        buttons.enumerateObjectsUsingBlock { (button, index, stop) -> Void in
            if let subView = button as? UIButton{
                subView.center = CGPoint(x: self.homeWidth/2, y: self.homeWidth/2)
                self.addSubview(subView)
                subView.hidden = true
                subView.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }
        }
    }
    
    func addHomeView(){
        if let subView = homeView{
            self.addSubview(subView)
        }
    }
    
    // MARK: -为 homeView 添加 点击手势
    
    func addTapGR(){
        var tgr = UITapGestureRecognizer(target: self, action: "tapClicked:")
        homeView?.addGestureRecognizer(tgr)
    }
    
    func tapClicked(_: UITapGestureRecognizer){
        self.showSubButtons(show)
        show = !show
    }
    
    // MARK: -显示 子视图
    
    func showSubButtons(show: Bool){
        show ? self.hiddenSubButtons() : self.showSubButtons()
    }
    
    func showSubButtons(){
        self.setFrameOfSlef(!show)
        self.userInteractionEnabled = false
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            for idx in 0...self.subCount-1{
                var button = self.buttons[idx] as UIButton
                button.transform = CATransform3DGetAffineTransform(CATransform3DMakeTranslation(0, self.homeWidth+CGFloat(idx)*(self.subSpace+self.subWidth), 0))
            }
            self.userInteractionEnabled = true
        }
        CATransaction.setAnimationDuration(animationDuration)
        buttons.enumerateObjectsUsingBlock { (view, index, stop) -> Void in
            let idx = self.subCount-index-1
            if let subView = view as? UIButton{
                let startPosition =  CGPointZero
                let finalPosition = CGPoint(x: 0, y: self.homeWidth+CGFloat(index)*(self.subSpace+self.subWidth))
                subView.hidden = false
                // 添加 position 动画
                self.addPositionAnimation(true, finalPosition: finalPosition, index: idx, view: subView)
                self.addScaleAnimation(idx, view: subView, show: true)
            }
        }
        
        CATransaction.commit()
        
    }
    
    func hiddenSubButtons(){
        // 添加 position 动画
        self.userInteractionEnabled = false
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            for idx in 0...self.subCount-1{
                var button = self.buttons[idx] as UIButton
                button.transform = CGAffineTransformIdentity
                button.hidden = true
            }
            self.setFrameOfSlef(self.show)
            self.userInteractionEnabled = true
        }
        CATransaction.setAnimationDuration(animationDuration)
        
        buttons.enumerateObjectsUsingBlock { (view, index, stop) -> Void in
            if let subView = view as? UIButton{
                let finalPosition = CGPoint(x: 0, y: self.homeWidth+CGFloat(index)*(self.subSpace+self.subWidth))
                self.addPositionAnimation(false, finalPosition: finalPosition, index: index, view: subView)
                
                self.addScaleAnimation(index, view: subView, show: false)
            }
        }
        CATransaction.commit()
        
    }
    
    // MARK: - 动画生成
    
    func addPositionAnimation(show: Bool,finalPosition: CGPoint, index: Int,view: UIButton){
        var positionAnimation = CABasicAnimation(keyPath: "transform")
        positionAnimation.duration = animationDuration
        
        // 起始点
        let fromTranslation =  CATransform3DIdentity
        let toTranslation = CATransform3DMakeTranslation(finalPosition.x, finalPosition.y, 0)

        positionAnimation.fromValue = NSValue(CATransform3D: show ? fromTranslation : toTranslation)
        positionAnimation.toValue = NSValue(CATransform3D: show ? toTranslation : fromTranslation)
        
        positionAnimation.beginTime = CACurrentMediaTime() + Double(index)/Double(subCount)*animationDuration

//        positionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        positionAnimation.fillMode = kCAFillModeForwards
        positionAnimation.removedOnCompletion = false

        view.layer.addAnimation(positionAnimation, forKey: "positionAnimation")
        
        
        
    }
    // 放大缩小动画
    func addScaleAnimation(index: Int,view: UIButton, show: Bool){
        var scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = animationDuration
        
        let fromScale = CATransform3DMakeScale(0.01, 0.01, 1)
        let toScale = CATransform3DMakeScale(1, 1, 1)
        
        scaleAnimation.fromValue = NSValue(CATransform3D: show ? fromScale: toScale)

        scaleAnimation.toValue = NSValue(CATransform3D: show ? toScale : fromScale)
        
        scaleAnimation.beginTime = CACurrentMediaTime() + Double(index)/Double(subCount)*animationDuration
        
        scaleAnimation.removedOnCompletion = false
        
        view.layer.addAnimation(scaleAnimation, forKey: "scaleAnimation")

    }

    
    
    
    
    
    
    // MARK: - 设置 self.frame
    func setFrameOfSlef(show: Bool){
        var showFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.homeWidth, self.homeWidth+CGFloat(self.subCount)*(self.subSpace+self.subWidth))
        var hiddenFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.homeWidth, self.homeWidth)
        self.frame = show ? showFrame : hiddenFrame
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    

    
    
    
    // MARK: - NSCoding 协议
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
    }
    
    
    
    
    
    
    
    
    
    
    
}
