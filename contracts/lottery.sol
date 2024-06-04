// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/vrf/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/vrf/interfaces/KeeperCompatibleInterface.sol";

error Lottery__NotEnoughEthEntered();
error Lottery__LotterytransferFailed();
error Lottery__LotteryNotOpen();

contract lettery is VRFConsumerBaseV2, KeeperCompatibleInterface {
    // types:
    enum LotteryState {OPEN, CALCULATING}  // enums are custom types

    // State variables
    uint256 private immutable i_entranceFee;    // i_ is used with immutable variables
    address payable[] private s_players;         // one player should win so addresses should be payable. s_ is used with storage variables
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 immutable private i_gasLane;
    bytes64 immutable private i_subscriptionId;
    uint32 immutable private i_callbackGasLimit;
    uint16 constant private REQUEST_CONFIRMATIONS = 3;
    uint32 constant private NUM_WORDS = 1;
    address private s_recentWinner ;
    LotteryState private s_lotteryState;  // represents the Lottery state (open, calculating)
    uint256 private s_lastTimeStamp;
    uint256 private immutable i_interval;


    // events
    event LotteryEnter(address indexed player);
    event RequestedLotteryWinner(uint256 indexed requestId);
    event WinnerPicked(address indexed winner);

    constructor(
        uint256 entranceFee,
        address vrfCoordinatorV2,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit,
        uint256 interval) {
        i_entranceFee = entranceFee;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
        s_lotteryState = LotteryState.OPEN;
        s_lastTimeStamp= block.timestamp;
        i_interval = interval;
    }

    function enterLottery() public payable {
        // require(msg.value > i_entranceFee, "Not enough ETH") this is not gas efficient, instead we can use if with a custom error
        if(msg.value< i_entranceFee) 
        {revert Lottery__NotEnoughEthEntered();}

        if(s_lotteryState!=LotteryState.OPEN) 
        {revert Lottery__LotteryNotOpen();}

        s_players.push(payable(msg.sender));   // msg.sender is not payable so we need to typecast it
        emit LotteryEnter(msg.sender);
    }

    function requestRandomWords() external {
        s_lotteryState = LotteryState.CALCULATING;
        uint256 requestId = i_vrfCoordinator.requestRandomWords(  // obtained from chainlink documentation
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,  // sets limit to how much fulfillRandomWords function can cost
            NUM_WORDS);
        emit RequestedLotteryWinner(requestId);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        s_lotteryState = LotteryState.OPEN;
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        s_players = new address payable[](0);
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        if(!success){
            revert Lottery__LotterytransferFailed();
        }
        emit WinnerPick
        ed(recentWinner);
    }
    function checkUpKeep(bytes calldata /*checkdata*/)external override {
        bool isOpen = (s_lotteryState = LotteryState.OPEN);
        bool timePassed = ((block.timestamp - s_lastTimeStamp) > i_interval);
    }

    function getPlayer(uint256 index) public view returns(address) {
        return s_players[index];
    }
}