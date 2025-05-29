// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Strings} from "../../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract NftCollection is ERC721 {
    using Strings for uint;

    uint public nextTokenId;
    uint public totalSupply;
    string public baseUri;
    address public owner;

    event Minted(address user, uint tokenId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not allowed.");
        _;
    }

    constructor(string memory _name, string memory _symbol, uint _totalSupply, string memory _baseUri) ERC721(_name, _symbol) {
        totalSupply = _totalSupply;
        baseUri = _baseUri;
        owner = msg.sender;
    }

    function mint() external {
        require(nextTokenId + 1 <= totalSupply, "Sold out!");

        _safeMint(msg.sender, ++nextTokenId);

        emit Minted(msg.sender, nextTokenId);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseUri;
    }

    function updateBaseUri(string memory _newBaseUri) public onlyOwner {
        baseUri = _newBaseUri;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string.concat(baseURI, tokenId.toString(), ".json") : "";
    }
}
