import XCTest
import TezosKit

class GetAddressCounterRPCTest: XCTestCase {
	public func testGetAddressCounterRPC() {
		let address = "abc123"
		let rpc = GetAddressCounterRPC(address: address) { _, _ in }

		XCTAssertEqual(rpc.endpoint, "/chains/main/blocks/head/context/contracts/" + address + "/counter")
		XCTAssertNil(rpc.payload)
		XCTAssertFalse(rpc.isPOSTRequest)
	}
}

