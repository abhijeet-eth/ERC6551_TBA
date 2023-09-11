// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
//smart wallet: 0x630f85F449F829251dFB4fDb146a516972Bb0cC0
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SampleERC721 is ERC721, Ownable {
    constructor() ERC721("SampleERC721", "MTK") {}

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }
}