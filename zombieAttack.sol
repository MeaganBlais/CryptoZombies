pragma solidity ^0.4.19;

import "./zombieHelper.sol";

contract ZombieBattle is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

    // function to return random number between 1-100
    function randMod(uint _modulus) internal returns (uint) {
        randNonce = randNonce.add(1);
        return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
    }

    // create function to initiate zombie battle, determine winner, adjust stats and provide rewards
    function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = randMod(100);
        if (rand <= attackVictoryProbability) {
            myZombie.winCount = myZombie.winCount.add(1);
            myZombie.level = myZombie.level.add(1);
            enemyZombie.lossCount = enemyZombie.lossCount.add(1);
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount = myZombie.lossCount.add(1);
            enemyZombie.winCount = enemyZombie.winCount.add(1);
            _triggerCooldown(myZombie);
        }
    }
}
