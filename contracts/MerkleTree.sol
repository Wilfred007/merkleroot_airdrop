// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    IERC20 public token;

    bytes32 public merkleRoot;

    mapping(address => bool) public hasClaimed;

    event AirdropClaimed(address indexed claimant, uint256 amount);

    constructor(address _token, bytes32 _merkleRoot) {
        token = IERC20(_token);
        merkleRoot = _merkleRoot;
    }

    function claimAirdrop(
        address _address,
        uint256 amount,
        bytes32[] calldata merkleProof
    ) external {

        require(_address != address(0), "Address Zero Detected.");

        require(!hasClaimed[_address], "Airdrop already claimed.");
        
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(_address, amount))));

        require(
            MerkleProof.verify(merkleProof, merkleRoot, leaf),
            "Invalid Merkle proof."
        );

        hasClaimed[_address] = true;

        require(token.transfer(_address, amount), "Token transfer failed.");

        emit AirdropClaimed(_address, amount);
    }
}