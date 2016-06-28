//
//  HomeScreenViewController.swift
//  Matching App
//
//  Created by Naman Kedia on 6/27/16.
//  Copyright © 2016 Naman Kedia. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var sectionDataTVTableView: UITableView!
    @IBOutlet var sectionimageView: UIImageView!
    @IBOutlet var backgroundImageView: UIImageView!
    
    var collection = Collection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionimageView.layer.cornerRadius = 40
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection.numberOfSectionDatas()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionBarTableViewTVCellIdentifer", for: indexPath) as! SectionDataTVTableViewCell
        let sectionData = collection.sectionDataAtIndex(index: indexPath.row)
        cell.titleLabel.text = sectionData.title
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PlayGameSegueIdentifier" {
            let gameViewController = segue.destinationViewController as! GamePlayTVViewController
            let index = sender as! Int
            gameViewController.sectionData = collection.sectionDataAtIndex(index: index)
        }
    }
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let index = context.nextFocusedIndexPath?.row
        if let index = index {
            let sectionData = collection.sectionDataAtIndex(index: index)
            sectionimageView.image = sectionData.backgroundImage
            backgroundImageView.image = sectionData.backgroundImage
        }
        
    }


}