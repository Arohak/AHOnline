//
//  MapViewController.swift
//  AHOnline
//
//  Created by AroHak on 09/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

import AlamofireImage

class MapViewController: BaseViewController {
    
    var output: MapViewOutput!

    private let cellIdentifire      = "cellIdentifire"
    private var location: CLLocation!
    private var locationAddress: String!
    private var myMarker: GMSMarker!
    private var drewPolyline: GMSPolyline!
    private var allGMSMarkers: [GMSMarker] = []
    private var selectedGMSMarker: GMSMarker?
    private var objects: [AHObject] = []
    private var addresses: [Address] = []
    private var myUserData = 1000000
    private var callback: ((CLLocation?, String?) -> Void)?
    private var distance = 5.0
    private var distances: [Double] = [1, 2, 5, 10, 20, 50, 100]
    
    //MARK: - Create UIElements
    private let mapView = MapView()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        output.viewIsReady()
        startUpdatingLocation { _ in }
        getNearestObjects()
    }
    
    // MARK: - Internal Method -
     override func baseConfig() {
        self.view = mapView

        mapView.tableView.dataSource = self
        mapView.tableView.delegate = self
        mapView.tableView.registerClass(MapObjectsCell.self, forCellReuseIdentifier: cellIdentifire)
        
        mapView.map.delegate = self
        mapView.bottomView.closeRoutButton.addTarget(self, action: #selector(clearPolyline(_:)), forControlEvents: .TouchUpInside)
        mapView.bottomView.locationButton.addTarget(self, action: #selector(goToMyLocation(_:)), forControlEvents: .TouchUpInside)
    }
    
    override func updateLocalizedStrings() {
        
        navigationItem.title = "map".localizedString
        navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "distance".localizedString, style: .Plain, target: self, action: #selector(chooseDistanceAction)), animated: true)
    }
    
    //MARK: - Actions -
    func clearPolyline(sender: UIButton) {
        drewPolyline.map = nil
        mapView.bottomView.closeRoutButton.hidden = true
    }
    
    func goToMyLocation(sender: UIButton) {
        startUpdatingLocation { (location, error) -> Void in
            self.mapView.map.animateToCameraPosition(GMSCameraPosition.cameraWithLatitude(location!.coordinate.latitude, longitude: location!.coordinate.longitude, zoom: 17))
            if let myMarker = self.myMarker { myMarker.map = nil }
            self.showMyMarkerInMap(location)
        }
    }
    
    func chooseDistanceAction() {
        let actionSheet = DistanceActionSheetPickerViewController(distances: distances) { distance, index in
            self.distance = distance
            self.getNearestObjects()
        }
        actionSheet.pickerView.selectRow(distances.indexOf(distance)!, inComponent: 0, animated: true)
        
        output.presentViewController(actionSheet)
    }
    
    func getNearestObjects() {
        startUpdatingLocation { (location, error) -> Void in
            if let location = location {
                let json = JSON([
                    "latitude"  : "\(location.coordinate.latitude)",
                    "longitude" : "\(location.coordinate.longitude)",
                    "km"        : "\(self.distance)"])
                
                self.output.getNearestObjects(json)
            }
        }
    }
    
    //MARK: - Private Methods -
    private func showMyMarkerInMap(location: CLLocation?) {
        if let location = location {
            myMarker = GMSMarker()
            myMarker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            myMarker.icon = UIImage(named: "img_mapview_mypin")
            myMarker.map = mapView.map
            allGMSMarkers.append(myMarker)
            myMarker.userData = myUserData
        }
    }
    
    private func onLocationRecieved(location: CLLocation) {
        if location.coordinate.latitude != 0.0 && location.coordinate.longitude != 0.0 {
            self.location = location
            locationHelper.geocodeAddress(location.coordinate, withCompletionHandler: { (status, address, success) -> Void in
                if success { self.locationAddress =  address}
            })
        }
    }
    
    private func drawRoute(address: Address) {
        startUpdatingLocation { (location, error) -> Void in
            let markerLocation = String(format: "%f,%f", address.latitude, address.longitude)
            let originLocation = String(format: "%f,%f", location!.coordinate.latitude, location!.coordinate.longitude)
            
            locationHelper.getDirections(originLocation, destination: markerLocation, waypoints: nil, travelMode: nil, completionHandler: { (status, polyline, success) in
                if success {
                    polyline!.strokeColor = UIColor.redColor()
                    polyline!.strokeWidth = DeviceType.IS_IPAD ? 5 : 3
                    polyline!.map = self.mapView.map
                    if let drewPolyline = self.drewPolyline { drewPolyline.map = nil }
                    if self.myMarker == nil { self.showMyMarkerInMap(location) }
                    
                    self.drewPolyline = polyline
                    self.mapView.bottomView.closeRoutButton.hidden = false
                } else {
                    UIHelper.showHUD(error ?? "location_services_disabled".localizedString)
                }
            })
        }
    }
    
    private func focusMapToShowAllMarkers() {
        let myLocation = allGMSMarkers.first!.position
        var bounds = GMSCoordinateBounds(coordinate: myLocation, coordinate: myLocation)
        for marker in allGMSMarkers {
            bounds = bounds.includingCoordinate(marker.position)
        }
        if allGMSMarkers.count == 1 {
            mapView.map.animateToCameraPosition(GMSCameraPosition.cameraWithLatitude(allGMSMarkers[0].position.latitude, longitude: allGMSMarkers[0].position.longitude, zoom: 17))
        } else if  allGMSMarkers.count > 1 {
            mapView.map.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: DeviceType.IS_IPAD ? 100 : 70))
        }
    }
    
    private func focusMapToShowMarkers(objects: [AHObject]) {
        let myLocation = myMarker.position
        var bounds = GMSCoordinateBounds(coordinate: myLocation, coordinate: myLocation)
        for object in objects {
            for address in object.addresses {
                let position = CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
                bounds = bounds.includingCoordinate(position)
            }
        }
        mapView.map.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: DeviceType.IS_IPAD ? 100 : 50))
    }
    
    private func showMarkersInMap(pins: [Address]) {
        for (index, value) in pins.enumerate() {
            let marker = GMSMarker()
            let object = objects.filter { $0.id == value.restaurant_id }.first!
            loadMarkerImage(marker, url: object.src)
            marker.position = CLLocationCoordinate2DMake(value.latitude, value.longitude)
            marker.map = mapView.map
            marker.userData = index
            allGMSMarkers.append(marker)
        }
        addresses = pins
    }
    
    private func loadMarkerImage(marker: GMSMarker, url: String) {
        let imgString = "img_mapview_pinplaceholder"
        let pinImage = UIImage(named: imgString)
        marker.icon = pinImage
        
        let imageDownloader = ImageDownloader.defaultInstance
        let URLRequest = NSURLRequest(URL: NSURL(string: url)!)
        imageDownloader.downloadImage(URLRequest: URLRequest) { (response) -> Void in
            if let image = response.result.value {
                marker.icon = Utils.maskImage(UIImage(named: imgString)!, withMask: image)
            }
        }
    }
    
    private func startUpdatingLocation(callback: (CLLocation?, String?) -> Void) {
        locationHelper.startUpdatingLocation { (location, error) -> Void in
            if error == nil && location != nil {
                self.onLocationRecieved(location!)
                callback(location, error)
            } else {
                UIHelper.showHUD(error ?? "location_services_disabled".localizedString)
            }
        }
    }
    
    //MARK: - Public Methods
    func setMarkersInMap(pins: [Address]) {
        self.mapView.map.clear()
        allGMSMarkers.removeAll()
        addresses.removeAll()
        mapView.bottomView.closeRoutButton.hidden = true
        
        self.showMyMarkerInMap(location)
        self.showMarkersInMap(pins)
        self.focusMapToShowAllMarkers()
    }
    
    func setMarkerInMap(pin: Address) {
        mapView.map.clear()
        allGMSMarkers.removeAll()
        addresses.removeAll()
        mapView.bottomView.closeRoutButton.hidden = true
        
        self.showMyMarkerInMap(location)
        self.showMarkersInMap([pin])
        self.focusMapToShowAllMarkers()
    }
}

//MARK: - extension for MapViewInput -
extension MapViewController: MapViewInput {
    
    func setupInitialState(objects: [AHObject]) {
        addresses.removeAll()
        self.objects = objects
        
        for object in objects {
            for address in object.addresses {
                addresses.append(address)
            }
        }
        
        addresses = addresses.sort { $0.0.distance < $0.1.distance }
        
        setMarkersInMap(addresses)
        mapView.tableView.reloadData()
    }
}

//MARK: - extension for GMSMapViewDelegate -
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let tag = marker.userData as! Int
        
        let customInfoWindow = MPInfoWindow(frame: CGRect(x: 0, y: 0, width: MP_INFOWINDOW_SIZE*4, height: MP_INFOWINDOW_SIZE + MP_INSET/2))
        if tag != myUserData {
            let selectedMarker = addresses[marker.userData as! Int]
            let object = objects.filter { $0.id == selectedMarker.restaurant_id }.first!
            customInfoWindow.drawRoutButton.tag = marker.userData as! Int
            customInfoWindow.titleLabel.text = object.label
            customInfoWindow.descLabel.text = selectedMarker.name
        } else {
            customInfoWindow.titleLabel.numberOfLines = 2
            customInfoWindow.widthRoutConstraints.constant = 0
            customInfoWindow.titleCenterConstraints.constant = MP_INSET/2
            customInfoWindow.titleLabel.text = locationAddress
        }
        
        customInfoWindow.layoutIfNeeded()
        return customInfoWindow
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        let tag = marker.userData as! Int
        if tag != myUserData {
            let address = addresses[marker.userData as! Int]
            drawRoute(address)
//            let object = objects.filter { $0.id == address.restaurant_id }.first!
//            output.didSelectObject(object)
        }
    }
}

//MARK: - extension for UITableView -
extension MapViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addresses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let address = addresses[indexPath.row]
        let object = objects.filter { $0.id == address.restaurant_id }.first!

        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifire) as! MapObjectsCell
        cell.setValues(NSURL(string: object.src)!, name: object.label, address: address.name, distance: String(format: "%.2f km", address.distance/1000))

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let address = addresses[indexPath.row]
        let object = objects.filter { $0.id == address.restaurant_id }.first!
        output.didSelectObject(object)
    }
}
