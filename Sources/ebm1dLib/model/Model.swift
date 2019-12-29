public struct Model {
    public struct AvgTempResult {
        public let delta: Double
        public let solarMult: Double
        public let solution: TempSolver.Solution
    }
    
    public struct Result {
        public let rising: [AvgTempResult]
        public let falling: [AvgTempResult]
    }
    
    static func solutionSeries(
        _ solver: TempSolver, _ delta: Double, _ smSeq: [Double],
        _ tempsIn: [Double]
    ) -> ([AvgTempResult], [Double]) {
        var result = [AvgTempResult]()
        var temps = tempsIn
        result.reserveCapacity(smSeq.count)
        for sm in smSeq {
            if let solution = try? solver.solve(
                solarMultiplier: sm, temp: temps
            ) {
                let record = AvgTempResult(
                    delta: delta, solarMult: sm, solution: solution)
                result.append(record)
                temps = solution.temps
            }
        }
        return (result, temps)
    }

    public static func getSolutions(
        minSM minSolarMult: Double, maxSM maxSolarMult: Double,
        gat0 globalAvgTemp0: Double, numZones: Int,
        f latTransferCoeff: Double = Defaults.latTransferCoeff,
        steps numSolarMults: Int = 20
    ) -> Result {
        let em = EarthModel(numZones: numZones)
        let solver = TempSolver(em: em, f: latTransferCoeff)

        let gat0 = [Double](repeating: globalAvgTemp0, count: numZones)

        let delta = (maxSolarMult - minSolarMult) / Double(numSolarMults)

        let smRising = stride(
            from: minSolarMult, to: maxSolarMult, by: delta).map {$0}
        let smFalling = stride(
            from: maxSolarMult, to: minSolarMult, by: -delta).map {$0}

            
        let temps = gat0
        let (rRising, tempsR) = Self.solutionSeries(solver, delta, smRising, temps)
        let (rFalling, _) = Self.solutionSeries(solver, delta, smFalling, tempsR)
        return Result(rising: rRising, falling: rFalling)
    }
}

public extension Model.Result {
    init() {
        rising = []
        falling = []
    }
}

