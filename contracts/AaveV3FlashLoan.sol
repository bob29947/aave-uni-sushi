// SPDX-License-Identifier: MIT
pragma solidity =0.8.10;

//need this FlashLoanSimpleReceiverBase in order to be a reciever of a flash loan
import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

error AaveV3FlashLoan__NotOwner();

interface IUniswapV3SingleSwap {
    function depositToken(uint256 _amountIn, address _tokenIn) external;

    function swapExactInputSingle(
        uint256 _amountIn,
        address _tokenIn,
        address _tokenOut
    ) external returns (uint256 amountOut);

    function getBalance(address _tokenAddress) external view returns (uint256);
}

contract AaveV3FlashLoan is FlashLoanSimpleReceiverBase {
    address private immutable i_owner;
    address private immutable i_uniswapV3SingleSwapAddress;
    address private tokenOut;

    event FlashLoanRequest(
        address indexed receiverAddress,
        uint256 indexed amountIn,
        address indexed tokenIn
    );

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert AaveV3FlashLoan__NotOwner();
        _;
    }

    constructor(
        address _addressProvider,
        address _uniswapV3SingleSwapAddress
    ) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        i_owner = msg.sender;
        i_uniswapV3SingleSwapAddress = _uniswapV3SingleSwapAddress;
    }

    receive() external payable {}

    function executeOperation(
        address _tokenIn,
        uint256 _amountIn,
        uint256 _premium,
        address /* initiator */,
        bytes calldata /* params */
    ) external override returns (bool) {
        IERC20(_tokenIn).approve(i_uniswapV3SingleSwapAddress, _amountIn);
        IUniswapV3SingleSwap(i_uniswapV3SingleSwapAddress).depositToken(_amountIn, _tokenIn);
        IUniswapV3SingleSwap(i_uniswapV3SingleSwapAddress).swapExactInputSingle(
            _amountIn,
            _tokenIn,
            tokenOut
        );

        uint256 amountOwed = _amountIn + _premium;
        IERC20(_tokenIn).approve(address(POOL), amountOwed);
        return true;
    }

    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20(_tokenAddress).transfer(msg.sender, IERC20(_tokenAddress).balanceOf(address(this)));
    }

    function requestFlashLoan(uint256 _amountIn, address _tokenIn, address _tokenOut) public {
        address receiverAddress = address(this);
        address asset = _tokenIn;
        uint256 amount = _amountIn;
        bytes memory params = "";
        uint16 referralCode = 0;
        tokenOut = _tokenOut;
        POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
        emit FlashLoanRequest(receiverAddress, amount, asset);
    }

    function getBalance(address _tokenAddress) public view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function getOwner() public view returns (address) {
        return (i_owner);
    }

    function getUniswapV3SingleSwapAddress() public view returns (address) {
        return (i_uniswapV3SingleSwapAddress);
    }
}
