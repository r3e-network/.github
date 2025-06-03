# NeoAPI - API Gateway Service

## 🎯 Overview

**NeoAPI** provides enterprise-grade API gateway infrastructure for Neo dApps, offering intelligent request routing, authentication, rate limiting, load balancing, and real-time analytics with TEE-protected API key management and advanced transformation capabilities.

## 🚀 Purpose

Modern dApps require robust API management to handle traffic spikes, secure access control, and seamless integration with multiple services. NeoAPI centralizes API management, providing developers with powerful tools to secure, monitor, and optimize their API infrastructure while ensuring scalability and reliability.

## ✨ Key Features

### **🔑 Advanced Authentication & Authorization**
- Multi-tenant API key management
- JWT token validation and refresh
- OAuth 2.0 and social provider integration
- Role-based access control (RBAC)

### **🚦 Traffic Management & Rate Limiting**
- Intelligent rate limiting with multiple strategies
- Request throttling and quota management
- Circuit breaker patterns for fault tolerance
- Load balancing across multiple backend services

### **🔄 Request/Response Transformation**
- Dynamic request and response modification
- Data format conversion (JSON, XML, GraphQL)
- Header manipulation and injection
- Real-time data enrichment

### **📊 Analytics & Monitoring**
- Real-time API usage analytics
- Performance monitoring and alerting
- Custom metrics and reporting
- API health checks and SLA monitoring

## 📊 Technical Specifications

### **Authentication Methods**
```typescript
enum AuthMethod {
  API_KEY = 'api_key',
  JWT_BEARER = 'jwt_bearer',
  OAUTH2 = 'oauth2',
  CUSTOM_HEADER = 'custom_header',
  WALLET_SIGNATURE = 'wallet_signature',
  MUTUAL_TLS = 'mutual_tls'
}
```

### **API Endpoints**

#### **Create API**
```http
POST /api/v1/gateway/apis
Content-Type: application/json
Authorization: Bearer <admin_token>

{
  "name": "My Neo dApp API",
  "slug": "my-neo-dapp",
  "description": "Main API for Neo dApp functionality",
  "upstream_url": "https://api.mydapp.com",
  "auth_method": "api_key",
  "rate_limits": {
    "requests_per_minute": 1000,
    "requests_per_hour": 50000
  }
}
```

#### **Generate API Key**
```http
POST /api/v1/gateway/apis/{api_id}/keys
Content-Type: application/json

{
  "name": "Frontend App Key",
  "scopes": ["read", "write"],
  "rate_limit_override": {
    "requests_per_minute": 100
  },
  "expires_at": "2025-12-31T23:59:59Z"
}

Response:
{
  "key_id": "key_abc123",
  "api_key": "neoapi_live_abc123def456...",
  "secret": "secret_xyz789...",
  "scopes": ["read", "write"],
  "created_at": "2024-01-15T10:30:00Z"
}
```

#### **Route Configuration**
```http
PUT /api/v1/gateway/apis/{api_id}/routes
Content-Type: application/json

{
  "routes": [
    {
      "path": "/v1/users/*",
      "methods": ["GET", "POST"],
      "upstream": "https://users-service.mydapp.com",
      "auth_required": true,
      "rate_limit": {
        "requests_per_minute": 60
      },
      "transformations": {
        "request": {
          "add_headers": {
            "X-Service-Version": "1.0"
          }
        }
      }
    }
  ]
}
```

### **SDK Integration**

#### **JavaScript/TypeScript**
```typescript
import { NeoAPI } from '@r3e/neo-api';

// Initialize API gateway client
const apiGateway = new NeoAPI({
  gatewayUrl: 'https://gateway.neoapi.r3e.network',
  apiKey: 'your-admin-api-key'
});

// Create new API
const api = await apiGateway.createAPI({
  name: 'My dApp API',
  upstreamUrl: 'https://api.mydapp.com',
  authMethod: 'api_key',
  rateLimits: {
    requestsPerMinute: 1000
  }
});

// Generate API keys for clients
const clientKey = await apiGateway.generateKey(api.id, {
  name: 'Mobile App',
  scopes: ['read', 'write'],
  rateLimitOverride: {
    requestsPerMinute: 100
  }
});

// Configure routes
await apiGateway.configureRoutes(api.id, [
  {
    path: '/v1/users/*',
    methods: ['GET', 'POST'],
    upstream: 'https://users-service.com',
    transformations: {
      request: {
        addHeaders: {
          'X-API-Version': '1.0'
        }
      }
    }
  }
]);
```

#### **React Admin Dashboard**
```typescript
import { useNeoAPI } from '@r3e/neo-api-react';

function APIManagementDashboard() {
  const {
    apis,
    analytics,
    createAPI,
    updateRateLimit,
    generateKey,
    revokeKey
  } = useNeoAPI();

  const handleCreateAPI = async (apiData: APIConfig) => {
    try {
      const newAPI = await createAPI(apiData);
      console.log('API created:', newAPI.id);
    } catch (error) {
      console.error('Failed to create API:', error);
    }
  };

  return (
    <div className="api-dashboard">
      <div className="api-overview">
        <h2>API Overview</h2>
        {apis.map(api => (
          <APICard
            key={api.id}
            api={api}
            analytics={analytics[api.id]}
            onUpdateRateLimit={updateRateLimit}
          />
        ))}
      </div>
      
      <div className="api-keys-section">
        <h3>API Keys</h3>
        <APIKeyManager
          onGenerateKey={generateKey}
          onRevokeKey={revokeKey}
        />
      </div>
    </div>
  );
}
```

#### **Client-Side Usage**
```typescript
// Using generated API key in client applications
const neoAPIClient = new NeoAPI({
  gatewayUrl: 'https://gateway.neoapi.r3e.network',
  apiKey: 'neoapi_live_abc123def456...'
});

// Make API calls through gateway
const response = await neoAPIClient.request({
  method: 'GET',
  path: '/v1/users/123',
  headers: {
    'Content-Type': 'application/json'
  }
});

// Automatic retry with exponential backoff
const robustRequest = await neoAPIClient.requestWithRetry({
  method: 'POST',
  path: '/v1/transactions',
  body: transactionData,
  retryOptions: {
    maxRetries: 3,
    backoffStrategy: 'exponential'
  }
});
```

#### **Rust Backend Integration**
```rust
use neo_api::{GatewayClient, APIConfig, RateLimit};

let gateway = GatewayClient::new("admin-api-key");

// Create API configuration
let api_config = APIConfig {
    name: "Neo Contract API".to_string(),
    upstream_url: "https://contracts.mydapp.com".to_string(),
    auth_method: AuthMethod::JwtBearer,
    rate_limits: Some(RateLimit {
        requests_per_minute: 500,
        requests_per_hour: 20000,
    }),
};

let api = gateway.create_api(api_config).await?;

// Generate service-to-service API key
let service_key = gateway.generate_key(&api.id, KeyConfig {
    name: "Contract Service Key".to_string(),
    scopes: vec!["admin".to_string()],
    expires_at: None, // No expiration for service keys
}).await?;
```

## 🔧 Configuration Options

### **Rate Limiting Strategies**
```typescript
const rateLimitConfig = {
  strategies: {
    fixed_window: {
      window_size: '1m',
      max_requests: 100
    },
    sliding_window: {
      window_size: '1m',
      max_requests: 100,
      precision: '10s'
    },
    token_bucket: {
      capacity: 100,
      refill_rate: 10, // tokens per second
      initial_tokens: 50
    },
    adaptive: {
      base_limit: 100,
      burst_multiplier: 2.0,
      cooldown_period: '5m'
    }
  },
  overrides: {
    premium_users: {
      multiplier: 5.0
    },
    internal_services: {
      unlimited: true
    }
  }
};
```

### **Load Balancing Configuration**
```typescript
const loadBalancerConfig = {
  algorithm: 'weighted_round_robin', // round_robin, least_connections, ip_hash
  health_checks: {
    enabled: true,
    interval: '30s',
    timeout: '5s',
    healthy_threshold: 2,
    unhealthy_threshold: 3
  },
  upstreams: [
    {
      url: 'https://api1.mydapp.com',
      weight: 3,
      max_conns: 100
    },
    {
      url: 'https://api2.mydapp.com',
      weight: 2,
      max_conns: 80
    }
  ]
};
```

### **Request Transformation**
```typescript
const transformationRules = {
  request: {
    add_headers: {
      'X-API-Gateway': 'NeoAPI',
      'X-Request-ID': '${request_id}',
      'X-Client-IP': '${client_ip}'
    },
    remove_headers: ['X-Internal-Token'],
    modify_body: {
      add_fields: {
        'gateway_timestamp': '${timestamp}',
        'api_version': 'v1'
      }
    }
  },
  response: {
    add_headers: {
      'X-Response-Time': '${response_time}ms',
      'X-Cache-Status': '${cache_status}'
    },
    filter_fields: ['internal_id', 'debug_info']
  }
};
```

## 🛡️ Security Features

### **TEE-Protected Key Management**
```typescript
// API keys are generated and stored in TEE enclaves
const secureKeyGeneration = {
  encryption: 'AES-256-GCM',
  key_derivation: 'HKDF-SHA256',
  secure_storage: 'Intel SGX',
  rotation_policy: {
    automatic: true,
    interval: '90d',
    overlap_period: '7d'
  }
};
```

### **Advanced Authentication**
```typescript
// Multi-factor API authentication
const authConfig = {
  primary: {
    method: 'api_key',
    validation: 'hmac_sha256'
  },
  secondary: {
    method: 'jwt_bearer',
    issuer_verification: true,
    audience_check: true
  },
  wallet_signature: {
    required_for: ['admin_operations'],
    message_format: 'EIP-191',
    nonce_validation: true
  }
};
```

### **Request Validation**
```typescript
const validationRules = {
  request_size_limit: '10MB',
  content_type_validation: true,
  sql_injection_detection: true,
  xss_protection: true,
  schema_validation: {
    enabled: true,
    strict_mode: false,
    custom_validators: ['neo_address', 'transaction_hash']
  }
};
```

## 💰 Pricing Model

### **Starter** - Free
- Up to 10,000 requests per month
- 2 APIs and 5 API keys
- Basic rate limiting
- Community support

### **Developer** - $29/month
- Up to 100,000 requests per month
- 10 APIs and unlimited keys
- Advanced rate limiting
- Email support
- Basic analytics

### **Professional** - $99/month
- Up to 1,000,000 requests per month
- Unlimited APIs and keys
- Load balancing and failover
- Advanced transformations
- Detailed analytics
- Priority support

### **Enterprise** - $299/month
- Up to 10,000,000 requests per month
- White-label gateway
- Custom authentication methods
- SLA guarantees
- 24/7 support
- On-premise deployment

## 🚀 Quick Start Guide

### **1. Install SDK**
```bash
npm install @r3e/neo-api
```

### **2. Create Your First API**
```typescript
import { NeoAPI } from '@r3e/neo-api';

const gateway = new NeoAPI({
  apiKey: process.env.NEO_API_ADMIN_KEY
});

const api = await gateway.createAPI({
  name: 'My Neo dApp',
  upstreamUrl: 'https://api.mydapp.com'
});
```

### **3. Generate Client API Key**
```typescript
const clientKey = await gateway.generateKey(api.id, {
  name: 'Web Client',
  scopes: ['read', 'write']
});

console.log('Client API Key:', clientKey.api_key);
```

### **4. Use API Key in Your App**
```typescript
const client = new NeoAPI({
  gatewayUrl: 'https://gateway.neoapi.r3e.network',
  apiKey: clientKey.api_key
});

const data = await client.get('/v1/users/me');
```

## 🔗 Integration Examples

### **DeFi Protocol API Management**
```typescript
class DeFiAPIManager {
  private gateway: NeoAPI;

  constructor() {
    this.gateway = new NeoAPI({
      apiKey: process.env.GATEWAY_ADMIN_KEY
    });
  }

  async setupDeFiAPIs() {
    // Trading API with high rate limits
    const tradingAPI = await this.gateway.createAPI({
      name: 'DeFi Trading API',
      upstreamUrl: 'https://trading.defi.com',
      rateLimits: {
        requestsPerSecond: 100,
        burstLimit: 500
      }
    });

    // Configure trading routes
    await this.gateway.configureRoutes(tradingAPI.id, [
      {
        path: '/v1/swap',
        methods: ['POST'],
        auth: { required: true, scopes: ['trading'] },
        rateLimits: {
          requestsPerMinute: 10 // Conservative for actual trades
        },
        transformations: {
          request: {
            addHeaders: {
              'X-Trading-Source': 'gateway'
            },
            validateBody: {
              schema: 'swap_request_schema'
            }
          }
        }
      }
    ]);

    // Analytics API with different limits
    const analyticsAPI = await this.gateway.createAPI({
      name: 'DeFi Analytics API',
      upstreamUrl: 'https://analytics.defi.com',
      rateLimits: {
        requestsPerMinute: 1000
      }
    });

    return { tradingAPI, analyticsAPI };
  }

  async generateUserAPIKey(userId: string, tier: 'basic' | 'premium') {
    const limits = tier === 'premium' 
      ? { requestsPerMinute: 1000 }
      : { requestsPerMinute: 100 };

    return await this.gateway.generateKey(this.tradingAPI.id, {
      name: `User ${userId} Key`,
      scopes: ['trading', 'analytics'],
      rateLimitOverride: limits,
      metadata: { user_id: userId, tier }
    });
  }
}
```

### **NFT Marketplace API Gateway**
```typescript
class NFTMarketplaceGateway {
  private gateway: NeoAPI;

  async setupMarketplaceAPIs() {
    // Public browsing API
    const browsingAPI = await this.gateway.createAPI({
      name: 'NFT Browsing API',
      upstreamUrl: 'https://browse.nft-marketplace.com',
      authMethod: 'none', // Public access
      rateLimits: {
        requestsPerMinute: 500
      },
      caching: {
        enabled: true,
        ttl: '5m',
        varyBy: ['query_params']
      }
    });

    // Authenticated trading API
    const tradingAPI = await this.gateway.createAPI({
      name: 'NFT Trading API',
      upstreamUrl: 'https://trading.nft-marketplace.com',
      authMethod: 'wallet_signature',
      rateLimits: {
        requestsPerMinute: 60
      }
    });

    // Configure marketplace-specific routes
    await this.gateway.configureRoutes(tradingAPI.id, [
      {
        path: '/v1/listings',
        methods: ['POST'],
        auth: { required: true },
        transformations: {
          request: {
            validateBody: {
              required: ['token_id', 'price', 'currency'],
              custom_validators: {
                price: 'positive_number',
                token_id: 'valid_nft_id'
              }
            }
          }
        },
        rateLimits: {
          requestsPerMinute: 5 // Limit listing creation
        }
      }
    ]);

    return { browsingAPI, tradingAPI };
  }
}
```

### **Gaming dApp API Infrastructure**
```typescript
class GameAPIGateway {
  private gateway: NeoAPI;

  async setupGameAPIs() {
    // Game state API with real-time features
    const gameStateAPI = await this.gateway.createAPI({
      name: 'Game State API',
      upstreamUrl: 'https://gamestate.mygame.com',
      authMethod: 'jwt_bearer',
      rateLimits: {
        requestsPerSecond: 50 // High frequency for real-time games
      },
      websocket: {
        enabled: true,
        upgrade_paths: ['/v1/game/live']
      }
    });

    // Leaderboard API with caching
    const leaderboardAPI = await this.gateway.createAPI({
      name: 'Leaderboard API',
      upstreamUrl: 'https://leaderboard.mygame.com',
      rateLimits: {
        requestsPerMinute: 200
      },
      caching: {
        enabled: true,
        ttl: '1m',
        refreshAhead: true
      }
    });

    // Asset trading API
    const assetAPI = await this.gateway.createAPI({
      name: 'Game Asset API',
      upstreamUrl: 'https://assets.mygame.com',
      authMethod: 'api_key',
      rateLimits: {
        requestsPerMinute: 100
      }
    });

    // Set up circuit breaker for critical game functions
    await this.gateway.configureCircuitBreaker(gameStateAPI.id, {
      failureThreshold: 10,
      timeout: '30s',
      halfOpenMaxCalls: 3
    });

    return { gameStateAPI, leaderboardAPI, assetAPI };
  }
}
```

## 🔍 Troubleshooting

### **Common Issues**

#### **Rate Limit Exceeded**
```typescript
// Handle rate limiting gracefully
const handleRateLimitedRequest = async (request: APIRequest) => {
  try {
    return await gateway.request(request);
  } catch (error) {
    if (error.code === 'RATE_LIMIT_EXCEEDED') {
      const retryAfter = error.headers['retry-after'];
      console.log(`Rate limited, retry after ${retryAfter} seconds`);
      
      // Implement exponential backoff
      await new Promise(resolve => 
        setTimeout(resolve, parseInt(retryAfter) * 1000)
      );
      
      return await gateway.request(request);
    }
    throw error;
  }
};
```

#### **Authentication Failures**
```typescript
// Debug authentication issues
const debugAuthRequest = async () => {
  try {
    const response = await gateway.request({
      method: 'GET',
      path: '/v1/debug/auth',
      debug: true
    });
    
    console.log('Auth debug info:', response.debug_info);
  } catch (error) {
    console.error('Auth error details:', {
      code: error.code,
      message: error.message,
      headers: error.response?.headers
    });
  }
};
```

#### **Performance Issues**
```typescript
// Monitor API performance
const monitorAPIPerformance = () => {
  gateway.on('request_completed', (metrics) => {
    if (metrics.response_time > 1000) {
      console.warn('Slow API response:', {
        path: metrics.path,
        response_time: metrics.response_time,
        upstream: metrics.upstream
      });
    }
  });
  
  // Set up alerts for high error rates
  gateway.on('error_rate_high', (alert) => {
    console.error('High error rate detected:', alert);
    // Implement circuit breaker or failover
  });
};
```

## 📞 Support & Resources

- **Documentation**: [docs.neoapi.r3e.network](https://docs.neoapi.r3e.network)
- **Gateway Dashboard**: [dashboard.neoapi.r3e.network](https://dashboard.neoapi.r3e.network)
- **API Reference**: [api.neoapi.r3e.network](https://api.neoapi.r3e.network)
- **Status Page**: [status.neoapi.r3e.network](https://status.neoapi.r3e.network)
- **Developer Portal**: [developers.neoapi.r3e.network](https://developers.neoapi.r3e.network)
- **Discord Support**: [discord.gg/r3e-network](https://discord.gg/r3e-network)
- **Email**: [api@r3e.network](mailto:api@r3e.network)

---

**NeoAPI provides enterprise-grade API gateway infrastructure that enables Neo dApps to scale securely with intelligent traffic management, authentication, and real-time analytics.** 