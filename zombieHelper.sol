pragma solidity ^0.4.19;

import "./zombieHelper.sol";

contract ZombieHelper is ZombieFeeding {

    uint levelUpFee = 0.001 ether;

    // set restriction based on level
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    // set function to level up zombie if fee paid
    function levelUp(uint _zombieId) external payable {
        require(msg.value == levelUpFee);
        zombies[_zombieId].level++;
    }

    // provide incentives to level up zombies
    function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].dna = _newDna;
    }

    // external view functions don't cost gas
    // function to display a user's entire zombie army
    // rebuilding an array in memory is cheaper than using storage
    function getZombiesByOwner(address _owner) external view returns (uint[]) {
        // instantiate a new array in memory
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        
        uint counter = 0;
    
        for (uint i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}