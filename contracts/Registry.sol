//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@asteroid-dao/eternal-storage/contracts/IStorage.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

import "hardhat/console.sol";

contract Registry is AccessControlEnumerable {
  bytes32 public constant EDITOR_ROLE = keccak256("EDITOR_ROLE");
  mapping(string => uint) addr_index;
  string [] addrs;
  address store;
  string registry_name;
  
  constructor(address _store, string memory _registry_name) {
    _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    _setupRole(EDITOR_ROLE, _msgSender());
    store = _store;
    registry_name = _registry_name;
  }

  function setStorage(address _addr) public onlyRole(DEFAULT_ADMIN_ROLE) {
    require(_addr != store, "address already set");
    store = _addr;
  }
  
  function add(string memory _name, address _addr) public onlyRole(EDITOR_ROLE) {
    require(addr_index[_name] == 0, "address already exists");
    addrs.push(_name);
    addr_index[_name] = addrs.length;
    IStorage(store).setAddress(keccak256(abi.encode(registry_name, _name)), _addr);
  }

  function remove(string memory _name) public onlyRole(EDITOR_ROLE) {
    require(addr_index[_name] != 0, "contract doesn't exist");
    delete addrs[addr_index[_name] - 1];
    delete addr_index[_name];
    IStorage(store).deleteAddress(keccak256(abi.encode(registry_name, _name)));
  }
  
  function get(string memory _name) public view returns (address addr){
    require(addr_index[_name] != 0, "contract doesn't exist");
    addr = IStorage(store).getAddress(keccak256(abi.encode(registry_name, _name)));
    require(addr != address(0), "address doesn't exist");
  }

  function list() public view returns (string[] memory _strs){
    return addrs;
  }
  
}
