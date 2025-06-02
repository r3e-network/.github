# R3E Labs 🚀

[*The AI and ZKP powered Neo N3 service layer*](https://r3e-network.netlify.app)

<div align="center">

[![Website](https://img.shields.io/badge/Website-r3e.network-blue)](https://r3e.network)
[![Contact](https://img.shields.io/badge/Contact-jimmy%40r3e.network-green)](mailto:jimmy@r3e.network)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

</div>

## 🎯 Mission

R3E Labs is dedicated to leveraging the power of **TEE** (Trusted Execution Environment), **AI**, **ZK** (Zero-Knowledge), and **Rust** to create powerful Neo infrastructures that empower the Neo network and seamlessly connect Neo Web3 dApps to Web2 computing power and data.

## 🛠️ Core Technologies

- **🔒 TEE (Trusted Execution Environment)** - Intel SGX with Occlum LibOS for secure execution
- **🤖 AI** - Machine learning and prediction capabilities integrated into blockchain services
- **🛡️ ZK (Zero-Knowledge)** - Privacy-preserving computations and proofs
- **⚡ Rust** - High-performance, memory-safe systems programming

## 🏗️ Key Projects

### 1. Neo N3 MCP Server
**An MCP server for seamless Neo N3 blockchain interactions**

- **Repository**: [neo-n3-mcp](https://github.com/r3e-network/neo-n3-mcp)
- **Website**: [neomcp.xyz](https://neomcp.xyz)
- **Package**: [@r3e/neo-n3-mcp](https://www.npmjs.com/package/@r3e/neo-n3-mcp)

Provides 34 tools and 9 resources for comprehensive Neo N3 blockchain interaction through the Model Context Protocol (MCP).

**Features:**
- Network management (mainnet/testnet)
- Wallet operations and asset transfers
- Smart contract interactions
- Blockchain data querying
- Security-first design with input validation

### 2. Neo N3 Rust Smart Contract DevPack
**Write Neo N3 smart contracts in Rust**

- **Repository**: [neo-contract-rs](https://github.com/r3e-network/neo-contract-rs)
- **Website**: [neo-rust.netlify.app](https://neo-rust.netlify.app)

Enable developers to write Neo N3 smart contracts using Rust, bringing memory safety and performance to Neo blockchain development.

**Benefits:**
- Memory safety and performance of Rust
- Familiar syntax for Rust developers
- Comprehensive development toolkit
- Seamless Neo N3 integration

### 3. Neo Rust SDK
**Comprehensive Neo N3 and Neo X Rust SDK**

- **Repository**: [NeoRust](https://github.com/r3e-network/NeoRust)
- **Website**: [neorust.netlify.app](https://neorust.netlify.app)

A powerful SDK for interacting with both Neo N3 and Neo X blockchains using Rust.

**Capabilities:**
- Multi-blockchain support (Neo N3 & Neo X)
- Type-safe blockchain interactions
- High-performance RPC client
- Comprehensive wallet management

### 4. Neo Service Layer
**Comprehensive secure services platform for Neo ecosystem**

- **Repository**: [neo-service-layer](https://github.com/r3e-network/neo-service-layer)

The Neo Service Layer provides oracle services and critical infrastructure using Intel SGX with Occlum LibOS enclaves for maximum security and privacy.

#### 🔧 Core Services

| Service | Description |
|---------|-------------|
| **Randomness Service** | Verifiable random number generation using Intel SGX |
| **Oracle Service** | External data delivery with cryptographic proofs |
| **Data Feeds Service** | Decentralized price and market data (Chainlink-like) |
| **Key Management Service** | Secure cryptographic key management in SGX enclaves |
| **Compute Service** | Secure JavaScript execution with access to user secrets |
| **Storage Service** | Encrypted, compressed data storage with access control |
| **Compliance Service** | Regulatory compliance verification for transactions |
| **Event Subscription Service** | Blockchain event monitoring and automation |
| **Automation Service** | Smart contract automation (Chainlink Automation-like) |
| **Cross-Chain Service** | Secure cross-chain interoperability (CCIP-like) |
| **Proof of Reserve Service** | Cryptographic asset backing verification |

#### 🧠 Advanced Infrastructure Services

| Service | Description |
|---------|-------------|
| **Zero-Knowledge Service** | Privacy-preserving computation (zk-SNARKs, zk-STARKs) |
| **Prediction Service** | AI-powered prediction and forecasting for smart contracts |
| **Pattern Recognition Service** | AI fraud detection and behavioral analysis |
| **Fair Ordering Service** | Protection against MEV attacks and unfair ordering |

## 🏛️ Architecture

R3E Labs follows a modular, security-first architecture:

```
┌─────────────────────────────────────────────────────────┐
│                    Client Applications                   │
├─────────────────────────────────────────────────────────┤
│                       API Layer                         │
├─────────────────────────────────────────────────────────┤
│                   Service Framework                     │
├─────────────────────────────────────────────────────────┤
│               Intel SGX + Occlum LibOS                  │
├─────────────────────────────────────────────────────────┤
│               Neo N3 & Neo X Integration                │
└─────────────────────────────────────────────────────────┘
```

## 🚀 Getting Started

### Quick Start with Neo N3 MCP Server
```bash
# Install globally
npm install -g @r3e/neo-n3-mcp

# Or run directly
npx @r3e/neo-n3-mcp --network testnet
```

### Using Neo Rust SDK
```rust
use neo_rust::prelude::*;

// Initialize client
let client = NeoClient::new("https://testnet1.neo.coz.io:443");

// Get blockchain info
let info = client.get_blockchain_info().await?;
```

### Developing with Neo Rust Smart Contracts
```rust
use neo_contract_rs::prelude::*;

#[contract]
pub fn hello_world() -> String {
    "Hello from Neo N3 Rust!".to_string()
}
```

## 🤝 Contributing

We welcome contributions to all our projects! Each repository contains detailed contribution guidelines:

1. **Fork** the repository
2. **Create** a feature branch
3. **Commit** your changes
4. **Push** to the branch
5. **Open** a Pull Request

## 📞 Contact & Support

- **Email**: [jimmy@r3e.network](mailto:jimmy@r3e.network)
- **Website**: [r3e.network](https://r3e.network)
- **Organization**: [github.com/r3e-network](https://github.com/r3e-network)

## 📄 License

All R3E Labs projects are released under the MIT License. See individual repositories for specific license details.

---

<div align="center">

**Building the future of Neo blockchain infrastructure with security, privacy, and performance at its core.**

*Powered by TEE, AI, ZK, and Rust* 🦀

</div> 
