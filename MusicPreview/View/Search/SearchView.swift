//
//  SearchView.swift
//  MusicPreview
//
//  Created by Deanira Fadrinaldi on 07/11/26.
//

import SwiftUI

struct SearchView: View {
  @StateObject var viewModel: SearchViewModel = SearchViewModel(searchUseCase: Injection.sharedInstance.provideSearchUseCase())
  @EnvironmentObject private var playerViewModel: PlayerViewModel

  var body: some View {
    ZStack {
      List {
        ForEach(viewModel.resultTracks) { track in
          Button {
            playerViewModel.play(track)
            playerViewModel.showNowPlaying = true
          } label: {
            TrackView(track: track, nowPlaying: playerViewModel.track?.id == track.id)
          }
          .buttonStyle(.plain)
          .listRowSeparator(.hidden, edges: track.id == viewModel.resultTracks.first?.id ? .top : [])
          .listRowSeparator(.hidden, edges: track.id == viewModel.resultTracks.last?.id ? .bottom : [])
          .swipeActions(edge: .trailing) {
            Button {
              viewModel.addSavedTrack(track)
            } label: {
              Image(systemName: "bookmark")
            }
            .tint(.green)
          }
        }
      }
      .listStyle(.plain)

      if viewModel.resultTracks.isEmpty {
        if viewModel.isLoading {
          ProgressView()
        } else if !viewModel.errorMessage.isEmpty {
          VStack {
            Text("Error: \(viewModel.errorMessage)")
              .multilineTextAlignment(.center)
            Button {
              viewModel.searchTracks()
            } label: {
              Text("Try Again")
            }
          }
          .padding()
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
