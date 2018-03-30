pragma solidity ^0.4.19;

contract ZombieFactory {

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
  function _createZombie(string _name, uint _dna) private {
      zombies.push(Zombie(_name, _dna));
  }

}
