//
//  ViewController.swift
//  MyFirstApp
//
//  Created by Ta Nguyen on 2018/02/08.
//  Copyright © 2018 Ta Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    
    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var helloTextView: UITextView!
    @IBOutlet weak var loadingImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameInputField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        helloTextView.text = "Hello \(nameInputField.text!) ! How are you!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    //MARK: Actions
    @IBAction func resetYourName(_ sender: UIButton) {
        nameInputField.text = ""
        helloTextView.text = ""
    }
    
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        helloTextView.text = "hi"
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

