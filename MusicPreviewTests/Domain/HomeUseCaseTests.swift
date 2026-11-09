//
//  HomeUseCaseTests.swift
//  MusicPreviewTests
//
//  Created by Deanira Fadrinaldi on 09/11/26.
//

import XCTest
import Combine
@testable import MusicPreview

final class HomeUseCaseTests: XCTestCase {

  static var request = MostPlayedRequest(countryCode: "id", limit: 25)
  static var tracks: [TrackModel] = [
    TrackModel(
      id: 1,
      title: "Blinding Lights",
      artist: "The Weeknd",
      artworkUrlLarge: "https://example.com/artwork/blinding-lights-600.jpg",
      artworkUrlSmall: "https://example.com/artwork/blinding-lights-100.jpg",
      previewUrl: "https://example.com/preview/blinding-lights.m4a",
      durationMillis: 200_040
    ),
    TrackModel(
      id: 2,
      title: "Levitating",
      artist: "Dua Lipa",
      artworkUrlLarge: "https://example.com/artwork/levitating-600.jpg",
      artworkUrlSmall: "https://example.com/artwork/levitating-100.jpg",
      previewUrl: "https://example.com/preview/levitating.m4a",
      durationMillis: 203_064
    )
  ]

  private var cancellables = Set<AnyCancellable>()

  override func tearDown() {
    cancellables.removeAll()
    super.tearDown()
  }

  func testFetchMostPlayedSongsSuccess() throws {
    let repository = MusicRepositoryMock()
    repository.result = .success(HomeUseCaseTests.tracks)
    let useCase = HomeUseCase(repository: repository)

    let expectation = expectation(description: "fetchMostPlayedSongs success")
    var receivedTracks: [TrackModel]?

    useCase.fetchMostPlayedSongs(request: HomeUseCaseTests.request)
      .sink(
        receiveCompletion: { completion in
          if case .failure = completion {
            XCTFail("Expected success but got failure")
          }
          expectation.fulfill()
        },
        receiveValue: { receivedTracks = $0 }
      )
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)

    XCTAssert(repository.verify())
    XCTAssertEqual(receivedTracks?.count, HomeUseCaseTests.tracks.count)
  }

  func testFetchMostPlayedSongsFailure() throws {
    let repository = MusicRepositoryMock()
    repository.result = .failure(MockError.generic)
    let useCase = HomeUseCase(repository: repository)

    let expectation = expectation(description: "fetchMostPlayedSongs failure")
    var receivedError: Error?

    useCase.fetchMostPlayedSongs(request: HomeUseCaseTests.request)
      .sink(
        receiveCompletion: { completion in
          if case .failure(let error) = completion {
            receivedError = error
          }
          expectation.fulfill()
        },
        receiveValue: { _ in XCTFail("Expected failure but got value") }
      )
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)

    XCTAssert(repository.verify())
    XCTAssertNotNil(receivedError)
  }
}

extension HomeUseCaseTests {

  enum MockError: Error {
    case generic
  }

  class MusicRepositoryMock: MusicRepositoryProtocol {
    var functionWasCalled = false
    var result: Result<[TrackModel], Error> = .success([])

    func fetchMostPlayedSongs(request: MostPlayedRequest) -> AnyPublisher<[TrackModel], Error> {
      functionWasCalled = true
      return result.publisher.eraseToAnyPublisher()
    }

    func searchTracks(query: String) -> AnyPublisher<[MusicPreview.TrackModel], any Error> {
      functionWasCalled = true
      return result.publisher.eraseToAnyPublisher()
    }

    func fetchSavedTracks() -> AnyPublisher<[MusicPreview.TrackModel], any Error> {
      fatalError("Not used in HomeUseCaseTests")
    }

    func addSavedTrack(_ track: MusicPreview.TrackModel) -> AnyPublisher<Bool, any Error> {
      fatalError("Not used in HomeUseCaseTests")
    }

    func deleteSavedTrack(id: String) -> AnyPublisher<Bool, any Error> {
      fatalError("Not used in HomeUseCaseTests")
    }

    func verify() -> Bool {
      return functionWasCalled
    }
  }
}
