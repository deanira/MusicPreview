//
//  HomeView.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 02/11/26.
//

import Kingfisher
import SwiftUI

struct HomeView: View {
  @StateObject var viewModel: HomeViewModel = HomeViewModel(homeUseCase: Injection.sharedInstance.provideHomeUseCase())
  @Environment(PlayerState.self) private var player

  var body: some View {
    ZStack {
      List {
        ForEach(viewModel.topTracks) { track in
          Button {
            player.currentTrack = track
            player.isPlaying = true
          } label: {
            TrackView(track: track)
          }
          .buttonStyle(.plain)
          .listRowSeparator(.hidden, edges: track.id == viewModel.topTracks.first?.id ? .top : [])
          .listRowSeparator(.hidden, edges: track.id == viewModel.topTracks.last?.id ? .bottom : [])
        }
      }
      .frame(maxHeight: .infinity)
      .scrollIndicators(.hidden)
      .listStyle(.plain)

      if viewModel.isLoadingTopTracks {
        ProgressView()
      }
    }
    .navigationTitle("Home")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        NavigationLink {
          ProfileView()
        } label: {
          Image(systemName: "person")
            .foregroundStyle(.blue)
        }
      }
    }
    .onAppear {
      if viewModel.topTracks.count == 0 {
        viewModel.fetchTopTracks()
      }
    }
  }
}

struct TrackView: View {
  let track: TrackModel

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
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
