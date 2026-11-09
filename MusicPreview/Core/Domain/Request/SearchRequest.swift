//
//  SearchRequest.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 01/11/26.
//

struct SearchRequest: Codable {
  var id: String?
  var term: String?
  var media: String?
  var entity: String?
  var limit: Int?
}
