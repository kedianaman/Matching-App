//
//  GamePlayTVViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 6/27/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class GamePlayTVViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collection = Collection()
    var sectionData: SectionData!
    var timer = Timer()
    var score = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    var matched = 0


    @IBOutlet var textCollectionView: UICollectionView!
    @IBOutlet var imageCollectionView: UICollectionView!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    
    var selectedImageCell: ImageTVCollectionViewCell?
    var selectedTextCell: TextTVCollectionViewCell?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = sectionData.backgroundImage
        titleLabel.text = sectionData.title
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    //MARK: Helper Methods
    
    func updateCounter() {
        score = score + 1
    }
    
    func endGame() {
        timer.invalidate()
//        performSegue(withIdentifier: "EndGameIdentifier", sender: self)
        
    }
    
    //MARK: Collection View Delegate Methopds

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionData.numberOfAssets()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCollectionView {
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageTVCollectionViewCell
            imageCell.contentImageView.image = sectionData.randomImageAtIndex(index: indexPath.row)
            imageCell.contentImageView.adjustsImageWhenAncestorFocused = true
            imageCell.layer.cornerRadius = 100
            return imageCell
        } else if collectionView == textCollectionView {
            let textCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! TextTVCollectionViewCell
            textCell.nameLabel.text = sectionData.randomTextAtIndex(index: indexPath.row)
            textCell.backgroundImage.adjustsImageWhenAncestorFocused = true
            textCell.backgroundImage.image = sectionData.backgroundImage
            textCell.layer.cornerRadius = 100
            return textCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        if collectionView == imageCollectionView {
            if let oldselectedImageCell = selectedImageCell {
                oldselectedImageCell.setHighlighted(selected: false)
            }
            selectedImageCell = collectionView.cellForItem(at: indexPath) as! ImageTVCollectionViewCell
            selectedImageCell?.setHighlighted(selected: true)
        } else if collectionView == textCollectionView {
            if let oldselectedTextCell = selectedTextCell {
                oldselectedTextCell.setHighlighted(selected: false)
            }
            selectedTextCell = collectionView.cellForItem(at: indexPath) as! TextTVCollectionViewCell
            selectedTextCell?.setHighlighted(selected: true)
        }
        
        // check to see if they match only if both are non-nil
        if selectedTextCell != nil && selectedImageCell != nil {
            let image = selectedImageCell?.contentImageView.image
            let text = selectedTextCell?.nameLabel.text
            let match = sectionData.match(image: image!, text: text!)
            if match == true {
                selectedTextCell?.setMatched()
                selectedTextCell = nil
                selectedImageCell?.setMatched()
                selectedImageCell?.contentImageView.image = sectionData.backgroundImage
                selectedImageCell = nil
                matched = matched + 1
                if matched == sectionData.numberOfAssets() {
                    endGame()
                }
                
            } else {
                selectedImageCell?.setHighlighted(selected: false)
                selectedImageCell?.shake()
                selectedImageCell = nil
                selectedTextCell?.setHighlighted(selected: false)
                selectedTextCell?.incorrectShake()
                selectedTextCell = nil
            }
        }

    }
    
    
    

   
}
