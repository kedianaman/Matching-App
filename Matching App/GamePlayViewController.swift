//
//  GamePlayViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 6/14/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class GamePlayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionViewStackView: UIStackView!
    var collection = Collection()
    var sectionData: SectionData!
    var retrying = false
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
        imageCollectionView.addShadow()
        textCollectionView.addShadow()
        backgroundImageView.image = sectionData.lightBlurredBackgroundImage
        titleLabel.text = sectionData.title
        do{
            audioPlayer = try AVAudioPlayer(contentsOf:correctSound as URL)
        }catch {
            print("Error getting the audio file")
        }
        audioPlayer.prepareToPlay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAxisForBoundsChange(size: view.bounds.size)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GamePlayViewController.updateCounter), userInfo: nil, repeats: true)
        if retrying == true {
            reset()
        }
    }
    
    
    //MARK: Helper Methods 
    
    func updateCounter() {
        score = score + 1
    }
    
    func endGame() {
        timer.invalidate()
        performSegue(withIdentifier: "EndGameIdentifier", sender: false)
    }
    
    func reset() {
        score = 0
        matched = 0
        selectedTextCell = nil
        selectedImageCell = nil
        for cell in imageCollectionView.visibleCells() {
            if let imageCell = cell as? ImageCollectionViewCell {
                imageCell.reset()
                let index = imageCollectionView.indexPath(for: imageCell)
                imageCell.contentImageView.image = sectionData.randomImageAtIndex(index: index!.row)
            }
        }
        for cell in textCollectionView.visibleCells() {
            if let textCell = cell as? TextCollectionViewCell {
                textCell.reset()
            }
        }
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
//                selectedTextCell?.nameLabel.alpha = 0.0
                selectedTextCell = nil
                selectedImageCell?.setMatched()
//                selectedImageCell?.contentImageView.image = sectionData.backgroundImage
                selectedImageCell = nil
                matched = matched + 1
//                audioPlayer.pause()
//                audioPlayer.play()
                AudioServicesPlaySystemSound(1111);

                if matched == sectionData.numberOfAssets() {
                    endGame()
                }
                
            } else {
                AudioServicesPlaySystemSound(1006);
                selectedImageCell?.setHighlighted(selected: false)
                selectedImageCell?.shake()
                selectedImageCell = nil
                selectedTextCell?.setHighlighted(selected: false)
                selectedTextCell?.shake()
                selectedTextCell = nil
            }
        } else {
            // plays toc sound when only one is selected
            AudioServicesPlaySystemSound(1104);
        }
        
        
    }
    
    @IBAction func resetGame(segue: UIStoryboardSegue) {
        retrying = true
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
