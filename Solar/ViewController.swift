//
//  ViewController.swift
//  Solar
//
//  Created by Adi on 26.04.22.
//

import UIKit
import SDWebImage
import Foundation

class ViewController: UIViewController {
    private var dataTask: URLSessionDataTask?
    var sendText = String()
    var planetNames : [String] = []
    var planetDescriptions : [String] = []
    var images : [String] = []
    @IBOutlet var collectionView: UICollectionView!
    var p : [String] = ["Sun", "Mercury","Venus","Earth","Mars","Jupiter","Saturn","Uranus","Neptune"]
   
    
    private var allPlanets: Plans? {
        didSet{
            guard let planet = allPlanets else {
                return
            }
            planetNames = planet.map {$0.name}
            planetDescriptions = planet.map {$0.planetDescription}
            images = planet.map {$0.imageURL}
            
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setGradient()
        collectionView.isPagingEnabled = true
//       Do any additional setup after loading the view.
//       setGradient()
//       let tap = UITapGestureRecognizer(target: self, action: #selector(self.transition(_:)))
//       collectionView.addGestureRecognizer(tap)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        loadData()
    }
   
    
    func setGradient(){
        let colorTop = UIColor(red: 7/255, green: 6/255, blue: 12/255, alpha: 1).cgColor
        let colorBottom = UIColor(red: 1/255, green: 10/255, blue: 44/255, alpha: 1).cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0.0, 1.0]
        gradient.frame = self.view.bounds
        self.collectionView.layer.insertSublayer(gradient, at: 0)
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func loadData(){
        guard let url = URL(string: "https://space-api-json.herokuapp.com/planets/") else{return}
        
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            guard let data = data else {
                return
            }
            
            let planets = try? JSONDecoder().decode(Plans.self, from: data)
            DispatchQueue.main.async {
                self.allPlanets = planets!
            }
        })
        
        dataTask?.resume()
    }
    
    
    struct Plan: Codable{
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

    typealias Plans = [Plan]
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "planetsCell", for: indexPath) as! PlanetCollectionViewCell
//        let colors : [UIColor] = [.red, .blue, .cyan, .orange, .purple, .systemPink, .yellow, .brown, .magenta]
//        cell.backgroundColor = colors[indexPath.row]
            let colorTop = UIColor(red: 7/255, green: 6/255, blue: 12/255, alpha: 1).cgColor
            let colorBottom = UIColor(red: 1/255, green: 10/255, blue: 44/255, alpha: 1).cgColor
            let gradient = CAGradientLayer()
            gradient.colors = [colorTop, colorBottom]
            gradient.locations = [0.0, 1.0]
            gradient.frame = self.view.bounds
            cell.layer.insertSublayer(gradient, at: 0)
        
            cell.name.text = planetNames[indexPath.row]
            cell.desc.text = planetDescriptions[indexPath.row]
            cell.image.sd_setImage(with: URL(string: images[indexPath.row]))
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PreviewController{
            let selectedRow = collectionView.indexPath(for: sender as! UICollectionViewCell)?.row
               destination.valueToPass = p[selectedRow!]
                print("Passing value : \(p[selectedRow!])")
        }
    }
}
