//
//  MapViewController.swift
//  AHOnline
//
//  Created by AroHak on 09/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

//MARK: - class MapViewController -
class MapViewController: UIViewController {

    var output: MapViewOutput!

    // MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        output.viewIsReady()
    }
}

//MARK: - extension for MapViewInput -
extension MapViewController: MapViewInput {
    
    func setupInitialState() {

    }
}
