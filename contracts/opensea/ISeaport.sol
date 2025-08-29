// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ISeaport
 * @notice Interface for OpenSea's Seaport 1.6 marketplace protocol
 * @dev This interface contains the main functions for interacting with the marketplace
 * @custom:tatara 0x0000000000FFe8B47B3e2130213B802212439497
 * @custom:katana 0x0000000000000068F116a894984e2DB1123eB395
 * @custom:bokuto 0x0000000000000068F116a894984e2DB1123eB395
 * @custom:tags opensea,nft,marketplace,seaport
 */
interface ISeaport {
    /**
     * @notice Types of items supported by Seaport
     */
    enum ItemType {
        NATIVE,                    // Native token (e.g., ETH)
        ERC20,                     // ERC20 token
        ERC721,                    // ERC721 token
        ERC1155,                   // ERC1155 token
        ERC721_WITH_CRITERIA,      // ERC721 with criteria (multiple possible tokens)
        ERC1155_WITH_CRITERIA      // ERC1155 with criteria (multiple possible tokens)
    }

    /**
     * @notice Types of orders in Seaport
     */
    enum OrderType {
        FULL_OPEN,                // No restrictions
        PARTIAL_OPEN,             // Partial fills allowed
        FULL_RESTRICTED,          // Restricted to zone
        PARTIAL_RESTRICTED        // Partial fills allowed, restricted to zone
    }

    /**
     * @notice Contains spent items for offer or consideration
     */
    struct SpentItem {
        ItemType itemType;         // The type of item (ERC20/721/1155/Native)
        address token;             // The token address
        uint256 identifier;        // The token identifier (or criteria)
        uint256 amount;            // The amount of the token to transfer
    }

    /**
     * @notice Contains received items for consideration
     */
    struct ReceivedItem {
        ItemType itemType;         // The type of item (ERC20/721/1155/Native)
        address token;             // The token address
        uint256 identifier;        // The token identifier (or criteria)
        uint256 amount;            // The amount of the token to transfer
        address payable recipient; // The recipient of the item
    }
    
    /**
     * @notice Additional recipients for basic orders
     */
    struct AdditionalRecipient {
        uint256 amount;
        address payable recipient;
    }

    /**
     * @notice Basic order parameters for a single order
     */
    struct OrderParameters {
        address offerer;           // The order's offerer
        address zone;              // The zone of the order (e.g., for restricted orders)
        SpentItem[] offer;         // The offer items
        ReceivedItem[] consideration; // The consideration items
        OrderType orderType;       // The type of order
        uint256 startTime;         // The order start time
        uint256 endTime;           // The order end time
        bytes32 zoneHash;          // The hash for the zone
        uint256 salt;              // Random value for uniqueness
        bytes32 conduitKey;        // The conduit key if using a conduit
        uint256 totalOriginalConsiderationItems; // The total number of original consideration items
    }
    
    /**
     * @notice Order with parameters and signature
     */
    struct Order {
        OrderParameters parameters;
        bytes signature;
    }
    
    /**
     * @notice Components needed for order creation
     */
    struct OrderComponents {
        address offerer;
        address zone;
        SpentItem[] offer;
        ReceivedItem[] consideration;
        OrderType orderType;
        uint256 startTime;
        uint256 endTime;
        bytes32 zoneHash;
        uint256 salt;
        bytes32 conduitKey;
        uint256 counter;
    }

    /**
     * @notice Parameters for fulfilling a basic order
     */
    struct BasicOrderParameters {
        address considerationToken;
        uint256 considerationIdentifier;
        uint256 considerationAmount;
        address payable offerer;
        address zone;
        address offerToken;
        uint256 offerIdentifier;
        uint256 offerAmount;
        uint8 basicOrderType;
        uint256 startTime;
        uint256 endTime;
        bytes32 zoneHash;
        uint256 salt;
        bytes32 offererConduitKey;
        bytes32 fulfillerConduitKey;
        uint256 totalOriginalAdditionalRecipients;
        AdditionalRecipient[] additionalRecipients;
        bytes signature;
    }

    /**
     * @notice Advanced order parameters with numerator/denominator for partial fills
     */
    struct AdvancedOrder {
        OrderParameters parameters; // The order parameters
        uint120 numerator;         // The numerator for partial fills
        uint120 denominator;       // The denominator for partial fills
        bytes signature;           // The signature of the order
        bytes extraData;           // Extra data supplied with order
    }

    /**
     * @notice For resolving criteria-based orders
     */
    struct CriteriaResolver {
        uint256 orderIndex;        // The index of the order
        uint256 side;              // 0 for offer, 1 for consideration
        uint256 index;             // The index of the item in the offer/consideration
        uint256 identifier;        // The actual token identifier
        bytes32[] criteriaProof;   // Merkle proof for criteria-based items
    }

    /**
     * @notice Component for fulfillment
     */
    struct FulfillmentComponent {
        uint256 orderIndex;        // The index of the order
        uint256 itemIndex;         // The index of the item in the order
    }

    /**
     * @notice Order fulfillment data
     */
    struct Fulfillment {
        FulfillmentComponent[] offerComponents;      // Components for the offer items
        FulfillmentComponent[] considerationComponents; // Components for the consideration items
    }

    /**
     * @notice Execution data for fulfillment
     */
    struct Execution {
        ReceivedItem item;         // The received item
        address offerer;           // The offerer of the item
        bytes32 conduitKey;        // The conduit key
    }

    // Events
    event OrderFulfilled(
        bytes32 orderHash,
        address indexed offerer,
        address indexed zone,
        address fulfiller,
        SpentItem[] offer,
        ReceivedItem[] consideration
    );

    event OrderCancelled(
        bytes32 orderHash,
        address indexed offerer,
        address indexed zone
    );

    event OrdersMatched(bytes32[] orderHashes);

    event CounterIncremented(
        address indexed offerer, 
        uint256 newCounter
    );

    /**
     * @notice Fulfill an order offering an ERC721 token
     * @param parameters The parameters for fulfilling a basic order
     * @return fulfilled Boolean indicating whether the order was fulfilled
     */
    function fulfillBasicOrder(
        BasicOrderParameters calldata parameters
    ) external payable returns (bool fulfilled);

    /**
     * @notice Fulfill a single order
     * @param order The order to fulfill
     * @param fulfillerConduitKey The conduitKey for the fulfiller
     * @return fulfilled Boolean indicating whether the order was fulfilled
     */
    function fulfillOrder(
        Order calldata order,
        bytes32 fulfillerConduitKey
    ) external payable returns (bool fulfilled);

    /**
     * @notice Fulfill an advanced order with criteria resolution
     * @param advancedOrder The advanced order to fulfill
     * @param criteriaResolvers Array of criteria resolvers
     * @param fulfillerConduitKey The conduitKey for the fulfiller
     * @param recipient The intended recipient for all received items
     * @return fulfilled Boolean indicating whether the order was fulfilled
     */
    function fulfillAdvancedOrder(
        AdvancedOrder calldata advancedOrder,
        CriteriaResolver[] calldata criteriaResolvers,
        bytes32 fulfillerConduitKey,
        address recipient
    ) external payable returns (bool fulfilled);

    /**
     * @notice Fulfill multiple available orders
     * @param orders The orders to fulfill
     * @param offerFulfillments Array of offer fulfillment components
     * @param considerationFulfillments Array of consideration fulfillment components
     * @param fulfillerConduitKey The conduitKey for the fulfiller
     * @param maximumFulfilled The maximum number of orders to fulfill
     * @return availableOrders Boolean array indicating which orders were fulfillable
     * @return executions The executions performed
     */
    function fulfillAvailableOrders(
        Order[] calldata orders,
        FulfillmentComponent[][] calldata offerFulfillments,
        FulfillmentComponent[][] calldata considerationFulfillments,
        bytes32 fulfillerConduitKey,
        uint256 maximumFulfilled
    ) external payable returns (bool[] memory availableOrders, Execution[] memory executions);

    /**
     * @notice Fulfill multiple available advanced orders
     * @param advancedOrders The advanced orders to fulfill
     * @param criteriaResolvers Array of criteria resolvers
     * @param offerFulfillments Array of offer fulfillment components
     * @param considerationFulfillments Array of consideration fulfillment components
     * @param fulfillerConduitKey The conduitKey for the fulfiller
     * @param recipient The intended recipient for all received items
     * @param maximumFulfilled The maximum number of orders to fulfill
     * @return availableOrders Boolean array indicating which orders were fulfillable
     * @return executions The executions performed
     */
    function fulfillAvailableAdvancedOrders(
        AdvancedOrder[] calldata advancedOrders,
        CriteriaResolver[] calldata criteriaResolvers,
        FulfillmentComponent[][] calldata offerFulfillments,
        FulfillmentComponent[][] calldata considerationFulfillments,
        bytes32 fulfillerConduitKey,
        address recipient,
        uint256 maximumFulfilled
    ) external payable returns (bool[] memory availableOrders, Execution[] memory executions);

    /**
     * @notice Match orders together (e.g., for bartering)
     * @param orders The orders to match
     * @param fulfillments The fulfillments to execute
     * @return executions The executions performed
     */
    function matchOrders(
        Order[] calldata orders,
        Fulfillment[] calldata fulfillments
    ) external payable returns (Execution[] memory executions);

    /**
     * @notice Match advanced orders with criteria resolution
     * @param advancedOrders The advanced orders to match
     * @param criteriaResolvers Array of criteria resolvers
     * @param fulfillments The fulfillments to execute
     * @param recipient The intended recipient for all unspent offer items
     * @return executions The executions performed
     */
    function matchAdvancedOrders(
        AdvancedOrder[] calldata advancedOrders,
        CriteriaResolver[] calldata criteriaResolvers,
        Fulfillment[] calldata fulfillments,
        address recipient
    ) external payable returns (Execution[] memory executions);

    /**
     * @notice Cancel multiple orders
     * @param orders The order parameters to cancel
     * @return cancelled Boolean indicating whether the orders were cancelled
     */
    function cancel(
        OrderComponents[] calldata orders
    ) external returns (bool cancelled);

    /**
     * @notice Validate an order, marking it as valid if the signature is valid
     * @param orders The orders to validate
     * @return validated Boolean indicating whether the orders were validated
     */
    function validate(
        Order[] calldata orders
    ) external returns (bool validated);

    /**
     * @notice Increment the counter for the caller, invalidating all orders with the previous counter
     * @return newCounter The new counter
     */
    function incrementCounter() external returns (uint256 newCounter);

    /**
     * @notice Get the current counter for a given offerer
     * @param offerer The offerer to get the counter for
     * @return counter The current counter
     */
    function getCounter(address offerer) external view returns (uint256 counter);

    /**
     * @notice Get information about an order
     * @param orderHash The order hash to query
     * @return isValidated Whether the order has been validated
     * @return isCancelled Whether the order has been cancelled
     * @return totalFilled The amount of the order that has been filled
     * @return totalSize The total size of the order
     */
    function getOrderStatus(bytes32 orderHash) external view returns (
        bool isValidated,
        bool isCancelled,
        uint256 totalFilled,
        uint256 totalSize
    );

    /**
     * @notice Get the order hash for a given order parameters
     * @param order The order parameters
     * @return orderHash The order hash
     */
    function getOrderHash(OrderParameters calldata order) external view returns (bytes32 orderHash);

    /**
     * @notice Get the domain separator used for signatures
     * @return domainSeparator The domain separator
     */
    function getDomainSeparator() external view returns (bytes32 domainSeparator);
    
    /**
     * @notice Retrieve configuration information for this contract
     * @return version The contract version
     * @return domainSeparator The domain separator for this contract
     * @return conduitController The conduit Controller set for this contract
     */
    function information() external view returns (
        string memory version,
        bytes32 domainSeparator,
        address conduitController
    );
    
    /**
     * @notice Retrieve the name of this contract
     * @return contractName The name of this contract
     */
    function name() external view returns (string memory contractName);
} 