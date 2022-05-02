//
//  FirstTimeController.swift
//  Solar
//
//  Created by Adi on 26.04.22.
//

import UIKit

class FirstTimeController : UIViewController{
    @IBOutlet var forwardBtn: UIButton!
    var imageView : UIImageView = {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.image = UIImage(named: "Welcomescreen.jpg")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.insertSubview(imageView, at: 0)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        forwardBtn.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        self.showToast(message: "Tap on Your screen!", font: .systemFont(ofSize: 12.0))
    }
    
    @IBAction func transitionToHome(_ sender: UIButton) {
        self.performSegue(withIdentifier: "firstTimeToHome", sender: self)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.performSegue(withIdentifier: "firstTimeToHome", sender: self)
    }
}

extension UIViewController {

    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-550, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.0, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
