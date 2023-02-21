// SPDX-License-Identifier: MIT
pragma solidity =0.8.10;

//need this FlashLoanSimpleReceiverBase in order to be a reciever of a flash loan
import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {IUniswapV3SingleSwap} from "contracts/interfaces/IUniswapV3SingleSwap.sol";

contract AaveV3FlashLoan is FlashLoanSimpleReceiverBase {
    address private immutable i_owner;
    IUniswapV3SingleSwap private immutable i_uniswapV3SingleSwap;
    address private tokenOut;

    event FlashLoanRequest(
        address indexed receiverAddress,
        uint256 indexed amountIn,
        address indexed tokenIn
    );

    error AaveV3FlashLoan__NotOwner();

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert AaveV3FlashLoan__NotOwner();
        _;
    }

    constructor(
        address addressProvider,
        address uniswapV3SingleSwapAddress
    ) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(addressProvider)) {
        i_owner = msg.sender;
        i_uniswapV3SingleSwap = IUniswapV3SingleSwap(uniswapV3SingleSwapAddress);
    }

    receive() external payable {}

    function withdraw(address tokenAddress) external onlyOwner {
        IERC20(tokenAddress).transfer(msg.sender, IERC20(tokenAddress).balanceOf(address(this)));
    }

    function executeOperation(
        address tokenIn,
        uint256 amountIn,
        uint256 premium,
        address /* initiator */,
        bytes calldata /* params */
    ) external override returns (bool) {
        IERC20(tokenIn).approve(address(i_uniswapV3SingleSwap), amountIn);
        i_uniswapV3SingleSwap.depositToken(amountIn, tokenIn);
        i_uniswapV3SingleSwap.swapExactInputSingle(amountIn, tokenIn, tokenOut);
        i_uniswapV3SingleSwap.withdraw(tokenIn);

        uint256 amountOwed = amountIn + premium;
        IERC20(tokenIn).approve(address(POOL), amountOwed);
        return true;
    }

    function requestFlashLoan(uint256 amountIn, address tokenIn, address _tokenOut) public {
        address receiverAddress = address(this);
        address asset = tokenIn;
        uint256 amount = amountIn;
        bytes memory params = "";
        uint16 referralCode = 0;
        tokenOut = _tokenOut;
        POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
        emit FlashLoanRequest(receiverAddress, amount, asset);
    }

    function getBalance(address tokenAddress) public view returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function getOwner() public view returns (address) {
        return (i_owner);
    }
}
