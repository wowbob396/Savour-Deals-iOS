//
//  FavoritesPreviewDelegate.swift
//  Savour
//
//  Created by Chris Patterson on 8/22/17.
//  Copyright © 2017 Chris Patterson. All rights reserved.
//

import Foundation
import UIKit

extension FavoritesViewController: 	UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = FavTable.indexPathForRow(at: location),
            let cell = FavTable.cellForRow(at: indexPath) as? DealTableViewCell else {
                return nil }
        let storyboard = UIStoryboard(name: "DealDetails", bundle: nil)
        let VC = storyboard.instantiateInitialViewController() as! DealViewController
        VC.hidesBottomBarWhenPushed = true
        VC.Deal = deals[indexPath.row]
        VC.fromDetails = false
        VC.photo = VC.Deal?.restrauntPhoto
        VC.preferredContentSize =
            CGSize(width: 0.0, height: 600)
        
        previewingContext.sourceRect = cell.frame
        
        return VC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        show(viewControllerToCommit, sender: self)
    }
    
    
}
