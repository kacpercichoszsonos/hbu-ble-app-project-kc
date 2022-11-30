//
//  ViewModelProtocol.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 15/11/2022.
//

import Foundation

protocol ViewModelProtocol: ViewModel {
    associatedtype UpdateType
    var update: ((UpdateType) -> Void)? {get set}
}
