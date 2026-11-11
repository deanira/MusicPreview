//
//  ProfileUseCaseTests.swift
//  MusicPreviewTests
//
//  Created by Deanira Fadrinaldi on 09/11/26.
//

import XCTest
import Combine
@testable import MusicPreview

final class ProfileUseCaseTests: XCTestCase {

  static var profile = ProfileModel(
    displayName: "dea",
    bio: "live now or never",
    avatarFileName: nil
  )

  private var cancellables = Set<AnyCancellable>()

  override func tearDown() {
    cancellables.removeAll()
    super.tearDown()
  }

  // MARK: - Fetch
  func testFetchProfileSuccess() throws {
    let repository = MusicRepositoryMock()
    repository.fetchResult = .success(ProfileUseCaseTests.profile)
    let useCase = ProfileUseCase(repository: repository)

    let expectation = expectation(description: "fetchProfile success")
    var receivedProfile: ProfileModel?

    useCase.fetchProfile()
      .sink(
        receiveCompletion: { completion in
          if case .failure = completion {
            XCTFail("Expected success but got failure")
          }
          expectation.fulfill()
        },
        receiveValue: { receivedProfile = $0 }
      )
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)

    XCTAssert(repository.verifyFetch())
    XCTAssertNotNil(receivedProfile)
    XCTAssertEqual(receivedProfile, ProfileUseCaseTests.profile)
  }

  func testFetchProfileNil() throws {
    let repository = MusicRepositoryMock()
    repository.fetchResult = .success(nil)
    let useCase = ProfileUseCase(repository: repository)

    let expectation = expectation(description: "fetchProfile nil")
    var receivedProfile: ProfileModel?
    var didReceiveValue = false

    useCase.fetchProfile()
      .sink(
        receiveCompletion: { completion in
          if case .failure = completion {
            XCTFail("Expected success but got failure")
          }
          expectation.fulfill()
        },
        receiveValue: { value in
          didReceiveValue = true
          receivedProfile = value
        }
      )
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)

    XCTAssert(repository.verifyFetch())
    XCTAssertTrue(didReceiveValue) // nilnya sampai sebagai value, bukan error
    XCTAssertNil(receivedProfile)
  }

  func testFetchProfileFailure() throws {
    let repository = MusicRepositoryMock()
    repository.fetchResult = .failure(MockError.generic)
    let useCase = ProfileUseCase(repository: repository)

    let expectation = expectation(description: "fetchProfile failure")
    var receivedError: Error?

    useCase.fetchProfile()
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

    XCTAssert(repository.verifyFetch())
    XCTAssertNotNil(receivedError)
    XCTAssertTrue(receivedError is MockError)
  }

  // MARK: - Save
  func testSaveProfileSuccess() throws {
    let repository = MusicRepositoryMock()
    repository.saveResult = .success(true)
    let useCase = ProfileUseCase(repository: repository)

    let expectation = expectation(description: "saveProfile success")
    var receivedResult: Bool?

    useCase.saveProfile(ProfileUseCaseTests.profile)
      .sink(
        receiveCompletion: { completion in
          if case .failure = completion {
            XCTFail("Expected success but got failure")
          }
          expectation.fulfill()
        },
        receiveValue: { receivedResult = $0 }
      )
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)

    XCTAssert(repository.verifySave())
    XCTAssertEqual(repository.receivedProfile, ProfileUseCaseTests.profile)
    XCTAssertEqual(receivedResult, true)
  }

  func testSaveProfileReturnsFalse() throws {
    let repository = MusicRepositoryMock()
    repository.saveResult = .success(false)
    let useCase = ProfileUseCase(repository: repository)

    let expectation = expectation(description: "saveProfile false")
    var receivedResult: Bool?

    useCase.saveProfile(ProfileUseCaseTests.profile)
      .sink(
        receiveCompletion: { completion in
          if case .failure = completion {
            XCTFail("Expected success but got failure")
          }
          expectation.fulfill()
        },
        receiveValue: { receivedResult = $0 }
      )
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)

    XCTAssert(repository.verifySave())
    XCTAssertEqual(receivedResult, false)
  }

  func testSaveProfileFailure() throws {
    let repository = MusicRepositoryMock()
    repository.saveResult = .failure(MockError.generic)
    let useCase = ProfileUseCase(repository: repository)

    let expectation = expectation(description: "saveProfile failure")
    var receivedError: Error?

    useCase.saveProfile(ProfileUseCaseTests.profile)
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

    XCTAssert(repository.verifySave())
    XCTAssertNotNil(receivedError)
    XCTAssertTrue(receivedError is MockError)
  }
}

extension ProfileUseCaseTests {

  enum MockError: Error {
    case generic
  }

  class MusicRepositoryMock: MusicRepositoryProtocol {
    var fetchWasCalled = false
    var saveWasCalled = false
    var receivedProfile: ProfileModel?
    var fetchResult: Result<ProfileModel?, Error> = .success(nil)
    var saveResult: Result<Bool, Error> = .success(true)

    func fetchProfile() -> AnyPublisher<MusicPreview.ProfileModel?, any Error> {
      fetchWasCalled = true
      return fetchResult.publisher.eraseToAnyPublisher()    }

    func saveProfile(_ profile: MusicPreview.ProfileModel) -> AnyPublisher<Bool, any Error> {
      saveWasCalled = true
      receivedProfile = profile
      return saveResult.publisher.eraseToAnyPublisher()
    }

    func deleteProfile() -> AnyPublisher<Bool, any Error> {
      fatalError("Not used in ProfileUseCaseTests")
    }

    func fetchMostPlayedSongs(request: MostPlayedRequest) -> AnyPublisher<[TrackModel], Error> {
      fatalError("Not used in ProfileUseCaseTests")
    }

    func searchTracks(query: String) -> AnyPublisher<[TrackModel], Error> {
      fatalError("Not used in ProfileUseCaseTests")
    }

    func fetchSavedTracks() -> AnyPublisher<[TrackModel], Error> {
      fatalError("Not used in ProfileUseCaseTests")
    }

    func addSavedTrack(_ track: TrackModel) -> AnyPublisher<Bool, Error> {
      fatalError("Not used in ProfileUseCaseTests")
    }

    func deleteSavedTrack(id: String) -> AnyPublisher<Bool, Error> {
      fatalError("Not used in ProfileUseCaseTests")
    }

    func verifyFetch() -> Bool {
      fetchWasCalled
    }

    func verifySave() -> Bool {
      saveWasCalled
    }
  }
}
