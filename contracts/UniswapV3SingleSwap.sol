// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ISushiSingleSwap} from "contracts/interfaces/ISushiSingleSwap.sol";

contract UniswapV3SingleSwap {
    // For this example, we will set the pool fee to 0.3%.
    uint24 private constant POOL_FEE = 3000;
    uint16 private constant AMOUNT_OUT_MINIMUM = 1;
    ISwapRouter private immutable i_swapRouter;
    ISushiSingleSwap private immutable i_sushiSingleSwap;

    constructor(address routerAddress, address sushiSingleSwapAddress) {
        i_swapRouter = ISwapRouter(routerAddress);
        i_sushiSingleSwap = ISushiSingleSwap(sushiSingleSwapAddress);
    }

    function depositToken(uint256 amountIn, address tokenIn) external {
        TransferHelper.safeTransferFrom(tokenIn, msg.sender, address(this), amountIn);
    }

    function withdraw(address tokenAddress) external {
        IERC20(tokenAddress).transfer(msg.sender, IERC20(tokenAddress).balanceOf(address(this)));
    }

    function swapExactInputSingle(
        uint256 amountIn,
        address tokenIn,
        address tokenOut
    ) external returns (uint256 amountOut) {
        TransferHelper.safeApprove(tokenIn, address(i_swapRouter), amountIn);
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            fee: POOL_FEE,
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: amountIn,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });
        amountOut = i_swapRouter.exactInputSingle(params);

        TransferHelper.safeApprove(tokenOut, address(i_sushiSingleSwap), amountOut);
        i_sushiSingleSwap.depositToken(amountOut, tokenOut);
        i_sushiSingleSwap.swapToken(amountOut, AMOUNT_OUT_MINIMUM, tokenOut, tokenIn);
        i_sushiSingleSwap.withdraw(tokenIn);
    }
}
