//
//  TrackEntity.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 06/11/26.
//

import Foundation
import RealmSwift

class TrackEntity: Object {
  @Persisted(primaryKey: true) var id: String
  @Persisted var title: String
  @Persisted var artist: String
  @Persisted var artworkUrlLarge: String
  @Persisted var artworkUrlSmall: String
  @Persisted var previewUrl: String
  @Persisted var durationMillis: Int
}
