//
//  LMBoard.swift
//  Letterman
//
//  Created by Tatyana kudryavtseva on 16/07/16.
//  Copyright © 2016 Alex Zabrodskiy. All rights reserved.
//

import Foundation


class LMBoard {
    
    let defaults = UserDefaults.standard
    
    private var secretWord : String = ""
    private var guessedWords : [String] = []
    private var tries : Int = 0
    private var matchFound : Bool = false
    private var allSecretWords: [String] = []
    private var totalTries = 10
    
    private var wordDifficulty : Int
    
    
   
    
    required init?()
        
    {
        wordDifficulty = defaults.integer(forKey: "WordDifficulty")
        
        loadSecretWords()
        
        //print (allSecretWords.count)
        
        checkWords()
        
        resetGame()
    
    
    }
    
  
    func checkWords(){
        /*
        for word in allSecretWords{
        
            var chars = Array(word.characters)
            var count = chars.count
            
            count -= 1
            
            chars = chars.sort()
            
            
            
            for i in 0..<count {
                if (chars[i] == chars[i+1]) {
                    print ("Bad word: \(word)")
                }
                
            }
        }
        */
        
    }
    
    
    
    

    func resetGame() {
    
        // choose secredWord
        chooseSecretWord()
        
        // reset guessedWords
        guessedWords.removeAll()
        
        // update tries
        tries = 0
        matchFound = false
        
        
        
    }
    
    func chooseSecretWord() {
        
        
        let currentWordDifficulty = defaults.integer(forKey: "WordDifficulty")
        
        if (currentWordDifficulty != wordDifficulty){
            
            wordDifficulty = currentWordDifficulty
            loadSecretWords()
            
        }
        
        
    
        //srand(UInt32(time(nil)))
        
        
        
        let random = Int(arc4random_uniform(UInt32(allSecretWords.count)))
    
        
        secretWord = allSecretWords[random]
        
    
    }
    
    
    func addWord(word : String) -> (Int, Int){
        
        guessedWords += [word]
        tries += 1
        
        let (mp, mc) = findMatches(word: word)
        
        if (mp == 5 && mc == 5){
            matchFound = true
        }
        
        return (mp, mc)
        
        
    }
    
    
    
    func findMatches(word : String) -> (Int, Int)
    
    {
    
        let wordCharacters = Array(word)
        
        let secretCharacters = Array (secretWord)
        
        
        var mc : Int = 0
        var mp : Int = 0
        
        for i in 0...4{
            
            for j in 0...4{
                
                if (wordCharacters[i]==secretCharacters[j]){
                    mc+=1
                    if (i == j){
                        mp+=1
                    }
                }
            }
        }
        
        return (mp,mc)
    }
    

    func isWon() ->  Bool {return matchFound}
    
    func isOver() -> Bool {return matchFound || tries >= totalTries}
    
    func getGuessedWords() -> [String]{
        return guessedWords
    }
    
    func getSecredWord() -> String {
        return secretWord
    }
    
    func getTotalTries() -> Int {
        return totalTries
    }
    
    func setTotalTries(total : Int){
        totalTries = total
    }
  
    
    func getTries() -> Int{
        
        //print("tries: \(guessedWords.count)")
        
        return guessedWords.count
        
        
    }
    
    
    func loadSecretWords() {
    
        var fileLocation : String
        
        if (defaults.integer(forKey: "WordDifficulty") == 0) { // normal
            fileLocation = Bundle.main.path( forResource: "words", ofType: "txt")!
        }
        else { // hard
            fileLocation = Bundle.main.path( forResource: "hard", ofType: "txt")!
        }
        let text : String
    
    
        do{
            text = try String(contentsOfFile: fileLocation)
        }
        catch{
            text = ""
            return
        }
    
    
    
        allSecretWords = text.components(separatedBy: "\n")
    
        return
    
    
    }
    
    
}
