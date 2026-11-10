//
//  MiniPlayerView.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 10/11/26.
//

import Kingfisher
import SwiftUI

struct MiniPlayerView: View {
  @EnvironmentObject private var viewModel: PlayerViewModel

  var body: some View {
    HStack(spacing: 12) {
      KFImage(viewModel.smallArtworkURL)
        .resizable()
        .frame(width: 36, height: 36)
        .clipShape(RoundedRectangle(cornerRadius: 6))

      Text(viewModel.title).lineLimit(1)

      Spacer()

      Button {
        viewModel.togglePlayPause()
      } label: {
        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
          .frame(width: 44, height: 44)
          .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
    }
    .padding(.horizontal)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .contentShape(Rectangle())
  }
}
