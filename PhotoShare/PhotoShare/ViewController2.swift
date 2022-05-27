//
//  ViewController2.swift
//  PhotoShare
//
//  Created by lab5 on 20.05.2022.
//

import UIKit
import Photos
import ImageIO

var image : UIImage = UIImage()

class ViewController2 : UIViewController{
    @IBOutlet weak var ScreenShotPreview: UIImageView!
    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var sharebutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ScreenShotPreview.image = image
        
    }
    @IBAction func tappedEditing(_ sender: Any) {
        let shareSheetVC = UIActivityViewController(activityItems: [ScreenShotPreview.image!], applicationActivities: nil)

        present(shareSheetVC,animated: true)
    }
    @IBAction func tappedShare(_ sender: Any) {
    }
    
}
