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
    private var images = [UIImage]()
    var title: String?
    var backgroundImage: UIImage?
    
    var topScore: Int? {
        set {
            UserDefaults.standard().set(topScore, forKey: title!)
        }
        get {
            
            return UserDefaults.standard().integer(forKey: title!)
        }
    }

    private var imagesWithText = [UIImage: String]()
    
    init(imagesWithText: [UIImage:String], key: String) {
        self.imagesWithText = imagesWithText
        for key in imagesWithText.keys {
            images.append(key)
        }
        for value in imagesWithText.values {
            texts.append(value)
        }
        title = key
        backgroundImage = UIImage(named: "\(key) - bg")
    }
    
    func match(image: UIImage, text: String) -> Bool {
        if imagesWithText[image] == text {
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
}

class Collection {
    
    var keys = ["Animals", "Vegetables", "Fruits", "Solar System"]
    
    
    private var animalImagesWithLabel = [UIImage: String]()
    
    private var wordsForKeys = ["Animals": ["zebra", "elephant", "chicken", "cow", "wolf", "deer", "giraffe", "rhino", "lion", "dog", "beaver", "cat"], "Vegetables" :["cabbage","potato", "cauliflower", "carrot", "onions", "tomato", "chilli", "okra", "corn", "eggplant", "cucumber", "brocolli"], "Fruits":["apple", "banana", "orange", "grape", "strawberry", "watermelon", "pineapple", "cherry", "pomogrenate", "pear", "lychee", "mango"], "Solar System": ["Sun", "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto", "Moon", "Milky Way"]]
    
    private var sectionDatas = [SectionData]()
    
    init() {
        
        for key in keys {
            var imagesWithLabel = [UIImage: String]()
            for i in 1...12 {
                let image = UIImage(named: "\(key) image - \(i)")
                imagesWithLabel[image!] = wordsForKeys[key]![i-1]
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




