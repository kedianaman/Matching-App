//
//  ReviewViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 6/26/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sectionData: SectionData!
    @IBOutlet weak var reviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCellIdentifier", for: indexPath) as! ReviewTableViewCell
        cell.pictureImageView.image = sectionData.imageAtIndex(index: indexPath.row)
        cell.wordLabel.text = sectionData.textAtIndex(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData.numberOfAssets()
    }

    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
  

}
