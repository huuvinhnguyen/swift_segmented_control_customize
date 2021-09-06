//
//  ViewController.swift
//  button_toggle
//
//  Created by chuyendo on 9/5/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var segment: SegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        segment.setSegmentedWith(items: ["Option 1", "Option2", "Option3"])
  


        segment.titlesFont = UIFont(name: "OpenSans-Semibold", size: 14)
        
        
    }
    
    @IBAction func updateSelectedIndex(_ sender: SegmentedControl) {
        print("SegmentedControl selected: \(sender.selectedSegmentIndex)")
    }


}

