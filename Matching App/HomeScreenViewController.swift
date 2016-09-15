//
//  HomeScreenViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 6/25/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var sectionDataTableView: UITableView!
    var collection = Collection()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sectionDataTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection.numberOfSectionDatas()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionBarTableViewCellIdentifer", for: indexPath) as! SectionBarTableViewCell
        let sectionData = collection.sectionDataAtIndex(index: indexPath.row)
        cell.titleLabel.text = sectionData.title
        cell.backgroundImageView.image = sectionData.lightBlurredBackgroundImage
        if sectionData.topScore != nil {
            cell.scoreLabel.text = String(sectionData.topScore!)
        } else {
            cell.scoreLabel.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PlayGameSegueIdentifier", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayGameSegueIdentifier" {
            let gameViewController = segue.destination as! GamePlayViewController
            let index = sender as! Int
            gameViewController.sectionData = collection.sectionDataAtIndex(index: index)
        }
    }
    
    
    @IBAction func exitToHome(segue:UIStoryboardSegue) {
        //Unwind Segue
    }
 

   
}
