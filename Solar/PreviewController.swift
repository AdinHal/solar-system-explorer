//
//  PreviewController.swift
//  Solar
//
//  Created by Adi on 26.04.22.
//

import UIKit
import SDWebImage

class PreviewController : UIViewController{
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var planetImage: UIImageView!
    @IBOutlet var distanceFromEarthLabel: UILabel!
    @IBOutlet var orbitalSpeedLabel: UILabel!
    @IBOutlet var rotationPeriodLabel: UILabel!
    @IBOutlet var surfaceAreaLabel: UILabel!
    @IBOutlet var satelitesLabel: UILabel!
    var valueToPass = String()

    private var dataTask: URLSessionDataTask?
    
    private var planet: Planet? {
        didSet{
            guard let planet = planet else {
                return
            }
            titleLabel.text = "\(planet.name)".uppercased()
            titleLabel.sizeToFit()
            descriptionLabel.text = "\(planet.description)"
            descriptionLabel.sizeToFit()
            distanceFromEarthLabel.text = "\(planet.distanceFromEarth)"
            distanceFromEarthLabel.sizeToFit()
            orbitalSpeedLabel.text = "\(planet.rotationSpeed)"
            rotationPeriodLabel.text = "\(planet.rotationPeriod)"
            surfaceAreaLabel.text = "\(planet.surfaceArea)"
            satelitesLabel.text = "\(planet.satelites)"
            planetImage.sd_setImage(with: URL(string: "\(planet.imageUrl)"))
            planetImage.sizeToFit()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setGradient()
        loadData()
        super.viewDidAppear(true)
        self.showToast(message: "Pull Down To Dismiss!", font: .systemFont(ofSize: 11.0))
    }
    
    override func viewDidLoad() {
        setGradient()
        loadData()
        super.viewDidLoad()
    }
    
    
    func loadData(){
        guard let url = URL(string: "https://space-api-json.herokuapp.com/planets/\(valueToPass)") else{return}
        
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            guard let data = data else {
                return
            }
            if let decodedData = try? JSONDecoder().decode(Planet.self, from: data){
                DispatchQueue.main.async {
                    self.planet = decodedData
                }
            }
        })
        
        dataTask?.resume()
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


struct Planet: Decodable{
    let name: String
    let description: String
    let rotationSpeed: String
    let distanceFromEarth: String
    let satelites: Int
    let surfaceArea: String
    let rotationPeriod: String
    let imageUrl: String
}
