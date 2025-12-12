// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IMorphoBlue
 * @notice Interface for Morpho Blue lending protocol
 * @dev This interface combines the core functions and types from the Morpho Blue protocol
 * @custom:tags morpho,defi,lending,blue,protocol
 */
interface IMorphoBlue {
    /**
     * @notice Market identifier type
     */
    type Id is bytes32;

    /**
     * @notice Market parameters
     * @param loanToken The address of the token to be borrowed/supplied
     * @param collateralToken The address of the token to be used as collateral
     * @param oracle The address of the oracle used to price the collateral against the loan token
     * @param irm The address of the interest rate model
     * @param lltv The liquidation loan-to-value (scaled by 1e18)
     */
    struct MarketParams {
        address loanToken;
        address collateralToken;
        address oracle;
        address irm;
        uint256 lltv;
    }

    /**
     * @notice Position of a user in a market
     * @dev For `feeRecipient`, `supplyShares` does not contain accrued shares since the last interest accrual
     * @param supplyShares The supply shares amount
     * @param borrowShares The borrow shares amount
     * @param collateral The collateral amount
     */
    struct Position {
        uint256 supplyShares;
        uint128 borrowShares;
        uint128 collateral;
    }

    /**
     * @notice Market state
     * @dev `totalSupplyAssets` and `totalBorrowAssets` do not contain accrued interest since the last interest accrual
     * @dev `totalSupplyShares` does not contain additional shares accrued by `feeRecipient` since the last interest accrual
     * @param totalSupplyAssets The total amount of assets supplied
     * @param totalSupplyShares The total amount of supply shares
     * @param totalBorrowAssets The total amount of assets borrowed
     * @param totalBorrowShares The total amount of borrow shares
     * @param lastUpdate The timestamp of the last interest accrual
     * @param fee The fee rate (scaled by 1e18)
     */
    struct Market {
        uint128 totalSupplyAssets;
        uint128 totalSupplyShares;
        uint128 totalBorrowAssets;
        uint128 totalBorrowShares;
        uint128 lastUpdate;
        uint128 fee;
    }

    /**
     * @notice Authorization data for delegated operations
     * @param authorizer The account delegating authorization
     * @param authorized The account being authorized
     * @param isAuthorized Whether the authorization is granted or revoked
     * @param nonce The nonce for preventing replay attacks
     * @param deadline The deadline after which the signature is no longer valid
     */
    struct Authorization {
        address authorizer;
        address authorized;
        bool isAuthorized;
        uint256 nonce;
        uint256 deadline;
    }

    /**
     * @notice EIP-712 signature components
     * @param v The recovery ID
     * @param r The first 32 bytes of the signature
     * @param s The second 32 bytes of the signature
     */
    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    /**
     * @notice The EIP-712 domain separator
     * @dev Every EIP-712 signed message based on this domain separator can be reused on chains with the same chain ID
     */
    function DOMAIN_SEPARATOR() external view returns (bytes32);

    /**
     * @notice The owner of the contract
     */
    function owner() external view returns (address);

    /**
     * @notice The fee recipient for all markets
     */
    function feeRecipient() external view returns (address);

    /**
     * @notice Checks if an interest rate model is enabled
     * @param irm The address of the interest rate model
     */
    function isIrmEnabled(address irm) external view returns (bool);

    /**
     * @notice Checks if a liquidation loan-to-value is enabled
     * @param lltv The liquidation loan-to-value
     */
    function isLltvEnabled(uint256 lltv) external view returns (bool);

    /**
     * @notice Checks if an account is authorized to manage another account's positions
     * @param authorizer The account delegating authorization
     * @param authorized The account to check authorization for
     */
    function isAuthorized(address authorizer, address authorized) external view returns (bool);

    /**
     * @notice Returns the current nonce for an account
     * @param authorizer The account to get the nonce for
     */
    function nonce(address authorizer) external view returns (uint256);

    /**
     * @notice Sets a new owner for the contract
     * @param newOwner The new owner address
     */
    function setOwner(address newOwner) external;

    /**
     * @notice Enables an interest rate model
     * @param irm The address of the interest rate model to enable
     */
    function enableIrm(address irm) external;

    /**
     * @notice Enables a liquidation loan-to-value
     * @param lltv The liquidation loan-to-value to enable
     */
    function enableLltv(uint256 lltv) external;

    /**
     * @notice Sets the fee for a market
     * @param marketParams The market parameters
     * @param newFee The new fee rate (scaled by 1e18)
     */
    function setFee(MarketParams memory marketParams, uint256 newFee) external;

    /**
     * @notice Sets a new fee recipient
     * @param newFeeRecipient The new fee recipient address
     */
    function setFeeRecipient(address newFeeRecipient) external;

    /**
     * @notice Creates a new market
     * @param marketParams The market parameters
     */
    function createMarket(MarketParams memory marketParams) external;

    /**
     * @notice Supplies assets or shares to a market
     * @param marketParams The market parameters
     * @param assets The amount of assets to supply (set to 0 if using shares)
     * @param shares The amount of shares to mint (set to 0 if using assets)
     * @param onBehalf The address that will own the increased supply position
     * @param data Arbitrary data to pass to the callback
     * @return assetsSupplied The amount of assets supplied
     * @return sharesSupplied The amount of shares minted
     */
    function supply(
        MarketParams memory marketParams,
        uint256 assets,
        uint256 shares,
        address onBehalf,
        bytes memory data
    ) external returns (uint256 assetsSupplied, uint256 sharesSupplied);

    /**
     * @notice Withdraws assets or shares from a market
     * @param marketParams The market parameters
     * @param assets The amount of assets to withdraw (set to 0 if using shares)
     * @param shares The amount of shares to burn (set to 0 if using assets)
     * @param onBehalf The address of the owner of the supply position
     * @param receiver The address that will receive the withdrawn assets
     * @return assetsWithdrawn The amount of assets withdrawn
     * @return sharesWithdrawn The amount of shares burned
     */
    function withdraw(
        MarketParams memory marketParams,
        uint256 assets,
        uint256 shares,
        address onBehalf,
        address receiver
    ) external returns (uint256 assetsWithdrawn, uint256 sharesWithdrawn);

    /**
     * @notice Borrows assets or shares from a market
     * @param marketParams The market parameters
     * @param assets The amount of assets to borrow (set to 0 if using shares)
     * @param shares The amount of shares to mint (set to 0 if using assets)
     * @param onBehalf The address that will own the increased borrow position
     * @param receiver The address that will receive the borrowed assets
     * @return assetsBorrowed The amount of assets borrowed
     * @return sharesBorrowed The amount of shares minted
     */
    function borrow(
        MarketParams memory marketParams,
        uint256 assets,
        uint256 shares,
        address onBehalf,
        address receiver
    ) external returns (uint256 assetsBorrowed, uint256 sharesBorrowed);

    /**
     * @notice Repays a borrow position
     * @param marketParams The market parameters
     * @param assets The amount of assets to repay (set to 0 if using shares)
     * @param shares The amount of shares to burn (set to 0 if using assets)
     * @param onBehalf The address of the owner of the debt position
     * @param data Arbitrary data to pass to the callback
     * @return assetsRepaid The amount of assets repaid
     * @return sharesRepaid The amount of shares burned
     */
    function repay(
        MarketParams memory marketParams,
        uint256 assets,
        uint256 shares,
        address onBehalf,
        bytes memory data
    ) external returns (uint256 assetsRepaid, uint256 sharesRepaid);

    /**
     * @notice Supplies collateral to a market
     * @param marketParams The market parameters
     * @param assets The amount of collateral to supply
     * @param onBehalf The address that will own the increased collateral position
     * @param data Arbitrary data to pass to the callback
     */
    function supplyCollateral(
        MarketParams memory marketParams,
        uint256 assets,
        address onBehalf,
        bytes memory data
    ) external;

    /**
     * @notice Withdraws collateral from a market
     * @param marketParams The market parameters
     * @param assets The amount of collateral to withdraw
     * @param onBehalf The address of the owner of the collateral position
     * @param receiver The address that will receive the collateral assets
     */
    function withdrawCollateral(
        MarketParams memory marketParams,
        uint256 assets,
        address onBehalf,
        address receiver
    ) external;

    /**
     * @notice Liquidates an unhealthy position
     * @param marketParams The market parameters
     * @param borrower The owner of the position
     * @param seizedAssets The amount of collateral to seize (set to 0 if using repaidShares)
     * @param repaidShares The amount of shares to repay (set to 0 if using seizedAssets)
     * @param data Arbitrary data to pass to the callback
     * @return The amount of assets seized
     * @return The amount of assets repaid
     */
    function liquidate(
        MarketParams memory marketParams,
        address borrower,
        uint256 seizedAssets,
        uint256 repaidShares,
        bytes memory data
    ) external returns (uint256, uint256);

    /**
     * @notice Executes a flash loan
     * @param token The token to flash loan
     * @param assets The amount of assets to flash loan
     * @param data Arbitrary data to pass to the callback
     */
    function flashLoan(address token, uint256 assets, bytes calldata data) external;

    /**
     * @notice Sets the authorization for an address to manage the caller's positions
     * @param authorized The authorized address
     * @param newIsAuthorized The new authorization status
     */
    function setAuthorization(address authorized, bool newIsAuthorized) external;

    /**
     * @notice Sets authorization using a signature
     * @param authorization The authorization data
     * @param signature The signature
     */
    function setAuthorizationWithSig(Authorization calldata authorization, Signature calldata signature) external;

    /**
     * @notice Accrues interest for a market
     * @param marketParams The market parameters
     */
    function accrueInterest(MarketParams memory marketParams) external;

    /**
     * @notice Returns the data stored on the different slots
     * @param slots The storage slots to read
     * @return The values stored in the slots
     */
    function extSloads(bytes32[] memory slots) external view returns (bytes32[] memory);

    /**
     * @notice Returns the position of a user in a market
     * @param id The market identifier
     * @param user The user address
     * @return The position data
     */
    function position(Id id, address user) external view returns (Position memory);

    /**
     * @notice Returns the state of a market
     * @param id The market identifier
     * @return The market state
     */
    function market(Id id) external view returns (Market memory);

    /**
     * @notice Returns the market parameters for a market ID
     * @param id The market identifier
     * @return The market parameters
     */
    function idToMarketParams(Id id) external view returns (MarketParams memory);
} 