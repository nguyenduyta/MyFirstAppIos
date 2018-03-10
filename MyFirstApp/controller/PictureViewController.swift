//
//  ViewController.swift
//  MyFirstApp
//
//  Created by Ta Nguyen on 2018/02/08.
//  Copyright © 2018 Ta Nguyen. All rights reserved.
//

import UIKit
import os.log

class PictureViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    
    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var helloTextView: UITextView!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    var picture: Picture?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameInputField.delegate = self
        
        // Set up views if editing an existing Picture.
        if let picture = picture {
            navigationItem.title = picture.name
            nameInputField.text   = picture.name
            loadingImageView.image = picture.photo
            ratingControl.rating = picture.rating
        }
        
        // Enable the Save button only if the text field has a valid picture name.
        updateSaveButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    // Fuction when back from next screen using exit
    @IBAction func returned(segue: UIStoryboardSegue) {
        helloTextView.text = "Welcome back!"
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddPictureMode = presentingViewController is UINavigationController
        
        if isPresentingInAddPictureMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The PictureViewController is not inside a navigation controller.")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        helloTextView.text = "Hello \(nameInputField.text!) ! How are you!"
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  Function will call before show next screen
    //  Send data from this controller to Page2Controller
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination as! Page2Controller
//        destination.dataExchangeFromScreen1 = nameInputField.text
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
 
        let name = nameInputField.text ?? ""
        let photo = loadingImageView.image
        let rating = ratingControl.rating
        let position = Utils.loadPictures()?.count ?? 1
        
        
        // Set the meal to be passed to PictureTableViewController after the unwind segue.
        picture = Picture(name: name, photo: photo, rating: rating, position: position)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameInputField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        loadingImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameInputField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

