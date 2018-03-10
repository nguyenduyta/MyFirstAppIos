//
//  PictureTableViewController.swift
//  MyFirstApp
//
//  Created by Ta Nguyen on 2018/03/01.
//  Copyright © 2018 Ta Nguyen. All rights reserved.
//

import UIKit
import os.log

class PictureTableViewController: UITableViewController {

    //MARK: Properties
    
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.isEditing = false
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedPictures = loadPictures() {
            pictures += savedPictures
        } else {
            // Load the sample data.
            loadSamplePictures()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Private Methods
    
    private func loadSamplePictures() {
        let photo1 = UIImage(named: "picture1")
        let photo2 = UIImage(named: "picture2")
        let photo3 = UIImage(named: "picture3")
        
        guard let picture1 = Picture(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate picture1")
        }
        
        guard let picture2 = Picture(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate picture2")
        }
        
        guard let picture3 = Picture(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate picture3")
        }
        
        pictures += [picture1, picture2, picture3]
    }
    
    private func loadPictures() -> [Picture]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Picture.ArchiveURL.path) as? [Picture]
    }

    private func savePictures() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(pictures, toFile: Picture.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Pictures successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Pictures...", log: OSLog.default, type: .error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PictureTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PictureTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PictureTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let picture = pictures[indexPath.row]
        
        cell.nameLabel.text = picture.name
        cell.photoImageView.image = picture.photo
        cell.ratingControl.rating = picture.rating
        
        return cell
    }
    
    // Comment out because it will hide remove control
    //    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    //        return .none
    //    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.pictures[sourceIndexPath.row]
        pictures.remove(at: sourceIndexPath.row)
        pictures.insert(movedObject, at: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(pictures)")
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            pictures.remove(at: indexPath.row)
            savePictures()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Need this function when exit unwind
     @IBAction func returned(segue: UIStoryboardSegue) {
    }
    
    //MARK: Actions
    @IBAction func unwindToPictureList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PictureViewController, let picture = sourceViewController.picture {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing picture.
                pictures[selectedIndexPath.row] = picture
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new picture.
                let newIndexPath = IndexPath(row: pictures.count, section: 0)
                
                pictures.append(picture)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals.
            savePictures()
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new picture.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let pictureDetailViewController = segue.destination as? PictureViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedPictureCell = sender as? PictureTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedPictureCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedPicture = pictures[indexPath.row]
            pictureDetailViewController.picture = selectedPicture
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

}
