// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    struct Item {
        string name;
        uint256 price;
    }

    Item[] public items;  // Array to store items

    mapping(address => uint256) public itemsOwned;  // Mapping to track items owned by players
    mapping(address => uint256) public playerLevels; // Mapping to track player levels

    event LevelUp(address indexed player, uint256 newLevel);
    event ItemRedeemed(address indexed player, string itemName, uint256 quantity);

    constructor() ERC20("DegenToken", "DGN")  Ownable(msg.sender)  {
        _mint(msg.sender, 10 * (10 ** uint256(decimals())));  // Initial minting to owner

        // Add items to the store
        items.push(Item("Sword", 100));
        items.push(Item("Shield", 150));
        items.push(Item("Potion", 50));
    }

    // Function for players to redeem tokens for items
    function redeemItem(uint256 itemId, uint256 quantity) public {
        require(itemId < items.length, "Invalid item ID");
        Item memory item = items[itemId];
        uint256 cost = item.price * quantity;
        require(balanceOf(msg.sender) >= cost, "Not enough tokens to redeem for item");

        itemsOwned[msg.sender] += quantity;
        _burn(msg.sender, cost);
        emit ItemRedeemed(msg.sender, item.name, quantity);
    }

    // Function to check the number of items owned by a player
    function checkItemsOwned(address user) public view returns (uint256) {
        return itemsOwned[user];
    }

    // Only owner can mint new tokens
    function mintTokens(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        _updatePlayerLevel(to);
    }

    // Function to check token balance of any account
    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    // Anyone can burn their own tokens
    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Not enough tokens to burn");
        _burn(msg.sender, amount);
        _updatePlayerLevel(msg.sender);
    }

    // Players can transfer tokens to others
    function transferTokens(address to, uint256 amount) public {
        require(to != address(0), "Invalid address");
        require(balanceOf(msg.sender) >= amount, "Not enough tokens to transfer");
        _transfer(msg.sender, to, amount);
        _updatePlayerLevel(msg.sender);
        _updatePlayerLevel(to);
    }

    // Private function to update player level based on token balance
    function _updatePlayerLevel(address player) private {
        uint256 balance = balanceOf(player);
        uint256 newLevel = balance / 1000; // Example leveling logic: 1 level per 1000 tokens
        if (newLevel > playerLevels[player]) {
            playerLevels[player] = newLevel;
            emit LevelUp(player, newLevel);
        }
    }

    // Function to get the level of a player
    function getPlayerLevel(address player) public view returns (uint256) {
        return playerLevels[player];
    }

    // Function to get the list of items available for redemption
    function getItems() public view returns (Item[] memory) {
        return items;
    }
}
