// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./access/OwnableUpgradeable.sol";
import "./utils/Initializable.sol";
import "./Interface/IERC1155ReceiverUpgradeable.sol";
import "./utils/ERC1155ReceiverUpgradeable.sol";
import "./utils/ERC1155HolderUpgradeable.sol";
import "./Interface/IERC1155Upgradeable.sol";

contract HypermoveNFTMarketplace is
  Initializable,
  OwnableUpgradeable,
  ERC1155ReceiverUpgradeable,
  ERC1155HolderUpgradeable
{
  uint256 public totalSales;

  mapping(uint256 => address) public nftOwners;
  mapping(uint256 => uint256) public nftPrices;

  event NFTListed(uint256 tokenId, uint256 price, address seller);
  event NFTSold(uint256 tokenId, uint256 price, address seller, address buyer);

  function initialize() public initializer {
    __Ownable_init();
    __ERC1155Holder_init();
  }

  function listNFT(
    address nftContract,
    uint256 tokenId,
    uint256 amount,
    uint256 price
  ) public onlyOwner {
    require(
      nftOwners[tokenId] == address(0),
      "This NFT is already listed for sale"
    );

    nftOwners[tokenId] = msg.sender;
    nftPrices[tokenId] = price;

    IERC1155Upgradeable(nftContract).setApprovalForAll(address(this), true);
    IERC1155Upgradeable(nftContract).safeTransferFrom(
      msg.sender,
      address(this),
      tokenId,
      amount,
      ""
    );

    emit NFTListed(tokenId, price, msg.sender);
  }

  function buyNFT(
    address nftContract,
    uint256 tokenId,
    uint256 amount
  ) public payable {
    require(
      nftOwners[tokenId] != address(0),
      "This NFT is not listed for sale"
    );
    require(
      msg.value >= nftPrices[tokenId],
      "The amount sent is less than the price of the NFT"
    );

    address payable seller = payable(nftOwners[tokenId]);
    address payable buyer = payable(msg.sender);
    uint256 price = nftPrices[tokenId];

    nftOwners[tokenId] = buyer;
    nftPrices[tokenId] = 0;

    IERC1155Upgradeable(nftContract).safeTransferFrom(
      address(this),
      buyer,
      tokenId,
      amount,
      ""
    );

    seller.transfer(price);
    totalSales += price;

    emit NFTSold(tokenId, price, seller, buyer);
  }

  function onERC1155Received(
    address,
    address,
    uint256,
    uint256,
    bytes memory
  )
    public
    virtual
    override(ERC1155HolderUpgradeable, IERC1155ReceiverUpgradeable)
    returns (bytes4)
  {
    return this.onERC1155Received.selector;
  }

  function onERC1155BatchReceived(
    address,
    address,
    uint256[] memory,
    uint256[] memory,
    bytes memory
  )
    public
    virtual
    override(ERC1155HolderUpgradeable, IERC1155ReceiverUpgradeable)
    returns (bytes4)
  {
    return this.onERC1155BatchReceived.selector;
  }

  function withdraw() public onlyOwner {
    payable(owner()).transfer(address(this).balance);
  }
}
