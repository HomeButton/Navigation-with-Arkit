//
//  ARViewController.swift
//  HomeButtonWelcomePage
//
//  Created by Yifan Tian on 11/16/17.
//  Copyright © 2017 Team#2. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

//    @IBOutlet weak var MapView: MKMapView!
    
    //
    //  ViewController.swift
    //  Turn by Turn
    //
    //  Created by Kyle Lee on 6/24/17.
    //  Copyright © 2017 Kyle Lee. All rights reserved.
    //
    
        @IBOutlet weak var directionsLabel: UILabel!
        //    @IBOutlet weak var locationLabel: UILabel!
        @IBOutlet weak var searchBar: UISearchBar!
        @IBOutlet var sceneView: ARSCNView!
    
        @IBOutlet weak var mapView: MKMapView!
    
//        @IBOutlet weak var mapView: MKMapView!
    
        let locationManager = CLLocationManager()
        var currentCoordinate: CLLocationCoordinate2D!
        
        var steps = [MKRouteStep]()
        let speechSynthesizer = AVSpeechSynthesizer()
        
        var stepCounter = 0
        var message = ""
        var step = 0;
        
        var sourcelatitude = 0.0
        var sourcelongitude = 0.0
        var deslatitude = 0.0
        var deslongitude = 0.0
        var theHeading = 0.0;
        
        var text = SCNText(string: "start", extrusionDepth:1)
        var material = SCNMaterial()
        //    material.diffuse.contents = UIColor.green
        //    text.materials = [material]
        
        var node = SCNNode()
        var oldlocation = Double(0.0);
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            locationManager.startUpdatingHeading()
            locationManager.requestAlwaysAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
            
            // Set the view's delegate
            //        sceneView.delegate = self
            
            //        let text = SCNText(string: "start journey!", extrusionDepth:1)
            //        let material = SCNMaterial()
            text = SCNText(string: "start journey!", extrusionDepth:1)
            material.diffuse.contents = UIColor.green
            text.materials = [material]
            
            //        let node = SCNNode()
            node.position = SCNVector3(x:-1, y:0.02, z:-1.1)
            node.scale = SCNVector3(x:0.01, y:0.01, z:0.01)
            node.geometry = text
            
            sceneView.scene.rootNode.addChildNode(node)
            sceneView.autoenablesDefaultLighting = true
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Create a session configuration
            let configuration = ARWorldTrackingConfiguration()
            
            // Run the view's session
            sceneView.session.run(configuration)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Pause the view's session
            sceneView.session.pause()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Release any cached data, images, etc that aren't in use.
        }
        
        func session(_ session: ARSession, didFailWithError error: Error) {
            // Present an error message to the user
            
        }
        
        func sessionWasInterrupted(_ session: ARSession) {
            // Inform the user that the session has been interrupted, for example, by presenting an overlay
            
        }
        
        func sessionInterruptionEnded(_ session: ARSession) {
            // Reset tracking and/or remove existing anchors if consistent tracking is required
            
        }
        
        func getDirections(to destination: MKMapItem) {
            
            self.deslatitude = Double(destination.placemark.coordinate.latitude)
            self.deslongitude = Double(destination.placemark.coordinate.longitude)
            
            let sourcePlacemark = MKPlacemark(coordinate: currentCoordinate)
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            
            let directionsRequest = MKDirectionsRequest()
            directionsRequest.source = sourceMapItem
            directionsRequest.destination = destination
            directionsRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionsRequest)
            directions.calculate { (response, _) in
                guard let response = response else { return }
                guard let primaryRoute = response.routes.first else { return }
                
                self.mapView.add(primaryRoute.polyline)
                
                self.locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
                
                self.steps = primaryRoute.steps
                
                let step1 = primaryRoute.steps[0]
                print(step1.instructions)
                print(step1.distance)
                
                let step2 = primaryRoute.steps[1]
                print(step2.instructions)
                print(step2.distance)
                
                for i in 0 ..< primaryRoute.steps.count {
                    let step = primaryRoute.steps[i]
                    print(step.instructions)
                    print(step.distance)
                    let region = CLCircularRegion(center: step.polyline.coordinate,
                                                  radius: 20,
                                                  identifier: "\(i)")
                    self.locationManager.startMonitoring(for: region)
                    let circle = MKCircle(center: region.center, radius: region.radius)
                    self.mapView.add(circle)
                }
                
                let initialMessage = "In \(self.steps[0].distance) meters, \(self.steps[0].instructions) then in \(self.steps[1].distance) meters, \(self.steps[1].instructions)."
                self.message = initialMessage
                self.directionsLabel.text = initialMessage
                let speechUtterance = AVSpeechUtterance(string: initialMessage)
                self.speechSynthesizer.speak(speechUtterance)
                self.stepCounter += 1
                
                self.text = SCNText(string: initialMessage, extrusionDepth:1)
                self.material.diffuse.contents = UIColor.green
                self.text.materials = [self.material]
                
                //            node.position = SCNVector3Make(node.position.x, node.position.y, node.position.z+2.0);
                self.node.position = SCNVector3(x:-1, y:0.02, z:-1.1)
                self.node.scale = SCNVector3(x:0.01, y:0.01, z:0.01)
                self.node.geometry = self.text
                self.sceneView.scene.rootNode.addChildNode(self.node)
                self.sceneView.autoenablesDefaultLighting = true
            }
        }
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            
            let location = locations[0]
            currentCoordinate = location.coordinate
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            mapView.setRegion(region,animated: true)
            
            self.mapView.showsUserLocation = true
            //        self.locationLabel.text = location.coordinate.latitude.description+" "+location.coordinate.longitude.description
            
            
            //        let theHeading = manager.heading?.trueHeading
            //        CLLocationDirection theHeading = newHeading.magneticHeading;
            
            let lon = Double(location.coordinate.longitude)
            let lat = Double(location.coordinate.latitude)
            let newlocation = lon*lon+lat*lat
            if(oldlocation == 0.0) {
                oldlocation = newlocation
            }
            print(String(oldlocation)+" "+String(newlocation))
            
            self.sourcelatitude = lat
            self.sourcelongitude = lon
            
            //        if(abs(newlocation - oldlocation) > 0.01) {
            print("update arrow")
            self.step += 1
            directionsLabel.text = self.message
            let mySession = self.sceneView.session
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -3 // Translate 10 cm in front of the camera
            translation.columns.3.x = 0 // Translate 10 cm in front of the camera       p: bottom, n: top
            translation.columns.3.y = -0 // Translate 10 cm in front of the camera    p: left, n: right
            
            //        if(self.step < 7) {
            //            self.node.position = SCNVector3(x:-0.1, y:-0.1, z:-0.1)
            //        }
            
            print("lat lon")
            print(String(self.sourcelatitude)+" "+String(self.sourcelongitude))
            print(String(self.deslatitude)+" "+String(self.deslongitude))
            
            let Radius = 6.3781*1000000;
            let pi = 3.1415926
            let latdiff = self.deslatitude - self.sourcelatitude
            let londiff = self.deslongitude - self.sourcelongitude
            print("diff: "+String(latdiff)+" "+String(londiff))
            let ydis = (pi/180)*latdiff*Radius
            let xdis = (pi/180)*londiff*(Radius*cos(pi*self.sourcelatitude/180))
            
            let dis = sqrt(xdis*xdis+ydis*ydis)
            
            //            self.mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
            //            let heading = self.mapView.userLocation.heading?.headingAccuracy
            
            print("heading: "+String(self.theHeading))
            print(String(xdis)+" "+String(ydis))
            
            if(self.step > 5) {
                self.node.simdTransform = matrix_multiply((mySession.currentFrame?.camera.transform)!, translation)
            }
            
//            self.text = SCNText(string: "update arrow", extrusionDepth:1)
            self.material.diffuse.contents = UIColor.green
            self.text.materials = [self.material]
            
            var correction = 0.0
            
            if(abs(self.deslongitude) > 1 ) {
                if(xdis < 0 && ydis < 0) {
                    correction = (atan(xdis/ydis)+pi)*(180/pi)
                } else if(xdis > 0 && ydis < 0 ) {
                    correction = (atan(xdis/ydis)+pi)*(180/pi)
                } else {
                    correction = atan(xdis/ydis)*(180/pi)
                }
                
            }
            print("correction: "+String(correction))
                        node.position = SCNVector3(x:0, y:-1, z:-2)
            self.node.eulerAngles = SCNVector3(x: -(3.14/180)*90, y: (3.14/180)*Float(self.theHeading-correction), z: 0)
            //        self.node.eulerAngles = SCNVector3(x: 0, y: 30, z: 0)
            self.node.scale = SCNVector3(x:1.0, y:1.0, z:1.0)
            //            self.node.geometry = self.text
            //            self.node.geometry = SCNCone();
            
            //            let cone = SCNCone(topRadius: 10, bottomRadius: 300.0, height: 2000.0)
            let cone = SCNCone(topRadius: 0.01, bottomRadius: 0.2, height: CGFloat(1.0))
            //        let cone = SCNCone(topRadius: 0.05, bottomRadius: 0.05, height: CGFloat(100.0))
            cone.firstMaterial?.diffuse.contents = UIColor.green
            //            let cone = SCNCone(topRadius: 1, bottomRadius: 1, height: CGFloat(dis))
            self.node.geometry = cone
            
            self.sceneView.scene.rootNode.addChildNode(self.node)
            self.sceneView.autoenablesDefaultLighting = true
            
            //            let newnode = SCNNode()
            //            newnode.position = SCNVector3(x:self.node.position.x+1, y:self.node.position.y+1, z:self.node.position.z+1)
            ////            newnode.simdTransform = matrix_multiply((mySession.currentFrame?.camera.transform)!, translation)
            //            newnode.scale = SCNVector3(x:0.01, y:0.01, z:0.01)
            //            newnode.geometry = self.text
            //            self.sceneView.scene.rootNode.addChildNode(newnode)
            //            self.sceneView.autoenablesDefaultLighting = true
            
            //            self.updateArrow()
            oldlocation = newlocation
            //        }
            //        let newlocation = location.coordinate.latitude.distance(to: Double)*location.coordinate.latitude.distance(to: Double)+location.coordinate.longitude.distance(to: Double)*location.coordinate.longitude.distance(to: Double)
            //
        }
        
        //    func showDirection() {
        //
        //    }
        
        func updateArrow() {
            //TODO
            print("update direction1")
            
            let mySession = self.sceneView.session
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -1 // Translate 10 cm in front of the camera
            self.node.simdTransform = matrix_multiply((mySession.currentFrame?.camera.transform)!, translation)
            
            self.text = SCNText(string: "update direction", extrusionDepth:1)
            self.material.diffuse.contents = UIColor.blue
            self.text.materials = [self.material]
            
            //  node.position = SCNVector3Make(node.position.x, node.position.y, node.position.z+2.0);
            //  self.node.position = SCNVector3(x:self.node.position.x-1, y:self.node.position.y-1, z:self.node.position.z-1)
            
            self.node.scale = SCNVector3(x:0.01, y:0.01, z:0.01)
            self.node.geometry = self.text
            // self.sceneView.scene.rootNode.addChildNode(self.node)
            // self.sceneView.autoenablesDefaultLighting = true
            let newnode = SCNNode()
            // self.sceneView.session.currentFrame?.camera.transform
            
            // newnode.position = SCNVector3(x:-1, y:0.02, z:-1.1)
            newnode.simdTransform = matrix_multiply((mySession.currentFrame?.camera.transform)!, translation)
            newnode.scale = SCNVector3(x:0.01, y:0.01, z:0.01)
            newnode.geometry = self.text
            self.sceneView.scene.rootNode.addChildNode(newnode)
            self.sceneView.autoenablesDefaultLighting = true
            
        }
        
        @IBAction func updateArrow(_ sender: UIButton) {
            //TODO
            print("update direction2")
            
            let mySession = self.sceneView.session
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -1 // Translate 10 cm in front of the camera
            self.node.simdTransform = matrix_multiply((mySession.currentFrame?.camera.transform)!, translation)
            
            self.text = SCNText(string: "update direction", extrusionDepth:1)
            self.material.diffuse.contents = UIColor.green
            self.text.materials = [self.material]
            
            // node.position = SCNVector3Make(node.position.x, node.position.y, node.position.z+2.0);
            // self.node.position = SCNVector3(x:self.node.position.x-1, y:self.node.position.y-1, z:self.node.position.z-1)
            
            self.node.scale = SCNVector3(x:0.01, y:0.01, z:0.01)
            self.node.geometry = self.text
            // self.sceneView.scene.rootNode.addChildNode(self.node)
            //  self.sceneView.autoenablesDefaultLighting = true
            
            let newnode = SCNNode()
            
            // self.sceneView.session.currentFrame?.camera.transform
            // newnode.position = SCNVector3(x:-1, y:0.02, z:-1.1)
            newnode.simdTransform = matrix_multiply((mySession.currentFrame?.camera.transform)!, translation)
            newnode.scale = SCNVector3(x:0.01, y:0.01, z:0.01)
            newnode.geometry = self.text
            self.sceneView.scene.rootNode.addChildNode(newnode)
            self.sceneView.autoenablesDefaultLighting = true
        }
        
        @IBAction func MakeCall(_ sender: Any) {
            let url:NSURL = NSURL(string:"tel://9492664539")!
            UIApplication.shared.openURL(url as URL)
        }
//    @IBAction func MakeCall(_ sender: Any) {
//    }
    
}
    
    
    
    
    extension ARViewController: CLLocationManagerDelegate {
        //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        manager.stopUpdatingLocation()
        //        guard let currentLocation = locations.first else { return }
        //        currentCoordinate = currentLocation.coordinate
        //        mapView.userTrackingMode = .followWithHeading
        //        locationLabel.text = currentLocation.coordinate.latitude.description+" "+currentLocation.coordinate.longitude.description
        //        print(locationLabel.text ?? "currentlocation")
        //    }
        
        func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
            //        print("update heading")
            self.theHeading = newHeading.trueHeading
            //        print(theHeading)
        }
        
        func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
            print("ENTERED")
            stepCounter += 1
            if stepCounter < steps.count {
                let currentStep = steps[stepCounter]
                let message = "In \(currentStep.distance) meters, \(currentStep.instructions)"
                self.message = message
                directionsLabel.text = message
                let speechUtterance = AVSpeechUtterance(string: message)
                speechSynthesizer.speak(speechUtterance)
                
                self.text = SCNText(string: message, extrusionDepth:1)
                self.material.diffuse.contents = UIColor.green
                self.text.materials = [self.material]
                
                self.node.position = SCNVector3(x:-1, y:0.02, z:-1.1)
                self.node.scale = SCNVector3(x:0.01, y:0.01, z:0.01)
                self.node.geometry = self.text
                self.sceneView.scene.rootNode.addChildNode(self.node)
                self.sceneView.autoenablesDefaultLighting = true
                
            } else {
                let message = "Arrived at destination"
                self.message = message
                directionsLabel.text = message
                let speechUtterance = AVSpeechUtterance(string: message)
                speechSynthesizer.speak(speechUtterance)
                stepCounter = 0
                locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
                
                self.text = SCNText(string: message, extrusionDepth:1)
                self.material.diffuse.contents = UIColor.green
                self.text.materials = [self.material]
                
                self.node.position = SCNVector3(x:-1, y:0.02, z:-1.1)
                self.node.scale = SCNVector3(x:0.01, y:0.01, z:0.01)
                self.node.geometry = self.text
                self.sceneView.scene.rootNode.addChildNode(self.node)
                self.sceneView.autoenablesDefaultLighting = true
            }
        }
    }
    
    extension ARViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(true)
            let localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.naturalLanguageQuery = "Berkeley"
            //        localSearchRequest.naturalLanguageQuery = searchBar.text
            let region = MKCoordinateRegion(center: currentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            localSearchRequest.region = region
            let localSearch = MKLocalSearch(request: localSearchRequest)
            localSearch.start { (response, _) in
                guard let response = response else { return }
                guard let firstMapItem = response.mapItems.first else { return }
                self.getDirections(to: firstMapItem)
            }
        }
    }
    
    extension ARViewController: MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = .blue
                renderer.lineWidth = 10
                return renderer
            }
            if overlay is MKCircle {
                let renderer = MKCircleRenderer(overlay: overlay)
                renderer.strokeColor = .red
                renderer.fillColor = .red
                renderer.alpha = 0.5
                return renderer
            }
            return MKOverlayRenderer()
        }
}

//extension ViewController: ARSCNViewDelegate {
//    func sceneView(_ scenceView: ARSCNView, rendererFor ) -> {
//
//        return  SCNSceneRenderer()
//    }
//}

