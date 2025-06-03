# NeoWallet - Universal Wallet Integration Service

## 🎯 Overview

**NeoWallet** provides universal wallet connection and transaction management for Neo dApps, offering simplified integration with multiple wallet providers, transaction signing abstraction, and seamless user experiences across different wallet types.

## 🚀 Purpose

Modern dApps need to support multiple wallet types and provide seamless user experiences regardless of the wallet choice. NeoWallet abstracts wallet complexity, providing a unified API that works with all major Neo wallets while maintaining security and user control.

## ✨ Key Features

### **🔌 Multi-Wallet Support**
- Support for all major Neo wallets (NeoLine, O3, OneGate, etc.)
- WalletConnect protocol integration for mobile wallets
- Hardware wallet support (Ledger, Trezor)
- Web3 wallet adapters for cross-chain compatibility

### **🎛️ Simplified Integration**
- Unified API across all wallet types
- Automatic wallet detection and connection
- Seamless wallet switching and management
- One-click wallet connection flows

### **🔐 Transaction Abstraction**
- Simplified transaction building and signing
- Gas estimation and optimization
- Batch transaction support
- Transaction status tracking and notifications

### **📊 Balance & History APIs**
- Real-time balance updates
- Transaction history retrieval
- Multi-token balance tracking
- Portfolio valuation and analytics

## 📊 Technical Specifications

### **Supported Wallets**
```typescript
const supportedWallets = {
  browser: [
    'neoline',     // NeoLine browser extension
    'o3',          // O3 wallet browser extension
    'onegate',     // OneGate wallet
    'neon',        // Neon wallet (desktop)
    'flamingo'     // Flamingo wallet
  ],
  mobile: [
    'neoline_mobile',  // NeoLine mobile app
    'o3_mobile',       // O3 mobile app
    'walletconnect'    // WalletConnect protocol
  ],
  hardware: [
    'ledger',      // Ledger hardware wallets
    'trezor'       // Trezor hardware wallets
  ]
};
```

### **API Endpoints**

#### **Get Available Wallets**
```http
GET /api/v1/wallets/available
Response:
{
  "wallets": [
    {
      "id": "neoline",
      "name": "NeoLine",
      "icon": "https://cdn.r3e.network/icons/neoline.png",
      "type": "browser",
      "installed": true,
      "version": "2.10.3"
    }
  ]
}
```

#### **Connect Wallet**
```http
POST /api/v1/wallets/connect
Content-Type: application/json

{
  "wallet_id": "neoline",
  "dapp_info": {
    "name": "My Neo dApp",
    "icon": "https://mydapp.com/icon.png",
    "url": "https://mydapp.com"
  }
}
```

#### **Sign Transaction**
```http
POST /api/v1/wallets/sign
Content-Type: application/json

{
  "wallet_id": "neoline",
  "transaction": {
    "script": "0x...",
    "attributes": [],
    "witnesses": []
  },
  "network": "mainnet"
}
```

### **SDK Integration**

#### **JavaScript/TypeScript**
```typescript
import { NeoWallet } from '@r3e/neo-wallet';

// Initialize wallet manager
const walletManager = new NeoWallet({
  appName: 'My Neo dApp',
  appIcon: 'https://mydapp.com/icon.png',
  networks: ['mainnet', 'testnet']
});

// Get available wallets
const availableWallets = await walletManager.getAvailableWallets();

// Connect to preferred wallet
const wallet = await walletManager.connect('neoline');

// Get user address and balance
const address = wallet.getAddress();
const balance = await wallet.getBalance();

// Send transaction
const txResult = await wallet.sendTransaction({
  to: 'recipient_address',
  amount: '100',
  token: 'GAS'
});

// Sign message
const signature = await wallet.signMessage('Hello Neo!');
```

#### **React Integration**
```typescript
import { useNeoWallet } from '@r3e/neo-wallet-react';

function WalletConnectButton() {
  const {
    wallet,
    isConnected,
    isConnecting,
    connect,
    disconnect,
    sendTransaction
  } = useNeoWallet();

  const handleConnect = async (walletId: string) => {
    try {
      await connect(walletId);
    } catch (error) {
      console.error('Wallet connection failed:', error);
    }
  };

  const handleSend = async () => {
    if (!wallet) return;
    
    try {
      const result = await sendTransaction({
        to: recipientAddress,
        amount: '10',
        token: 'GAS'
      });
      console.log('Transaction sent:', result.txid);
    } catch (error) {
      console.error('Transaction failed:', error);
    }
  };

  if (isConnected) {
    return (
      <div className="wallet-connected">
        <div>Connected: {wallet.name}</div>
        <div>Address: {wallet.address}</div>
        <button onClick={handleSend}>Send Transaction</button>
        <button onClick={disconnect}>Disconnect</button>
      </div>
    );
  }

  return (
    <WalletSelector
      onSelectWallet={handleConnect}
      loading={isConnecting}
    />
  );
}
```

#### **Vue.js Integration**
```typescript
import { useNeoWallet } from '@r3e/neo-wallet-vue';

export default {
  setup() {
    const {
      wallet,
      isConnected,
      connect,
      getBalance,
      sendTransaction
    } = useNeoWallet();

    const connectWallet = async (walletType: string) => {
      try {
        await connect(walletType);
        const balance = await getBalance();
        console.log('Wallet connected, balance:', balance);
      } catch (error) {
        console.error('Connection failed:', error);
      }
    };

    return {
      wallet,
      isConnected,
      connectWallet,
      sendTransaction
    };
  }
};
```

#### **Rust Backend Integration**
```rust
use neo_wallet::{WalletClient, TransactionBuilder, NetworkType};

let wallet_client = WalletClient::new("your-api-key");

// Build transaction
let tx_builder = TransactionBuilder::new()
    .add_output("recipient_address", "100", "GAS")
    .set_network(NetworkType::MainNet);

let unsigned_tx = tx_builder.build()?;

// Send to frontend for signing
let sign_request = wallet_client.create_sign_request(unsigned_tx).await?;
```

## 🔧 Wallet Management

### **Wallet Detection**
```typescript
// Automatic wallet detection
const walletDetector = new WalletDetector();

walletDetector.on('walletDetected', (wallet) => {
  console.log(`${wallet.name} detected`);
  updateAvailableWallets(wallet);
});

walletDetector.on('walletRemoved', (walletId) => {
  console.log(`${walletId} removed`);
  removeWalletOption(walletId);
});

// Start detection
walletDetector.start();
```

### **Connection Management**
```typescript
// Connect with preferences
const connectionOptions = {
  preferredWallet: 'neoline',
  fallbackWallets: ['o3', 'onegate'],
  autoConnect: true,
  persistent: true
};

const wallet = await walletManager.connect(connectionOptions);

// Connection state management
wallet.on('connected', () => {
  console.log('Wallet connected');
  updateUI();
});

wallet.on('disconnected', () => {
  console.log('Wallet disconnected');
  clearUserData();
});

wallet.on('accountChanged', (newAddress) => {
  console.log('Account changed to:', newAddress);
  refreshUserData();
});
```

### **Multi-Wallet Support**
```typescript
// Support multiple connected wallets
const walletManager = new MultiWalletManager();

// Connect multiple wallets
const primaryWallet = await walletManager.connect('neoline');
const secondaryWallet = await walletManager.connect('o3');

// Use specific wallet for transactions
await walletManager.sendTransaction(
  'neoline', // wallet ID
  transactionData
);

// Aggregate balances across wallets
const totalBalance = await walletManager.getTotalBalance();
```

## 🔐 Transaction Management

### **Transaction Builder**
```typescript
// Build complex transactions
const txBuilder = wallet.createTransactionBuilder();

const transaction = await txBuilder
  .addOutput('recipient1', '50', 'GAS')
  .addOutput('recipient2', '100', 'USDT')
  .addAttribute('description', 'Batch payment')
  .setNetworkFee('0.1')
  .build();

// Sign and send
const result = await wallet.signAndSend(transaction);
```

### **Gas Management**
```typescript
// Estimate gas for transaction
const gasEstimate = await wallet.estimateGas({
  to: recipientAddress,
  amount: '100',
  token: 'USDT'
});

console.log('Estimated gas:', gasEstimate);

// Auto-optimize gas
const optimizedTx = await wallet.optimizeTransaction(transaction, {
  strategy: 'lowest_cost', // or 'fastest'
  maxGasPrice: '0.2'
});
```

### **Batch Transactions**
```typescript
// Execute multiple transactions in batch
const batchTx = await wallet.createBatch([
  { to: 'address1', amount: '50', token: 'GAS' },
  { to: 'address2', amount: '100', token: 'USDT' },
  { to: 'address3', amount: '25', token: 'NEO' }
]);

const batchResult = await wallet.executeBatch(batchTx);
```

## 📊 Balance & Portfolio Management

### **Real-Time Balance Updates**
```typescript
// Subscribe to balance updates
wallet.subscribeToBalanceUpdates((balances) => {
  console.log('Updated balances:', balances);
  updateBalanceDisplay(balances);
});

// Get detailed balance info
const balanceInfo = await wallet.getDetailedBalance();
/*
{
  "GAS": {
    "balance": "150.5",
    "value_usd": "756.25",
    "change_24h": "+2.5%"
  },
  "NEO": {
    "balance": "10",
    "value_usd": "120.00",
    "change_24h": "-1.2%"
  }
}
*/
```

### **Transaction History**
```typescript
// Get transaction history
const history = await wallet.getTransactionHistory({
  limit: 50,
  offset: 0,
  token: 'all',
  type: 'all' // 'sent', 'received', 'contract'
});

// Get specific transaction details
const txDetails = await wallet.getTransactionDetails(txId);
```

### **Portfolio Analytics**
```typescript
// Get portfolio overview
const portfolio = await wallet.getPortfolioAnalytics();
/*
{
  "total_value_usd": "2450.75",
  "change_24h": "+5.2%",
  "change_7d": "-2.1%",
  "tokens": [
    {
      "symbol": "GAS",
      "percentage": "65%",
      "value_usd": "1592.99"
    }
  ]
}
*/
```

## 🛡️ Security Features

### **Secure Communication**
- End-to-end encrypted communication with wallets
- Message signing for authentication
- Request verification and validation
- Secure key management protocols

### **Transaction Security**
```typescript
// Verify transaction before signing
const verification = await wallet.verifyTransaction(transaction);

if (verification.risks.length > 0) {
  console.warn('Transaction risks detected:', verification.risks);
  const userConfirmed = await showRiskWarning(verification.risks);
  if (!userConfirmed) return;
}

// Sign with additional security checks
const signature = await wallet.signTransaction(transaction, {
  requireUserConfirmation: true,
  showTransactionDetails: true
});
```

### **Permission Management**
```typescript
// Request specific permissions
const permissions = await wallet.requestPermissions([
  'read_address',
  'sign_transactions',
  'access_balance'
]);

// Check current permissions
const currentPermissions = await wallet.getPermissions();
```

## 💰 Pricing Model

### **Developer** - Free
- Up to 1,000 wallet connections per month
- Basic wallet integration
- Community support
- Standard transaction limits

### **Startup** - $29/month
- Up to 10,000 wallet connections per month
- Advanced wallet features
- Email support
- Higher transaction limits
- Analytics dashboard

### **Professional** - $99/month
- Up to 100,000 wallet connections per month
- Custom wallet integrations
- Priority support
- Advanced analytics
- White-label options

### **Enterprise** - Custom
- Unlimited wallet connections
- Dedicated infrastructure
- 24/7 support
- SLA guarantees
- Custom features

## 🚀 Quick Start Guide

### **1. Install SDK**
```bash
npm install @r3e/neo-wallet
# or
yarn add @r3e/neo-wallet
```

### **2. Initialize Wallet Manager**
```typescript
import { NeoWallet } from '@r3e/neo-wallet';

const walletManager = new NeoWallet({
  appName: 'My Neo dApp',
  appIcon: 'https://mydapp.com/icon.png',
  supportedNetworks: ['mainnet', 'testnet']
});
```

### **3. Connect User Wallet**
```typescript
// Show wallet selection dialog
const availableWallets = await walletManager.getAvailableWallets();
const selectedWallet = await showWalletSelector(availableWallets);

// Connect to selected wallet
const wallet = await walletManager.connect(selectedWallet.id);
console.log('Connected to:', wallet.name);
```

### **4. Send Transaction**
```typescript
// Simple transaction
const result = await wallet.sendTransaction({
  to: 'NXXzKhzgs8EQtpNrNdvLfPjBQU3Cq3Kt1i',
  amount: '10',
  token: 'GAS'
});

console.log('Transaction sent:', result.txid);
```

## 🔗 Integration Examples

### **DeFi Protocol Integration**
```typescript
class DeFiWalletManager {
  private walletManager: NeoWallet;

  constructor() {
    this.walletManager = new NeoWallet({
      appName: 'DeFi Protocol',
      appIcon: '/defi-icon.png'
    });
  }

  async connectAndApprove(spenderContract: string, amount: string) {
    // Connect wallet
    const wallet = await this.walletManager.connect();
    
    // Check current allowance
    const currentAllowance = await this.checkAllowance(
      wallet.getAddress(),
      spenderContract
    );

    // Request approval if needed
    if (parseFloat(currentAllowance) < parseFloat(amount)) {
      const approveTx = await wallet.sendTransaction({
        contract: 'USDT_CONTRACT',
        method: 'approve',
        params: [spenderContract, amount]
      });
      
      await this.waitForConfirmation(approveTx.txid);
    }

    return wallet;
  }

  async executeSwap(tokenIn: string, tokenOut: string, amount: string) {
    const wallet = await this.walletManager.getConnectedWallet();
    
    const swapTx = await wallet.sendTransaction({
      contract: 'DEX_CONTRACT',
      method: 'swap',
      params: [tokenIn, tokenOut, amount, wallet.getAddress()]
    });

    return swapTx;
  }
}
```

### **NFT Marketplace Integration**
```typescript
class NFTMarketplaceWallet {
  private walletManager: NeoWallet;

  constructor() {
    this.walletManager = new NeoWallet({
      appName: 'NFT Marketplace',
      appIcon: '/marketplace-icon.png'
    });
  }

  async listNFT(tokenId: string, price: string) {
    const wallet = await this.walletManager.getConnectedWallet();
    
    // Create listing transaction
    const listingTx = await wallet.sendTransaction({
      contract: 'MARKETPLACE_CONTRACT',
      method: 'list',
      params: [
        wallet.getAddress(), // seller
        tokenId,
        price,
        'USDT' // payment token
      ]
    });

    return listingTx;
  }

  async purchaseNFT(tokenId: string, price: string) {
    const wallet = await this.walletManager.getConnectedWallet();
    
    // Check balance
    const balance = await wallet.getTokenBalance('USDT');
    if (parseFloat(balance) < parseFloat(price)) {
      throw new Error('Insufficient balance');
    }

    // Execute purchase
    const purchaseTx = await wallet.sendTransaction({
      contract: 'MARKETPLACE_CONTRACT',
      method: 'purchase',
      params: [tokenId, wallet.getAddress()]
    });

    return purchaseTx;
  }
}
```

### **Gaming dApp Integration**
```typescript
class GameWalletManager {
  private walletManager: NeoWallet;

  constructor() {
    this.walletManager = new NeoWallet({
      appName: 'Neo Game',
      appIcon: '/game-icon.png'
    });
  }

  async claimRewards(gameSession: GameSession) {
    const wallet = await this.walletManager.getConnectedWallet();
    
    // Calculate rewards
    const rewards = this.calculateSessionRewards(gameSession);
    
    // Claim transaction
    const claimTx = await wallet.sendTransaction({
      contract: 'GAME_CONTRACT',
      method: 'claimRewards',
      params: [
        wallet.getAddress(),
        gameSession.sessionId,
        rewards.amount,
        rewards.items
      ]
    });

    return claimTx;
  }

  async purchaseGameItem(itemId: string, price: string) {
    const wallet = await this.walletManager.getConnectedWallet();
    
    const purchaseTx = await wallet.sendTransaction({
      contract: 'GAME_ITEMS_CONTRACT',
      method: 'purchase',
      params: [itemId, wallet.getAddress()]
    });

    return purchaseTx;
  }
}
```

## 🔍 Troubleshooting

### **Common Issues**

#### **Wallet Not Detected**
```typescript
// Handle wallet detection issues
const handleWalletDetection = async () => {
  const wallets = await walletManager.getAvailableWallets();
  
  if (wallets.length === 0) {
    // Show wallet installation guide
    showWalletInstallationGuide();
  } else {
    // Filter installed wallets
    const installedWallets = wallets.filter(w => w.installed);
    if (installedWallets.length === 0) {
      showWalletSetupInstructions();
    }
  }
};
```

#### **Connection Failures**
```typescript
// Retry connection with fallback
const connectWithRetry = async (preferredWallet: string) => {
  try {
    return await walletManager.connect(preferredWallet);
  } catch (error) {
    console.warn('Primary wallet failed, trying fallback');
    
    const fallbackWallets = ['o3', 'onegate'];
    for (const fallback of fallbackWallets) {
      try {
        return await walletManager.connect(fallback);
      } catch (fallbackError) {
        console.warn(`Fallback ${fallback} failed`);
      }
    }
    
    throw new Error('All wallet connections failed');
  }
};
```

#### **Transaction Failures**
```typescript
// Handle transaction errors gracefully
const sendTransactionSafely = async (txData: any) => {
  try {
    const result = await wallet.sendTransaction(txData);
    return result;
  } catch (error) {
    if (error.code === 'USER_REJECTED') {
      showMessage('Transaction was cancelled by user');
    } else if (error.code === 'INSUFFICIENT_FUNDS') {
      showMessage('Insufficient balance for transaction');
    } else if (error.code === 'NETWORK_ERROR') {
      showMessage('Network error, please try again');
    } else {
      showMessage('Transaction failed: ' + error.message);
    }
    throw error;
  }
};
```

## 📞 Support & Resources

- **Documentation**: [docs.neowallet.r3e.network](https://docs.neowallet.r3e.network)
- **Integration Guide**: [integration.neowallet.r3e.network](https://integration.neowallet.r3e.network)
- **API Reference**: [api.neowallet.r3e.network](https://api.neowallet.r3e.network)
- **SDK Examples**: [github.com/r3e-network/neo-wallet-examples](https://github.com/r3e-network/neo-wallet-examples)
- **Discord Support**: [discord.gg/r3e-network](https://discord.gg/r3e-network)
- **Email**: [wallet@r3e.network](mailto:wallet@r3e.network)

---

**NeoWallet simplifies blockchain integration by providing a unified interface to all Neo wallets, enabling seamless user experiences while maintaining security and user control over their assets.** 