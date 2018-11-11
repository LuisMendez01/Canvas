//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Luis Mendez on 11/10/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var trayView: UIView!
    
    //for position
    var trayOriginalCenter: CGPoint!
    
    //for speed/velocity
    var trayDownOffset: CGFloat! = 0//The trayDownOffset will dictate how much the tray moves down.
    var trayUp: CGPoint!
    var trayDown: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The trayDownOffset will dictate how much the tray moves down
        trayDownOffset = 270//270 worked for my tray, but you will likely have to adjust this value to accommodate the specific size of your tray.
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
        
    }

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let location = sender.location(in: view)
        let velocity = sender.velocity(in: view)
        
        //When the gesture begins (.began), store the tray's center into the trayOriginalCenter variable:
        if sender.state == .began {
            print("Gesture began")
            //store the tray's center into the trayOriginalCenter variable. This way each time the tray is panned, we will have a reference to where it was before the panning started.
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            print("Gesture is changing")
            // change the trayView.center by the translation. Note: we ignore the x translation because we only want the tray to move up and down:
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {//Since we are focusing on the user's last gesture movement,
            print("Gesture ended")
            
            //If the y component of the velocity is a positive value, the user is panning down
            if velocity.y > 0 {
                print("Moving down")
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                }, completion: nil)
            } else {//If the y component is negative, the user is panning up.
                print("Moving up")
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayUp
                }, completion: nil)
            }
        }
    }
}
