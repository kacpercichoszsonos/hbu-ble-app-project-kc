//
//  ViewModel.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 30/11/2022.
//

import Foundation

class ViewModel {
    enum BaseType {
        case beginLoading
        case endLoading
    }
    var base: ((BaseType) -> Void)?
}
