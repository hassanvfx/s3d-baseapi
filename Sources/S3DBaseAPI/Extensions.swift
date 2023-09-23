//
//  File.swift
//  
//
//  Created by Eon Fluxor on 9/23/23.
//
import Foundation
extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8EncodedData: Data { Data(self.utf8) }
}
