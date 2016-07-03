//
//  EndGameViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 6/23/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {
    
    var paused = false 
    var score: Int?
    var sectionData: SectionData?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var bestScoreLabel: UILabel!
    @IBOutlet var reviewButton: UIButton!
    @IBOutlet var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView(paused: paused)
   
    }
    
    func setUpView(paused: Bool) {
        titleLabel.addShadow()
        
        backgroundImage.image = sectionData?.backgroundImage
        if paused == true {
            reviewButton.removeFromSuperview()
            titleLabel.text = "Paused."
            feedbackLabel.text = " You've paused set \((sectionData?.title)!)."
            scoreLabel.text = "\(score!)*"
            bestScoreLabel.text = String((sectionData?.topScore)!)
        } else {
            continueButton.removeFromSuperview()
            titleLabel.text = "Congratulations!"
            feedbackLabel.text = " You've finished set \((sectionData?.title)!)."
            scoreLabel.text = "\(score!)"
            if sectionData?.topScore != nil {
                if sectionData?.topScore < score {
                    sectionData?.topScore = score
                }
                bestScoreLabel.text = String((sectionData?.topScore)!)
            } else {
                sectionData?.topScore = score
            }
            
        }
        
    }
    
    @IBAction func playAgain(_ sender: AnyObject) {
//        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func playAnother(_ sender: AnyObject) {
    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func reviewButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "ReviewSegueIdentifier", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReviewSegueIdentifier" {
            let reviewViewController = segue.destinationViewController as! ReviewViewController
            reviewViewController.sectionData = self.sectionData
            
        }
    }

  }
