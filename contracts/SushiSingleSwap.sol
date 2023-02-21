// SPDX-License-Identifier: MIT
pragma solidity =0.6.12;

import "@sushiswap/sushiswap/contracts/interfaces/IUniswapV2Router02.sol";
import "@sushiswap/sushiswap/contracts/libraries/TransferHelper.sol";
import {IERC20Uniswap} from "@sushiswap/sushiswap/contracts/interfaces/IERC20.sol";

contract SushiSingleSwap {
    IUniswapV2Router02 private immutable i_uniswapV2Router02;

    constructor(address routerAddress) public {
        i_uniswapV2Router02 = IUniswapV2Router02(routerAddress);
    }

    function depositToken(uint256 amountIn, address tokenIn) external {
        TransferHelper.safeTransferFrom(tokenIn, msg.sender, address(this), amountIn);
    }

    function withdraw(address tokenAddress) external {
        IERC20Uniswap(tokenAddress).transfer(
            msg.sender,
            IERC20Uniswap(tokenAddress).balanceOf(address(this))
        );
    }

    function swapToken(
        uint256 amountIn,
        uint256 amountOutMinimum,
        address tokenIn,
        address tokenOut
    ) external {
        address[] memory path;
        path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;

        TransferHelper.safeApprove(tokenIn, address(i_uniswapV2Router02), amountIn);
        i_uniswapV2Router02.swapExactTokensForTokens(
            amountIn,
            amountOutMinimum,
            path,
            address(this),
            block.timestamp
        );
    }
}
