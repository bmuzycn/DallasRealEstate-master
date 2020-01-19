//
//  ViewController.swift
//  LunchTyme
//
//  Created by Yu Zhang on 7/30/19.
//  Copyright © 2019 Yu Zhang. All rights reserved.
//

import UIKit
import MapKit

let nameFont: UIFont = UIFont.init(name: "AvenirNext-DemiBold", size: 16)!
let categoryFont: UIFont = UIFont.init(name: "AvenirNext-Regular", size: 12)!
let regularFont: UIFont = UIFont.init(name: "AvenirNext-Regular", size: 16)!
let regularColor: UIColor = UIColor(red: 42, green: 42, blue: 42)

class DetailVC: UIViewController, CLLocationManagerDelegate {
    
    var properties = Array<Property>()
    
    var location: CLLocationCoordinate2D? {
        willSet(newValue) {
            if let newCenter = newValue {
                let center = CLLocationCoordinate2D(latitude: newCenter.latitude, longitude: newCenter.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let myRegion = MKCoordinateRegion(center: center, span: span)
                mapView.setRegion(myRegion, animated: true)
            }
        }
        didSet {
            if let oldCenter = oldValue {
                let center = CLLocationCoordinate2D(latitude: oldCenter.latitude, longitude: oldCenter.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let myRegion = MKCoordinateRegion(center: center, span: span)

                MKMapView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
                    self.mapView.setRegion(myRegion, animated: true)
                })
            }

        }
    }
    
    let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    let titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 52, green: 179, blue: 121)
        return view
    }()
    
    let priceLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.white
        view.font = nameFont
        return view
    }()
    
    let sqftLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.white
        view.font = categoryFont
        return view
    }()
    
    let detailContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let address1Label: UILabel = {
        let view = UILabel()
        view.textColor = regularColor
        view.font = regularFont
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.frame.size.width = 300
        view.sizeToFit()
        return view
    }()
    
    let label: UILabel = {
        let view = UILabel()
        view.textColor = regularColor
        view.font = regularFont
        return view
    }()
    
    let bedsLabel: UILabel = {
        let view = UILabel()
        view.textColor = regularColor
        view.font = regularFont
        return view
    }()
    
    let bathsLabel: UILabel = {
        let view = UILabel()
        view.textColor = regularColor
        view.font = regularFont
        return view
    }()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // MARK: setup views
    
    func setupViews() {
        
        self.title = "Details"
        let mapButton = UIBarButtonItem(image: UIImage(named: "icon_map"), style: .plain, target: self, action: #selector(pressMapButton))
        self.navigationItem.setRightBarButton(mapButton, animated: true)
        // Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // loading info to the map
        mapView.delegate = self

        var annotations = Array<MKAnnotation>()
        for property in properties {
            let lat = property.lat
            let lng = property.lon
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            location = coordinate
            let annotation = MKPointAnnotation()
            annotation.subtitle = property.address
            annotation.coordinate = coordinate
            annotation.title = property.price
//            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "forSale")
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        mapView.showsUserLocation = true
        mapView.showAnnotations(annotations, animated: true)
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
//        mapConstrainForFull()
    }
    //Mark: map button method
    @objc func pressMapButton() {
        if properties.count <= 1 {
            let mapVC = DetailVC()
            mapVC.properties = properties
            mapVC.mapConstrainForFull()
            mapVC.navigationItem.rightBarButtonItem = nil
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    
    //MARK: if data pass from mapButton then constraint for full map

    func mapConstrainForFull() {
        let myConstraints = [
            NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)]
        view.addConstraints(myConstraints)
    }
    
    //MARK: if data pass from listVC cell than adjust layout for loading individual restaurant info
    func updateLayout() {
        view.addSubview(titleContainerView)
        titleContainerView.addSubview(priceLabel)
        titleContainerView.addSubview(sqftLabel)
        view.addSubview(detailContainerView)
        detailContainerView.addSubview(address1Label)
        detailContainerView.addSubview(label)
        detailContainerView.addSubview(bedsLabel)
        detailContainerView.addSubview(bathsLabel)
        titleContainerView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        detailContainerView.translatesAutoresizingMaskIntoConstraints = false
        address1Label.translatesAutoresizingMaskIntoConstraints = false
        sqftLabel.translatesAutoresizingMaskIntoConstraints = false
        bedsLabel.translatesAutoresizingMaskIntoConstraints = false
        bathsLabel.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        
        let myConstraints = [
            //set mapView constraints
            NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: mapView, attribute: .top, multiplier: 1.0, constant: 180 + 64),
            
            //set container constraints
            NSLayoutConstraint(item: titleContainerView, attribute: .top, relatedBy: .equal, toItem: mapView, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: titleContainerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: titleContainerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: titleContainerView, attribute: .bottom, relatedBy: .equal, toItem: titleContainerView, attribute: .top, multiplier: 1.0, constant: 60),

            //set priceLabel
            NSLayoutConstraint(item: priceLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: titleContainerView, attribute: .top, multiplier: 1.0, constant: 6),
            NSLayoutConstraint(item: priceLabel, attribute: .leading, relatedBy: .equal, toItem: titleContainerView, attribute: .leading, multiplier: 1.0, constant: 12),
            NSLayoutConstraint(item: priceLabel, attribute: .bottom, relatedBy: .equal, toItem: sqftLabel, attribute: .top, multiplier: 1.0, constant: -6),

            //set sqftLabel
            NSLayoutConstraint(item: sqftLabel, attribute: .leading, relatedBy: .equal, toItem: priceLabel, attribute: .leading, multiplier: 1.0, constant: 0),


            //set detailContainerView
            NSLayoutConstraint(item: detailContainerView, attribute: .top, relatedBy: .equal, toItem: titleContainerView, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: detailContainerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: detailContainerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: detailContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),

            //set address
            NSLayoutConstraint(item: address1Label, attribute: .top, relatedBy: .equal, toItem: detailContainerView, attribute: .top, multiplier: 1.0, constant: 16),
            NSLayoutConstraint(item: address1Label, attribute: .leading, relatedBy: .equal, toItem: detailContainerView, attribute: .leading, multiplier: 1.0, constant: 12),
            NSLayoutConstraint(item: address1Label, attribute: .trailing, relatedBy: .equal, toItem: detailContainerView, attribute: .trailing, multiplier: 1.0, constant: -12),
            
            NSLayoutConstraint(item: label, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: address1Label, attribute: .bottom, multiplier: 1.0, constant: 2),
            NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: detailContainerView, attribute: .leading, multiplier: 1.0, constant: 12),
            NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: bedsLabel, attribute: .top, multiplier: 1.0, constant: -26),

            //set phoneLabel twitterlabel
            NSLayoutConstraint(item: bedsLabel, attribute: .leading, relatedBy: .equal, toItem: detailContainerView, attribute: .leading, multiplier: 1.0, constant: 12),
            NSLayoutConstraint(item: bathsLabel, attribute: .leading, relatedBy: .equal, toItem: detailContainerView, attribute: .leading, multiplier: 1.0, constant: 12),

            NSLayoutConstraint(item: bathsLabel, attribute: .top, relatedBy: .equal, toItem: bedsLabel, attribute: .bottom, multiplier: 1.0, constant: 26)



        ]
        view.addConstraints(myConstraints)
        view.updateConstraints()
        
    }

    //didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let cllocation = locations[locations.count - 1]
        if cllocation.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            location = CLLocationCoordinate2D(latitude: cllocation.coordinate.latitude, longitude: cllocation.coordinate.longitude)
//            lat = location.coordinate.latitude
//            lng = location.coordinate.longitude
        }
    }
    
    //MARK: remove the back button text
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    deinit {
        print ("There is no memory leak from mapView controller")
    }

}

extension DetailVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "forSale"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        annotationView!.image = UIImage(named: "home.png")
//        configureDetailView(annotationView: annotationView!)
        
        return annotationView
    }


    func configureDetailView(annotationView: MKAnnotationView) {
        if #available(iOS 9.0, *) {
            annotationView.detailCalloutAccessoryView = UIImageView(image: UIImage(named: "home.png"))
        } else {
            // Fallback on earlier versions
        }
    }
}

