//
//  Utils.swift
//  MoviesDB
//
//  Created by Admin on 13/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

// MARK: - Helper functions for creating encoders and decoders
public func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

public func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
// MARK: - Alamofire response handlers
