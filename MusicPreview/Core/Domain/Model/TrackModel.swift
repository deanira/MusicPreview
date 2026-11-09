//
//  SongModel.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 01/11/26.
//

struct TrackModel: Equatable, Identifiable {
  let id: Int
  let title: String
  let artist: String
  let artworkUrlLarge: String
  let artworkUrlSmall: String
  let previewUrl: String
  let durationMillis: Int
}
