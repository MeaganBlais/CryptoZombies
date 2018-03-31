pragma solidity ^0.4.19;

import "./zombiefactory.sol";

//define interface to declare function that we will interact with from others contract
contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory {
// CryptoKitties address
  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  
  // Initialize contract to read from CryptoKitties
  KittyInterface kittyContract = KittyInterface(ckAddress);

  // setting up new zombie with mutated dna using zombieOwner who infected them
  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    _createZombie("NoName", newDna);
  }

  // setting function to handle multiple return values from CrytoKitties interface
  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna);
  }

}