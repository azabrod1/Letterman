//
//  OptionsViewController.swift
//  Letterman
//
//  Created by Tatyana kudryavtseva on 19/07/16.
//  Copyright © 2016 Alex Zabrodskiy. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    @IBOutlet weak var controlWordDifficulty: UISegmentedControl!
    @IBOutlet weak var controlSound: UISwitch!

    
    @IBOutlet weak var labelGamesWon: UILabel!
    @IBOutlet weak var imageBackground: UIImageView!
   
    @IBOutlet weak var labelUnder8: UILabel!


    
    @IBOutlet weak var viewStats: UIView!
    @IBOutlet weak var viewOptions: UIView!
 
    @IBOutlet weak var buttonReset: UIButton!
    
    
    @IBOutlet weak var buttonSaveNew: UIButton!
    @IBOutlet weak var buttonCancelNew: UIButton!
    
   let defaults = NSUserDefaults.standardUserDefaults()
    
    
    @IBAction func saveButtonPressed( sender: UIButton) {
        
        
        
        defaults.setInteger(controlWordDifficulty.selectedSegmentIndex, forKey: "WordDifficulty")
        
        defaults.setBool(controlSound.on, forKey: "SilentMode")
        
        
        MainController.playSound("click", ext: "mp3")
        
        self.dismissViewControllerAnimated(true, completion: {});
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func cancelButtonNewPressed( sender: UIButton) {
        
        MainController.playSound("click", ext: "mp3")
        
        self.dismissViewControllerAnimated(true, completion: {});

    }
  
    
    
    @IBAction func resetButtonPressed(sender: UIButton) {
    
        MainController.playSound("click", ext: "mp3")
        
        defaults.setInteger(0, forKey: "GamesWon")
        defaults.setInteger(0, forKey: "Under8")
        var result = defaults.integerForKey("GamesWon")
        
        labelGamesWon.text = "Games won: \(result)"
        
        result  = defaults.integerForKey("Under8")
        
        labelUnder8.text = "Games won under 8: \(result)"
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlWordDifficulty.selectedSegmentIndex = defaults.integerForKey("WordDifficulty")
        
        controlSound.setOn(defaults.boolForKey("SilentMode"), animated: true)
        
        var result = defaults.integerForKey("GamesWon")
        
        labelGamesWon.text = "Games won: \(result)"
        
        result  = defaults.integerForKey( "Under8")
        
        labelUnder8.text = "Games won under 8: \(result)"

        
     
        buttonCancelNew.layer.backgroundColor = UIColor.redColor().CGColor
        
        //buttonCancelNew.backgroundColor = UIColor.red
        //buttonCancelNew.setTitleColor(UIColor.white, for: .normal)
        buttonCancelNew.layer.cornerRadius = 10 //* buttonCancelNew.bounds.size.height
        
        //buttonSaveNew.backgroundColor = UIColor.red
        //buttonSaveNew.setTitleColor(UIColor.white, for: .normal)
        buttonSaveNew.layer.cornerRadius = 10 //* buttonSaveNew.bounds.size.height
        
        //buttonReset.backgroundColor = UIColor.red
        //buttonReset.setTitleColor(UIColor.white, for: UIControlState())
        buttonReset.layer.cornerRadius = 10 //* buttonReset.bounds.size.height
        


        // Do any additional setup after loading the view.
        
        //self.view.bringSubview(toFront: viewStats)
        
        viewStats.layer.borderWidth = 2
        viewStats.layer.borderColor = UIColor.redColor().CGColor
        viewStats.layer.cornerRadius = 0.1 * viewStats.bounds.size.height
        
        
        //self.view.bringSubview(toFront: viewOptions)
        
        viewOptions.layer.borderWidth = 2
        viewOptions.layer.borderColor = UIColor.redColor().CGColor
        viewOptions.layer.cornerRadius = 0.1 * viewOptions.bounds.size.height
        
        
        self.view.sendSubviewToBack(imageBackground)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
