//
//  SearchView.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import SwiftUI

struct SearchView: View {
  @StateObject var viewModel: SearchViewModel = SearchViewModel(searchUseCase: Injection.sharedInstance.provideSearchUseCase())
  @Environment(PlayerState.self) private var player

  var body: some View {
    ZStack {
      List {
        ForEach(viewModel.resultTracks) { track in
          Button {
            player.currentTrack = track
            player.isPlaying = true
          } label: {
            TrackView(track: track)
          }
          .buttonStyle(.plain)
          .listRowSeparator(.hidden, edges: track.id == viewModel.resultTracks.first?.id ? .top : [])
          .listRowSeparator(.hidden, edges: track.id == viewModel.resultTracks.last?.id ? .bottom : [])
        }
      }
      .listStyle(.plain)

      if viewModel.resultTracks.isEmpty {
        if viewModel.isLoading {
          ProgressView()
        } else {
          Text("Find songs")
            .frame(maxWidth: .infinity)
        }
      }
    }
    .frame(maxWidth: .infinity)
    .navigationTitle("Search")
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
    .searchable(
      text: $viewModel.query,
      placement: .navigationBarDrawer(displayMode: .always),
      prompt: "Artists, Songs, Lyrics, and More"
    )
  }
}
