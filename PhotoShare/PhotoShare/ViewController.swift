//
//  ViewController.swift
//  PhotoShare
//
//  Created by lab5 on 9.05.2022.
//

import UIKit
import Photos
import CoreLocation
import CoreGraphics
import Accelerate

var sourceImage : UIImage = UIImage()
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraPreview: UIImageView!
    @IBOutlet weak var PhotoLibraryButton:UIButton!
    @IBOutlet weak var PhotoLibraryPreview: UIImageView!
    @IBOutlet weak var btngotosht: UIButton!
    @IBOutlet weak var ScreenShotButton: UIButton!
    @IBOutlet weak var Latitude: UILabel!
    @IBOutlet weak var Longitude: UILabel!
    @IBOutlet weak var Adress: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var firstDesription: UILabel!
    var imagePickerController = UIImagePickerController()
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationConfig()
        checkPermission()
        btngotosht.isHidden = true
        PhotoLibraryButton.isHidden = false
        cameraButton.isHidden = false
        textBox.isHidden = true
        clearButton.isHidden = true
        ScreenShotButton.isHidden = true
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func clearData(_ sender: Any) {
        textBox.text = nil
        viewLabel.text = nil
        PhotoLibraryPreview.image = nil
        PhotoLibraryButton.isHidden = false
        cameraPreview.image = nil
        cameraButton.isHidden = false
        firstDesription.isHidden = false
        clearButton.isHidden = true
        btngotosht.isHidden = true
        ScreenShotButton.isHidden = true
    }
    
    @IBAction func ScreenShoot(_ sender: Any) {
        PhotoLibraryButton.isHidden = true
        cameraButton.isHidden = true
        clearButton.isHidden = false
        firstDesription.isHidden = true
        viewLabel.text = textBox.text
        let screenshot = self.view.takeScreenShot()
        sourceImage = screenshot

        // The shortest side
        let sideLength = min(1500.0,1800.0)
        print(sourceImage.size.width,
              sourceImage.size.height)

        // Determines the x,y coordinate of a centered
        // sideLength by sideLength square
        let sourceSize = sourceImage.size
        let xOffset = (sourceSize.width - sideLength) / 2.0
        let yOffset = (sourceSize.height - sideLength) / 2.0

        // The cropRect is the rect of the image to keep,
        // in this case centered
        let cropRect = CGRect(
            x: xOffset,
            y: yOffset,
            width: sideLength,
            height: sideLength
        ).integral

        // Center crop the image
        let sourceCGImage = sourceImage.cgImage!
        let croppedCGImage = sourceCGImage.cropping(
            to: cropRect
        )!
        let croppedImage = UIImage(
            cgImage: croppedCGImage,
            scale: sourceImage.imageRendererFormat.scale,
            orientation: sourceImage.imageOrientation
        )
        image = croppedImage
        btngotosht.isHidden = false
    }
    
    @IBAction func camareActionController(_ sender: Any) {
        cameraButton.isHidden = true
        PhotoLibraryButton.isHidden = true
        textBox.isHidden = false
        ScreenShotButton.isHidden = false
        firstDesription.isHidden = true
        clearButton.isHidden = false
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    @IBAction func tappedLibraryButton(_ sender: Any) {
        cameraButton.isHidden = true
        PhotoLibraryButton.isHidden = true
        textBox.isHidden = false
        ScreenShotButton.isHidden = false
        firstDesription.isHidden = true
        clearButton.isHidden = false
        self.imagePickerController.sourceType = .photoLibrary
        self.imagePickerController.allowsEditing = true
        self.imagePickerController.delegate = self
        
        self.present(self.imagePickerController,animated: true,completion: nil)
    }
    
    func checkPermission() {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
            PHPhotoLibrary.requestAuthorization({(status: PHAuthorizationStatus)->Void in () })
        }
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
        } else{
            PHPhotoLibrary
                .requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status:PHAuthorizationStatus){
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
            print("Access Granted To Use Photo Library")
        } else{
            print("We Don't Have Access To Your Photos")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker.sourceType == .photoLibrary {
        PhotoLibraryPreview?.image = info[UIImagePickerController.InfoKey.originalImage]as?UIImage
        } else {
        cameraPreview?.image = info[UIImagePickerController.InfoKey.editedImage]as?UIImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func locationConfig (){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            print("Location Enabled")
            locationManager.startUpdatingLocation()
        } else {
            print("Location Not Enabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        Latitude.text = "Latitude: \(latitude)"
        Longitude.text = "Longitude: \(longitude)"
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation){ [self](placemarks,error) in
            if(error != nil){ print("Error in reversGeocodeLocation") }
            let placemark = placemarks! as [CLPlacemark]
            if (placemark.count>0){
            let placemark = placemarks![0]
            let locality = placemark.locality ?? ""
            let administrativeArea = placemark.administrativeArea ?? ""
            let country = placemark.country ?? ""
            self.Adress.text = "Adress: \(locality), \(administrativeArea), \(country)"
            }
        }
    }
}
extension UIView{
    func takeScreenShot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            return image!
            
        }
        return UIImage()
    }
}
