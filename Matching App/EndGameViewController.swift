//
//  EndGameViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 6/23/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {
    
    
    var score: Int?
    var sectionData: SectionData?
    
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = sectionData?.backgroundImage
        feedbackLabel.text = "Congratulations! You've finished set \((sectionData?.title)!)."
        scoreLabel.text = "\(score!)"
        if sectionData?.topScore != nil {
            if sectionData?.topScore < score {
                sectionData?.topScore = score
            }
        } else {
            sectionData?.topScore = score
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
