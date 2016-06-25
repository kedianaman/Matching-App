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
    
    var backgroundImage: UIImage?
}

class Collection {
    
    var keys = ["Animals"]
    
    private var animalImagesWithLabel = [UIImage: String]()
    private var wordsForKeys = ["Animals": ["zebra", "elephant", "chicken", "cow", "wolf", "deer", "giraffe", "rhino", "lion", "dog", "beaver", "cat"]]
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
    
//    func getSectionDataWithKey(key: String) -> SectionData? {
//        if let sectionData = sectionDatas[key] {
//            return sectionData
//        } else {
//            return nil
//        }
//    }
//    
    func numberOfSectionDatas() -> Int {
        return sectionDatas.count
    }
    
    func sectionDataAtIndex(index: Int) -> SectionData {
        return sectionDatas[index]
    }
    
    
}


