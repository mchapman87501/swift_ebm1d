import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(EarthModelTests.allTests),
        testCase(TempSolverTests.allTests),
        testCase(ModelTests.allTests)
    ]
}
#endif
