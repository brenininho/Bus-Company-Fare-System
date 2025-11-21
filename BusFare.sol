// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// the following contract simulate the fare payment system of a bus company
// the customer has pay for the €2 fare transfering it to the busCompany wallet and
// the Bus company approves the top up on the customer wallet
contract BusFare {
address public constant BusCompany = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
address public constant Customer = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;


event TopUp(address from, address to, uint256 amount, uint256 balance);
event TappedOn(address from, address to, uint256 amount, uint256 balance);

modifier onlyBus() {
    require(msg.sender == BusCompany, "Only BusCompany can call this");
    _;
}

modifier onlyCustomer() {
    require(msg.sender == Customer, "Only Customer can call this");
    _;
}

function topUp() external payable onlyBus {
    require(Customer.balance < 200 ether, "Ether has to be less than 200");

    require(msg.value + Customer.balance <= 200 ether , "Total amount has to be less than 200");

    (bool ok, ) = payable(Customer).call{value:msg.value}("");
    require(ok, "Top up failed");

    emit TopUp(BusCompany, Customer, msg.value, Customer.balance);
}

function Tap() external payable onlyCustomer {
    require(Customer.balance >= 1 ether, "Your balance is lower than 1");
    require(msg.value == 2 ether, "The fare is 2 euros");

    (bool ok, ) = payable(BusCompany).call{value: msg.value}("");

    require(ok, "Low balance");
    
    emit TappedOn(Customer, BusCompany, msg.value, Customer.balance);
    }

}