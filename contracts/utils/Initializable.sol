// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./AddressUpgradeable.sol";

abstract contract Initializable {
  uint8 private _initialized;

  bool private _initializing;

  event Initialized(uint8 version);

  modifier initializer() {
    bool isTopLevelCall = !_initializing;
    require(
      (isTopLevelCall && _initialized < 1) ||
        (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
      "Initializable: contract is already initialized"
    );
    _initialized = 1;
    if (isTopLevelCall) {
      _initializing = true;
    }
    _;
    if (isTopLevelCall) {
      _initializing = false;
      emit Initialized(1);
    }
  }

  modifier reinitializer(uint8 version) {
    require(
      !_initializing && _initialized < version,
      "Initializable: contract is already initialized"
    );
    _initialized = version;
    _initializing = true;
    _;
    _initializing = false;
    emit Initialized(version);
  }

  modifier onlyInitializing() {
    require(_initializing, "Initializable: contract is not initializing");
    _;
  }

  function _disableInitializers() internal virtual {
    require(!_initializing, "Initializable: contract is initializing");
    if (_initialized < type(uint8).max) {
      _initialized = type(uint8).max;
      emit Initialized(type(uint8).max);
    }
  }

  /**
   * @dev Returns the highest version that has been initialized. See {reinitializer}.
   */
  function _getInitializedVersion() internal view returns (uint8) {
    return _initialized;
  }

  /**
   * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
   */
  function _isInitializing() internal view returns (bool) {
    return _initializing;
  }
}
