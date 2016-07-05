//
//  GamePlayViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 6/14/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit
import AVFoundation

class GamePlayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionViewStackView: UIStackView!
    var collection = Collection()
    var sectionData: SectionData!
    var correctSound = NSURL(fileURLWithPath: Bundle.main().pathForResource("CorrectSound", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
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
        backgroundImageView.image = sectionData.lightBlurredBackgroundImage
        titleLabel.text = sectionData.title
        addParalax()
        do{
            audioPlayer = try AVAudioPlayer(contentsOf:correctSound as URL)
        }catch {
            print("Error getting the audio file")
        }
        audioPlayer.prepareToPlay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GamePlayViewController.updateCounter), userInfo: nil, repeats: true)
 
    }
    
    
    //MARK: Helper Methods 
    
    func updateCounter() {
        score = score + 1
    }
    
    func endGame() {
        timer.invalidate()
        performSegue(withIdentifier: "EndGameIdentifier", sender: false)
    }
    
    func addParalax() {
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
                                                               type: .tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -20
        verticalMotionEffect.maximumRelativeValue = 20
        
        // Set horizontal effect
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
                                                                 type: .tiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -20
        horizontalMotionEffect.maximumRelativeValue = 20
        
        // Create group to combine both
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        backgroundImageView.addMotionEffect(group)
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
            imageCell.contentImageView.image = sectionData.randomImageAtIndex(index: indexPath.row)
            imageCell.layer.cornerRadius = 20
            return imageCell
        } else  {
            let textCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! TextCollectionViewCell
            textCell.nameLabel.text = sectionData.randomTextAtIndex(index: indexPath.row)
            textCell.backgroundImage.image = sectionData.backgroundImage
            textCell.layer.cornerRadius = 20
            return textCell
        }
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
        
        // check to see if they match only if both are non-nil
        if selectedTextCell != nil && selectedImageCell != nil {
            let image = selectedImageCell?.contentImageView.image
            let text = selectedTextCell?.nameLabel.text
            let match = sectionData.match(image: image!, text: text!)
            if match == true {
                selectedTextCell?.setMatched()
                selectedTextCell?.nameLabel.alpha = 0.0
                selectedTextCell = nil
                selectedImageCell?.setMatched()
                selectedImageCell?.contentImageView.image = sectionData.backgroundImage
                selectedImageCell = nil
                matched = matched + 1
                audioPlayer.pause()
                audioPlayer.play()

                if matched == sectionData.numberOfAssets() {
                    endGame()
                }
                
            } else {
                selectedImageCell?.setHighlighted(selected: false)
                selectedImageCell?.shake()
                selectedImageCell = nil
                selectedTextCell?.setHighlighted(selected: false)
                selectedTextCell?.shake()
                selectedTextCell = nil
            }
        }
        
        
    }
    
    @IBAction func continueGame(segue:UIStoryboardSegue) {
       print("game continued")
    }

    
    @IBAction func pauseGame(_ sender: AnyObject) {
        timer.invalidate()
        performSegue(withIdentifier: "EndGameIdentifier", sender: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EndGameIdentifier" {
            if let endGameViewConroller = segue.destinationViewController as? EndGameViewController {
                endGameViewConroller.paused = sender as! Bool
                endGameViewConroller.sectionData = sectionData
                endGameViewConroller.score = score
            }
        }
    }
    // MARK:- Trait Collection Changes

    func updateAxisForBoundsChange(size: CGSize) {
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            // iPad - check orientation in this case.
            if size.width > size.height {
                self.collectionViewStackView.axis = UILayoutConstraintAxis.horizontal
            }
            else {
                self.collectionViewStackView.axis = UILayoutConstraintAxis.vertical
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateAxisForBoundsChange(size: size)
    }
    
    
    
    
}
