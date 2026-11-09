//
//  URLRequestUtils.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 01/11/26.
//

import Alamofire
import Foundation

struct URLRequestUtils {
  static func setupURLRequest(from modelRequest: NetworkModelRequest) throws -> URLRequest {
    let baseURL = modelRequest.baseURL
    let url = try baseURL.asURL().appendingPathComponent(modelRequest.path)

    let encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default
    let request = try URLRequest(url: url, method: .get)

    return try modelRequest.parameters.map { try encoder.encode($0, into: request) } ?? request
  }
}
