import SwiftUI
import Playgrounds

@Observable
final class PlayerState {
  var currentTrack: TrackModel?
  var isPlaying = false
  var showNowPlaying = false
}

struct ContentView: View {
  @State private var player = PlayerState()
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
    .tabViewBottomAccessory(isEnabled: player.currentTrack != nil) {
      MiniPlayerView(player: player)
        .matchedTransitionSource(id: "player", in: namespace)
        .onTapGesture { player.showNowPlaying = true }
    }
    .tabBarMinimizeBehavior(.onScrollDown)
    .sheet(isPresented: $player.showNowPlaying) {
      PlayerView()
        .navigationTransition(.zoom(sourceID: "player", in: namespace))
    }
    .environment(player)
  }
}

#Preview {
  ContentView()
}

#Playground {
  _ = 1 + 2
}

struct MiniPlayerView: View {
  let player: PlayerState

  var body: some View {
    HStack(spacing: 12) {
      AsyncImage(url: URL(string: player.currentTrack?.artworkUrlSmall ?? "")) { image in
        image.resizable()
      } placeholder: {
        Color.gray.opacity(0.3)
      }
      .frame(width: 36, height: 36)
      .clipShape(RoundedRectangle(cornerRadius: 6))

      Text(player.currentTrack?.title ?? "")
        .lineLimit(1)

      Spacer()

      Button {
        player.isPlaying.toggle()
      } label: {
        Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
      }
      .buttonStyle(.plain)
    }
    .padding(.horizontal)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .contentShape(Rectangle())
  }
}
