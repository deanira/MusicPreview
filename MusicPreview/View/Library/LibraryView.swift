//
//  LibraryView.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import SwiftUI

struct LibraryView: View {
  @StateObject var viewModel: LibraryViewModel = LibraryViewModel(libraryUseCase: Injection.sharedInstance.provideLibraryUseCase())
  @Environment(PlayerState.self) private var player

  var body: some View {
    VStack {
      List {
        ForEach(viewModel.savedTracks) { track in
          Button {
            player.currentTrack = track
            player.isPlaying = true
          } label: {
            TrackView(track: track)
          }
          .buttonStyle(.plain)
          .listRowSeparator(.hidden, edges: track.id == viewModel.savedTracks.first?.id ? .top : [])
          .listRowSeparator(.hidden, edges: track.id == viewModel.savedTracks.last?.id ? .bottom : [])
        }
      }
      .listStyle(.plain)
      .frame(maxHeight: .infinity)
      .scrollIndicators(.automatic)
      .padding(.horizontal)
      .onAppear {
        viewModel.fetchSavedTracks()
      }
    }
    .navigationTitle("Library")
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
  }
}
