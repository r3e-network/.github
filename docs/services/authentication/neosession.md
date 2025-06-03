# NeoSession - Session Management Service

## 🎯 Overview

**NeoSession** provides secure session handling for Neo dApps, enabling persistent user authentication across devices and applications while maintaining security through TEE-protected token management.

## 🚀 Purpose

Modern dApps require seamless user experiences with persistent login sessions. NeoSession eliminates the need for users to reconnect their wallets or re-authenticate every time they visit a dApp, while maintaining the highest security standards through Intel SGX protection.

## ✨ Key Features

### **🔒 TEE-Secured JWT Management**
- JWT tokens generated and managed within Intel SGX enclaves
- Cryptographic guarantees for token integrity and confidentiality
- Hardware-protected private keys for token signing
- Tamper-proof session state management

### **📱 Cross-Device Persistence**
- Sessions persist across multiple devices
- Secure session synchronization
- Device-specific security policies
- Remote session revocation capabilities

### **🔄 Auto-Renewal & Refresh**
- Automatic token refresh before expiration
- Seamless background authentication
- Zero-interruption user experience
- Configurable renewal policies

### **🌐 Cross-dApp Session Sharing**
- Single sign-on across R3E ecosystem
- Shared session state with permission controls
- Unified logout functionality
- Fine-grained access control per application

## 📊 Technical Specifications

### **Session Token Structure**
```json
{
  "sub": "neo_address",
  "iss": "neosession.r3e.network",
  "exp": 1699123456,
  "iat": 1699120000,
  "scope": ["profile", "wallet", "transactions"],
  "device_id": "device_fingerprint_hash",
  "session_id": "unique_session_identifier",
  "app_permissions": {
    "dapp1.com": ["read", "write"],
    "dapp2.com": ["read"]
  }
}
```

### **API Endpoints**

#### **Session Creation**
```http
POST /api/v1/sessions
Content-Type: application/json

{
  "wallet_address": "NXXzKhzgs8EQtpNrNdvLfPjBQU3Cq3Kt1i",
  "signature": "signed_challenge",
  "device_info": {
    "fingerprint": "device_hash",
    "user_agent": "Mozilla/5.0...",
    "platform": "web"
  },
  "permissions": ["profile", "wallet"]
}
```

#### **Session Validation**
```http
GET /api/v1/sessions/validate
Authorization: Bearer <jwt_token>
```

#### **Session Refresh**
```http
POST /api/v1/sessions/refresh
Authorization: Bearer <refresh_token>
```

#### **Session Revocation**
```http
DELETE /api/v1/sessions/{session_id}
Authorization: Bearer <jwt_token>
```

### **SDK Integration**

#### **JavaScript/TypeScript**
```typescript
import { NeoSession } from '@r3e/neo-session';

// Initialize session manager
const sessionManager = new NeoSession({
  apiUrl: 'https://neosession.r3e.network',
  appId: 'your-dapp-id'
});

// Create session after wallet connection
const session = await sessionManager.createSession({
  walletAddress: userAddress,
  signature: signedChallenge,
  permissions: ['profile', 'wallet']
});

// Auto-refresh handling
sessionManager.on('tokenRefreshed', (newToken) => {
  // Update stored token
  localStorage.setItem('neo_session', newToken);
});

// Session expiry handling
sessionManager.on('sessionExpired', () => {
  // Redirect to login
  window.location.href = '/login';
});
```

#### **Rust**
```rust
use neo_session::{SessionManager, SessionConfig};

let config = SessionConfig {
    api_url: "https://neosession.r3e.network".to_string(),
    app_id: "your-dapp-id".to_string(),
};

let session_manager = SessionManager::new(config);

// Create session
let session = session_manager.create_session(CreateSessionRequest {
    wallet_address: user_address,
    signature: signed_challenge,
    permissions: vec!["profile".to_string(), "wallet".to_string()],
}).await?;
```

## 🔧 Configuration Options

### **Session Policies**
```yaml
session_config:
  default_expiry: 7200  # 2 hours
  max_expiry: 86400     # 24 hours
  refresh_threshold: 300 # 5 minutes before expiry
  max_devices_per_user: 5
  require_device_binding: true
  enable_cross_app_sharing: true
```

### **Security Settings**
```yaml
security:
  require_signature_validation: true
  enable_device_fingerprinting: true
  enforce_origin_validation: true
  max_session_per_device: 1
  session_hijacking_detection: true
```

## 🛡️ Security Features

### **TEE Protection**
- All session tokens generated within Intel SGX enclaves
- Private keys never leave secure execution environment
- Cryptographic attestation of token authenticity
- Hardware-based random number generation

### **Device Binding**
- Cryptographic binding to device fingerprints
- Detection of session hijacking attempts
- Automatic revocation of suspicious sessions
- Device registration and management

### **Origin Validation**
- Strict CORS policies
- Origin-based access control
- Request signature validation
- Anti-CSRF token protection

## 📈 Usage Statistics & Monitoring

### **Session Analytics**
- Active session count per application
- Session duration statistics
- Device usage patterns
- Geographic distribution of sessions

### **Security Monitoring**
- Failed authentication attempts
- Suspicious session activity
- Device anomaly detection
- Session hijacking alerts

## 💰 Pricing Model

### **Developer Tier** - Free
- Up to 1,000 active sessions
- Basic session management
- 7-day session history
- Community support

### **Professional Tier** - $29/month
- Up to 10,000 active sessions
- Advanced security features
- 30-day session history
- Email support
- Custom session policies

### **Enterprise Tier** - $149/month
- Unlimited active sessions
- Full security suite
- 1-year session history
- Priority support
- Custom integrations
- SLA guarantees

## 🚀 Getting Started

### **1. Register Your Application**
```bash
curl -X POST https://neosession.r3e.network/api/v1/apps \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My Neo dApp",
    "origin": "https://mydapp.com",
    "permissions": ["profile", "wallet"]
  }'
```

### **2. Install SDK**
```bash
# npm
npm install @r3e/neo-session

# Cargo
cargo add neo-session
```

### **3. Initialize Session Manager**
```typescript
const session = new NeoSession({
  appId: 'your-app-id',
  apiUrl: 'https://neosession.r3e.network'
});
```

## 🔗 Integration Examples

### **React dApp Integration**
```typescript
import React, { useEffect, useState } from 'react';
import { NeoSession } from '@r3e/neo-session';

function useNeoSession() {
  const [session, setSession] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const sessionManager = new NeoSession({
      appId: process.env.REACT_APP_NEO_SESSION_ID
    });

    // Check for existing session
    const existingToken = localStorage.getItem('neo_session');
    if (existingToken) {
      sessionManager.validateSession(existingToken)
        .then(isValid => {
          if (isValid) setSession(existingToken);
          setLoading(false);
        });
    } else {
      setLoading(false);
    }
  }, []);

  return { session, loading };
}
```

### **Vue.js dApp Integration**
```typescript
import { ref, onMounted } from 'vue';
import { NeoSession } from '@r3e/neo-session';

export function useNeoSession() {
  const session = ref(null);
  const isAuthenticated = ref(false);

  const sessionManager = new NeoSession({
    appId: import.meta.env.VITE_NEO_SESSION_ID
  });

  onMounted(async () => {
    const token = localStorage.getItem('neo_session');
    if (token) {
      const isValid = await sessionManager.validateSession(token);
      if (isValid) {
        session.value = token;
        isAuthenticated.value = true;
      }
    }
  });

  return { session, isAuthenticated, sessionManager };
}
```

## 📚 Best Practices

### **Session Management**
1. **Always validate sessions** on application startup
2. **Handle token refresh** automatically in background
3. **Implement graceful fallbacks** for session expiry
4. **Use secure storage** for session tokens
5. **Monitor session health** proactively

### **Security Guidelines**
1. **Never store tokens** in plain text
2. **Validate origin** on all session requests
3. **Implement logout** functionality properly
4. **Monitor for anomalies** in session patterns
5. **Use HTTPS only** for all session communications

## 🔍 Troubleshooting

### **Common Issues**

#### **Session Not Persisting**
```typescript
// Ensure proper token storage
if (typeof window !== 'undefined') {
  localStorage.setItem('neo_session', token);
}
```

#### **Cross-Origin Issues**
```typescript
// Configure proper origin in app registration
const session = new NeoSession({
  appId: 'your-app-id',
  origin: window.location.origin
});
```

#### **Token Refresh Failures**
```typescript
// Implement retry logic
sessionManager.on('refreshFailed', async () => {
  await new Promise(resolve => setTimeout(resolve, 1000));
  await sessionManager.refreshSession();
});
```

## 📞 Support & Resources

- **Documentation**: [docs.neosession.r3e.network](https://docs.neosession.r3e.network)
- **API Reference**: [api.neosession.r3e.network](https://api.neosession.r3e.network)
- **GitHub Issues**: [github.com/r3e-network/neo-session](https://github.com/r3e-network/neo-session)
- **Discord Support**: [discord.gg/r3e-network](https://discord.gg/r3e-network)
- **Email**: [support@r3e.network](mailto:support@r3e.network)

---

**NeoSession transforms dApp user experience by providing secure, persistent authentication that works seamlessly across devices and applications while maintaining the highest security standards through TEE protection.** 