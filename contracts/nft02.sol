// contracts/NFT1Item.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT02 is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event MintSuccessEvent(
        uint256 indexed nftid,
        address indexed owner,
        string tokenURI
    );

    constructor() ERC721("NFT1 Item", "NFT1") {}

    function mintItem(address owner, string memory tokenURI)
        public
        returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();
        _mint(owner, newItemId);
        _setTokenURI(newItemId, tokenURI);
        _tokenIds.increment();

        emit MintSuccessEvent(newItemId, owner, tokenURI);
        
        return newItemId;
    }
}