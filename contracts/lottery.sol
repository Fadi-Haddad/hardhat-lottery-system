// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract lettery {

    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee){
        entranceFee = i_entranceFee;
    }

    function enterLottery()  {
        require(msg.value > i_entranceFee, "Not enough ETH")
        
    }
    // function pickRandomWinner(){}
}