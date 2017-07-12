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
        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth: CGFloat = screenSize.width;
            let cellWidth = screenWidth / 13.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
            let size: CGSize = CGSize(width: cellWidth, height: cellWidth);
            
            return size;
    }

    override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        var attributes = UICollectionViewLayoutAttributes()
        attributes.frame = CGRect(x: 10, y: 10, width: 50, height: 70)
        attributes.zIndex = 10
        let path = CGPath(rect: CGRect(x: 10, y: 10, width: 50, height: 70), transform: nil)
        attributes.isHidden =  true
        
        return attributes
    }


}
