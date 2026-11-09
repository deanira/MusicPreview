//
//  PlayerView.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import Kingfisher
import SwiftUI

struct PlayerView: View {
  @StateObject var viewModel: PlayerViewModel = PlayerViewModel(playerUseCase: Injection.sharedInstance.providePlayerUseCase())

  var body: some View {
    VStack {
      if let track = viewModel.track,
         let artworkUrlLarge = URL(string: track.artworkUrlLarge) {
        KFImage(artworkUrlLarge)
          .resizable()
          .frame(width: 100, height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 8))
      }
    }
    .frame(maxWidth: .infinity)
  }
}
