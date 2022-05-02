//
//  ViewController.swift
//  Solar
//
//  Created by Adi on 26.04.22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var testBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setGradient()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.transition(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func setGradient(){
        let colorTop = UIColor(red: 7/255, green: 6/255, blue: 12/255, alpha: 1).cgColor
        let colorBottom = UIColor(red: 1/255, green: 10/255, blue: 44/255, alpha: 1).cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0.0, 1.0]
        gradient.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    @objc func transition(_ sender: UITapGestureRecognizer? = nil) {
        self.performSegue(withIdentifier: "homeToPreview", sender: self)
    }
    
}

