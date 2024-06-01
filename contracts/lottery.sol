// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

error Lottery__NotEnoughEthEntered()

contract lettery {
    // State variables
    uint256 private immutable i_entranceFee;    // i_ is used with immutable variables
    address payable[] private s_players;         // one player should win so addresses should be payable. s_ is used with storage variables

    constructor(uint256 entranceFee){
        entranceFee = i_entranceFee;
    }

    function enterLottery() public payable {
        // require(msg.value > i_entranceFee, "Not enough ETH") this is not gas efficient, instead we can use if with a custom error
        if(msg.value< i_entranceFee) {revert Lottery__NotEnoughEthEntered()}
        s_players.push(payable(msg.sender));   // msg.sender is not payable so we need to typecast it
        
    }
    function getPlayer(uint256 index) public view returns(address) {
        return s_players[index];
    }
    // function pickRandomWinner(){}
}