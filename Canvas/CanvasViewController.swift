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
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
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
        //let location = sender.location(in: view)
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
    
    //drag and create new faces from canvas
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        print("translation: \(translation)")
        
        if sender.state == .began {
            print("didPanFace Gesture began")
            
            let imageView = sender.view as! UIImageView//imageView now refers to the face that you panned on.
            
            newlyCreatedFace = UIImageView(image: imageView.image) //Create a new image view that has the same image as the one you're currently panning.
            
            // The didMoveFace: will move the little faces
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didMoveFace(_:)))
            
            // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            
            view.addSubview(newlyCreatedFace)// Add the new face to the main view.
            
            newlyCreatedFace.center = imageView.center //Initialize the position of the new face.
            
            print("newlyCreatedFace.center: \(newlyCreatedFace.center)")
            print("trayView.frame.origin.y: \(trayView.frame.origin)")
            
            //since face y is 114.0 inside tray then we want to know what is 114.0 for the main view
            //outside the tray, so tray 567+114= the position of face according to main view.
            newlyCreatedFace.center.y = trayView.frame.origin.y //Since the original face is in the tray, but the new face is in the main view, you have to offset the coordinates.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            UIView.animate(withDuration: 1,
                           animations: {
                            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.6) {
                                self.newlyCreatedFace.transform = CGAffineTransform.identity
                            }
            })
            
        } else if sender.state == .changed {
            print("didPanFace Gesture is changing")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
    }
    
    //allows to move smiley faces that were created from dragging from canvas
    @objc func didMoveFace(_ sender: UIPanGestureRecognizer) {

        let translation = sender.translation(in: view)

        if sender.state == .began {
            print("didMoveFace Gesture began")
            newlyCreatedFace = sender.view as? UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center // so we can offset by translation later.
        }else if sender.state == .changed {
            print("didMoveFace Gesture is changing")
            //position will where face was to where it was translated to
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
    }
}
