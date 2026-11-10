//
//  TrackView.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 10/11/26.
//

import Kingfisher
import SwiftUI

struct TrackView: View {
  let track: TrackModel
  let nowPlaying: Bool?

  init(track: TrackModel, nowPlaying: Bool? = nil) {
    self.track = track
    self.nowPlaying = nowPlaying
  }

  var body: some View {
    HStack {
      if let artworkUrlSmall = URL(string: track.artworkUrlSmall) {
        KFImage(artworkUrlSmall)
          .resizable()
          .frame(width: 60, height: 60)
          .clipShape(RoundedRectangle(cornerRadius: 8))
      }

      VStack(alignment: .leading) {
        Text(track.title)
          .bold()
        Text(track.artist)
      }

      Spacer()

      if nowPlaying ?? false {
        Image(systemName: "waveform.mid")
          .symbolEffect(.bounce.up.byLayer, options: .repeat(.continuous))
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .contentShape(Rectangle())
  }
}
