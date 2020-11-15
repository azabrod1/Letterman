//
//  ViewController.swift
//  Letterman
//
//  Created by Tatyana kudryavtseva on 16/07/16.
//  Copyright © 2016 Alex Zabrodskiy. All rights reserved.
//

import UIKit
import AVFoundation


class MainController: UIViewController, UITextFieldDelegate {

    
    // MARK: constants
    
    var round = 0
    static var player: AVAudioPlayer?
    
    
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    
    let letterNormalColor =  UIColor(red: 12.0/255, green: 118.0/255, blue: 240.0/255, alpha: 1.0)
    let letterWinColor = UIColor.whiteColor()
    let letterLoseColor = UIColor.whiteColor()
    let numberColor = UIColor.whiteColor()
    let colorPlate = [UIColor( red:  0.564 , green: 0.764, blue:0.9519, alpha: 0.7 ) , UIColor( red:  0.564 , green: 0.88235, blue:0.882, alpha: 0.7 ),  UIColor( red:  0.564 , green: 0.8824, blue:0.7059, alpha: 0.7 ), UIColor( red:  0.564 , green: 0.8824, blue:0.4705, alpha: 0.7 ), UIColor( red:  0.733 , green: 0.8824, blue:0.3529, alpha: 0.7 ) , UIColor( red:  0.8824 , green: 0.8824, blue:0.3829, alpha: 0.7 ),  UIColor( red:  0.9019 , green: 0.8078, blue:0.1960, alpha: 0.85 ),  UIColor( red:  0.9019 , green: 0.63137, blue:0.1960, alpha: 0.85 ) , UIColor( red:  0.9019 , green: 0.39215, blue:0.1960, alpha: 0.85 ), UIColor( red:  0.8019 , green: 0.1960, blue:0.25, alpha: 0.85 ) ]
    
    
    // MARK : member variables
    
    
    
    private var grid = [[UITextField]]()
    
    private let letterCnt = 5
    private let totalCols = 7
    var board: LMBoard = LMBoard()!


    var buttonGo = UIButton()
    
    
    @IBOutlet weak var imageHeader: UIImageView!
   
    
    @IBOutlet weak var toolBar: UIToolbar!
    // MARK: init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        createBoard()
        resetBoard()
        updateBoard()
        
        
        //toolBar.tintColor = UIColor.blue.withAlphaComponent(0.3)
        
        //create buttons for toolbar
        
        let playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        
        ///let barSeperator = UIBarButtonItem.
        
        let optionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        
        let helpButton = UIButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        
        let horizontalSeperator: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)

        
        

        
        //set images for buttons
        playButton.setImage(UIImage(named: "play.png"), forState: UIControlState.Normal)
        
        helpButton.setImage(UIImage(named: "help.png"), forState: UIControlState.Normal)
        
        optionButton.setImage(UIImage(named: "options.png"), forState: UIControlState.Normal)
        

        

        //set frame
        
        let barButtons = [UIBarButtonItem(customView: playButton), horizontalSeperator, UIBarButtonItem(customView: optionButton),  UIBarButtonItem(customView: helpButton)]


        //Add actions to toolbar buttons
        
        
        playButton.addTarget(self, action: #selector(startButtonPressed), forControlEvents: UIControlEvents.TouchDown)
        
        optionButton.addTarget(self, action: #selector(optionButtonPressed), forControlEvents: UIControlEvents.TouchDown)
 
        helpButton.addTarget(self, action: #selector(helpButtonPressed), forControlEvents: UIControlEvents.TouchDown)
        
        
        toolBar.items = barButtons
        
 
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        // move the button next to guess word - for some reason does not work in viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: board
    
    // this function executes only once at the beginning of the app running
    func createBoard () {
        
        //constants
        var frameWidth = self.view.frame.width
        var frameHeight = self.view.frame.height
        
        // to deal with a weird issue when iPad launches in landscape
        if (frameWidth > frameHeight){
            
            let temp = frameWidth
            frameWidth = frameHeight
            frameHeight = temp
            
            
        }
        
        frameHeight -= imageHeader.frame.height
        frameHeight -= toolBar.frame.height
        
        
        if (frameWidth > frameHeight){
           
            let temp = frameWidth
            
            frameWidth = frameHeight
            frameHeight = temp
            
            
        }
        
        
        
        let textSize = min(0.1 * frameWidth, (frameHeight  ) * 0.075)
        
        let xDistance = 0.010 * frameWidth
        let yDistance = 0.014 * frameHeight
        
        let xStart = 0.5 * frameWidth - 3.5 * textSize - 2 * xDistance
        
        let yStart = imageHeader.frame.height + 1 * yDistance
                
        
        round = board.getTotalTries()
        
        for r in 0..<round + 1 {
            
            var word = [UITextField]()
            var char : LMTextField
            
            for c in 0..<letterCnt + 2{
                
                let x = xStart + CGFloat(c) * (textSize + xDistance)
                let y = yStart + CGFloat(r) * (textSize + yDistance)
                
                char = LMTextField(frame: CGRect(x: x, y: y, width: textSize, height: textSize))
                char.myDelegate = self
                
                
                if (c == 0 ){
                    
                    char.borderStyle = UITextBorderStyle.None
                    char.backgroundColor = UIColor.clearColor()
                    char.textColor = numberColor
                    char.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
                    char.textAlignment = .Justified
                    char.userInteractionEnabled = false

                }
                else if (c == 6){
                    
                    char.borderStyle = UITextBorderStyle.None
                    char.backgroundColor = UIColor.clearColor()
                    char.textColor = numberColor
                    char.font = UIFont(name: "Optima-ExtraBlack", size: 18)
                    char.textAlignment = .Left
                    char.userInteractionEnabled = false
                }
                    
                else {
                    
                    char.borderStyle = UITextBorderStyle.RoundedRect
                    char.backgroundColor = colorPlate[0]
                    char.textColor = letterNormalColor
                    char.layer.borderColor = colorPlate[0].CGColor
                    
                    char.font = UIFont(name: "Optima-ExtraBlack", size: 18)
                    
                    char.layer.cornerRadius = 0.35 * char.bounds.size.width
                    char.textAlignment = .Center
                    char.userInteractionEnabled = (r == 0) // enable editing for the 0 row
                }
                
                
                char.adjustsFontSizeToFitWidth = true
                char.minimumFontSize = 8
                //char.autocapitalizationType = .AllCharacters
                
                char.textAlignment = .Center
                char.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
                
                word += [char]
                self.view.addSubview(char)
                
                char.delegate = self
                
                
                
                //char.addTarget(self, action: #selector(editingChange(_:)), for: UIControlEvents.editingChanged)
                
                
                
            }
            grid += [word]
        }
        
        // permanenty hide the counter for the first row
        grid[0][6].hidden = true
        // create a button instead
        
        let x = grid[0][6].frame.minX + xDistance  //xStart + 6 * (textSize + xDistance)
        let y = grid[0][6].frame.minY // yStart + 0 * (textSize + yDistance)
        
        buttonGo = UIButton (frame: CGRect(x: x, y: y, width: textSize, height: textSize))
        
        buttonGo.setTitle("Go", forState: UIControlState.Normal)
        buttonGo.backgroundColor = UIColor.redColor()
        buttonGo.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonGo.layer.cornerRadius = 0.5 * buttonGo.bounds.size.width
        buttonGo.addTarget(self, action: #selector(buttonPressed), forControlEvents: .TouchUpInside)
        //buttonGo font = UIFont(name: "Optima-ExtraBlack", size: 18)!
        self.view.addSubview(buttonGo)
        
        
        // tag the first row (for firstresponder pass)
        for c in 1...5{
            (grid[0][c]).tag = c
        }

        // make sure elements are visible
        
        self.view.bringSubviewToFront( imageHeader)
        self.view.bringSubviewToFront( toolBar)
        
        
        
    }
    
    // this function is executed at the beginning of each game
    
    func resetBoard(){
        
        board.resetGame()
        
        //labelStatus.backgroundColor = UIColor(patternImage: UIImage(named: "Logo.png")!)
        //labelStatus.text = "Letterman: Let's Play!"
        
        imageHeader.image = UIImage(named: "Logo")
        
        //print(imageHeader.image)
        
        grid[0][0].hidden = false
        grid[0][0].text = "1"
        buttonGo.hidden = false
        buttonGo.enabled = true
        
        
        // set the first row
        for i in 1...5{
            (grid[0][i]).userInteractionEnabled = true
            (grid[0][i]).text = ""
            (grid[0][i]).textColor = letterNormalColor
            (grid[0][i]).backgroundColor = colorPlate[0]
        }
        
        // hide all the rows except first
        for r in 1...board.getTotalTries(){
            for c in 0...6{
                (grid[r][c]).hidden = true
            }
        }
        
        grid[0][1].becomeFirstResponder()
    }
    
    
    
    
    // this function is executed every time the game status changes
    
    func updateBoard(){
        
        let guesses = board.getGuessedWords()
        round = guesses.count
        colorTiles(board)

        
        if(board.isWon()) {
            
            let secretWord = board.getSecredWord()
            
            MainController.playSound("win", ext: "mp3")
            
            for c in 1...5{
                (grid[0][c]).text = String(secretWord[secretWord.startIndex.advancedBy(c-1)])
                    
                    //[secretWord.characters.indexOf(secretWord.startIndex, offsetBy: c-1)]) //Reveal secret word
                
                (grid[0][c]).backgroundColor = UIColor.blueColor()
                (grid[0][c]).textColor =  letterWinColor
                (grid[0][c]).userInteractionEnabled = false
            }

            imageHeader.image = UIImage(named: "Victory")
            
            buttonGo.hidden = true
            
            
            var result = MainController.defaults.integerForKey ("GamesWon")
            result += 1
            MainController.defaults.setInteger(result, forKey: "GamesWon")
            
            if(board.getTries() < 8){
                //print("under 8")
                
                var result = MainController.defaults.integerForKey("Under8")
                result += 1
                MainController.defaults.setInteger(result, forKey: "Under8")
                
            }
            

            
        }
            
        else if(board.isOver()){
            
            MainController.playSound("lose", ext: "mp3")
            
            let secretWord = board.getSecredWord()
            for c in 1...5{
                (grid[0][c]).text = String(secretWord[secretWord.startIndex.advancedBy(c-1)])
                    
                    //secretWord.characters.indexOf(secretWord.startIndex, offsetBy: c-1)]) //Reveal secret word
                (grid[0][c]).backgroundColor = UIColor.darkGrayColor()
                (grid[0][c]).textColor =  letterLoseColor
                (grid[0][c]).userInteractionEnabled = false
            }
            
            let guesses = board.getGuessedWords()
            // populate prior guesses
            for r in 0..<round{
                let word = guesses[round - r - 1]
                let chars = Array(word.characters)
                
                (grid[r+1][0]).hidden = false
                (grid[r+1][0]).text = "\(round-r )"
                
                for c in 0...4{
                    (grid[r+1][c+1]).text = String(chars[c])
                    (grid[r+1][c+1]).hidden = false
                    
                }
                (grid[r+1][6]).hidden = false
                let (np, nc) = board.findMatches(word)
                (grid[r+1][6]).text = "\(np)/\(nc)"
                
            }

            
            imageHeader.image = UIImage(named: "Defeat")
            
            buttonGo.hidden = true
            grid[0][0].text = "x"
            
            
            
        }
        else{
            if (round > 0){
                MainController.playSound("click", ext: "mp3")
            }
            
            // populate first row
            grid[0][0].text = "\(round + 1)"
            
            for c in 1...5 {
                grid[0][c].text = ""
            }
            
            for c in 1...6{ (grid[0][c]).backgroundColor = colorPlate[round]}
            
            // populate prior guesses
            for r in 0..<round{
                
                let word = guesses[round - r - 1]
                let chars = Array(word.characters)
                
                (grid[r+1][0]).hidden = false
                (grid[r+1][0]).text = "\(round-r )"
                
                
                for c in 0...4{
                    (grid[r+1][c+1]).text = String(chars[c])
                    (grid[r+1][c+1]).hidden = false
                    
                }
                
                
                (grid[r+1][6]).hidden = false
                let (np, nc) = board.findMatches(word)
                (grid[r+1][6]).text = "\(np)/\(nc)"
                
            }

            
        }
        grid[0][1].becomeFirstResponder()
        
      

    }
    
    
    // add a new word
    
    
    func addWord() {
        
        var word : String = ""
        
        for i in 1...5{
            
            var char = (grid[0][i]).text
            
            if (char == nil || char == ""){
                char =  " "
            }
            
            
            word += char!
        }
        _ = board.addWord(word)
        
        updateBoard()
 
        
    }
 
    func colorTiles( board: LMBoard){
        
        if (!board.isOver()){
            for r in 0...round{
                for c in 1...5{
                    //(grid[r+1][c]).layer.borderColor = colorPlate[r].CGColor
                    (grid[r][c]).backgroundColor = colorPlate[round - r]
                }
            }
        }
        else{
            
            for r in 0..<round{
                for c in 1...5{
                    if (board.isWon()){
                    (grid[r][c]).backgroundColor = colorPlate[round - r - 1]
                    }
                    else {
                        (grid[r+1][c]).backgroundColor = colorPlate[round - r - 1]
                    }
                }
            }
        }
    }
    
    // MARK: text events
    
    func handleBackspace(tag: Int){
        
        
        if ((grid[0][tag].text?.characters.count)! > 0){
            grid[0][tag].text = ""
        }
            
        if (tag > 0){
            (grid[0][tag-1]).becomeFirstResponder()
            
            (grid[0][tag-1]).selectedTextRange  = (grid[0][tag-1]).textRangeFromPosition((grid[0][tag-1]).beginningOfDocument, toPosition: (grid[0][tag-1]).beginningOfDocument)
                
                
                
            
        }
        
        
    }
    
    func editingDidEnd( textField: UITextField) {
        
        
        textField.resignFirstResponder()
        //return false;
    }
    
    
   
        
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) ->Bool {
        
        
        print("+\(string)+  \(string.characters.count)")
        
        if (string.characters.count > 0){
            textField.text = String(string.characters.first!)
        
        
            if (textField.tag < 5 && (grid[0][textField.tag].text?.characters.count)! > 0){
                (grid[0][textField.tag+1]).becomeFirstResponder()
            
                (grid[0][textField.tag+1]).selectedTextRange = (grid[0][textField.tag+1]).textRangeFromPosition( (grid[0][textField.tag+1]).beginningOfDocument, toPosition: (grid[0][textField.tag+1]).beginningOfDocument)
            
            
                //.setContentOffset(CGPointZero, animated: false)
            
            }
        } else {
            
            let wasEmpty = (textField.text?.characters.count == 0)
            
            textField.text = ""
            
            
            if (textField.tag > 0){
                (grid[0][textField.tag-1]).becomeFirstResponder()
                
                (grid[0][textField.tag-1]).selectedTextRange = (grid[0][textField.tag-1]).textRangeFromPosition((grid[0][textField.tag-1]).beginningOfDocument, toPosition: (grid[0][textField.tag-1]).beginningOfDocument)
                
                if (wasEmpty){
                    (grid[0][textField.tag-1]).text = ""
                }
                
                
            }
            
            
            
        }
        
        
        
        textField.resignFirstResponder()
        
        
        return false
    }
    
    /*
    func editingChange( textField: UITextField) {
        
        var text : String = textField.text!
        
        if (text.characters.count > 1){
            
            let char : Character = text.characters.last!
            text = String(char)
        }
        
        textField.text = text.uppercaseString
        
        if (textField.tag < 5 && (grid[0][textField.tag].text?.characters.count)! > 0){
            (grid[0][textField.tag+1]).becomeFirstResponder()
            
            (grid[0][textField.tag+1]).selectedTextRange = (grid[0][textField.tag+1]).textRangeFromPosition( (grid[0][textField.tag+1]).beginningOfDocument, toPosition: (grid[0][textField.tag+1]).beginningOfDocument)

                
                //.setContentOffset(CGPointZero, animated: false)

        }
        
        textField.resignFirstResponder()
        
    }
 */
 
    
    func buttonPressed( sender: UIButton){
        addWord()
    }
    
    
    // MARK : control actions

    
    func startButtonPressed( sender: UIBarButtonItem) {
        
        MainController.playSound("click", ext: "mp3")
        resetBoard()
        
    }
    
    func optionButtonPressed( sender: UIBarButtonItem){
        
        MainController.playSound("click", ext: "mp3")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier( "OptionsViewController")
        
        
        //let optionsVC = OptionsViewController
        //instantiateFromStoryboard(self.storyboard!)
        
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    
    func helpButtonPressed( sender: UIBarButtonItem){
        
        MainController.playSound("click", ext: "mp3")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HelpViewController")
        
        
        //let optionsVC = OptionsViewController
        //instantiateFromStoryboard(self.storyboard!)
        
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: cosmetics
    

    
    static func playSound( name : String, ext : String) {
        
        
        if (defaults.boolForKey("SilentMode")){
            return
        }
        
        
        let url = NSBundle.mainBundle().URLForResource( name, withExtension: ext)!
        
        do {
            player = try AVAudioPlayer(contentsOfURL: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print("sound error : \(error.description)")
        }
    }
    
    
    
    

}

