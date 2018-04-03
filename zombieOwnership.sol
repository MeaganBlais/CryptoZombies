pragma solidity ^0.4.19;

import "./zombieAttack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {
  
    // check total zombies per owner
    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerZombieCount[_owner];
    }

    // check owner of zombie
    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return zombieToOwner[_tokenId];
    }
    
}