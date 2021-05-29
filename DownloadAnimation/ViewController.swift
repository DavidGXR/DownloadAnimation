//
//  ViewController.swift
//  DownloadAnimation
//
//  Created by David Im on 13/4/21.
//

import UIKit

class ViewController: UIViewController {
    
    private let shape = CAShapeLayer()
    private let baseShape = CAShapeLayer()
    private let containerView = UIView()
    private var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .light)
        label.text = "Downloading"
        label.numberOfLines = 1
        return label
    }()
    
    private let downloadButton:UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var buttonWidth = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDownloadButton()
        setupCircle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.addSubview(titleLabel)
        titleLabel.sizeToFit()
        titleLabel.center = view.center
        titleLabel.isHidden = true
    }

    private func setupDownloadButton() {
        
        view.addSubview(downloadButton)
        downloadButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonWidth = downloadButton.widthAnchor.constraint(equalToConstant: 120)
        buttonWidth.isActive = true
        downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        downloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        downloadButton.addTarget(self, action: #selector(downloadButtonTap), for: .touchUpInside)
    }
    
    private func setupCircle() {
        
        let baseCircle  = UIBezierPath(arcCenter: view.center,
                                       radius: 140,
                                       startAngle: -(.pi/2),
                                       endAngle: .pi * 2,
                                       clockwise: true)
        baseShape.path = baseCircle.cgPath
        baseShape.lineWidth = 15
        baseShape.strokeColor = UIColor.lightGray.cgColor
        baseShape.fillColor   = UIColor.clear.cgColor
        view.layer.addSublayer(baseShape)
        
        let circlePath  = UIBezierPath(arcCenter: view.center,
                                       radius: 140,
                                       startAngle: -(.pi/2),
                                       endAngle: .pi * 2,
                                       clockwise: true)
        shape.path = circlePath.cgPath
        shape.lineWidth = 15
        shape.strokeColor = UIColor.systemBlue.cgColor
        shape.fillColor   = UIColor.clear.cgColor
        shape.strokeEnd   = 0
        view.layer.addSublayer(shape)
    }
    
    private func startCircleAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 3
        animation.isRemovedOnCompletion = false // put this so that when the animation ends the stroke color won't disappear
        animation.fillMode = .forwards
        shape.add(animation, forKey: "animation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.5) {
                self.titleLabel.text = "Completed"
                self.buttonWidth.constant = 120
                self.view.layoutIfNeeded()
                
            } completion: { completed in
                self.downloadButton.setTitle("Download", for: .normal)
            }
        }
    }
    
    @objc func downloadButtonTap() {
        UIView.animate(withDuration: 0.5) {
            self.buttonWidth.constant = 150
            self.view.layoutIfNeeded()
            
        } completion: { completed in
            self.downloadButton.setTitle("Downloading", for: .normal)
            self.titleLabel.text = "Downloading"
            self.titleLabel.isHidden = false
            self.startCircleAnimation()
        }

    }
    


}

