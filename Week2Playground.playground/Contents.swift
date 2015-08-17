//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

func countNumberOfWordsInSentence(sentence: String) -> Int {
  var spaceCounter = 0
  
  for character in sentence {
    if character == " " {
      spaceCounter++
    }
  }
  
  var numberOfWords = spaceCounter + 1
  println("There are \(numberOfWords) words in this sentence.")
  return numberOfWords
}

countNumberOfWordsInSentence("I like to drink milk, it makes my bones strong")
