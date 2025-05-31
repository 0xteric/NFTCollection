// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Strings} from "../../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract NftCollection is ERC721 {
    using Strings for uint;

    uint public nextTokenId;
    uint public totalSupply;
    uint public maxMintAmountPerTx;
    uint public price;
    string public baseUri;
    address public owner;
    mapping(address => bool) public whitelist;

    event Minted(address user, uint tokenId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not allowed.");
        _;
    }

    constructor(string memory _name, string memory _symbol, uint _totalSupply, string memory _baseUri) ERC721(_name, _symbol) {
        totalSupply = _totalSupply;
        baseUri = _baseUri;
        owner = msg.sender;
        maxMintAmountPerTx = 10;
        price = 0.01 ether;
    }

    function isWhitelisted(address _user) public view returns (bool) {
        return whitelist[_user];
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string.concat(baseURI, tokenId.toString(), ".json") : "";
    }

    function mint(uint _amount) external payable {
        require(_amount <= maxMintAmountPerTx, "Amount exceeds max!");

        if (!whitelist[msg.sender]) {
            require(msg.value >= _amount * price, "Not enough value");
        }

        for (uint i = 0; i < _amount; i++) {
            require(nextTokenId + 1 <= totalSupply, "Sold out!");

            _safeMint(msg.sender, ++nextTokenId);

            emit Minted(msg.sender, nextTokenId);
        }
    }

    function updateBaseUri(string memory _newBaseUri) external onlyOwner {
        baseUri = _newBaseUri;
    }

    function addToWhitelist(address[] memory _addresses) external onlyOwner {
        for (uint i = 0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = true;
        }
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseUri;
    }
}
