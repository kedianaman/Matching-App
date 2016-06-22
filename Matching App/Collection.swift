//
//  Collection.swift
//  Matching App
//
//  Created by Naman Kedia on 6/13/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import Foundation
import UIKit

class Collection {
    
    
    var animals = ["zebra", "elephant", "chicken", "cow", "wolf", "deer", "giraffe", "rhino", "lion", "dog", "beaver", "cat"]
    
    var imagesWithLabel = [UIImage: String]()
    
    init() {
        for i in 1...12 {
            let image = UIImage(named: "animal image - \(i)")
            imagesWithLabel[image!] = animals[i-1]
        }
    }
    
    func match(_ image: UIImage, name: String) -> Bool {
        if imagesWithLabel[image] == name {
            return true
        } else {
            return false
        }
    }
    
    func getImages() -> [UIImage] {
        var images = [UIImage]()
        for key in imagesWithLabel.keys {
            images.append(key)
        }
        return images
    }
    
    func getNames() -> [String] {
        return animals
    }
    
    
}
