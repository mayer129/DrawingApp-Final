//
//  DrawingsViewController.swift
//  DrawingApp-Final
//
//  Created by Travis Mayer on 12/15/20.
//

import UIKit
import PencilKit

final class DrawingsViewController: UICollectionViewController {
    private let reuseIdentifier = "DrawingCell";
    private let sectionInsets = UIEdgeInsets(
        top: 50.0,
        left: 20.0,
        bottom: 50.0,
        right: 20.0)
    private let itemsPerRow: CGFloat = 3
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadView()
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    
}

extension DrawingsViewController {
    override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        return StorageHandler.storageCount()
  }
    

    override func collectionView(
      _ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cellDrawingArray = StorageHandler.getStorage(key: "drawings")
        let cellDrawing = cellDrawingArray[indexPath.item]
        let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DrawingImageCellCollectionViewCell
        
        
        /*
        let cWidth: CGFloat = 96
        let thumbnailSize = CGSize(width: 192, height: 256)
        
        let aspectRatio = thumbnailSize.width / thumbnailSize.height
        let thumbnailRect = CGRect(x: 0, y: 0, width: cWidth, height: cWidth / aspectRatio)
        let thumbnailScale = UIScreen.main.scale * thumbnailSize.width / cWidth
 
        let image = cellDrawing.image(from: thumbnailRect, scale: thumbnailScale)
         
        */
        
        let bounds = CGRect(x: 0, y: 0, width: 768, height: 500)
        let boundsSize = CGSize(width: 96, height: 128)
        
        let cellDrawingUI = cellDrawing.image(from: bounds, scale: CGFloat(1.0))
        
        let image = self.resizeImage(image: cellDrawingUI, targetSize: boundsSize)
        
        cell.backgroundColor = .white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1.0
        cell.imageView.image = image
        
        return cell
    }
}


extension DrawingsViewController : UICollectionViewDelegateFlowLayout {
  //1
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    //2
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  //3
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  // 4
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}



extension DrawingsViewController {
  override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    let cellDrawingArray = StorageHandler.getStorage(key: "drawings")
    let cellDrawing = cellDrawingArray[indexPath.item]
    let drawingTab = navigationController!.viewControllers[0] as! ViewController
    drawingTab.changeDrawing(value: cellDrawing)
    
    return false
  }
}






