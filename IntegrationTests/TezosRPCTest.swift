import XCTest
import TezosSwift
@testable import TezosSwift_Example

class TezosRPCTest: XCTestCase {
    let tezosClient = TezosClient(remoteNodeURL: Constants.defaultNodeURL)
    let defaultPassiveAddress = "tz1NRTQeqcuwybgrZfJavBY3of83u8uLpFBj"
    var wallet: Wallet!

    override func setUp() {
        super.setUp()
        let mnemonic = "soccer click number muscle police corn couch bitter gorilla camp camera shove expire pill praise"
        wallet = Wallet(mnemonic: mnemonic)!
    }

    func testBalance() {
        let testBalanceExpectation = expectation(description: "Test balance")
        tezosClient.balance(of: defaultPassiveAddress, completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(let value):
                XCTAssertEqual(Mutez(104403), value)
                testBalanceExpectation.fulfill()
            }
        })

        waitForExpectations(timeout: 3)
    }

    func testChainHead() {
        let testChainHeadExpectation = expectation(description: "Test chain head")
        tezosClient.chainHead(completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(_):
                testChainHeadExpectation.fulfill()
            }
        })

        waitForExpectations(timeout: 3)
    }

    func testDelegate() {
        let testDelegateExpectation = expectation(description: "Test delegate")
        tezosClient.delegate(of: "tz1XV5grkdVLMC9x5cy8GSPLEuSKQeDi39D5", completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(let value):
                XCTAssertEqual("tz1XV5grkdVLMC9x5cy8GSPLEuSKQeDi39D5", value)
                testDelegateExpectation.fulfill()
            }
        })

        waitForExpectations(timeout: 3)
    }

    func testStatus() {
        let testStatusExpectation = expectation(description: "Test status")
        tezosClient.status(of: defaultPassiveAddress, completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(let value):
                XCTAssertEqual(Tez(23), value.balance)
                XCTAssertEqual(value.manager, "tz1dD918PXDuUHV6Mh6z2QqMukA67YULuhqd")
                XCTAssertFalse(value.spendable)
                testStatusExpectation.fulfill()
            }
        })

        waitForExpectations(timeout: 3)
    }

    func testCurrentQuorum() {
        let callExpectation = expectation(description: "Current quorum")
        tezosClient.currentQuorum(completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(let value):
                XCTAssertGreaterThan(value, 0)
                callExpectation.fulfill()
            }
        })

        waitForExpectations(timeout: 3)
    }

    func testAccountOrigination() {
        let callExpectation = expectation(description: "Account origination")
        tezosClient.originateAccount(initialBalance: Tez(1), from: wallet, completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(_):
                callExpectation.fulfill()
            }
        })

        waitForExpectations(timeout: 3)
    }

    func testUndelegating() {
        let callExpectation = expectation(description: "Undelegating")
        tezosClient.undelegate(wallet: wallet, completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(_):
                callExpectation.fulfill()
            }
        })

        waitForExpectations(timeout: 3)
    }
}
