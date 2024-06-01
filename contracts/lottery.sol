// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

Lottery__NotEnoughEthEntered()

contract lettery {

    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee){
        entranceFee = i_entranceFee;
    }

    function enterLottery()  {
        // require(msg.value > i_entranceFee, "Not enough ETH") this is not gas efficient, instead we can use if with a custom error
        if(msg.value< i_entranceFee) {revert Lottery__NotEnoughEthEntered()}
        
    }
    // function pickRandomWinner(){}
}