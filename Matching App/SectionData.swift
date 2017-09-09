//
//  SectionData.swift
//  Matching App
//
//  Created by Naman Kedia on 3/16/17.
//  Copyright © 2017 Naman Kedia. All rights reserved.
//

import Foundation
import UIKit

// Complete data class for simple section including texts, images, and a background image.
class SectionData {
    
    private var texts = [String]()
    private var randomizedTexts = [String]()
    private var images = [UIImage]()
    private var randomizedImages = [UIImage]()
    private var matchedImage = [UIImage: Bool]()
    var title: String?
    var backgroundImage: UIImage?
    var lightBlurredBackgroundImage: UIImage?
    var darkBlurredBackgroundImage: UIImage?
    
    // Highest score for section, stored in User Defaults.
    var topScore: Int? {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: title!)
        }
        get {
            let defaults = UserDefaults.standard
            return defaults.value(forKey: title!) as? Int
        }
    }
    
    private var imagesWithText = [String: UIImage]()
    
    init(imagesWithText: [String:UIImage], sectionTitle: String) {
        self.imagesWithText = imagesWithText
        for value in imagesWithText.values {
            images.append(value)
            
        }
        for key in imagesWithText.keys {
            texts.append(key)
        }
        randomizedImages = images.shuffled()
        randomizedTexts = texts.shuffled()
        title = sectionTitle
        backgroundImage = UIImage(named: "\(sectionTitle) - bg")
        lightBlurredBackgroundImage = UIImage(named: "\(sectionTitle) - bgLightBlur")
        darkBlurredBackgroundImage = UIImage(named: "\(sectionTitle) - bgDarkBlur")
    }
    // function which takes in a text and image and decides whether the match is correct.
    func match(image: UIImage, text: String) -> Bool {
        if imagesWithText[text] == image {
            // make image true
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

// Function for randomizing array
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
