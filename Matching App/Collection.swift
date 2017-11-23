//
//  Collection.swift
//  Matching App
//
//  Created by Naman Kedia on 6/13/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import Foundation
import UIKit

//complete Collection with section datas for each different section
class Collection {
    
    var sectionTitles = ["Animals", "Vegetables", "Fruits", "Solar System", "Shapes", "Flowers", "Colors", "Transport"]
    
    private var wordsForKeys = ["Animals": texts().animals, "Vegetables" : texts().vegetables, "Fruits": texts().fruits, "Solar System": texts().solarSystem, "Shapes": texts().shapes, "Colors": texts().colors, "Flowers" : texts().flowers, "Transport" : texts().transportation]
    
    private var sectionDatas = [SectionData]()
    
    // initialization of Collection. Adds all the different section Datas
    init() {
        
        for sectionTitle in sectionTitles {
            var imagesWithLabel = [String: UIImage]()
            for i in 1...12 {
                let image = UIImage(named: "\(sectionTitle) image - \(i)")
                imagesWithLabel[wordsForKeys[sectionTitle]![i-1]] = image!
            }
            sectionDatas.append(SectionData(imagesWithText: imagesWithLabel, sectionTitle: sectionTitle))
        }
    }
    
    func numberOfSectionDatas() -> Int {
        return sectionDatas.count
    }
    
    func sectionDataAtIndex(index: Int) -> SectionData {
        return sectionDatas[index]
    }
}

// arrays which hold texts from different categories
    private struct texts {
        var animals = ["zebra", "elephant", "chicken", "cow", "wolf", "deer", "giraffe", "rhino", "lion", "dog", "beaver", "cat"]
        var vegetables = ["cabbage","potato", "cauliflower", "carrot", "onions", "tomato", "chilli", "okra", "corn", "eggplant", "cucumber", "brocolli"]
        var fruits = ["apple", "banana", "orange", "grape", "strawberry", "watermelon", "pineapple", "cherry", "pomogranate", "pear", "lychee", "mango"]
        var solarSystem = ["Sun", "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto", "Moon", "Milky Way"]
        var shapes = ["circle", "square", "triangle", "rectangle", "oval", "diamond", "pentagon", "hexagon", "octagon", "star", "heart", "arrow"]
        var colors = ["red", "orange", "yellow", "green", "blue", "gray", "violet", "purple", "pink", "brown", "white", "black"]
        var flowers = ["Sunflower", "Tulip", "Hibiscus", "Daisy", "Rose", "Lily", "Daffodil", "Orchid", "Iris", "Lotus", "Jasmine", "Marigold"]
        var transportation = ["airplane", "helicopter", "rocket", "train", "bicycle", "motorcycle", "bus", "car", "ship", "crane", "boat", "truck"]
    }
    
    
    
