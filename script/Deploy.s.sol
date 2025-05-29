// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {NftCollection} from "../src/NftCollection.sol";

contract Deploy is Script {
    function run() external returns (NftCollection) {
        uint deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        NftCollection nftCollection = new NftCollection("Random NFTS", "RNFT", 333, "ipfs://bafybeiednv7zjkglw6pm7afwbsl7nz5ni7ekiz5tms6rghq3zvqgttj32a/");
        vm.stopBroadcast();
        return nftCollection;
    }
}
