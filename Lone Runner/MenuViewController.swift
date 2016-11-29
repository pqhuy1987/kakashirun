//
//  MenuViewController.swift
//  Lone Runner
//
//  Created by Siddarth Patel on 7/18/16.
//  Copyright © 2016 Appworks. All rights reserved.
//

import UIKit
import CircleMenu
import AVFoundation

class MenuViewController: UIViewController {
   
    let items: [(icon:String, color: UIColor)] = [
        ("play-button", UIColor.orangeColor()),
        ("yellow-info-button-icon-50692", UIColor.orangeColor()),
        ("bbstarone-y_500_500", UIColor.orangeColor())]
    
    var player: AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let button = CircleMenu(
            frame: CGRect(x: CGRectGetMidX(self.view.frame) - 20, y: CGRectGetMidY(self.view.frame), width: 50, height: 50),
            normalIcon:"mainIcon4",
            selectedIcon:"mainIcon4",
            buttonsCount: 3,
            duration: 0.7,
            distance: 100)
        button.delegate = self
        button.layer.cornerRadius = button.frame.size.width / 2.0
        view.addSubview(button)

    }
    func play(){
    
        let audioPath = NSBundle.mainBundle().pathForResource("poof", ofType: "wav")
        do{
            
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath!))
            player.play()
            
        }
        catch{
            print("error")
        }
    
    }
    
    
    func circleMenu(circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        
        button.backgroundColor = items[atIndex].color
        button.setImage(UIImage(imageLiteral: items[atIndex].icon), forState: .Normal)
        let highlightedImage = UIImage(imageLiteral: items[atIndex].icon).imageWithRenderingMode(.AlwaysTemplate)
        button.setImage(highlightedImage, forState: .Highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        print("button did selected: \(atIndex)")
         if atIndex == 0 {
            play()
            self.performSegueWithIdentifier("play", sender: self)
         }
         
         else if atIndex == 1{
            play()
            self.performSegueWithIdentifier("instructions", sender: self)
         }
         
         else{
            play()
            self.performSegueWithIdentifier("highscore", sender: self)
         
         }
    }

    

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
