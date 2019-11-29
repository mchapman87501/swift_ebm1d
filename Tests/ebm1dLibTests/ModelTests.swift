import XCTest
import class Foundation.Bundle
@testable import ebm1dLib

final class ModelTests: XCTestCase {
    func testGenTemps() throws {
        let m = Model()
        let minSM = 0.1
        let maxSM = 100.0
        let results = m.getSolutions(
            minSM: minSM, maxSM: maxSM, gat0: -60.0, numZones: 9)
        XCTAssertTrue(results.count >= 2)
        for record in results {
            let sm = record.solarMult
            XCTAssertLessThanOrEqual(minSM, sm)
            XCTAssertLessThanOrEqual(sm, maxSM)
        }
    }

    static var allTests = [
        ("testGenTemps", testGenTemps)
    ]
}