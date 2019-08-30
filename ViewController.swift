//
//  ViewController.swift
//  acelerômetro e giroscópio
//
//  Created by Cassia Franco on 30/08/2019.
//  Copyright © 2019 Cassia Franco. All rights reserved.
//

import UIKit
import  CoreMotion

class ViewController: UIViewController {
    @IBOutlet weak var street: UIImageView!
    @IBOutlet weak var player: UIImageView!
    @IBOutlet weak var tbTimePlayer: UILabel!
    @IBOutlet weak var viewGameOver: UIView!
    @IBOutlet weak var lbInstructions: UILabel!
    
    var isMoving: Bool =  false
    lazy var motionManager = CMMotionManager ()
    var gameTimer : Timer!
    var startDate : Data!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            viewGameOver.isHidden = true
            
            street.frame.size.width = view.frame.size.width * 2
            street.frame.size.height = view.frame.size.height * 2
            
            player.center = view.center
            player.animationImages = []
            for i in 0...7 {
                let image = UIImage(named: "player\(i)")!
                player.animationImages?.append(image)
            }
            player.animationDuration = 0.5
            player.startAnimating()
            
            Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { (timer) in
                self.start()
            }
    }
            
        func start() {
            lbInstructions.isHidden = true
            viewGameOver.isHidden = true
            isMoving = false
            startDate = Data()
                
            
                self.player.transform = CGAffineTransform (rotationAngle: 0)
                self.street.transform = CGAffineTransform (rotationAngle: 0)
                
                if motionManager.isDeviceMotionAvailable{
                    motionManager.startDeviceMotionUpdates(to: OperationQueue.main , withHandler: {(data,error) in
                        if error == nil {
                            if let data = data {
                                
                                //print("x:" , data.gravity.x, "y:" , data.gravity.y, "z:", data.gravity.z)
                                let angle = atan2(data.gravity.x, data.gravity.y) - .pi
                                self.player.transform = CGAffineTransform (rotationAngle: CGFloat (angle))
                                if !self.isMoving {
                                    self.checkGameOver()
                                }
                            }
                        }
                        
                    })
                }
                gameTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { (timer) in
                    
                    self.rotadeWorld()
                })
            }
        func rotadeWorld(){
            
            let rondomAngle = Double(arc4random_uniform(120))/100 - 0.6
            isMoving = true
            UIView.animate(withDuration: 0.75, animations: {
                self.street.transform = CGAffineTransform(rotationAngle: CGFloat (rondomAngle) )
                
            }) {(sucess) in
                self.isMoving = false
            }
        func checkGameOver(){
                let wordAngle = atan2(Double(street.transform.a),Double(street.transform.b))
                let playerAngle = atan2(Double(player.transform.a),Double(player.transform.b))
                let difference = abs(wordAngle - playerAngle)
                if difference > 0.25 {
                    gameTimer.invalidate()
                    viewGameOver.isHidden = false
                    motionManager.stopDeviceMotionUpdates()
                    let secondsPlayed = round(Data().timeIntervalSince(startDate))
                    tbTimePlayer.text = "Você jogou durante \(secondsPlayed) segundos"
            }
        }
        
            @IBAction func playAgain(_ sender: UIButton) {
                start()
            }
        }

    }
