//
//  HighscoreViewController.swift
//  Lone Runner
//
//  Created by Siddarth Patel on 7/18/16.
//  Copyright © 2016 Appworks. All rights reserved.
//

import UIKit

var highscore = 0

class HighscoreViewController: UIViewController {

    @IBOutlet var highscoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            if NSUserDefaults.standardUserDefaults().objectForKey("highscore") != nil {
            highscore = NSUserDefaults.standardUserDefaults().objectForKey("highscore") as! Int
            highscoreLabel.text = "\(highscore)"
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
