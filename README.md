# DegenToken

A simple ERC20 token smart contract with additional features for redeeming items, tracking player levels, and managing token balances.

## Description

DegenToken is an ERC20 token built using the OpenZeppelin library. It includes features for minting and burning tokens, transferring tokens, redeeming tokens for items, and tracking player levels based on their token balance. This smart contract aims to provide a comprehensive solution for managing an in-game currency or reward system.

## Table of Contents

1. [Contract Details](#contract-details)
2. [Features](#features)
3. [Installing](#installing)
4. [Deployment](#deployment)
    - [Interacting with the Contract](#interaction-with-the-contract)
5. [Security Considerations](#security-considerations)
6. [Help](#help)
7. [Authors](#authors)
8. [License](#license)
9. [Contributing](#contributing)

## Contract Details

- **Name:** DegenToken
- **Symbol:** DGN
- **Decimals:** 18 (standard for most ERC20 tokens)

## Features

1. **Minting:** The contract owner can mint new tokens to any specified address.
2. **Transfers:** Users can transfer tokens to other addresses.
3. **Burning:** Users can burn (destroy) their own tokens.
4. **Redeeming Tokens:** Users can redeem their tokens for items in the in-game store.
5. **Checking token balance:** Users can check their token balance at any time.
6. **Level Up System:** Users can level up based on the token they have and redeemed.

## Installing

1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/DegenToken.git
   cd DegenToken
   ```

2. Open the project in Remix IDE:
   - Navigate to [Remix IDE](https://remix.ethereum.org/).
   - Create a new file named `DegenToken.sol`.
   - Copy and paste the following contract code into `DegenToken.sol`:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    
    uint256 public constant REDEMPTION_RATE = 100;  // Rate for redeeming tokens for items
    mapping(address => uint256) public itemsOwned;  // Mapping to track items owned by players
    mapping(address => uint256) public playerLevels; // Mapping to track player levels
    
    event LevelUp(address indexed player, uint256 newLevel);

    constructor() ERC20("DegenToken", "DGN")  Ownable(msg.sender)  {
        _mint(msg.sender, 10 * (10 ** uint256(decimals())));  // Initial minting to owner
    }

    // Function for players to redeem tokens for items
    function redeemItem(uint256 quantity) public {
        uint256 cost = REDEMPTION_RATE * quantity;
        require(balanceOf(msg.sender) >= cost, "Not enough tokens to redeem for an item");

        itemsOwned[msg.sender] += quantity;
        _burn(msg.sender, cost);
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
}
```

## Deployment

1. **Compile the Contract:**
   - Open Remix IDE.
   - Select the `DegenToken.sol` file.
   - Go to the "Solidity Compiler" tab.
   - Click "Compile DegenToken.sol".

2. **Deploy the Contract:**
   - Go to the "Deploy & Run Transactions" tab.
   - Select `DegenToken` from the contract dropdown.
   - Choose the "Injected Web3" environment if using MetaMask, or "Remix VM" for local testing.
   - Click "Deploy".
   - Confirm the transaction if using MetaMask.

#### Interacting with the Contract

1. **Mint Tokens:**
   - Function: `mintTokens(address to, uint256 amount)`
   - Example:
     ```sh
     mintTokens("0xRecipientAddress", 1000)
     ```

2. **Transfer Tokens:**
   - Function: `transferTokens(address to, uint256 amount)`
   - Example:
     ```sh
     transferTokens("0xRecipientAddress", 500)
     ```

3. **Redeem Tokens:**
   - Function: `redeemItem(uint256 quantity)`
   - Example:
     ```sh
     redeemItems(2)
     ```

4. **Check Balance:**
   - Function: `checkBalance(address account)`
   - Example:
     ```sh
     checkBalance("0xYourAddressHere")
     ```

5. **Burn Tokens:**
   - Function: `burnTokens(uint256 amount)`
   - Example:
     ```sh
     burnTokens(300)
     ```

6. **Check Redeemed Items:**
   - Function: `checkItemsOwned(address user)`
   - Example:
     ```sh
     checkItemsOwned("0xYourAddressHere")
     ```

7. **Check Player Level:**
   - Function: `getPlayerLevel(address player)`
   - Example:
     ```sh
     getPlayerLevel("0xYourAddressHere")
     ```

## Security Considerations

- Ensure proper access control for minting tokens (onlyOwner modifier).
- Test thoroughly before deploying to a live network.
- Consider using libraries like OpenZeppelin for more robust and audited token contracts.

## Help

For common problems or issues, refer to the following tips:

1. **Compilation Errors:**
   - Ensure you are using the correct Solidity version (`^0.8.23`).

2. **Deployment Issues:**
   - Make sure you have enough funds in your account for deploying the contract.
   - Check your network settings if you are deploying to a testnet.

3. **Transaction Errors:**
   - Verify the input parameters (addresses, amounts) are correct and valid.

For additional help, you can run:
```sh
remix help
```

## Authors

Kurt Lawrence Dela Cruz

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributions

Contributions are welcome! Please open an issue or submit a pull request for any improvements.

```
This raw markdown code can be copied and pasted directly into your `README.md` file.
```
