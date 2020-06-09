//
//  ViewController.swift
//  CrazyBall
//
//  Created by Antonius F Aulia on 09/06/20.
//  Copyright © 2020 Antonius F Aulia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let ball = UIView()
    let size = CGSize(width: 100, height: 100)
    var animatorProperty = UIViewPropertyAnimator()
    var isPulse = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    private func setup() {
        ball.frame.size = size
        ball.center = view.center
        
        ball.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        ball.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ball.layer.borderWidth = 2
        
        ball.layer.cornerRadius = size.width/2
        ball.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ballDidTap))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ballPan(_ :)))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ballLongPress(_ :)))
        ball.addGestureRecognizer(tap)
        ball.addGestureRecognizer(pan)
        ball.addGestureRecognizer(longPress)
        
        view.addSubview(ball)
        pulseBall()
    }
    
    @objc func ballDidTap() {
        animatorProperty = UIViewPropertyAnimator(duration: 1,
                                                  curve: .linear,
                                                  animations: {
                                                    self.ball.alpha = 0
        })
        animatorProperty.addCompletion { (position) in
            if position == .end {
                self.isPulse = false
                self.resetBall()
            }
        }
        
        animatorProperty.startAnimation()
    }
    
    @objc func ballPan(_ sender: UIPanGestureRecognizer){
        if !isPulse {
            view.bringSubviewToFront(ball)
            let translation = sender.translation(in: view)
            ball.center = CGPoint(x: ball.center.x + translation.x, y: ball.center.y + translation.y)
            sender.setTranslation(CGPoint.zero , in: view)
            
            if sender.state == .ended {
                bringBallToCenter()
            }
        }
    }
    
    @objc func ballLongPress(_ sender : UILongPressGestureRecognizer){
        if !isPulse && sender.state == .began{
            ballZoom()
        }
    }
    
    private func ballZoom() {
        UIView.animateKeyframes(withDuration: 1,
                                delay: 0,
                                options: .calculationModeLinear,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 1) {
                                                        self.ball.transform = CGAffineTransform(scaleX: 10, y: 10)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                                        self.ball.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                                        self.ball.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2) {
                                        self.ball.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2) {
                                        self.ball.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2) {
                                        self.ball.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                                    }
        }) { (isAnimate) in
            self.ballDidTap()
        }
    }
    
    private func bringBallToCenter() {
        let animatorToCenter = UIViewPropertyAnimator(
            duration: 1,
            dampingRatio: 0.2) {
                self.ball.center = self.view.center
        }
        animatorToCenter.startAnimation()
    }
    
    
    private func pulseBall() {
//        animation
//        UIView.animate(withDuration: 2){
//            self.ball.frame.size.width = self.size.width * 1.2
//            self.ball.frame.size.height = self.size.height * 1.2
//            self.ball.layer.cornerRadius = self.size.width * 0.6
//        }
        
        UIView.animate(
            withDuration: 2,
            delay: 0,
            options: [.autoreverse, .repeat, .allowUserInteraction],
            animations: {
                self.ball.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        },
            completion: nil)
        
    }
    
    private func resetBall() {
        ball.layer.removeAllAnimations()
        ball.transform = .identity
        UIView.animate(withDuration: 1) {
            self.ball.alpha = 1
        }
        
    }

}

