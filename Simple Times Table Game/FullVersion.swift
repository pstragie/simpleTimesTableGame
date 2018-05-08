//
//  FullVersion.swift
//  Simple Times Table Game
//
//  Created by Pieter Stragier on 20/03/2018.
//  Copyright © 2018 PWS-apps. All rights reserved.
//

import Foundation

public struct STTGFull {
    
    public static let FullVersion = "STTGFull2"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [STTGFull.FullVersion]
    
    public static let store = IAPHelper(productIds: STTGFull.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

