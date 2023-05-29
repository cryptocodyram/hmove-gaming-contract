// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Initializable.sol";
import "./ERC165Upgradeable.sol";
import "../Interface/IERC1155ReceiverUpgradeable.sol";

abstract contract ERC1155ReceiverUpgradeable is
  Initializable,
  ERC165Upgradeable,
  IERC1155ReceiverUpgradeable
{
  function __ERC1155Receiver_init() internal onlyInitializing {}

  function __ERC1155Receiver_init_unchained() internal onlyInitializing {}

  /**
   * @dev See {IERC165-supportsInterface}.
   */
  function supportsInterface(
    bytes4 interfaceId
  )
    public
    view
    virtual
    override(ERC165Upgradeable, IERC165Upgradeable)
    returns (bool)
  {
    return
      interfaceId == type(IERC1155ReceiverUpgradeable).interfaceId ||
      super.supportsInterface(interfaceId);
  }

  /**
   * @dev This empty reserved space is put in place to allow future versions to add new
   * variables without shifting down storage in the inheritance chain.
   * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
   */
  uint256[50] private __gap;
}
