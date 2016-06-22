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
    
    private var imagesWithText = [UIImage: String]()
    
    init(imagesWithText: [UIImage:String]) {
        self.imagesWithText = imagesWithText
        for key in imagesWithText.keys {
            images.append(key)
        }
        for value in imagesWithText.values {
            texts.append(value)
        }
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
    
    
    private var animals = ["zebra", "elephant", "chicken", "cow", "wolf", "deer", "giraffe", "rhino", "lion", "dog", "beaver", "cat"]
    
    private var animalImagesWithLabel = [UIImage: String]()
    private var sectionDatas = [String: SectionData]()

    
    init() {
        for i in 1...12 {
            let image = UIImage(named: "animal image - \(i)")
            animalImagesWithLabel[image!] = animals[i-1]
        }
        sectionDatas["Animals"] = SectionData(imagesWithText: animalImagesWithLabel)
    }
    
    func getSectionDataWithKey(key: String) -> SectionData? {
        if let sectionData = sectionDatas[key] {
            return sectionData
        } else {
            return nil
        }
    }
    
    
    
}
