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
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = sectionData?.backgroundImage
        scoreLabel.text = "\(score!) s."

        

    }
    @IBAction func playAgain(_ sender: AnyObject) {
//        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func playAnother(_ sender: AnyObject) {
    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

  }
