//
//  Dynamic.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 06.03.2024.
//

import Foundation

class Dynamic<T> {
    
    // MARK: - Properties
    
    typealias Listener = (T) -> Void
    private var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    // MARK: - Init
    
    init(_ v: T) {
        value = v
    }
    
    // MARK: - Methods
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
}
