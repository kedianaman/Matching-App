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
    
    @IBOutlet weak var scoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func playAgain(_ sender: AnyObject) {
//        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func playAnother(_ sender: AnyObject) {
    }

  }
