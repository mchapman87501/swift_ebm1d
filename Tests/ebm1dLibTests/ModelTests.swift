import XCTest
import class Foundation.Bundle
@testable import ebm1dLib

final class ModelTests: XCTestCase {
    func testGenTemps() throws {
        let minSM = 0.4
        let maxSM = 15.0
        let results = Model.getSolutions(
            minSM: minSM, maxSM: maxSM, gat0: -60.0, numZones: 9)
        XCTAssertTrue(results.count >= 2)
        let avgs = results.map { $0.solution.avg }
        let dAvg = avgs.delta()
        let d2AvgNormed = dAvg.delta().normed()
        print("d2Avg: \(d2AvgNormed.formatted())")
        for record in results {
            let sm = record.solarMult
            XCTAssertLessThanOrEqual(minSM, sm)
            XCTAssertLessThanOrEqual(sm, maxSM)
        }
    }

    func testSensitivity() throws {
        let minSM = 0.4
        let maxSM = 15.0
        let gat0 = -60.0

        let r1 = Model.getSolutions(
            minSM: minSM, maxSM: maxSM, gat0: gat0, numZones: 9)

        let r2 = Model.getSolutions(
            minSM: minSM, maxSM: maxSM, gat0: gat0, numZones: 90)

        let diff = zip(r1, r2).map { (s1, s2) in
            s2.solution.avg - s1.solution.avg
        }
        print("Solution diffs: \(diff)")
        
    }

    static var allTests = [
        ("testGenTemps", testGenTemps)
    ]
}