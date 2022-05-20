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

    private var da: URLSessionDataTask?
    
    private var plane: Planet? {
        didSet{
            guard let pt = plane else {
                return
            }
            titleLabel.text = "\(pt.name)".uppercased()
            titleLabel.sizeToFit()
            descriptionLabel.text = "\(pt.planetDescription)"
            descriptionLabel.sizeToFit()
            distanceFromEarthLabel.text = "\(pt.distanceFromEarth)"
            distanceFromEarthLabel.sizeToFit()
            orbitalSpeedLabel.text = "\(pt.rotationSpeed)"
            rotationPeriodLabel.text = "\(pt.rotationPeriod)"
            surfaceAreaLabel.text = "\(pt.surfaceArea)"
            satelitesLabel.text = "\(pt.satelites)"
            planetImage.sd_setImage(with: URL(string: "\(pt.imageURL)"))
            planetImage.sizeToFit()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setGradient()
        fetchData()
        super.viewDidAppear(true)
        self.showToast(message: "Pull Down To Dismiss!", font: .systemFont(ofSize: 11.0))
    }
    
    override func viewDidLoad() {
        setGradient()
        fetchData()
        super.viewDidLoad()
    }
    
    
    func fetchData(){
        guard let url = URL(string: "https://space-api-json.herokuapp.com/planets/\(valueToPass)") else{return}
        
        da?.cancel()
        da = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            guard let data = data else {
                return
            }
            if let decodedData = try? JSONDecoder().decode(Planet.self, from: data){
                DispatchQueue.main.async {
                    self.plane = decodedData
                }
            }
        })
        
        da?.resume()
    }
    
    struct Planet: Codable{
        let name, planetDescription, rotationSpeed, distanceFromEarth: String
        let satelites: Int
        let surfaceArea, rotationPeriod: String
        let imageURL: String
        
        enum CodingKeys: String, CodingKey{
            case name
            case planetDescription="description"
            case rotationSpeed, distanceFromEarth, satelites, surfaceArea, rotationPeriod
            case imageURL = "imageUrl"
        }
    }

    typealias Planets = [Planet]
    
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
