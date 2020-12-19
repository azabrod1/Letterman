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
    
    static let defaults = UserDefaults.standard
    
    let letterNormalColor =  UIColor(red: 12.0/255, green: 118.0/255, blue: 240.0/255, alpha: 1.0)
    let letterWinColor = UIColor.white
    let letterLoseColor = UIColor.white
    let numberColor = UIColor.white
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
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}
    
    override var prefersStatusBarHidden: Bool {get {return true}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createBoard()
        resetBoard()
        updateBoard()

        //toolBar.tintColor = UIColor.blue.withAlphaComponent(0.3)
        //create buttons for toolbar
        let startBarButton = UIBarButtonItem(image: UIImage(named: "play.png"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(startButtonPressed))
        
        let optionBarButton = UIBarButtonItem(image: UIImage(named: "options.png"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(optionButtonPressed))
        
        let helpBarButton = UIBarButtonItem(image: UIImage(named: "help.png"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(helpButtonPressed))
        
        let horizontalSeparator: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // don't understand why setting image does not work in above
        startBarButton.setBackgroundImage(UIImage(named: "play.png"), for: UIControl.State.normal, barMetrics: UIBarMetrics.default)
        optionBarButton.setBackgroundImage(UIImage(named: "options.png"), for: UIControl.State.normal, barMetrics: UIBarMetrics.default)
        helpBarButton.setBackgroundImage(UIImage(named: "help.png"), for: UIControl.State.normal, barMetrics: UIBarMetrics.default)
            
        let barButtons = [startBarButton, horizontalSeparator,
                          helpBarButton, optionBarButton]
       /*
        let playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        ///let barSeperator = UIBarButtonItem.
        let optionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        
        let helpButton = UIButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        
        let horizontalSeperator: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        //set images for buttons
        playButton.setImage(UIImage(named: "play.png"), for: UIControl.State.normal)
        
        helpButton.setImage(UIImage(named: "help.png"), for: UIControl.State.normal)
        
        optionButton.setImage(UIImage(named: "options.png"), for: UIControl.State.normal)
        
        //set frame
        
        let barButtons = [UIBarButtonItem(customView: playButton), horizontalSeperator, UIBarButtonItem(customView: optionButton),  UIBarButtonItem(customView: helpButton)]

        //Add actions to toolbar buttons
        
        playButton.addTarget(self, action: #selector(startButtonPressed), for: UIControl.Event.touchDown)
        optionButton.addTarget(self, action: #selector(optionButtonPressed), for: UIControl.Event.touchDown)
        helpButton.addTarget(self, action: #selector(helpButtonPressed), for: UIControl.Event.touchDown)
        */
        //self.toolbarItems = barButtons
        
        toolBar.items = barButtons
        
 
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        
        
        frameHeight -= imageHeader.frame.maxY//imageHeader.frame.height
        frameHeight -= toolBar.frame.height
        
        if (frameWidth > frameHeight){
            swap(&frameHeight, &frameWidth)
            //let temp = frameWidth
            //frameWidth = frameHeight
            //frameHeight = temp
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
                    
                    char.borderStyle = UITextField.BorderStyle.none
                    char.backgroundColor = UIColor.clear
                    char.textColor = numberColor
                    char.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
                    char.textAlignment = .justified
                    char.isUserInteractionEnabled = false

                }
                else if (c == 6){
                    
                    char.borderStyle = UITextField.BorderStyle.none
                    char.backgroundColor = UIColor.clear
                    char.textColor = numberColor
                    char.font = UIFont(name: "Optima-ExtraBlack", size: 18)
                    char.textAlignment = .left
                    char.isUserInteractionEnabled = false
                }
                    
                else {
                    
                    char.borderStyle = UITextField.BorderStyle.roundedRect
                    char.backgroundColor = colorPlate[0]
                    char.textColor = letterNormalColor
                    char.layer.borderColor = colorPlate[0].cgColor
                    
                    char.font = UIFont(name: "Optima-ExtraBlack", size: 18)
                    
                    char.layer.cornerRadius = 0.35 * char.bounds.size.width
                    char.textAlignment = .center
                    char.isUserInteractionEnabled = (r == 0) // enable editing for the 0 row
                }
                
                
                char.adjustsFontSizeToFitWidth = true
                char.minimumFontSize = 18 //___ 8
                //char.autocapitalizationType = .AllCharacters
                char.autocorrectionType = .no

                char.textAlignment = .center
                char.autocapitalizationType = UITextAutocapitalizationType.allCharacters
                
                word += [char]
                self.view.addSubview(char)
                
                char.delegate = self
                //char.addTarget(self, action: #selector(editingChange(_:)), for: UIControlEvents.editingChanged)
            }
            grid += [word]
        }
        
        // permanenty hide the counter for the first row
        grid[0][6].isHidden = true
        // create a button instead
        
        let x = grid[0][6].frame.minX + xDistance  //xStart + 6 * (textSize + xDistance)
        let y = grid[0][6].frame.minY // yStart + 0 * (textSize + yDistance)
        
        buttonGo = UIButton (frame: CGRect(x: x, y: y, width: textSize, height: textSize))
        
        buttonGo.setTitle("Go", for: UIControl.State.normal)
        buttonGo.backgroundColor = UIColor.red
        buttonGo.setTitleColor(UIColor.white, for: UIControl.State.normal)
        buttonGo.layer.cornerRadius = 0.5 * buttonGo.bounds.size.width
        buttonGo.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        //buttonGo font = UIFont(name: "Optima-ExtraBlack", size: 18)!
        self.view.addSubview(buttonGo)
        
        // tag the first row (for firstresponder pass)
        for c in 1...5{
            (grid[0][c]).tag = c
        }
        // make sure elements are visible
        
        self.view.bringSubviewToFront(imageHeader)
        self.view.bringSubviewToFront(toolBar)
    }
    
    // this function is executed at the beginning of each game
    
    func resetBoard(){
        
        board.resetGame()
        
        //labelStatus.backgroundColor = UIColor(patternImage: UIImage(named: "Logo.png")!)
        //labelStatus.text = "Letterman: Let's Play!"
        
        imageHeader.image = UIImage(named: "Logo")
        
        //print(imageHeader.image)
        
        grid[0][0].isHidden = false
        grid[0][0].text = "1"
        buttonGo.isHidden = false
        buttonGo.isEnabled = true
        
        
        // set the first row
        for i in 1...5{
            (grid[0][i]).isUserInteractionEnabled = true
            (grid[0][i]).text = ""
            (grid[0][i]).textColor = letterNormalColor
            (grid[0][i]).backgroundColor = colorPlate[0]
        }
        
        // hide all the rows except first
        for r in 1...board.getTotalTries(){
            for c in 0...6{
                (grid[r][c]).isHidden = true
            }
        }
        
        grid[0][1].becomeFirstResponder()
    }
    
    
    
    
    // this function is executed every time the game status changes
    
    func updateBoard(){
        
        let guesses = board.getGuessedWords()
        round = guesses.count
        colorTiles(board: board)

        
        if(board.isWon()) {
            
            let secretWord = board.getSecredWord()
            
            MainController.playSound(name: "win", ext: "mp3")
            
            for c in 1...5{
                (grid[0][c]).text = String(secretWord[secretWord.index(secretWord
                                    .startIndex, offsetBy: c-1)])
                                                      
                                                      //startIndex.advancedBy(c-1)])
                    
                    //[secretWord.characters.indexOf(secretWord.startIndex, offsetBy: c-1)]) //Reveal secret word
                
                (grid[0][c]).backgroundColor = UIColor.blue
                (grid[0][c]).textColor =  letterWinColor
                (grid[0][c]).isUserInteractionEnabled = false
            }

            imageHeader.image = UIImage(named: "Victory")
            
            buttonGo.isHidden = true
            
            
            var result = MainController.defaults.integer (forKey: "GamesWon")
            result += 1
            MainController.defaults.set(result, forKey: "GamesWon")
            
            if(board.getTries() < 8){
                //print("under 8")
                
                var result = MainController.defaults.integer(forKey: "Under8")
                result += 1
                MainController.defaults.set(result, forKey: "Under8")
                
            }
            

            
        }
            
        else if(board.isOver()){
            
            MainController.playSound(name: "lose", ext: "mp3")
            
            let secretWord = board.getSecredWord()
            for c in 1...5{
                (grid[0][c]).text = String(secretWord[secretWord.index(secretWord.startIndex, offsetBy: c-1)])
                                                        
                                                        //.startIndex.advancedBy(c-1)])
                    
                    //secretWord.characters.indexOf(secretWord.startIndex, offsetBy: c-1)]) //Reveal secret word
                (grid[0][c]).backgroundColor = UIColor.darkGray
                (grid[0][c]).textColor =  letterLoseColor
                (grid[0][c]).isUserInteractionEnabled = false
            }
            
            let guesses = board.getGuessedWords()
            // populate prior guesses
            for r in 0..<round{
                let word = guesses[round - r - 1]
                let chars = Array(word)
                
                (grid[r+1][0]).isHidden = false
                (grid[r+1][0]).text = "\(round-r )"
                
                for c in 0...4{
                    (grid[r+1][c+1]).text = String(chars[c])
                    (grid[r+1][c+1]).isHidden = false
                    
                }
                (grid[r+1][6]).isHidden = false
                let (np, nc) = board.findMatches(word: word)
                (grid[r+1][6]).text = "\(np)/\(nc)"
                
            }

            
            imageHeader.image = UIImage(named: "Defeat")
            
            buttonGo.isHidden = true
            grid[0][0].text = "x"
            
            
            
        }
        else{
            if (round > 0){
                MainController.playSound(name: "click", ext: "mp3")
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
                let chars = Array(word)
                
                (grid[r+1][0]).isHidden = false
                (grid[r+1][0]).text = "\(round-r )"
                
                
                for c in 0...4{
                    (grid[r+1][c+1]).text = String(chars[c])
                    (grid[r+1][c+1]).isHidden = false
                    
                }
                
                
                (grid[r+1][6]).isHidden = false
                let (np, nc) = board.findMatches(word: word)
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
        _ = board.addWord(word: word)
        
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
        
        
        if ((grid[0][tag].text?.count)! > 0){
            grid[0][tag].text = ""
        }
            
        if (tag > 0){
            (grid[0][tag-1]).becomeFirstResponder()
            
            (grid[0][tag-1]).selectedTextRange  = (grid[0][tag-1]).textRange(from:(grid[0][tag-1]).beginningOfDocument,
                                        to: (grid[0][tag-1]).beginningOfDocument)
                
                
                
            
        }
        
        
    }
    
    func editingDidEnd( textField: UITextField) {
        
        
        textField.resignFirstResponder()
        //return false;
    }
    
    
   
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) ->Bool {
        
        
        print("+\(string)+  \(string.count)")
        
        if (string.count > 0){
            
            textField.text = String(string.first!)
        
        
            if (textField.tag < 5 && (grid[0][textField.tag].text?.count)! > 0){
                (grid[0][textField.tag+1]).becomeFirstResponder()
            
                (grid[0][textField.tag+1]).selectedTextRange = (grid[0][textField.tag+1]).textRange(from: (grid[0][textField.tag+1]).beginningOfDocument, to: (grid[0][textField.tag+1]).beginningOfDocument)
            
            
                //.setContentOffset(CGPointZero, animated: false)
            
            }
        } else {
            
            let wasEmpty = (textField.text?.count == 0)
            
            textField.text = ""
            
            
            if (textField.tag > 0){
                (grid[0][textField.tag-1]).becomeFirstResponder()
                
                (grid[0][textField.tag-1]).selectedTextRange = (grid[0][textField.tag-1]).textRange(from:(grid[0][textField.tag-1]).beginningOfDocument, to: (grid[0][textField.tag-1]).beginningOfDocument)
                
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
 
    
    @objc func buttonPressed( sender: UIButton){
        addWord()
    }
    
    
    // MARK : control actions

    
    @objc func startButtonPressed(_ sender: UIBarButtonItem) {
        MainController.playSound(name: "click", ext: "mp3")
        resetBoard()
    }
    
    @objc func optionButtonPressed(_ sender: UIBarButtonItem){
        MainController.playSound(name: "click", ext: "mp3")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController( withIdentifier: "OptionsViewController")
        
        //let optionsVC = OptionsViewController
        //instantiateFromStoryboard(self.storyboard!)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func helpButtonPressed(_ sender: UIBarButtonItem){
        
        MainController.playSound(name: "click", ext: "mp3")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HelpViewController")
        
        
        //let optionsVC = OptionsViewController
        //instantiateFromStoryboard(self.storyboard!)
        
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: cosmetics
    

    
    static func playSound( name : String, ext : String) {
        
        
        if (defaults.bool(forKey: "SilentMode")){
            return
        }
        
        
        let url :URL = Bundle.main.url(forResource: name, withExtension:ext)!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print("sound error : \(error.description)")
        }
    }
    
    
    
    

}

