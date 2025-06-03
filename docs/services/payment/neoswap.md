# NeoSwap - Token Exchange Service

## 🎯 Overview

**NeoSwap** provides comprehensive token exchange infrastructure for Neo dApps, offering DEX aggregation, intelligent routing, slippage protection, and cross-chain swapping capabilities with TEE-protected transaction security and real-time price optimization.

## 🚀 Purpose

DeFi applications need reliable, efficient token swapping with optimal pricing and minimal slippage. NeoSwap aggregates liquidity across multiple DEXs, provides intelligent routing algorithms, and ensures users get the best possible rates while maintaining security and speed for all token exchanges.

## ✨ Key Features

### **🔄 DEX Aggregation & Routing**
- Multi-DEX liquidity aggregation across Neo ecosystem
- Intelligent routing algorithms for optimal pricing
- Real-time price comparison and execution
- Split trades across multiple venues for best rates

### **🛡️ Advanced Protection Mechanisms**
- Configurable slippage protection
- MEV (Maximum Extractable Value) protection
- Front-running detection and prevention
- Price impact analysis and warnings

### **🌉 Cross-Chain Swapping**
- Native cross-chain token bridging
- Wrapped token management and unwrapping
- Multi-hop swapping through intermediate tokens
- Cross-chain arbitrage opportunities

### **⚡ Performance Optimization**
- Sub-second swap execution times
- Gas optimization and estimation
- Batch swapping for multiple tokens
- Mempool monitoring and priority gas

## 📊 Technical Specifications

### **Swap Types**
```typescript
enum SwapType {
  DIRECT = 'direct',                    // Direct token pair swap
  MULTI_HOP = 'multi_hop',             // Through intermediate tokens
  CROSS_CHAIN = 'cross_chain',         // Cross-chain bridge swap
  SPLIT_TRADE = 'split_trade',         // Split across multiple DEXs
  LIMIT_ORDER = 'limit_order',         // Limit order execution
  DCA = 'dollar_cost_average'          // Dollar cost averaging
}
```

### **API Endpoints**

#### **Get Quote**
```http
GET /api/v1/swap/quote
Query Parameters:
- from_token: 0x123... (Neo token hash)
- to_token: 0x456... (Target token hash)  
- amount: 1000000000 (Amount in smallest unit)
- slippage: 0.5 (Max slippage percentage)

Response:
{
  "quote_id": "quote_abc123",
  "from_token": "0x123...",
  "to_token": "0x456...",
  "from_amount": "1000000000",
  "to_amount": "2500000000",
  "price": "2.5",
  "price_impact": "0.12",
  "gas_estimate": "150000",
  "route": [
    {
      "dex": "flamingo",
      "percentage": 60,
      "amount_in": "600000000",
      "amount_out": "1500000000"
    },
    {
      "dex": "forthewin",
      "percentage": 40,
      "amount_in": "400000000", 
      "amount_out": "1000000000"
    }
  ],
  "expires_at": "2024-01-15T10:35:00Z"
}
```

#### **Execute Swap**
```http
POST /api/v1/swap/execute
Content-Type: application/json
Authorization: Bearer <api_key>

{
  "quote_id": "quote_abc123",
  "user_address": "NXXzKhzgs8EQtpNrNdvLfPjBQU3Cq3Kt1i",
  "max_slippage": "0.5",
  "deadline": "2024-01-15T10:35:00Z",
  "signature": "wallet_signature_for_approval"
}

Response:
{
  "swap_id": "swap_def456",
  "transaction_hash": "0xabc123...",
  "status": "pending",
  "estimated_completion": "2024-01-15T10:31:30Z",
  "tracking_url": "https://swaps.neoswap.r3e.network/swap_def456"
}
```

#### **Swap Status**
```http
GET /api/v1/swap/{swap_id}/status
Authorization: Bearer <api_key>

Response:
{
  "swap_id": "swap_def456",
  "status": "completed",
  "transaction_hash": "0xabc123...",
  "from_amount": "1000000000",
  "to_amount": "2487500000",
  "actual_price": "2.4875",
  "slippage": "0.5",
  "gas_used": "145000",
  "completed_at": "2024-01-15T10:31:15Z"
}
```

### **SDK Integration**

#### **JavaScript/TypeScript**
```typescript
import { NeoSwap } from '@r3e/neo-swap';

// Initialize swap client
const swapClient = new NeoSwap({
  apiKey: 'your-api-key',
  network: 'mainnet'
});

// Get swap quote
const quote = await swapClient.getQuote({
  fromToken: 'GAS_TOKEN_HASH',
  toToken: 'NEO_TOKEN_HASH', 
  amount: '100000000', // 1 GAS
  slippage: 0.5 // 0.5% max slippage
});

console.log('Quote:', quote);

// Execute swap
const swapResult = await swapClient.executeSwap({
  quoteId: quote.quote_id,
  userAddress: userWalletAddress,
  onProgress: (status) => {
    console.log('Swap progress:', status);
  }
});

// Monitor swap completion
const finalStatus = await swapClient.waitForCompletion(swapResult.swap_id);
console.log('Swap completed:', finalStatus);

// Get swap history
const history = await swapClient.getSwapHistory(userWalletAddress, {
  limit: 50,
  from: '2024-01-01'
});
```

#### **React Integration**
```typescript
import { useNeoSwap } from '@r3e/neo-swap-react';

function SwapInterface() {
  const {
    getQuote,
    executeSwap,
    isLoading,
    swapStatus,
    supportedTokens
  } = useNeoSwap();

  const [fromToken, setFromToken] = useState('GAS');
  const [toToken, setToToken] = useState('NEO');
  const [amount, setAmount] = useState('');
  const [quote, setQuote] = useState(null);

  const handleGetQuote = async () => {
    if (!amount) return;
    
    try {
      const quoteResult = await getQuote({
        fromToken,
        toToken,
        amount,
        slippage: 0.5
      });
      setQuote(quoteResult);
    } catch (error) {
      console.error('Quote failed:', error);
    }
  };

  const handleSwap = async () => {
    if (!quote) return;
    
    try {
      await executeSwap({
        quoteId: quote.quote_id,
        onProgress: (status) => {
          console.log('Swap status:', status);
        }
      });
    } catch (error) {
      console.error('Swap failed:', error);
    }
  };

  return (
    <div className="swap-interface">
      <div className="token-input">
        <select value={fromToken} onChange={(e) => setFromToken(e.target.value)}>
          {supportedTokens.map(token => (
            <option key={token.hash} value={token.symbol}>
              {token.symbol}
            </option>
          ))}
        </select>
        <input
          type="number"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          placeholder="Amount"
        />
      </div>

      <div className="swap-arrow">
        <button onClick={() => { 
          setFromToken(toToken); 
          setToToken(fromToken); 
        }}>
          ↕️
        </button>
      </div>

      <div className="token-output">
        <select value={toToken} onChange={(e) => setToToken(e.target.value)}>
          {supportedTokens.map(token => (
            <option key={token.hash} value={token.symbol}>
              {token.symbol}
            </option>
          ))}
        </select>
        <div className="output-amount">
          {quote ? quote.to_amount : '0'}
        </div>
      </div>

      <button onClick={handleGetQuote} disabled={!amount || isLoading}>
        Get Quote
      </button>

      {quote && (
        <div className="quote-details">
          <div>Rate: 1 {fromToken} = {quote.price} {toToken}</div>
          <div>Price Impact: {quote.price_impact}%</div>
          <div>Gas Estimate: {quote.gas_estimate}</div>
          <button onClick={handleSwap} disabled={isLoading}>
            Execute Swap
          </button>
        </div>
      )}

      {swapStatus && (
        <div className="swap-status">
          Status: {swapStatus.status}
          {swapStatus.transaction_hash && (
            <a href={`https://explorer.neo.org/transaction/${swapStatus.transaction_hash}`}>
              View Transaction
            </a>
          )}
        </div>
      )}
    </div>
  );
}
```

#### **Vue.js Integration**
```typescript
import { useNeoSwap } from '@r3e/neo-swap-vue';

export default {
  setup() {
    const {
      getQuote,
      executeSwap,
      getBestRoute,
      getTokenPrice
    } = useNeoSwap();

    const swapTokens = async (fromToken, toToken, amount) => {
      // Get best route
      const route = await getBestRoute({
        fromToken,
        toToken,
        amount
      });

      // Get quote
      const quote = await getQuote({
        fromToken,
        toToken,
        amount,
        route: route.optimal_route
      });

      // Execute if user confirms
      const confirmed = await confirmSwap(quote);
      if (confirmed) {
        return await executeSwap({
          quoteId: quote.quote_id
        });
      }
    };

    return {
      swapTokens,
      getTokenPrice,
      getBestRoute
    };
  }
};
```

#### **Rust Backend Integration**
```rust
use neo_swap::{SwapClient, SwapRequest, QuoteParams};

let swap_client = SwapClient::new("your-api-key");

// Get quote
let quote_params = QuoteParams {
    from_token: "GAS_TOKEN_HASH".to_string(),
    to_token: "NEO_TOKEN_HASH".to_string(),
    amount: "100000000".to_string(),
    slippage: 0.5,
};

let quote = swap_client.get_quote(quote_params).await?;

// Execute swap
let swap_request = SwapRequest {
    quote_id: quote.quote_id,
    user_address: user_address.to_string(),
    max_slippage: 0.5,
    deadline: SystemTime::now() + Duration::from_secs(300),
};

let swap_result = swap_client.execute_swap(swap_request).await?;
println!("Swap initiated: {}", swap_result.swap_id);
```

## 🔧 Configuration Options

### **Swap Configuration**
```typescript
const swapConfig = {
  default_slippage: 0.5, // 0.5%
  max_slippage: 5.0,     // 5%
  default_deadline: 300,  // 5 minutes
  gas_optimization: {
    enabled: true,
    priority: 'balanced', // 'fast', 'balanced', 'cheap'
    max_gas_price: '200'
  },
  routing: {
    max_hops: 3,
    min_liquidity: '10000', // Minimum pool liquidity
    exclude_dexs: [], // Exclude specific DEXs
    prefer_dexs: ['flamingo', 'forthewin']
  }
};
```

### **Advanced Features**
```typescript
const advancedOptions = {
  mev_protection: {
    enabled: true,
    private_mempool: true,
    flashbots_protection: true
  },
  split_trades: {
    enabled: true,
    max_splits: 4,
    min_split_size: '1000' // Minimum amount per split
  },
  limit_orders: {
    enabled: true,
    max_duration: '30d',
    partial_fills: true
  }
};
```

## 🛡️ Security Features

### **TEE-Protected Execution**
- Transaction building within Intel SGX enclaves
- Private key operations in secure environments
- Encrypted communication with DEX protocols
- Tamper-proof swap execution logic

### **Anti-MEV Protection**
```typescript
const mevProtection = {
  strategies: [
    'private_mempool',     // Use private mempools
    'randomized_timing',   // Random execution delays
    'batch_auctions',      // Batch multiple swaps
    'commit_reveal'        // Two-phase execution
  ],
  monitoring: {
    detect_frontrunning: true,
    detect_sandwich: true,
    alert_on_mev: true
  }
};
```

### **Price Oracle Integration**
```typescript
const priceValidation = {
  oracle_sources: ['chainlink', 'band_protocol', 'pyth'],
  price_deviation_threshold: '2%', // Alert if price deviates
  minimum_sources: 2, // Require multiple oracle confirmations
  staleness_threshold: '60s' // Max oracle data age
};
```

## 💰 Pricing Model

### **Basic** - Free
- Up to 100 swaps per month
- Standard DEX aggregation
- Basic slippage protection
- Community support

### **Pro** - $19/month
- Up to 1,000 swaps per month
- Advanced routing algorithms
- MEV protection
- Priority execution
- Email support

### **Premium** - $99/month
- Unlimited swaps
- Custom routing strategies
- Advanced analytics
- API access
- Private mempool access
- Priority support

### **Enterprise** - $299/month
- White-label swap interface
- Custom DEX integrations
- Dedicated infrastructure
- SLA guarantees
- 24/7 support

## 🚀 Quick Start Guide

### **1. Install SDK**
```bash
npm install @r3e/neo-swap
```

### **2. Initialize Client**
```typescript
import { NeoSwap } from '@r3e/neo-swap';

const swapClient = new NeoSwap({
  apiKey: process.env.NEO_SWAP_API_KEY,
  network: 'mainnet'
});
```

### **3. Get Your First Quote**
```typescript
const quote = await swapClient.getQuote({
  fromToken: 'GAS',
  toToken: 'NEO',
  amount: '100', // 100 GAS
  slippage: 0.5
});

console.log('Best rate:', quote.price);
```

### **4. Execute Swap**
```typescript
const swap = await swapClient.executeSwap({
  quoteId: quote.quote_id,
  userAddress: userWallet.address
});

console.log('Swap transaction:', swap.transaction_hash);
```

## 🔗 Integration Examples

### **DeFi Protocol Integration**
```typescript
class DeFiSwapManager {
  private swapClient: NeoSwap;

  constructor() {
    this.swapClient = new NeoSwap({
      apiKey: process.env.SWAP_API_KEY
    });
  }

  async executePortfolioRebalancing(user: string, targetAllocation: any) {
    const currentBalances = await this.getUserBalances(user);
    const swapsNeeded = this.calculateRebalanceSwaps(currentBalances, targetAllocation);

    // Execute swaps in optimal order
    const swapPromises = swapsNeeded.map(async (swap) => {
      const quote = await this.swapClient.getQuote({
        fromToken: swap.fromToken,
        toToken: swap.toToken,
        amount: swap.amount,
        slippage: 1.0 // Higher slippage for rebalancing
      });

      return await this.swapClient.executeSwap({
        quoteId: quote.quote_id,
        userAddress: user
      });
    });

    return await Promise.all(swapPromises);
  }

  async setupDollarCostAveraging(user: string, config: DCAConfig) {
    return await this.swapClient.createDCAOrder({
      fromToken: config.fromToken,
      toToken: config.toToken,
      totalAmount: config.totalAmount,
      frequency: config.frequency, // 'daily', 'weekly', 'monthly'
      duration: config.duration,
      userAddress: user
    });
  }
}
```

### **NFT Marketplace Integration**
```typescript
class NFTMarketplaceSwap {
  private swapClient: NeoSwap;

  async handleNFTPurchaseWithSwap(nftPrice: string, paymentToken: string, userToken: string) {
    // If user doesn't have the required payment token, swap first
    if (userToken !== paymentToken) {
      const quote = await this.swapClient.getQuote({
        fromToken: userToken,
        toToken: paymentToken,
        amount: nftPrice,
        slippage: 1.0
      });

      const swapResult = await this.swapClient.executeSwap({
        quoteId: quote.quote_id,
        userAddress: user.address,
        onProgress: (status) => {
          this.updatePurchaseStatus(status);
        }
      });

      // Wait for swap completion before NFT purchase
      await this.swapClient.waitForCompletion(swapResult.swap_id);
    }

    // Proceed with NFT purchase
    return await this.executeNFTPurchase(nftId, paymentToken);
  }

  async setupInstantNFTLiquidity(nftCollectionFloor: string) {
    // Create limit orders to instantly liquidate NFTs at floor price
    return await this.swapClient.createLimitOrder({
      fromToken: 'COLLECTION_TOKEN',
      toToken: 'USDT',
      price: nftCollectionFloor,
      amount: 'any', // Accept any amount
      duration: '30d'
    });
  }
}
```

### **Gaming dApp Integration**
```typescript
class GameTokenSwap {
  private swapClient: NeoSwap;

  async setupGameEconomy() {
    // Auto-swap game rewards to stable tokens
    await this.swapClient.createAutoSwap({
      trigger: 'balance_threshold',
      fromToken: 'GAME_TOKEN',
      toToken: 'USDT',
      triggerAmount: '1000', // Swap when balance > 1000 game tokens
      swapPercentage: 50 // Swap 50% of balance
    });

    // Provide instant liquidity for in-game purchases
    await this.swapClient.createLiquidityPool({
      tokenA: 'GAME_TOKEN',
      tokenB: 'NEO',
      initialLiquidity: {
        tokenA: '100000',
        tokenB: '50'
      },
      feeRate: '0.3%'
    });
  }

  async handleInGamePurchase(itemPrice: string, userTokens: any) {
    // Find optimal payment method from user's tokens
    const bestToken = await this.findBestPaymentToken(userTokens, itemPrice);
    
    if (bestToken.token !== 'GAME_TOKEN') {
      // Swap to game token for purchase
      const quote = await this.swapClient.getQuote({
        fromToken: bestToken.token,
        toToken: 'GAME_TOKEN',
        amount: itemPrice
      });

      await this.swapClient.executeSwap({
        quoteId: quote.quote_id,
        userAddress: userAddress
      });
    }

    return await this.purchaseGameItem(itemId, itemPrice);
  }
}
```

## 🔍 Troubleshooting

### **Common Issues**

#### **High Slippage**
```typescript
// Handle high slippage scenarios
const handleHighSlippage = async (quote: SwapQuote) => {
  if (parseFloat(quote.price_impact) > 2.0) {
    console.warn('High price impact detected:', quote.price_impact);
    
    // Try split trade to reduce impact
    const splitQuote = await swapClient.getQuote({
      ...originalParams,
      enableSplitTrade: true,
      maxSplits: 4
    });
    
    if (splitQuote.price_impact < quote.price_impact) {
      return splitQuote;
    }
  }
  
  return quote;
};
```

#### **Failed Swaps**
```typescript
// Handle swap failures with retry logic
const executeSwapWithRetry = async (quoteId: string, maxRetries = 3) => {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await swapClient.executeSwap({ quoteId });
    } catch (error) {
      if (error.code === 'INSUFFICIENT_LIQUIDITY') {
        // Wait and retry with updated quote
        await new Promise(resolve => setTimeout(resolve, 5000));
        const newQuote = await swapClient.refreshQuote(quoteId);
        quoteId = newQuote.quote_id;
      } else if (error.code === 'SLIPPAGE_EXCEEDED') {
        // Increase slippage tolerance
        const quote = await swapClient.getQuote({
          ...originalParams,
          slippage: originalParams.slippage * 1.5
        });
        quoteId = quote.quote_id;
      } else {
        throw error;
      }
    }
  }
  
  throw new Error('Swap failed after maximum retries');
};
```

#### **Quote Expiration**
```typescript
// Handle quote expiration
const monitorQuoteExpiration = (quote: SwapQuote) => {
  const expiresAt = new Date(quote.expires_at);
  const timeUntilExpiry = expiresAt.getTime() - Date.now();
  
  if (timeUntilExpiry < 30000) { // Less than 30 seconds
    console.warn('Quote expires soon, refreshing...');
    return swapClient.refreshQuote(quote.quote_id);
  }
  
  return quote;
};
```

## 📞 Support & Resources

- **Documentation**: [docs.neoswap.r3e.network](https://docs.neoswap.r3e.network)
- **Swap Interface**: [swap.neoswap.r3e.network](https://swap.neoswap.r3e.network)
- **API Reference**: [api.neoswap.r3e.network](https://api.neoswap.r3e.network)
- **Analytics Dashboard**: [analytics.neoswap.r3e.network](https://analytics.neoswap.r3e.network)
- **Liquidity Pools**: [pools.neoswap.r3e.network](https://pools.neoswap.r3e.network)
- **Discord Support**: [discord.gg/r3e-network](https://discord.gg/r3e-network)
- **Email**: [swap@r3e.network](mailto:swap@r3e.network)

---

**NeoSwap provides optimal token exchange infrastructure that ensures users get the best rates across all Neo DEXs while maintaining security and protection against MEV attacks.** 