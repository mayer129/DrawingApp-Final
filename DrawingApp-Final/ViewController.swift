//
//  ViewController.swift
//  DrawingApp
//
//  Created by Travis Mayer on 12/15/20.
//

import UIKit
import PencilKit
import PhotosUI

class ViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {


    @IBOutlet weak var canvasView: PKCanvasView!
    
    
    let canvasWidth: CGFloat = 768
    let canvasOverscrollHeight: CGFloat = 500
    var toolPicker: PKToolPicker!
    var drawing = PKDrawing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.delegate = self
        canvasView.drawing = drawing
        
        canvasView.alwaysBounceVertical = true
        canvasView.drawingPolicy = .anyInput
        
        
        toolPicker = PKToolPicker()
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        
        
    }
    

    
    @IBAction func saveImage(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, false, UIScreen.main.scale)
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.creationRequestForAsset(from: image!)}, completionHandler: {success, error in
                // why hello there
            })
        }
        //UserDefaults.standard.removeObject(forKey: "drawings")
       
    }
    
    @IBAction func shareImage(_ sender: Any) {
        let shareText = "Check out my cool drawing!"
        let shareImage = canvasView.drawing.image(
          from: canvasView.bounds, scale: UIScreen.main.scale)
        let shareAll = [shareText, shareImage] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func saveDrawing(_ sender: Any) {
        StorageHandler.set(value: canvasView.drawing)
    }
    
    @IBAction func togglePicker(_ sender: Any) {
        if canvasView.isFirstResponder {
            canvasView.resignFirstResponder()
        } else {
            canvasView.becomeFirstResponder()
        }

    }
    
    func changeDrawing(value: PKDrawing) {
        canvasView.drawing = value
    }
    
    
    
}

