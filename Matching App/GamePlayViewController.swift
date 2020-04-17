//
//  GamePlayViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 6/14/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

// Class which controls the game play screen of the user.

import UIKit
import AVFoundation
import AudioToolbox

class GamePlayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: Properties 
    
    var endGameViewController: EndGameViewController?
    var imageCells = [ImageCollectionViewCell]()
    var textCells = [TextCollectionViewCell]()
    var collection = Collection()
    var sectionData: SectionData!
    var retrying = false
    var numberMatched = 0
    var aced = true
    var numIncorrect = 0
    var matchedImages = [UIImage]()
    var matchedTexts = [String]()
    var selectedImageCell: ImageCollectionViewCell?
    var selectedTextCell: TextCollectionViewCell?
    var fontSize = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 0.028
    var gamePaused = false

    
    //MARK: IB Outlets
    
    @IBOutlet var collectionViewStackView: UIStackView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var textCollectionView: UICollectionView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var darkView: UIView!
 
    // MARK:- Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.addShadow()
        textCollectionView.addShadow()
        if #available(iOS 12.0, *) {
            if (self.traitCollection.userInterfaceStyle == .dark) {
                self.backgroundImageView.image = sectionData.darkBlurredBackgroundImage
            } else {
                self.backgroundImageView.image = sectionData.lightBlurredBackgroundImage
            }
        } else {
            self.backgroundImageView.image = sectionData.lightBlurredBackgroundImage
        }
        titleLabel.text = sectionData.title
        self.collectionViewStackView.addParalaxToView()
        darkView.frame = CGRect(origin: darkView.frame.origin, size: CGSize(width: darkView.frame.width, height: 0.126 * max(self.view.bounds.width, self.view.bounds.height)))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAxisForBoundsChange(size: view.bounds.size)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if retrying == true {
            reset()
        }
    }
    
    func updateAxisForBoundsChange(size: CGSize) {
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            // iPad - check orientation in this case.
            
            if size.width > size.height {
                self.collectionViewStackView.axis = NSLayoutConstraint.Axis.horizontal
            }
            else {
                self.collectionViewStackView.axis = NSLayoutConstraint.Axis.vertical
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        updateAxisForBoundsChange(size: size)
        coordinator.animate(alongsideTransition: { (context) in
            self.imageCollectionView.collectionViewLayout.invalidateLayout()
            self.textCollectionView.collectionViewLayout.invalidateLayout()
        }) { (context) in

        }
    }
    
    //MARK: Helper Methods 
    
    
    func endGame() {
        addEndGameChildViewController(paused: false)
    }
    
    func reset() {
        numberMatched = 0
        selectedTextCell = nil
        selectedImageCell = nil
        aced = true
        for cell in imageCollectionView.visibleCells {
            if let imageCell = cell as? ImageCollectionViewCell {
                imageCell.reset()
                let index = imageCollectionView.indexPath(for: imageCell)
                imageCell.contentImageView.image = sectionData.randomImageAtIndex(index: index!.row)
            }
        }
        for cell in textCollectionView.visibleCells {
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
    
    // function which returns either a text or image cell.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // if it's an image collection view, return an image cell of index. If it's a text collection view, return text cell of index.
        if collectionView == imageCollectionView {
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
            let image = sectionData.randomImageAtIndex(index: indexPath.row)
            imageCell.contentImageView.image = image
            imageCell.paused = gamePaused
            imageCell.matched = (matchedImages.contains(image))
            if let currentlySelectedImageCell = selectedImageCell {
                if currentlySelectedImageCell.contentImageView.image == image {
                    imageCell.currentlySelected = true
                    selectedImageCell = imageCell
                }
            }
            return imageCell
        } else  {
            let textCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! TextCollectionViewCell
            let word = sectionData.randomTextAtIndex(index: indexPath.row)
            textCell.nameLabel.text = word
            textCell.nameLabel.font = textCell.nameLabel.font.withSize(fontSize)
            textCell.paused = gamePaused
            textCell.matched = (matchedTexts.contains(word))
            if let currentlySelectedTextCell = selectedTextCell {
                if currentlySelectedTextCell.nameLabel.text == word {
                    textCell.currentlySelected = true
                    selectedTextCell = textCell
                }
            }
            return textCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionViewStackView.axis == .horizontal) {
            return CGSize(width: collectionView.bounds.width/3 - (60/3), height: collectionView.bounds.height/4 - (60/3))
        } else {
            return CGSize(width: collectionView.bounds.width/4 - (60/3), height: collectionView.bounds.height/3 - (60/3))
        }
    }
    
    
    // function which is called when user selects either a text or an image.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // deselects old selected image or text and selects and highlights newly selected cell
            if collectionView == imageCollectionView {
            if let oldselectedImageCell = selectedImageCell {
                oldselectedImageCell.currentlySelected = false
            }
            selectedImageCell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell
            selectedImageCell?.currentlySelected = true

        } else if collectionView == textCollectionView {
            if let oldselectedTextCell = selectedTextCell {
                oldselectedTextCell.currentlySelected = false
            }
            selectedTextCell = collectionView.cellForItem(at: indexPath) as? TextCollectionViewCell
            selectedTextCell?.currentlySelected = true

        }
        
        // check to see if they match only if both are non-nil 
        if selectedTextCell != nil && selectedImageCell != nil {
            let image = selectedImageCell?.contentImageView.image
            let text = selectedTextCell?.nameLabel.text
            let match = sectionData.match(image: image!, text: text!)
            if match == true {
                selectedTextCell?.matched = true
                selectedTextCell = nil
                selectedImageCell?.matched = true
                selectedImageCell = nil
                numberMatched = numberMatched + 1
                matchedImages.append(image!)
                matchedTexts.append(text!)
                AudioServicesPlaySystemSound(1394);

                if numberMatched == sectionData.numberOfAssets() {
                    endGame()
                }
                
            } else {
                AudioServicesPlaySystemSound(1006);
                selectedImageCell?.currentlySelected = false
                selectedImageCell?.shake()
                selectedImageCell = nil
                selectedTextCell?.currentlySelected = false
                selectedTextCell?.shake()
                selectedTextCell = nil
                aced = false 
            }
        } else {
            // plays toc sound when only one is selected
            AudioServicesPlaySystemSound(1104);
        }
        
    }
    
    //MARK: IB Actions

    
    @IBAction func resetGame(segue: UIStoryboardSegue) {
        removeEndGameChildViewController()
        reset()
        animateCards(hide: false)
        gamePaused = false
        matchedImages.removeAll()
        matchedTexts.removeAll()

    }
    
    @IBAction func continueGame(segue:UIStoryboardSegue) {
        animateCards(hide: false)
        removeEndGameChildViewController()
        gamePaused = false
    }
    
    
    @IBAction func pauseGame(_ sender: AnyObject) {
        animateCards(hide: true)
        addEndGameChildViewController(paused: true)
        gamePaused = true
    }
    
    //MARK: Pause Controller Helper Functiosn

    
    func addEndGameChildViewController(paused: Bool) {
        endGameViewController = self.storyboard?.instantiateViewController(withIdentifier: "EndGameViewController") as? EndGameViewController
        if let endGameViewController = endGameViewController {
            if paused == true {
                endGameViewController.paused = true
            }
            endGameViewController.sectionData = sectionData
            endGameViewController.matched = numberMatched
            endGameViewController.aced = aced
            
            let width: CGFloat = 600
            let height: CGFloat = 500
            endGameViewController.view.frame = CGRect(x: self.view.bounds.width/2 - width/2, y: self.view.bounds.height, width: width, height: height)
            
            endGameViewController.view.autoresizingMask = UIView.AutoresizingMask.flexibleTopMargin.union(UIView.AutoresizingMask.flexibleBottomMargin).union(UIView.AutoresizingMask.flexibleLeftMargin).union(UIView.AutoresizingMask.flexibleRightMargin)

            self.view.addSubview(endGameViewController.view)
            self.addChild(endGameViewController)
            
            endGameViewController.view.layer.cornerRadius = 40
            endGameViewController.view.layer.masksToBounds = true
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                endGameViewController.view.frame.origin.y = self.view.bounds.height/2 - height/2
                self.hideTopView(willHide: true)
            }, completion: { (complete) in
                endGameViewController.didMove(toParent: self)
            })
            
        }
    }
    
    
    func removeEndGameChildViewController() {
        if let endGameViewController = endGameViewController {
            endGameViewController.willMove(toParent: nil)
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                endGameViewController.view.frame.origin.y = self.view.bounds.height
                self.hideTopView(willHide: false)
            }, completion: { (complete) in
                endGameViewController.view.removeFromSuperview()
                endGameViewController.removeFromParent()
            })
        }
    }
    
    func hideTopView(willHide: Bool) {
        if willHide == true  {
            self.titleLabel.alpha = 0.0
            self.darkView.alpha = 0.0
            self.pauseButton.alpha = 0.0
            self.pauseButton.isUserInteractionEnabled = false
        } else {
            self.titleLabel.alpha = 1.0
            self.darkView.alpha = 1.0
            self.pauseButton.alpha = 1.0
            self.pauseButton.isUserInteractionEnabled = true
        }
    }
    
    
    func animateCards(hide: Bool) {
        if hide == true {
            self.imageCollectionView.isUserInteractionEnabled = false
            self.textCollectionView.isUserInteractionEnabled = false
        } else {
            self.imageCollectionView.isUserInteractionEnabled = true
            self.textCollectionView.isUserInteractionEnabled = true
        }
        
        let cells = imageCollectionView.visibleCells + textCollectionView.visibleCells
        
        for cell in cells {
            UIView.animate(withDuration: 0.5 + Double(arc4random_uniform(5)) * 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                if let cell = cell as? GamePlayCollectionViewCell {
                    cell.paused = hide
                }
                }, completion: { (finished) in
            })
        }
        
    }
}
