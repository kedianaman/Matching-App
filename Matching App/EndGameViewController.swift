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
    var matched: Int? {
        didSet {
            progress = CGFloat(matched!)/12.0
        }
    }
    var sectionData: SectionData?
    var progress: CGFloat!
    var animateProgressBar = true
    
    @IBOutlet weak var progressBarIndicator: UIView!
    @IBOutlet weak var progressBarBorder: UIView!
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
        progressBarBorder.layer.cornerRadius = 20
        progressBarIndicator.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            self.progressBarIndicator.frame = CGRect(origin: self.progressBarIndicator.frame.origin, size: CGSize(width: self.progressBarBorder.frame.width * self.progress, height: self.progressBarIndicator.frame.height))
        }, completion: { (complete) in
            self.animateProgressBar = false
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (self.animateProgressBar == false) {
             self.progressBarIndicator.frame = CGRect(origin: self.progressBarIndicator.frame.origin, size: CGSize(width: self.progressBarBorder.frame.width * self.progress, height: self.progressBarIndicator.frame.height))
        }
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
    }
    
  }
