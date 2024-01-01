//
//  FriendAddViewModelTests.swift
//  KlockAppTests
//
//  Created by 성찬우 on 1/1/24.
//

import XCTest
@testable import KlockApp

class FriendAddViewModelTests: XCTestCase {
    var viewModel: FriendAddViewModel!

    override func setUp() {
        super.setUp()
        viewModel = FriendAddViewModel()
    }

    func testGenerateInviteQRCode_Success() {
        let result = viewModel.generateInviteQRCode()
        print("Result: \(String(describing: result))")
        XCTAssertNotNil(result)
    }
}
