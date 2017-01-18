//
//  Collection.swift
//  Matching App
//
//  Created by Naman Kedia on 6/13/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import Foundation
import UIKit



class SectionData {
    
    private var texts = [String]()
    private var randomizedTexts = [String]()
    private var images = [UIImage]()
    private var randomizedImages = [UIImage]()
    var title: String?
    var backgroundImage: UIImage?
    var lightBlurredBackgroundImage: UIImage?
    var darkBlurredBackgroundImage: UIImage?
    
    var topScore: Int? {
        set {
            let defaults = UserDefaults.standard
            defaults.set(topScore, forKey: title!)
        }
        get {
            let defaults = UserDefaults.standard
            return defaults.integer(forKey: title!)
        }
    }

    private var imagesWithText = [String: UIImage]()
    
    init(imagesWithText: [String:UIImage], key: String) {
        self.imagesWithText = imagesWithText
        for value in imagesWithText.values {
            images.append(value)
        }
        randomizedImages = images.shuffled()
        for key in imagesWithText.keys {
            texts.append(key)
        }
        randomizedTexts = texts.shuffled()
        title = key
        backgroundImage = UIImage(named: "\(key) - bg")
        lightBlurredBackgroundImage = UIImage(named: "\(key) - bgLightBlur")
        darkBlurredBackgroundImage = UIImage(named: "\(key) - bgDarkBlur")
    }
    
    func match(image: UIImage, text: String) -> Bool {
        if imagesWithText[text] == image {
            return true
        } else {
            return false
        }
    }
    
    func numberOfAssets() -> Int {
        return texts.count
    }
    
    func imageAtIndex(index: Int) -> UIImage {
        return images[index]
    }
    
    func textAtIndex(index: Int) -> String {
        return texts[index]
    }
    
    func randomImageAtIndex(index: Int) -> UIImage {
        return randomizedImages[index]
    }
    
    func randomTextAtIndex(index: Int) -> String {
        return randomizedTexts[index]
    }
}

class Collection {
    
    var keys = ["Animals", "Vegetables", "Fruits", "Solar System", "Shapes", "Flowers", "Colors", "Transportation"]
    
    private var wordsForKeys = ["Animals": texts().animals, "Vegetables" : texts().vegetables, "Fruits": texts().fruits, "Solar System": texts().solarSystem, "Shapes": texts().shapes, "Colors": texts().colors, "Flowers" : texts().flowers, "Transportation" : texts().transportation]
    
    private var sectionDatas = [SectionData]()
    
    init() {
        
        for key in keys {
            var imagesWithLabel = [String: UIImage]()
            for i in 1...12 {
                let image = UIImage(named: "\(key) image - \(i)")
                imagesWithLabel[wordsForKeys[key]![i-1]] = image!
            }
            sectionDatas.append(SectionData(imagesWithText: imagesWithLabel, key: key))
        }
    }
    
        func numberOfSectionDatas() -> Int {
        return sectionDatas.count
    }
    
    func sectionDataAtIndex(index: Int) -> SectionData {
        return sectionDatas[index]
    }
}

    private struct texts {
        var animals = ["zebra", "elephant", "chicken", "cow", "wolf", "deer", "giraffe", "rhino", "lion", "dog", "beaver", "cat"]
        var vegetables = ["cabbage","potato", "cauliflower", "carrot", "onions", "tomato", "chilli", "okra", "corn", "eggplant", "cucumber", "brocolli"]
        var fruits = ["apple", "banana", "orange", "grape", "strawberry", "watermelon", "pineapple", "cherry", "pomogrenate", "pear", "lychee", "mango"]
        var solarSystem = ["Sun", "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto", "Moon", "Milky Way"]
        var shapes = ["circle", "square", "triangle", "rectangle", "oval", "diamond", "pentagon", "hexagon", "octagon", "star", "heart", "arrow"]
        var colors = ["red", "orange", "yellow", "green", "blue", "gray", "violet", "purple", "pink", "brown", "white", "black"]
        var flowers = ["Sunflower", "Tulip", "Hibiscus", "Daisy", "Rose", "Lily", "Daffodil", "Orchid", "Iris", "Lotus", "Jasmine", "Marigold"]
        var transportation = ["airplane", "helicopter", "rocket", "train", "bicycle", "motorcycle", "bus", "car", "ship", "crane", "boat", "truck"]
    }
    
    

extension Array {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
    
    /// Return a copy of `self` with its elements shuffled
    func shuffled() -> [Element] {
        var list = self
        list.shuffle()
        return list
    }
}
    
    
    
