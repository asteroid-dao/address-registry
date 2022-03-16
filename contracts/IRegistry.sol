//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRegistry {

  function setStorage(address _addr) external;
  
  function add(string memory _name, address _addr) external;

  function remove(string memory _name) external;
  
  function get(string memory _name) external view returns (address addr);

  function list() external view returns (string[] memory _strs);
  
}
