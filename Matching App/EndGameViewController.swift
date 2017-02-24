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
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var bestScoreLabel: UILabel!
    @IBOutlet var retryButton: UIButton!
    @IBOutlet var reviewButton: UIButton!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var exitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView(paused: paused)
        retryButton.layer.cornerRadius = 20
        reviewButton.layer.cornerRadius = 20
        continueButton.layer.cornerRadius = 20
        exitButton.layer.cornerRadius = 20
    }
    
    func setUpView(paused: Bool) {        
        if paused == true {
            reviewButton.removeFromSuperview()
            titleLabel.text = "Paused."
            feedbackLabel.text = " You've paused set \((sectionData?.title)!)."
            scoreLabel.text = "\(score!)*"
            if sectionData!.topScore != nil {
                bestScoreLabel.text = "Score: \(sectionData!.topScore!)"
            } else {
                bestScoreLabel.text = "--"
            }
        } else {
            continueButton.removeFromSuperview()
            titleLabel.text = "Congratulations!"
            feedbackLabel.text = " You've finished set \((sectionData?.title)!)."
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

    
    @IBAction func reviewButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "ReviewSegueIdentifier", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReviewSegueIdentifier" {
            let reviewViewController = segue.destination as! ReviewViewController
            reviewViewController.sectionData = self.sectionData
            
        }
    }

  }
