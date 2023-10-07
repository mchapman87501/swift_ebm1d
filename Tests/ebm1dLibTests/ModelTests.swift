import XCTest

@testable import ebm1dLib

final class ModelTests: XCTestCase {
    func testGenTemps() throws {
        let minSM = 0.4
        let maxSM = 15.0
        let results = Model.getSolutions(
            minSM: minSM, maxSM: maxSM, gat0: -60.0, numZones: 9)

        for series in [results.rising, results.falling] {
            XCTAssertTrue(series.count >= 2)
            for record in series {
                let sm = record.solarMult
                XCTAssertLessThanOrEqual(minSM, sm)
                XCTAssertLessThanOrEqual(sm, maxSM)
            }
        }
    }

    func testModelResultsInit() {
        let results = Model.Result()
        XCTAssertEqual(results.falling.count, 0)
        XCTAssertEqual(results.rising.count, 0)
    }
}
