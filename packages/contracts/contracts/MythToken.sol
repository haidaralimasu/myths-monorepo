// SPDX-License-Identifier: MIT

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {ERC721AQueryable} from "erc721a/contracts/extensions/ERC721AQueryable.sol";

contract MythToken is Ownable, Pausable, ReentrancyGuard, ERC721AQueryable {
    using Strings for uint256;

    string private baseTokenURI;
    string private hiddenTokenURI;

    uint256 public maxMyths = 10000;
    uint256 public price = 0.08 ether;
    uint256 public maxPerMint = 5;
    uint256 public maxMythMint = 10;
    uint256 public reservedMyths = 100;

    uint256 public reservedClaimed;
    uint256 public numMythsMinted;

    bool public publicSaleStarted;
    bool public presaleStarted;

    mapping(address => bool) private _presaleEligible;
    mapping(address => uint256) _totalClaimed;

    modifier whenPresaleStarted() {
        require(presaleStarted, "Presale has not started");
        _;
    }

    modifier whenPublicSaleStarted() {
        require(publicSaleStarted, "Public sale has not started");
        _;
    }

    modifier mintComplaince(uint256 _amount) {
        require(
            _totalMinted() + _amount <= maxMyths,
            "All Myths are solded out"
        );
        require(
            _amount <= maxPerMint,
            "Cannot mint more Myths in one transaction"
        );
        _;
    }

    modifier presaleComplaince(uint256 _amount, address _minter) {
        require(
            _totalClaimed[_minter] + _amount <= maxMythMint,
            "Please wait for public sale to mint more Myth"
        );
        _;
    }
}
