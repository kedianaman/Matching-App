//
//  EndGameViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 6/23/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

// Class which shows the end game screen or the pause screen. 

import UIKit

class EndGameViewController: UIViewController {
    
    var paused = false 
    var score: Int?
    var sectionData: SectionData?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var bestScoreLabel: UILabel!
    @IBOutlet var retryButton: UIButton!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var exitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView(paused: paused)
        retryButton.layer.cornerRadius = 20
        continueButton.layer.cornerRadius = 20
        exitButton.layer.cornerRadius = 20
    }
    
    // Sets up the view for either a paused screen or an end screen.
    func setUpView(paused: Bool) {        
        if paused == true {
            titleLabel.text = "Paused"
            feedbackLabel.text = "\(sectionData!.title!)"
            scoreLabel.text = "\(score!)*"
            if sectionData!.topScore != nil {
                bestScoreLabel.text = "\(sectionData!.topScore!)"
            } else {
                bestScoreLabel.text = "--"
            }
        } else {
            continueButton.removeFromSuperview()
            titleLabel.text = "Congratulations!"
            feedbackLabel.text = " You've finished \((sectionData?.title)!)"
            scoreLabel.text = "\(score!)"
            if sectionData?.topScore != nil {
                if (sectionData?.topScore)! < score! {
                    sectionData?.topScore = score
                }
                bestScoreLabel.text = String((sectionData?.topScore)!)
            } else {
                sectionData?.topScore = score
                bestScoreLabel.text = String((sectionData?.topScore)!)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReviewSegueIdentifier" {
            let reviewViewController = segue.destination as! ReviewViewController
            reviewViewController.sectionData = self.sectionData
        }
    }

  }
