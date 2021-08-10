//
//  GameUIConstraintsSetter.swift
//  Pairs
//
//  Created by Irakli Lomidze on 05.08.21.
//

import Foundation
import UIKit

extension GameController {
    /// Adds constraints on IBOutlets
    func setUIConstraints() {
        card1.translatesAutoresizingMaskIntoConstraints = false
        card2.translatesAutoresizingMaskIntoConstraints = false
        card3.translatesAutoresizingMaskIntoConstraints = false
        card4.translatesAutoresizingMaskIntoConstraints = false
        card5.translatesAutoresizingMaskIntoConstraints = false
        card6.translatesAutoresizingMaskIntoConstraints = false
        card7.translatesAutoresizingMaskIntoConstraints = false
        card8.translatesAutoresizingMaskIntoConstraints = false
        card9.translatesAutoresizingMaskIntoConstraints = false
        card10.translatesAutoresizingMaskIntoConstraints = false
        card11.translatesAutoresizingMaskIntoConstraints = false
        card12.translatesAutoresizingMaskIntoConstraints = false
        card13.translatesAutoresizingMaskIntoConstraints = false
        card14.translatesAutoresizingMaskIntoConstraints = false
        
        let cardDimensions = getCardDimensions(with: CGFloat(0.5))
        
        // horizontal constraints for card1
        let widthFreeSpace: CGFloat = view.safeAreaLayoutGuide.layoutFrame.width - numOfCols*cardDimensions.cardWidth
        
        let horizontalFreeSpace = widthFreeSpace / (numOfCols+1)
        let borderSpacingHorizontal: CGFloat

        if horizontalFreeSpace > 10 {
            borderSpacingHorizontal = horizontalFreeSpace - 5
        } else {
            borderSpacingHorizontal = horizontalFreeSpace
        }
        
        // vertical constraints for card1
        let heightFreeSpace: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height - numOfRows*cardDimensions.cardHeight
        
        let verticalFreeSpace = heightFreeSpace / (numOfRows+1)
        let borderSpacingVertical: CGFloat
        
        if verticalFreeSpace > 10 {
            borderSpacingVertical = verticalFreeSpace - 5
        } else {
            borderSpacingVertical = verticalFreeSpace
        }
        
        // adding constraints
        let leadingConstraint = card1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: borderSpacingHorizontal)
        let topConstraint = card1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: borderSpacingVertical)
        let cardWidth = card1.widthAnchor.constraint(equalToConstant: cardDimensions.cardWidth)
        let cardHeight = card1.heightAnchor.constraint(equalToConstant: cardDimensions.cardHeight)

        let c2Width = card2.widthAnchor.constraint(equalTo: card1.widthAnchor)
        let c2Height = card2.heightAnchor.constraint(equalTo: card1.heightAnchor)
        let c2HPos = card2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -borderSpacingHorizontal)
        let c2VPos = card2.centerYAnchor.constraint(equalTo: card1.centerYAnchor)

        let c3Width = card3.widthAnchor.constraint(equalTo: card1.widthAnchor)
        let c3Height = card3.heightAnchor.constraint(equalTo: card1.heightAnchor)
        let c3HPos = card3.centerXAnchor.constraint(equalTo: card1.centerXAnchor)
        let c3VPos = card3.topAnchor.constraint(equalTo: card1.bottomAnchor, constant: verticalFreeSpace)

        let c4Width = card4.widthAnchor.constraint(equalTo: card1.widthAnchor)
        let c4Height = card4.heightAnchor.constraint(equalTo: card1.heightAnchor)
        let c4HPos = card4.centerXAnchor.constraint(equalTo: card2.centerXAnchor)
        let c4VPos = card4.centerYAnchor.constraint(equalTo: card3.centerYAnchor)

        let c5Width = card5.widthAnchor.constraint(equalTo: card1.widthAnchor)
        let c5Height = card5.heightAnchor.constraint(equalTo: card1.heightAnchor)
        let c5HPos = card5.centerXAnchor.constraint(equalTo: card1.centerXAnchor)
        let c5VPos = card5.topAnchor.constraint(equalTo: card3.bottomAnchor, constant: verticalFreeSpace)

        let c6Width = card6.widthAnchor.constraint(equalTo: card1.widthAnchor)
        let c6Height = card6.heightAnchor.constraint(equalTo: card1.heightAnchor)
        let c6HPos = card6.centerXAnchor.constraint(equalTo: card4.centerXAnchor)
        let c6VPos = card6.centerYAnchor.constraint(equalTo: card5.centerYAnchor)
        
        let c7Width = card7.widthAnchor.constraint(equalTo: card1.widthAnchor)
        let c7Height = card7.heightAnchor.constraint(equalTo: card1.heightAnchor)
        let c7HPos = card7.centerXAnchor.constraint(equalTo: card1.centerXAnchor)
        let c7VPos = card7.topAnchor.constraint(equalTo: card5.bottomAnchor, constant: verticalFreeSpace)

        let c8Width = card8.widthAnchor.constraint(equalTo: card1.widthAnchor)
        let c8Height = card8.heightAnchor.constraint(equalTo: card1.heightAnchor)
        let c8HPos = card8.centerXAnchor.constraint(equalTo: card6.centerXAnchor)
        let c8VPos = card8.centerYAnchor.constraint(equalTo: card7.centerYAnchor)
        
        let c9Width = card9.widthAnchor.constraint(equalTo: card1.widthAnchor)
        let c9Height = card9.heightAnchor.constraint(equalTo: card1.heightAnchor)
        let c9HPos = card9.centerXAnchor.constraint(equalTo: card1.centerXAnchor)
        let c9VPos = card9.topAnchor.constraint(equalTo: card7.bottomAnchor, constant: verticalFreeSpace)

        let c10Width = card10.widthAnchor.constraint(equalTo: card1.widthAnchor)
        let c10Height = card10.heightAnchor.constraint(equalTo: card1.heightAnchor)
        let c10HPos = card10.centerXAnchor.constraint(equalTo: card8.centerXAnchor)
        let c10VPos = card10.centerYAnchor.constraint(equalTo: card9.centerYAnchor)
        
        let c11Width = card11.widthAnchor.constraint(equalTo: card1.widthAnchor)
        let c11Height = card11.heightAnchor.constraint(equalTo: card1.heightAnchor)
        let c11HPos = card11.centerXAnchor.constraint(equalTo: card1.centerXAnchor)
        let c11VPos = card11.topAnchor.constraint(equalTo: card9.bottomAnchor, constant: verticalFreeSpace)

        let c12Width = card12.widthAnchor.constraint(equalTo: card1.widthAnchor)
        let c12Height = card12.heightAnchor.constraint(equalTo: card1.heightAnchor)
        let c12HPos = card12.centerXAnchor.constraint(equalTo: card10.centerXAnchor)
        let c12VPos = card12.centerYAnchor.constraint(equalTo: card11.centerYAnchor)
        
        let c13Width = card13.widthAnchor.constraint(equalTo: card1.widthAnchor)
        let c13Height = card13.heightAnchor.constraint(equalTo: card1.heightAnchor)
        let c13HPos = card13.centerXAnchor.constraint(equalTo: card1.centerXAnchor)
        let c13VPos = card13.topAnchor.constraint(equalTo: card11.bottomAnchor, constant: verticalFreeSpace)

        let c14Width = card14.widthAnchor.constraint(equalTo: card1.widthAnchor)
        let c14Height = card14.heightAnchor.constraint(equalTo: card1.heightAnchor)
        let c14HPos = card14.centerXAnchor.constraint(equalTo: card12.centerXAnchor)
        let c14VPos = card14.centerYAnchor.constraint(equalTo: card13.centerYAnchor)
        
        

        NSLayoutConstraint.activate([leadingConstraint, topConstraint, cardWidth, cardHeight, c2Height, c2Width, c2HPos, c2VPos, c3Width, c3Height, c3HPos, c3VPos, c4Width, c4Height, c4HPos, c4VPos, c5Width, c5Height, c5HPos, c5VPos, c6Width, c6Height, c6HPos, c6VPos, c7Width, c7Height, c7HPos, c7VPos, c8Width, c8Height, c8HPos, c8VPos, c9Width, c9Height, c9HPos, c9VPos, c10Width, c10Height, c10HPos, c10VPos, c11Width, c11Height, c11HPos, c11VPos, c12Width, c12Height, c12HPos, c12VPos, c13Width, c13Height, c13HPos, c13VPos, c14Width, c14Height, c14HPos, c14VPos])
    }
    
    /// Returns appropriate size for cards - so that 7x2 array can fit in the device
    func getCardDimensions(with aspectRatio: CGFloat) -> (cardWidth: CGFloat, cardHeight: CGFloat){
        let viewWidth = view.safeAreaLayoutGuide.layoutFrame.width
        let viewHeight = view.safeAreaLayoutGuide.layoutFrame.height
        
        var cardWidth: CGFloat = 0
        var cardHeight: CGFloat = 0
        
        var widthCoef = CGFloat(0.4)
        
        while true {
            cardWidth = viewWidth * widthCoef
            cardHeight = cardWidth * aspectRatio
            
            if cardHeight*numOfRows + 15 < viewHeight {
                break
            } else {
                widthCoef -= 0.05
                if widthCoef <= 0.05 {
                    fatalError("Something's wrong with the safeAreaLayout sizes")
                }
            }
        }
        return (cardWidth, cardHeight)
    }
}
