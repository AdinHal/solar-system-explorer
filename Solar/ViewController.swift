//
//  ViewController.swift
//  Solar
//
//  Created by Adi on 26.04.22.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imagePlanet: UIImageView!
    private var dataTask: URLSessionDataTask?
    var sendText = String()
    
    private var plnt: Planets? {
        didSet{
            guard let plan = plnt else {
                return
            }
            titleLabel.text = "\(plan.name)".uppercased()
            titleLabel.sizeToFit()
            sendText = "\(plan.name)"
            descriptionLabel.text = "\(plan.description)"
            descriptionLabel.sizeToFit()
            imagePlanet.sd_setImage(with: URL(string: "\(plan.imageUrl)"))
            imagePlanet.sizeToFit()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setGradient()
        loadData()
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
    
    func loadData(){
        guard let url = URL(string: "https://space-api-json.herokuapp.com/planets/Jupiter") else{return}
        
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            guard let data = data else {
                return
            }
            if let decodedData = try? JSONDecoder().decode(Planets.self, from: data){
                DispatchQueue.main.async {
                    self.plnt = decodedData
                }
            }
        })
        
        dataTask?.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            //For entire screen size
            /*let screenSize = UIScreen.main.bounds.size
            return screenSize*/
            //If you want to fit the size with the size of ViewController use bellow
            let viewControllerSize = self.view.frame.size
            return viewControllerSize

            // Even you can set the cell to uicollectionview size
            /*let cvRect = collectionView.frame
            return CGSize(width: cvRect.width, height: cvRect.height)*/


        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PreviewController{
            destination.valueToPass = sendText
        }
    }
}


struct Planets: Decodable{
    let name: String
    let description: String
    let rotationSpeed: String
    let distanceFromEarth: String
    let satelites: Int
    let surfaceArea: String
    let rotationPeriod: String
    let imageUrl: String
}
