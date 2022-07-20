pragma solidity ^0.5.0;
import './Tether.sol';
import './RWD.sol';


contract DecentralBank{
    string public name="Decentral Bank";
    address public owner;
    Tether public tether;
    RWD public rwd;

    address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;


    constructor(RWD _rwd,Tether _tether) public{
        rwd=_rwd;
        tether=_tether;
        owner=msg.sender;
    }

    function depositTokens(uint _amount) public{
        require(_amount>0,"Amount cannot be 0");

        tether.transferFrom(msg.sender,address(this), _amount);

        stakingBalance[msg.sender]+=_amount;

        if(!hasStaked[msg.sender])
            stakers.push(msg.sender);
        
        hasStaked[msg.sender]=true;
        isStaking[msg.sender]=true;
    }

    function issueTokens() public{
        //require(msg.sender==owner , 'the caller must be owner');

        for(uint i=0;i<stakers.length;i++)
        {
            address recipient=stakers[i];
            uint balance=stakingBalance[recipient]/9;
            if(balance>0){
            rwd.transfer(recipient,balance);
            }
        }
    }

    function unstakeTokens() public{
        uint balance=stakingBalance[msg.sender];
        require(balance>0 , 'staking balance cannot be 0');

        tether.transfer(msg.sender,balance);

        stakingBalance[msg.sender]=0;

        isStaking[msg.sender]=false;
    }


}