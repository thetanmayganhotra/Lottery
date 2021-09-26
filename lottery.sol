// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public participants;
    
    constructor(){
        
        manager = msg.sender;
        
    }
    
    modifier isvalue()
    {
        require(msg.value >= 1 ether);
        _;
    }
    
    modifier ismanager()
    {
        require(msg.sender == manager);
        _;
    }
    
    receive() external payable isvalue
    {   
        participants.push(payable(msg.sender));
    }
    
    
    
    function getbalance() public view ismanager returns(uint)
    {
        return address(this).balance;
    }
    
    function random() public view ismanager returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }
    
    function selectwinner() public ismanager {
        require(participants.length>=3);
        uint r = random();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getbalance());
        participants = new address payable[](0);
    } 
    
}