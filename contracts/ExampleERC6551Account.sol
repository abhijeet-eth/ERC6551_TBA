pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC1271.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Support/ERC721Holder.sol";
import "./Support/Bytecode.sol";
import "./Interface/IERC6551Account.sol";


contract ExampleERC6551Account is IERC165, IERC1271, IERC6551Account,ERC721Holder  {
    error NotAuthorized();

    event ERC2OTokenTransferred(address from, address to, uint256 tokenId);
    event NFTTransferred(address from, address to, uint256 tokenId);

    receive() external payable {}

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        address _owner = owner();
        if (msg.sender != _owner) revert NotAuthorized();
    }

    function executeCall(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable returns (bytes memory result) {
        require(msg.sender == owner(), "Not token owner");
        return _call(to, value, data);
        
    }
    
    // Transfer an ERC2O Token from this contract to another address
    function transferERC20Tokens(
        address tokenCollection,
        address to,
        uint256 amount
    ) external onlyOwner {
        // Get the instance of the IERC20 contract
        IERC20 erc20Contract = IERC20(tokenCollection);

        // Check if the owner have required amount of tokens
        require(
            erc20Contract.balanceOf(address(this)) >= amount,
            "Owner dont have sufficient amount of ERC20 tokens"
        );

        // Transfer the tokens to the specified address
        erc20Contract.transfer(to, amount);

        // Emit the ERC2OTokenTransferred event
        emit ERC2OTokenTransferred(address(this), to, amount);
    }

    function transferFromERC20Tokens(
        address tokenCollection,
        address from,
        address to,
        uint256 amount
    ) external onlyOwner {
        // Get the instance of the IERC20 contract
        IERC20 erc20Contract = IERC20(tokenCollection);

        // Check if the owner have required amount of tokens
        require(
            erc20Contract.balanceOf(from) >= amount,
            "Owner dont have sufficient amount of ERC20 tokens"
        );

        // Transfer the tokens to the specified address
        erc20Contract.transferFrom(from, to, amount);

        // Emit the ERC2OTokenTransferred event
        emit ERC2OTokenTransferred(from, to, amount);
    }

    function ApproveERC20Tokens(
        address tokenCollection,
        address spender,
        uint256 amount
    ) external onlyOwner {
        // Get the instance of the IERC20 contract
        IERC20 erc20Contract = IERC20(tokenCollection);

        // Check if the owner have required amount of tokens
        require(
            erc20Contract.balanceOf(address(this)) >= amount,
            "Owner dont have sufficient amount of ERC20 tokens"
        );

        // Transfer the tokens to the specified address
        erc20Contract.approve(spender, amount);

        // Emit the Approve event
        emit Approval(address(this), spender, amount);
    }

    function transferERC721Tokens(
        address tokenCollection,
        address to,
        uint256 tokenId
    ) external onlyOwner {
        // Get the instance of the ERC721 contract
        IERC721 nftContract = IERC721(tokenCollection);

        // Check if the sender is the current owner of the NFT
        require(
            nftContract.ownerOf(tokenId) == address(this),
            "NFTHandler: Sender is not the owner"
        );

        // Transfer the NFT to the specified address
        nftContract.transferFrom(address(this), to, tokenId);

        // Emit the NFTTransferred event
        emit NFTTransferred(address(this), to, tokenId);
    }

    function _call(
        address to,
        uint256 value,
        bytes calldata data
    ) internal returns (bytes memory result) {
    bool success;
        (success, result) = to.call{value: value}(data);

        if (!success) {
            assembly {
                revert(add(result, 32), mload(result))
            }
        }
    }    

    function token()
        external
        view
        returns (
            uint256 chainId,
            address tokenContract,
            uint256 tokenId
        )
    {
        uint256 length = address(this).code.length;
        return
            abi.decode(
                Bytecode.codeAt(address(this), length - 0x60, length),
                (uint256, address, uint256)
            );
    }

    function owner() public view returns (address) {
        (uint256 chainId, address tokenContract, uint256 tokenId) = this
            .token();
        if (chainId != block.chainid) return address(0);

        return IERC721(tokenContract).ownerOf(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return (interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC721Receiver).interfaceId ||
            interfaceId == type(IERC6551Account).interfaceId);
    }

    function isValidSignature(bytes32 hash, bytes memory signature)
        external
        view
        returns (bytes4 magicValue)
    {
        bool isValid = SignatureChecker.isValidSignatureNow(
            owner(),
            hash,
            signature
        );

        if (isValid) {
            return IERC1271.isValidSignature.selector;
        }

        return "";
    }

    function nonce() external view returns (uint256){
        return 0;
    }

    //     function supportsInterface(
    //     bytes4 interfaceId
    // ) public view virtual override(IERC165, IERC721Receiver) returns (bool) {
    //     // default interface support
    //     if (
    //         interfaceId == type(IERC721Receiver).interfaceId ||
    //         interfaceId == type(IERC165).interfaceId
    //     ) {
    //         return true;
    //     }
    // }


}