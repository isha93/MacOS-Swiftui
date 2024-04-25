//
//  Networker.swift
//  Poke-Card
//
//  Created by NurFajar, Isa | INPD on 2024/03/31.
//

import Foundation
import Combine
import SwiftUI

protocol NetworkerProtocol: AnyObject {
    func taskAsync<T>(type: T.Type,
                      endPoint: NetworkFactory,
                      isMultipart: Bool
    ) async throws -> T where T: Decodable
}

final class Networker: NetworkerProtocol {
    var data: Data = Data()
    var response: URLResponse = URLResponse()
    func taskAsync<T>(type: T.Type, endPoint: NetworkFactory, isMultipart: Bool) async throws -> T where T: Decodable {
        do {
            try await self.isMultipart(endPoint: endPoint, isMultipart: isMultipart)
        } catch {
            throw NetworkError.internetError(message: "Connection Error")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.middlewareError(code: 500, message: "Connection Error")
        }
        
        #if DEBUG
        let dataString = String(decoding: data, as: UTF8.self)
        print("Endpoint: \(endPoint.path)")
        print("Request: \(endPoint.bodyParam ?? ["":""])")
        print("Response : \(dataString)")
        #endif
        
        guard 200..<300 ~= httpResponse.statusCode else {
            if httpResponse.statusCode == 401 {
                throw NetworkError.unAuthorized
            }
            let res  = try JSONDecoder().decode(NetworkHandle.self, from: data)
            throw NetworkError.middlewareError(code: res.code, message: res.message)
        }
        
        do {
            let decoder = JSONDecoder()
            let dataNew = try decoder.decode(type, from: data)
            return dataNew
        } catch let decodingError as DecodingError {
            #if DEBUG
            print(decodingError)
            #endif
            throw NetworkError.decodingError(message: decodingError.errorDescription ?? "")
        }
    }
}

extension Networker {
    private func isMultipart(endPoint: NetworkFactory, isMultipart: Bool) async throws {
        if isMultipart {
            let (data, response) = try await URLSession.shared.upload(
                for: endPoint.urlRequestMultiPart,
                from: endPoint.createBodyWithParameters(
                    parameters: endPoint.bodyParam ?? [:],
                    imageDataKey: endPoint.data,
                    boundary: endPoint.boundary))
            self.data = data
            self.response = response
        } else {
            let (data, response) = try await URLSession.shared.data(for: isMultipart ? endPoint.urlRequestMultiPart  : endPoint.urlRequest)
            self.data = data
            self.response = response
        }
    }
}
