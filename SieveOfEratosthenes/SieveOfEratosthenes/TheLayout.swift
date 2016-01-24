//
//  TheLayout.swift
//  SieveOfEratosthenes
//
//  Created by Kelly Alonso-Palt on 11/5/15.
//  Copyright © 2015 Kelly Alonso. All rights reserved.
//

import UIKit

class TheLayout: UICollectionViewLayout {
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let screenWidth: CGFloat = screenSize.width;
            let cellWidth = screenWidth / 13.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
            let size: CGSize = CGSizeMake(cellWidth, cellWidth);
            
            return size;
    }

}
