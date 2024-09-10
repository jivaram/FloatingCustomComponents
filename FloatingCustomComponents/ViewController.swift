//
//  ViewController.swift
//  FloatingCustomComponents
//
//  Created by KaHa on 10/09/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var floatingView:UIView!
    var messageLabel: UILabel!
    var progressView: UIView!
    var progressLayer: CAShapeLayer!
    var connectionStateImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setUPFloatingView()
        setUPMessagelable()
        setupImage()
        setUpprogressView()
        animateProgress(duration: 2.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as? TestTableViewCell else {return UITableViewCell()}
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row % 2) == 0 {
            floatingView.isHidden = true
        } else {
            floatingView.isHidden = false
        }
    }
}

extension ViewController {
    func setUPFloatingView() {
        floatingView = UIView()
        floatingView.backgroundColor = .gray
        floatingView.translatesAutoresizingMaskIntoConstraints = false
        floatingView.layer.cornerRadius = 30
        floatingView.clipsToBounds = true
        mainView.addSubview(floatingView)
        
        NSLayoutConstraint.activate([
            floatingView.heightAnchor.constraint(equalToConstant: 60),
            floatingView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 24),
            floatingView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -24),
            floatingView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -30)
        ])
    }
    
    func setUPMessagelable() {
        messageLabel = UILabel()
        messageLabel.text = "Establishing connection between your Smart <Ring> and Bluetooth"
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        floatingView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: floatingView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: floatingView.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: floatingView.leadingAnchor, constant: 60),
            messageLabel.trailingAnchor.constraint(equalTo: floatingView.trailingAnchor, constant: -16)
        ])
    }
    
    func setUpprogressView() {
        // Initialize progress view container
        progressView = UIView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        floatingView.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 40),
            progressView.heightAnchor.constraint(equalToConstant: 40),
            progressView.centerYAnchor.constraint(equalTo: floatingView.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: floatingView.leadingAnchor, constant: 16)
        ])
        
        // Create circular path
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: 20, y: 20),
            radius: 20,
            startAngle: -(CGFloat.pi / 6),  // Start at 2 o'clock
            endAngle: 2 * CGFloat.pi - (CGFloat.pi / 6), // End at 2 o'clock after full circle
            clockwise: true
        )
        
        // Create shape layer for progress
        progressLayer = CAShapeLayer()
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.red.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor // This ensures only the stroke is drawn
        progressLayer.lineWidth = 2
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0 // Initial progress is 0
        
        // Add progress layer to progressView
        progressView.layer.addSublayer(progressLayer)
    }
    

    func animateProgress(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0.7 // Full progress
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: "progressAnim")
        
        // Dismiss floating view after completion (on success)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: .infinity) {
                self.floatingView.alpha = 0
            } completion: { _ in
                self.floatingView.removeFromSuperview()
            }
        }
    }
    
    func setupImage() {
        // Initialize the UIImageView instead of UIImage
        let connectionStateImage = UIImageView()
        
        // Set the image for the UIImageView
        connectionStateImage.image = UIImage(named: "discoonetionState")
        
        // Add the image view to the floating view
        connectionStateImage.translatesAutoresizingMaskIntoConstraints = false
        connectionStateImage.layer.masksToBounds = true
        floatingView.addSubview(connectionStateImage)
        
        // Add the layout constraints
        NSLayoutConstraint.activate([
            connectionStateImage.widthAnchor.constraint(equalToConstant: 44),
            connectionStateImage.heightAnchor.constraint(equalToConstant: 44),
            connectionStateImage.centerYAnchor.constraint(equalTo: floatingView.centerYAnchor),
            connectionStateImage.leadingAnchor.constraint(equalTo: floatingView.leadingAnchor, constant: 14)
        ])
    }
    
}

class TestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
