//
//  PlayerView.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import Kingfisher
import SwiftUI

struct PlayerView: View {
  @EnvironmentObject private var viewModel: PlayerViewModel

  var body: some View {
    VStack(spacing: 28) {
      KFImage(viewModel.artworkURL)
        .resizable()
        .scaledToFit()
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 12, y: 6)
        .padding(.horizontal, 32)

      VStack(spacing: 4) {
        Text(viewModel.title).font(.title2.bold()).lineLimit(1)
        Text(viewModel.artist).foregroundStyle(.secondary).lineLimit(1)
      }
      .padding(.horizontal)

      VStack(spacing: 4) {
        Slider(
          value: $viewModel.currentTime,
          in: viewModel.sliderRange,
          onEditingChanged: viewModel.scrubbingChanged
        )
        HStack {
          Text(viewModel.currentTimeText)
          Spacer()
          Text(viewModel.durationText)
        }
        .font(.caption.monospacedDigit())
        .foregroundStyle(.secondary)
      }
      .padding(.horizontal, 32)

      Button {
        viewModel.togglePlayPause()
      } label: {
        Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
          .resizable()
          .frame(width: 72, height: 72)
      }
      .buttonStyle(.plain)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.vertical)
  }
}
