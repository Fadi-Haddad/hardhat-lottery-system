// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/vrf/interfaces/VRFCoordinatorV2Interface.sol";

error Lottery__NotEnoughEthEntered()

contract lettery is VRFConsumerBaseV2 {
    // State variables
    uint256 private immutable i_entranceFee;    // i_ is used with immutable variables
    address payable[] private s_players;         // one player should win so addresses should be payable. s_ is used with storage variables
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 immutable private i_gasLane;


    // events
    event LotteryEnter( address indexed player);


    constructor(uint256 entranceFee, address vrfCoordinatorV2, bytes32 gasLane){
        i_entranceFee = entranceFee;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
    }

    function enterLottery() public payable {
        // require(msg.value > i_entranceFee, "Not enough ETH") this is not gas efficient, instead we can use if with a custom error
        if(msg.value< i_entranceFee) {revert Lottery__NotEnoughEthEntered();}
        s_players.push(payable(msg.sender));   // msg.sender is not payable so we need to typecast it

        emit LotteryEnter(msg.sender);
        
    }

    function requestRandomWords() external {
        i_vrfCoordinator.requestRandomWords(  // obtained from chainlink documentation
            i_gasLane,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords);
    }

    function getPlayer(uint256 index) public view returns(address) {
        return s_players[index];
    }
    // function pickRandomWinner(){}
}