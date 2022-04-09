// SPDX-License-Identifier: MIT
// Author: cryptowissen
// Version: 2

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract CWCoin is ERC20, Ownable{
    using SafeMath for uint256;

    address public marketingWalletAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    uint8 public marketingFee = 5;

    constructor (string memory name, string memory symbol, uint256 amount)
        ERC20(name, symbol){
            _mint(msg.sender, amount * 10 ** uint(decimals()) );
    }

    function setMarketingWalletAddress(address _marketingWalletAddress) public onlyOwner{
        marketingWalletAddress = _marketingWalletAddress;
    }

    function setMarketingFee(uint8 _marketingFee) public onlyOwner{
        marketingFee = _marketingFee;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override{
        require(from != address(0), "From not null address");
        require(to != address(0), "To not null address");

        if(amount == 0){
            super._transfer(from, to, 0);
            return;
        }

        uint256 marketing = amount.mul(marketingFee).div(100);

        super._transfer(from, marketingWalletAddress, marketing);
        super._transfer(from, to, amount.sub(marketing));
    }

}
