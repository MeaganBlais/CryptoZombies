pragma solidity ^0.4.19;

contract ZombieFactory {

  // declare new event for front end to listen for
  event NewZombie(uint zombieId, string name, uint dna);

  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;

  // struct allows for complicated data types that have multiple properties
  struct Zombie {
      string name;
      uint dna;
  }

  // create Dynamic (non-fixed) array set to public so other contracts can read
  Zombie[] public zombies;

  // create new Zombie, set parameter variables and add it to the ombies array
  // fire event to let the app know the function was called
  function _createZombie(string _name, uint _dna) private {
      uint id = zombies.push(Zombie(_name, _dna)) - 1;
      NewZombie(id, _name, _dna);
  }

  // define function with view (not pure) permissions and set to return uint
  // generate pseudo-random hexidecimal typcast as uint, return modulus of dnaModulus
  function _generateRandomDna(string _str) private view returns (uint) {
    uint rand = uint(keccak256(_str));
    return rand % dnaModulus;         
  }

  // generate new zombie
  function createRandomZombie(string _name) public {
    uint randDna = _generateRandomDna(_name);
    _createZombie(_name, randDna);
  }

}
