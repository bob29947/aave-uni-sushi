// SPDX-License-Identifier: MIT
pragma solidity =0.8.10;

interface IUniswapV3SingleSwap {
    function depositToken(uint256 amountIn, address tokenIn) external;

    function withdraw(address tokenAddress) external;

    function swapExactInputSingle(
        uint256 amountIn,
        address tokenIn,
        address tokenOut
    ) external returns (uint256 amountOut);
}
