//
//  OptionsViewController.swift
//  Letterman
//
//  Copyright © 2016 Alex Zabrodskiy. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    @IBOutlet weak var controlWordDifficulty: UISegmentedControl!
    @IBOutlet weak var controlSound: UISwitch!

    
    @IBOutlet weak var labelGamesWon: UILabel!
    //@IBOutlet weak var imageBackground: UIImageView!
   
    @IBOutlet weak var labelUnder8: UILabel!

    
    @IBOutlet weak var viewStats: UIView!
    @IBOutlet weak var viewOptions: UIView!
 
    @IBOutlet weak var buttonReset: UIButton!
    
    
    @IBOutlet weak var buttonSaveNew: UIButton!
    @IBOutlet weak var buttonCancelNew: UIButton!
    
    let defaults = UserDefaults.standard
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2,
            animations: {
                sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    sender.transform = CGAffineTransform.identity
                    // actual code
                    self.defaults.set(self.controlWordDifficulty.selectedSegmentIndex, forKey: "WordDifficulty")
                    self.defaults.set(self.controlSound.isOn, forKey: "SilentMode")
                    MainController.playSound(name: "click", ext: "mp3")
                    self.dismiss(animated: true, completion: {});
                    // end of actual code
                }
            })
    }
    
    override var prefersStatusBarHidden: Bool {get {return true}}

    
    @IBAction func cancelButtonNewPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2,
            animations: {
                sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    sender.transform = CGAffineTransform.identity
                    // actual code
                    MainController.playSound(name: "click", ext: "mp3")
                    self.dismiss(animated: true, completion: {});                    // end of actual code
                }
            })
    }
  
    
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
    
        UIView.animate(withDuration: 0.2,
            animations: {
                sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    sender.transform = CGAffineTransform.identity
                    // actual code
                    MainController.playSound(name: "click", ext: "mp3")
                    
                    self.defaults.set(0, forKey: "GamesWon")
                    self.defaults.set(0, forKey: "Under8")
                    var result = self.defaults.integer(forKey: "GamesWon")
                    
                    self.labelGamesWon.text = "Games won: \(result)"
                    
                    result  = self.defaults.integer(forKey: "Under8")
                    
                    self.labelUnder8.text = "Games won under 8: \(result)"
                    // end of actual code
                }
            })
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attr = [NSAttributedString.Key.font : UIFont(name: "Chalkduster", size: 12)!,
            NSAttributedString.Key.foregroundColor:UIColor.systemBlue]
        
        controlWordDifficulty.setTitleTextAttributes(attr, for: .normal)
    
        controlWordDifficulty.selectedSegmentIndex = defaults.integer(forKey: "WordDifficulty")
        
        controlSound.setOn(defaults.bool(forKey: "SilentMode"), animated: true)
        
        var result = defaults.integer(forKey: "GamesWon")
        
        labelGamesWon.text = "Games won: \(result)"
        
        result  = defaults.integer( forKey: "Under8")
        
        labelUnder8.text = "Games won under 8: \(result)"

        
     
        buttonCancelNew.layer.backgroundColor = UIColor.systemBlue.cgColor
        
        //buttonCancelNew.backgroundColor = UIColor.red
        //buttonCancelNew.setTitleColor(UIColor.white, for: .normal)
        buttonCancelNew.layer.cornerRadius = 10 //* buttonCancelNew.bounds.size.height
        
        //buttonSaveNew.backgroundColor = UIColor.red
        //buttonSaveNew.setTitleColor(UIColor.white, for: .normal)
        buttonSaveNew.layer.backgroundColor = UIColor.systemBlue.cgColor
        buttonSaveNew.layer.cornerRadius = 10 //* buttonSaveNew.bounds.size.height
        
        //buttonReset.backgroundColor = UIColor.red
        //buttonReset.setTitleColor(UIColor.white, for: UIControlState())
        buttonReset.layer.cornerRadius = 10 //* buttonReset.bounds.size.height
        


        // Do any additional setup after loading the view.
        
        //self.view.bringSubview(toFront: viewStats)
        
        viewStats.layer.borderWidth = 2
        viewStats.layer.borderColor = UIColor.systemBlue.cgColor
        viewStats.layer.cornerRadius = 0.1 * viewStats.bounds.size.height
        
        
        //self.view.bringSubview(toFront: viewOptions)
        
        viewOptions.layer.borderWidth = 2
        viewOptions.layer.borderColor = UIColor.systemBlue.cgColor
        viewOptions.layer.cornerRadius = 0.1 * viewOptions.bounds.size.height
        
        
        //self.view.sendSubviewToBack(imageBackground)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
