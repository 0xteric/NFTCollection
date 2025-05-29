// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "../src/NftCollection.sol";

contract NftTest is Test {
    address public owner = vm.addr(1);
    address public user1 = vm.addr(2);

    NftCollection nftCollection;

    function setUp() public {
        vm.prank(owner);
        nftCollection = new NftCollection("NftTest", "NFTT", 10, "basedUri");
    }

    function testOwner() public view {
        assertEq(nftCollection.owner(), owner);
    }

    function testMint() public {
        vm.prank(user1);

        nftCollection.mint();

        address firstOwner = IERC721(address(nftCollection)).ownerOf(1);
        assertEq(firstOwner, user1);
    }

    function testUpdateBaseURI() public {
        string memory firstUri = nftCollection.baseUri();
        string memory newUri = "NewBaseUri";
        vm.prank(owner);
        nftCollection.updateBaseUri(newUri);

        assertEq(firstUri, "basedUri");
        assertEq(nftCollection.baseUri(), newUri);
    }

    function testUpdateBaseURINotAllowed() public {
        vm.expectRevert("Not allowed.");
        nftCollection.updateBaseUri("NewURI");
    }

    function testTokenURI() public {
        vm.prank(user1);
        nftCollection.mint();
        string memory tokenUri = nftCollection.tokenURI(1);
        string memory baseURI = nftCollection.baseUri();

        assertEq(tokenUri, string.concat(baseURI, "1.json"));
    }

    function testSoldOut() public {
        vm.startPrank(user1);
        for (uint i = 0; i <= 10; i++) {
            if (i == 10) {
                vm.expectRevert("Sold out!");
                nftCollection.mint();
            } else {
                nftCollection.mint();
            }
        }
    }
}
