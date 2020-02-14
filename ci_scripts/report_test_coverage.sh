#!/bin/bash
XCTESTDIR=$(find .build -name '*.xctest')
BIN=$(find ${XCTESTDIR} -type f)
PROFDATA=$(find .build -name 'default.profdata')
xcrun llvm-cov report -use-color -instr-profile ${PROFDATA} ${BIN}