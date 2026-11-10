import Kingfisher
import SwiftUI
import Playgrounds

struct ContentView: View {
  @StateObject private var player = PlayerViewModel(
    playerUseCase: Injection.sharedInstance.providePlayerUseCase(),
    audioPlayerManager: AudioPlayerManager.shared
  )
  @Namespace private var namespace

  var body: some View {
    TabView {
      Tab {
        NavigationStack { HomeView() }
      } label: {
        Image(systemName: "house")
        Text("Home")
      }

      Tab {
        NavigationStack { SearchView() }
      } label: {
        Image(systemName: "magnifyingglass")
        Text("Search")
      }

      Tab {
        NavigationStack { LibraryView() }
      } label: {
        Image(systemName: "bookmark")
        Text("Library")
      }
    }
    .tabViewBottomAccessory(isEnabled: player.hasTrack) {
      MiniPlayerView()
        .matchedTransitionSource(id: "player", in: namespace)
        .onTapGesture { player.showNowPlaying = true }
    }
    .tabBarMinimizeBehavior(.onScrollDown)
    .sheet(isPresented: $player.showNowPlaying) {
      PlayerView()
        .navigationTransition(.zoom(sourceID: "player", in: namespace))
    }
    .environmentObject(player)
  }
}

#Preview {
  ContentView()
}

#Playground {
  _ = 1 + 2
}
