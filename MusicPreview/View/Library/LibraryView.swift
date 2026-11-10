//
//  LibraryView.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import SwiftUI

struct LibraryView: View {
  @StateObject var viewModel: LibraryViewModel = LibraryViewModel(libraryUseCase: Injection.sharedInstance.provideLibraryUseCase())
  @EnvironmentObject private var playerViewModel: PlayerViewModel

  var body: some View {
    Group {
      if !viewModel.hasLoaded {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else if viewModel.savedTracks.isEmpty {
        emptyState
      } else {
        trackList
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
    .onAppear {
      viewModel.fetchSavedTracks()
    }
  }

  private var trackList: some View {
    List {
      ForEach(viewModel.savedTracks) { track in
        Button {
          playerViewModel.play(track)
        } label: {
          TrackView(track: track, nowPlaying: playerViewModel.track?.id == track.id)
        }
        .buttonStyle(.plain)
        .listRowSeparator(.hidden, edges: track.id == viewModel.savedTracks.first?.id ? .top : [])
        .listRowSeparator(.hidden, edges: track.id == viewModel.savedTracks.last?.id ? .bottom : [])
        .swipeActions(edge: .leading) {
          Button {
            viewModel.deleteTrack(id: track.id)
          } label: {
            Image(systemName: "trash")
          }
          .tint(.red)
        }
      }
    }
    .listStyle(.plain)
    .scrollIndicators(.automatic)
  }

  private var emptyState: some View {
    ContentUnavailableView(
      "Your library is empty",
      systemImage: "music.note.list",
      description: Text("Tracks you save will appear here.")
    )
  }
}
