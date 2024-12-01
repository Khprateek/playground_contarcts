// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/utils/Strings.sol";
contract Lottery{
 uint256 public constant ticketPrice = 0.001 ether;
 uint256 public constant maxTickets = 100;
 uint256 public constant duration = 30 minutes;


 uint256 public expiration;
 address public Dealer;
 uint256 public DealerTotalCommission;
 address public lastWinner;
 uint256 public lastWinnerAmount;


 mapping(address => bool) public hasTicket;
 mapping(address => uint256) public winners;
 address[] public tickets;

 modifier isDealer(){
  require(
    (msg.sender == Dealer),
    "Caller is not Lottery Operator"
  );
  _;
 }

 modifier isWinner(){
  require(IsWinner(),
   "Caller is not the winner"
   );
   _;
 }

  constructor(){
      Dealer = msg.sender;
      expiration = block.timestamp + duration;
  }

  function getWinningsForAddress(address addr) public view returns (uint256){
    return winners[addr];
  }
  function BuyTicket() public payable {
      uint256 remainingTickets = RemainingTickets();
      require(remainingTickets > 0, "There are no more Tickets");
      require(!hasTicket[msg.sender], "You can only buy 1 Ticket");
        require( 
            msg.value == ticketPrice,
            string.concat(
                "The value must be exactly",
                Strings.toString(ticketPrice),
                " Ether"
            )
        );

      hasTicket[msg.sender] = true;
      tickets.push(msg.sender);
  }

    function DrawWinnerTicket() public isDealer {
        require(tickets.length > 0, "No tickets were purchased");

        bytes32 blockHash = blockhash(block.number - tickets.length);
        uint256 randomNumber = uint256(
            keccak256(abi.encodePacked(block.timestamp, blockHash))
        );
        uint256 winningTicket = randomNumber % tickets.length;

        address winner = tickets[winningTicket];
        lastWinner = winner;
        uint256 totalPrize = tickets.length * ticketPrice;
        uint256 winnerPrize = (totalPrize*90/100);
        
        winners[winner] += winnerPrize;
        lastWinnerAmount = winnerPrize;

        DealerTotalCommission += totalPrize*10/100;
        for (uint256 i = 0; i < tickets.length; i++) {
            hasTicket[tickets[i]] = false;
        }
        delete tickets;
        expiration = block.timestamp + duration;
    }
    function restartDraw() public isDealer{
        require(tickets.length == 0, "Cannot Restart Draw as Draw is in play");
        delete tickets;
        expiration = block.timestamp + duration;
    }


    function WithdrawWinnings() public isWinner {
        address payable winner = payable(msg.sender);

        uint256 reward2Transfer = winners[winner];
        winners[winner] = 0;

        winner.transfer(reward2Transfer);
    }

    function WithdrawCommission() public isDealer {
        address payable operator = payable(msg.sender);

        uint256 commission2Transfer = DealerTotalCommission;
        DealerTotalCommission = 0;

        operator.transfer(commission2Transfer);
    }

    function getTickets() public view returns (address[] memory){
        return tickets;
    }
    function IsWinner() public view returns (bool) {
        return winners[msg.sender] > 0;
    }

    function CurrentWinningReward() public view returns (uint256) {
        return (tickets.length * ticketPrice)*90/100;
    }

    function RemainingTickets() public view returns (uint256) {
        return maxTickets - tickets.length;
    }
}
