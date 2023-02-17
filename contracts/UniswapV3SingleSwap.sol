// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ISushiSingleSwap {
    function depositToken(uint256 _amountIn, address _tokenIn) external;

    function swapToken(
        uint256 _amountIn,
        uint256 _amountOutMin,
        address _tokenIn,
        address _tokenOut
    ) external;
}

contract UniswapV3SingleSwap {
    ISwapRouter public immutable swapRouter;
    ISushiSingleSwap public immutable sushiSwapSingle;
    // For this example, we will set the pool fee to 0.3%.
    uint24 public constant poolFee = 3000;
    uint16 public constant amountOutMin = 1;

    constructor(address _routerAddress, address _sushiSwapSingleAddress) {
        swapRouter = ISwapRouter(_routerAddress);
        sushiSwapSingle = ISushiSingleSwap(_sushiSwapSingleAddress);
    }

    function depositToken(uint256 _amountIn, address _tokenIn) external {
        TransferHelper.safeTransferFrom(_tokenIn, msg.sender, address(this), _amountIn);
    }

    function swapExactInputSingle(
        uint256 _amountIn,
        address _tokenIn,
        address _tokenOut
    ) external returns (uint256 amountOut) {
        TransferHelper.safeApprove(_tokenIn, address(swapRouter), _amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: _tokenIn,
            tokenOut: _tokenOut,
            fee: poolFee,
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: _amountIn,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        amountOut = swapRouter.exactInputSingle(params);
        TransferHelper.safeApprove(_tokenOut, address(sushiSwapSingle), amountOut);
        sushiSwapSingle.depositToken(amountOut, _tokenOut);
        sushiSwapSingle.swapToken(amountOut, amountOutMin, _tokenOut, _tokenIn);
    }

    function getBalance(address _tokenAddress) public view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }
}
