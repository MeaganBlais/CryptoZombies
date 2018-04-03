pragma solidity ^0.4.19;

import "./zombieFactory.sol";

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
  
  // Initialize contract
  KittyInterface kittyContract;

  modifier onlyOwnerOf(uint _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    _;
  }

  // providing function to allow external contract address to be changed if needed
  function setKittyContractAddress(address _address) external onlyOwner {
      kittyContract = KittyInterface(_address);
  }

  // setting a cooldown period to be used between feedings
  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  // providing verification function for feeding schedule
  function _isReady(Zombie storage _zombie) internal view returns (bool) {
    return (_zombie.readyTime <= now);
  }

  // setting up new zombie with mutated dna using zombieOwner who infected them
  // set to internal to avoid misuse and since only needed for feedOnKitty function
  // verify zombie is only eating once a day
  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal onlyOwnerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    require(_isReady(myZombie));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    // check if new zombie is kitty and adjust dna as needed
    if (keccak256(_species) == keccak256("kitty")) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    _triggerCooldown(myZombie);
  }

  // setting function to handle multiple return values from CrytoKitties interface
  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}