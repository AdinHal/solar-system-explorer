//
//  PreviewController.swift
//  Solar
//
//  Created by Adi on 26.04.22.
//

import UIKit

class PreviewController : UIViewController{
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var planetImage: UIImageView!
    @IBOutlet var distanceFromEarthLabel: UILabel!
    @IBOutlet var orbitalSpeedLabel: UILabel!
    @IBOutlet var rotationPeriodLabel: UILabel!
    @IBOutlet var surfaceAreaLabel: UILabel!
    @IBOutlet var satelitesLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        setGradient()
        super.viewDidAppear(true)
        self.showToast(message: "Pull Down To Dismiss!", font: .systemFont(ofSize: 11.0))
    }
    
    override func viewDidLoad() {
        setGradient()
        super.viewDidLoad()
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
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

extension UIView{
    @IBInspectable var cornerRadiusV: CGFloat{
        get{
            return layer.cornerRadius
        }set{
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColorV : UIColor?{
        get{
            return UIColor(cgColor: layer.borderColor!)
        }set{
            layer.borderColor = newValue?.cgColor
        }
    }
}
