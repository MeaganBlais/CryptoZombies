pragma solidity ^0.4.19;

import "./ownable.sol"

contract ZombieFactory is Ownable {

  // declare new event for front end to listen for
  event NewZombie(uint zombieId, string name, uint dna);

  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;

  // struct allows for complicated data types that have multiple properties
  struct Zombie {
      string name;
      uint dna;
      uint32 level;
      uint32 readyTime;
      uint16 winCount;
      uint16 lossCount;
  }

  // create Dynamic (non-fixed) array set to public so other contracts can read
  Zombie[] public zombies;

  // tracking zombie ownership and quantity
  mapping (uint => address) public zombieToOwner;
  mapping (address => uint) ownerZombieCount;

  // create new Zombie, set parameter variables and add it to the ombies array
  // assign zombie to caller of function and increase owner count
  // execute event to let the app know the function was called
  function _createZombie(string _name, uint _dna) internal {
      uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
      zombieToOwner[id] = msg.sender;
      ownerZombieCount[msg.sender]++;
      NewZombie(id, _name, _dna);
  }

  // define function with view (not pure) permissions and set to return uint
  // generate pseudo-random hexidecimal typcast as uint, return modulus of dnaModulus
  function _generateRandomDna(string _str) private view returns (uint) {
    uint rand = uint(keccak256(_str));
    return rand % dnaModulus;         
  }

  // verify that sender does not own zombie and if not, generate new zombie
  function createRandomZombie(string _name) public {
    require(ownerZombieCount[msg.sender] == 0);
    uint randDna = _generateRandomDna(_name);
    _createZombie(_name, randDna);
  }

}
