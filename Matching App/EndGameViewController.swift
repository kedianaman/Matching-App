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
    var matched: Int? 
    var sectionData: SectionData?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var bestScoreLabel: UILabel!
    @IBOutlet var retryButton: UIButton!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var exitButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
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
        } else {
            continueButton.removeFromSuperview()
            titleLabel.text = "Congratulations!"
            feedbackLabel.text = " You've finished \((sectionData?.title)!)"
        }
        
        progressView.setProgress((Float(Double(matched!)/12.0)), animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReviewSegueIdentifier" {
            let reviewViewController = segue.destination as! ReviewViewController
            reviewViewController.sectionData = self.sectionData
        }
    }

  }
