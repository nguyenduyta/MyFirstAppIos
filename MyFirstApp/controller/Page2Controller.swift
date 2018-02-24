//
//  Page2Controller.swift
//  MyFirstApp
//
//  Created by Ta Nguyen on 2018/02/13.
//  Copyright © 2018 Ta Nguyen. All rights reserved.
//

import UIKit

class Page2Controller: UIViewController {

    
    @IBOutlet weak var labelScreen2: UILabel!
    var dataExchangeFromScreen1: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        labelScreen2.text = dataExchangeFromScreen1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
