// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@5.0.1/access/Ownable.sol";

contract ImitInvestmentTokenTest is ERC721, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;
        string public baseTokenURI;
    uint[] soldedTokenIds;
    mapping (address => uint[]) nftOwner;
    event MintNft(address senderAddress, uint256 nftToken);
    uint public constant PRICE = 0.2 ether;

    constructor(address initialOwner)
        ERC721("Imit investment token test", "IMITT")
        Ownable(initialOwner)
    {}

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }
         modifier checkTokenStatus(uint _tokenId) {
        bool isTokenSold = false;
        for (uint i = 0; i < soldedTokenIds.length; i++) {
            if(soldedTokenIds[i] == _tokenId) {
                isTokenSold = true;
                break;
            }
        }
        require(!isTokenSold, "Token is sold");
        _;
    }

        function mintNFT(uint _tokenId) public payable checkTokenStatus(_tokenId) {
        require(msg.value >= PRICE, "Not enough ether to purchase NFTs.");
        _safeMint(msg.sender, _tokenId);
        soldedTokenIds.push(_tokenId);
        emit MintNft(msg.sender, _tokenId);
        
    }
        function tokensOfOwner(address _owner) external view returns (uint[] memory) {
        return nftOwner[_owner];
    }

    function withdraw() public payable onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No ether left to withdraw");
        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed.");
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
