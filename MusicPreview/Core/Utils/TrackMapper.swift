//
//  TrackMapper.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 02/11/26.
//

import Foundation
import Realm
import RealmSwift

struct TrackMapper {
  static func mapTrackResponsesToDomains(input: [TrackResponse]) -> [TrackModel] {
    return input.map { response in
      TrackModel(
        id: response.id ?? 0,
        title: response.title ?? "",
        artist: response.artist ?? "",
        artworkUrlLarge: response.artworkUrlLarge ?? "",
        artworkUrlSmall: response.artworkUrlSmall ?? "",
        previewUrl: response.previewUrl ?? "",
        durationMillis: response.durationMillis ?? 0
      )
    }
  }

  static func mapTrackEntitiesToDomains(input: [TrackEntity]) -> [TrackModel] {
    return input.map { entity in
      TrackModel(
        id: Int(entity.id) ?? 0,
        title: entity.title,
        artist: entity.artist,
        artworkUrlLarge: entity.artworkUrlLarge,
        artworkUrlSmall: entity.artworkUrlSmall,
        previewUrl: entity.previewUrl,
        durationMillis: entity.durationMillis
      )
    }
  }

  static func mapTrackDomainToEntity(input: TrackModel) -> TrackEntity {
    let entity = TrackEntity()
    entity.id = String(input.id)
    entity.title = input.title
    entity.artist = input.artist
    entity.artworkUrlLarge = input.artworkUrlLarge
    entity.artworkUrlSmall = input.artworkUrlSmall
    entity.previewUrl = input.previewUrl
    entity.durationMillis = input.durationMillis
    return entity
  }
}
