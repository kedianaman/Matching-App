//
//  GamePlayViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 6/14/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var collection = Collection()
    var sectionData: SectionData!
    var timer = Timer()
    var score = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    var matched = 0
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var textCollectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
 
    var selectedImageCell: ImageCollectionViewCell?
    var selectedTextCell: TextCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        sectionData = collection.sectionDataAtIndex(index: 0)
        backgroundImageView.image = sectionData.backgroundImage
        titleLabel.text = sectionData.title
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GamePlayViewController.updateCounter), userInfo: nil, repeats: true)
 
    }
    
    
    //MARK: Helper Methods 
    
    func updateCounter() {
        if score >= 1 {
            score = score - 1
        }
    }
    
    func endGame() {
        timer.invalidate()
        performSegue(withIdentifier: "EndGameIdentifier", sender: self)
        
    }
    

    
    //MARK: Collection View Delegate Methopds

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionData.numberOfAssets()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCollectionView {
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
            imageCell.contentImageView.image = sectionData.imageAtIndex(index: indexPath.row)
            imageCell.layer.cornerRadius = 20
            return imageCell
        } else if collectionView == textCollectionView {
            let textCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! TextCollectionViewCell
            textCell.nameLabel.text = sectionData.textAtIndex(index: indexPath.row)
            textCell.backgroundImage.image = sectionData.backgroundImage
            textCell.layer.cornerRadius = 20
            return textCell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Selected")
        if collectionView == imageCollectionView {
            if let oldselectedImageCell = selectedImageCell {
                oldselectedImageCell.setHighlighted(selected: false)
            }
            selectedImageCell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
            selectedImageCell?.setHighlighted(selected: true)
        } else if collectionView == textCollectionView {
            if let oldselectedTextCell = selectedTextCell {
                oldselectedTextCell.setHighlighted(selected: false)
            }
            selectedTextCell = collectionView.cellForItem(at: indexPath) as! TextCollectionViewCell
            selectedTextCell?.setHighlighted(selected: true)
        }
        
        // check to see if they match if both are non-nil 
        if selectedTextCell != nil && selectedImageCell != nil {
            let image = selectedImageCell?.contentImageView.image
            let text = selectedTextCell?.nameLabel.text
            let match = sectionData.match(image: image!, text: text!)
            if match == true {
                score = score + 20
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
                if score >= 10 {
                    score = score - 10
                } else {
                    score = 0
                }
                selectedImageCell?.setHighlighted(selected: false)
                selectedImageCell?.shake()
                selectedImageCell = nil
                selectedTextCell?.setHighlighted(selected: false)
                selectedTextCell?.incorrectShake()
                selectedTextCell = nil
            }
        }
        
        
    }
    
    @IBAction func resetGame(segue:UIStoryboardSegue) {
        print("Unwinded")
        score = 0
        matched = 0
        imageCollectionView.reloadData()
        textCollectionView.reloadData()
    }
    
 
    


}
