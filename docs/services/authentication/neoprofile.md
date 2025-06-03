# NeoProfile - User Profile Management Service

## 🎯 Overview

**NeoProfile** provides unified user profile management for Neo dApps, enabling privacy-controlled data sharing, cross-dApp identity, and reputation systems with decentralized storage and TEE-protected privacy controls.

## 🚀 Purpose

Modern dApps need seamless user identity management that works across applications while respecting user privacy. NeoProfile creates a unified identity layer that allows users to control their data sharing preferences and build reputation across the Neo ecosystem.

## ✨ Key Features

### **🔐 Decentralized Profile Storage**
- IPFS-based profile data storage with content addressing
- User-controlled data sovereignty and ownership
- Encrypted profile data with selective disclosure
- Version-controlled profile updates and history

### **🎛️ Privacy-Controlled Data Sharing**
- Granular privacy controls per data field
- dApp-specific permission management
- Consent-based data sharing protocols
- Zero-knowledge proofs for sensitive attributes

### **🌐 Cross-dApp Profile Portability**
- Universal profile format across Neo ecosystem
- Single profile for multiple dApp integrations
- Unified identity across applications
- Seamless dApp onboarding with existing profiles

### **🏆 Reputation & Verification Systems**
- Cross-dApp reputation aggregation
- Skill and achievement verification
- Social proof and endorsement systems
- Trust score calculation and display

## 📊 Technical Specifications

### **Profile Data Schema**
```json
{
  "profile_id": "neo_address_hash",
  "version": "1.0.0",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-15T10:30:00Z",
  "basic_info": {
    "display_name": "John Doe",
    "username": "johndoe",
    "bio": "Neo ecosystem developer",
    "avatar_ipfs": "QmHash...",
    "location": "San Francisco, CA",
    "website": "https://johndoe.dev"
  },
  "contact_info": {
    "email": "encrypted_email_hash",
    "twitter": "@johndoe",
    "discord": "johndoe#1234",
    "github": "johndoe"
  },
  "verification": {
    "email_verified": true,
    "github_verified": true,
    "twitter_verified": false,
    "kyc_level": "basic"
  },
  "reputation": {
    "trust_score": 8.5,
    "total_interactions": 1250,
    "positive_reviews": 98,
    "achievements": ["early_adopter", "developer", "contributor"]
  },
  "privacy_settings": {
    "email": "private",
    "location": "dapps_only",
    "contact_info": "verified_dapps",
    "reputation": "public"
  },
  "dapp_permissions": {
    "mydapp.com": ["basic_info", "reputation"],
    "marketplace.neo": ["basic_info", "contact_info", "reputation"]
  }
}
```

### **API Endpoints**

#### **Create Profile**
```http
POST /api/v1/profiles
Content-Type: application/json
Authorization: Bearer <session_token>

{
  "wallet_signature": "signed_profile_data",
  "profile_data": {
    "display_name": "John Doe",
    "username": "johndoe",
    "bio": "Neo ecosystem developer",
    "avatar_file": "base64_image_data"
  },
  "privacy_settings": {
    "email": "private",
    "location": "dapps_only"
  }
}
```

#### **Get Profile**
```http
GET /api/v1/profiles/{neo_address}
Authorization: Bearer <api_key>
X-DApp-Origin: https://mydapp.com

Response:
{
  "profile_id": "hash",
  "basic_info": { /* filtered based on permissions */ },
  "reputation": { /* public reputation data */ },
  "permissions_granted": ["basic_info", "reputation"]
}
```

#### **Update Profile**
```http
PATCH /api/v1/profiles/{profile_id}
Content-Type: application/json
Authorization: Bearer <session_token>

{
  "updates": {
    "bio": "Updated bio text",
    "location": "New York, NY"
  },
  "signature": "signed_update_hash"
}
```

#### **Grant dApp Permissions**
```http
POST /api/v1/profiles/{profile_id}/permissions
Content-Type: application/json

{
  "dapp_origin": "https://newdapp.com",
  "permissions": ["basic_info", "contact_info"],
  "consent_signature": "signed_consent"
}
```

### **SDK Integration**

#### **JavaScript/TypeScript**
```typescript
import { NeoProfile } from '@r3e/neo-profile';

// Initialize profile manager
const profileManager = new NeoProfile({
  apiKey: 'your-api-key',
  dappOrigin: 'https://mydapp.com'
});

// Create user profile
const profile = await profileManager.createProfile({
  displayName: 'John Doe',
  username: 'johndoe',
  bio: 'Neo developer',
  avatarFile: avatarBlob,
  privacySettings: {
    email: 'private',
    location: 'dapps_only'
  }
});

// Get user profile with permissions
const userProfile = await profileManager.getProfile(neoAddress, {
  requestedPermissions: ['basic_info', 'reputation']
});

// Update profile
await profileManager.updateProfile({
  bio: 'Updated bio',
  location: 'San Francisco'
});

// Request additional permissions
await profileManager.requestPermissions(['contact_info'], {
  reason: 'To send important notifications'
});
```

#### **React Integration**
```typescript
import { useNeoProfile } from '@r3e/neo-profile-react';

function UserProfileComponent() {
  const { 
    profile, 
    loading, 
    error, 
    updateProfile, 
    requestPermissions 
  } = useNeoProfile();

  const handleUpdateProfile = async (updates) => {
    try {
      await updateProfile(updates);
      toast.success('Profile updated successfully');
    } catch (err) {
      toast.error('Failed to update profile');
    }
  };

  if (loading) return <ProfileSkeleton />;
  if (error) return <ErrorMessage error={error} />;

  return (
    <div className="profile-container">
      <Avatar src={profile.avatar_url} alt={profile.display_name} />
      <h2>{profile.display_name}</h2>
      <p>{profile.bio}</p>
      <TrustScore score={profile.reputation.trust_score} />
      <Achievements badges={profile.reputation.achievements} />
    </div>
  );
}
```

#### **Rust Backend Integration**
```rust
use neo_profile::{ProfileClient, ProfileData, PrivacyLevel};

let profile_client = ProfileClient::new("your-api-key", "https://mydapp.com");

// Get user profile
let profile = profile_client.get_profile(
    &neo_address,
    vec!["basic_info".to_string(), "reputation".to_string()]
).await?;

// Verify user permissions
let has_permission = profile_client.check_permission(
    &neo_address,
    "contact_info"
).await?;

if has_permission {
    // Access sensitive data
    let contact_info = profile_client.get_contact_info(&neo_address).await?;
}
```

## 🔧 Privacy Controls

### **Data Visibility Levels**
- **Public**: Visible to everyone
- **dApps Only**: Visible to connected dApps with permission
- **Verified dApps**: Only dApps with verification status
- **Private**: Not shared with any dApp
- **Friends Only**: Shared with trusted connections

### **Permission Management**
```typescript
// Fine-grained permission control
const permissionConfig = {
  basic_info: {
    display_name: 'public',
    username: 'public',
    bio: 'dapps_only',
    avatar: 'public'
  },
  contact_info: {
    email: 'private',
    social_links: 'verified_dapps'
  },
  location: 'dapps_only',
  reputation: 'public'
};
```

### **Consent Management**
```typescript
// Request user consent for data access
const consentRequest = await profileManager.requestConsent({
  permissions: ['contact_info', 'location'],
  purpose: 'User verification and communication',
  dataUsage: 'One-time verification, not stored',
  retentionPeriod: '30 days'
});
```

## 🛡️ Security Features

### **TEE-Protected Privacy**
- Privacy settings encrypted within Intel SGX enclaves
- Zero-knowledge proofs for attribute verification
- Cryptographic access control enforcement
- Tamper-proof permission management

### **Data Integrity**
- Profile data signed with user's private key
- Content-addressed IPFS storage for immutability
- Version control with audit trails
- Cryptographic proof of data authenticity

### **Access Control**
- dApp origin verification and allowlisting
- Rate limiting for profile access
- Suspicious access pattern detection
- Automatic permission revocation on anomalies

## 🏆 Reputation System

### **Trust Score Calculation**
```typescript
// Trust score factors
const trustFactors = {
  account_age: 0.2,        // 20% weight
  transaction_history: 0.25, // 25% weight
  peer_reviews: 0.3,       // 30% weight
  verification_level: 0.15, // 15% weight
  community_activity: 0.1   // 10% weight
};

const trustScore = calculateTrustScore(userProfile, trustFactors);
```

### **Achievement System**
- **Developer**: Smart contract deployments and contributions
- **Trader**: DeFi participation and trading volume
- **Creator**: NFT creation and artistic contributions
- **Contributor**: Open source contributions and community help
- **Early Adopter**: Early Neo ecosystem participation

### **Peer Reviews**
```typescript
// Submit peer review
await profileManager.submitReview({
  revieweeAddress: 'target_neo_address',
  rating: 5,
  category: 'trustworthiness',
  comment: 'Excellent trader, fast and reliable',
  transactionProof: 'tx_hash_reference'
});
```

## 💰 Pricing Model

### **Basic** - Free
- Up to 1 profile per address
- Basic privacy controls
- Standard reputation features
- Community support

### **Premium** - $5/month
- Enhanced privacy controls
- Priority profile verification
- Advanced reputation analytics
- Email support

### **Professional** - $15/month
- Multiple profile personas
- Business verification badges
- API access for profile data
- Custom integration support

### **Enterprise** - $50/month
- White-label profile system
- Custom verification workflows
- Dedicated support
- SLA guarantees

## 🚀 Quick Start Guide

### **1. Install SDK**
```bash
npm install @r3e/neo-profile
# or
yarn add @r3e/neo-profile
```

### **2. Initialize Profile Manager**
```typescript
import { NeoProfile } from '@r3e/neo-profile';

const profileManager = new NeoProfile({
  apiKey: process.env.NEO_PROFILE_API_KEY,
  dappOrigin: window.location.origin
});
```

### **3. Create User Profile**
```typescript
// After user wallet connection
const profile = await profileManager.createProfile({
  displayName: userInput.name,
  username: userInput.username,
  bio: userInput.bio,
  privacySettings: {
    email: 'private',
    location: 'dapps_only'
  }
});
```

### **4. Request Profile Access**
```typescript
// In your dApp
const userProfile = await profileManager.getProfile(userAddress, {
  requestedPermissions: ['basic_info', 'reputation'],
  purpose: 'Display user information in marketplace'
});
```

## 🔗 Integration Examples

### **Marketplace Integration**
```typescript
class MarketplaceProfile {
  private profileManager: NeoProfile;

  constructor() {
    this.profileManager = new NeoProfile({
      apiKey: process.env.PROFILE_API_KEY,
      dappOrigin: 'https://marketplace.neo'
    });
  }

  async displaySellerProfile(sellerAddress: string) {
    const profile = await this.profileManager.getProfile(sellerAddress, {
      requestedPermissions: ['basic_info', 'reputation']
    });

    return {
      name: profile.display_name,
      avatar: profile.avatar_url,
      trustScore: profile.reputation.trust_score,
      totalSales: profile.reputation.marketplace_stats?.total_sales,
      memberSince: profile.created_at
    };
  }

  async submitSellerReview(sellerAddress: string, purchaseData: any) {
    await this.profileManager.submitReview({
      revieweeAddress: sellerAddress,
      rating: purchaseData.rating,
      category: 'seller_reliability',
      comment: purchaseData.review,
      transactionProof: purchaseData.tx_hash
    });
  }
}
```

### **Social dApp Integration**
```typescript
class SocialProfileManager {
  private profileManager: NeoProfile;

  constructor() {
    this.profileManager = new NeoProfile({
      apiKey: process.env.PROFILE_API_KEY
    });
  }

  async connectUsers(userAddress1: string, userAddress2: string) {
    // Check mutual permissions
    const profile1 = await this.profileManager.getProfile(userAddress1);
    const profile2 = await this.profileManager.getProfile(userAddress2);

    if (profile1.privacy_settings.social_connections !== 'private') {
      await this.profileManager.addConnection({
        fromAddress: userAddress1,
        toAddress: userAddress2,
        connectionType: 'friend'
      });
    }
  }

  async getProfileForFeed(userAddress: string) {
    return await this.profileManager.getProfile(userAddress, {
      requestedPermissions: ['basic_info', 'social_activity'],
      purpose: 'Display in social feed'
    });
  }
}
```

## 📊 Analytics & Insights

### **Profile Analytics**
- Profile view statistics
- Permission grant rates
- dApp integration analytics
- User engagement metrics

### **Reputation Trends**
- Trust score evolution over time
- Achievement unlock patterns
- Review sentiment analysis
- Cross-dApp reputation correlation

### **Privacy Insights**
- Permission usage patterns
- Privacy setting preferences
- Data sharing consent rates
- User control utilization

## 🔍 Troubleshooting

### **Common Issues**

#### **Profile Not Loading**
```typescript
// Check profile existence and permissions
try {
  const profile = await profileManager.getProfile(address);
} catch (error) {
  if (error.code === 'PROFILE_NOT_FOUND') {
    // Prompt user to create profile
    await promptProfileCreation();
  } else if (error.code === 'PERMISSION_DENIED') {
    // Request necessary permissions
    await requestProfilePermissions();
  }
}
```

#### **Permission Errors**
```typescript
// Handle permission scenarios gracefully
const safeGetProfile = async (address: string) => {
  try {
    return await profileManager.getProfile(address, {
      requestedPermissions: ['basic_info'],
      fallbackToPublic: true
    });
  } catch (error) {
    // Return minimal public profile
    return {
      display_name: 'Anonymous User',
      avatar_url: '/default-avatar.png'
    };
  }
};
```

## 📞 Support & Resources

- **Documentation**: [docs.neoprofile.r3e.network](https://docs.neoprofile.r3e.network)
- **Profile Dashboard**: [profiles.r3e.network](https://profiles.r3e.network)
- **API Reference**: [api.neoprofile.r3e.network](https://api.neoprofile.r3e.network)
- **Privacy Guide**: [privacy.neoprofile.r3e.network](https://privacy.neoprofile.r3e.network)
- **Discord Support**: [discord.gg/r3e-network](https://discord.gg/r3e-network)
- **Email**: [profiles@r3e.network](mailto:profiles@r3e.network)

---

**NeoProfile empowers users with complete control over their digital identity while enabling seamless cross-dApp experiences through privacy-preserving profile management and reputation systems.** 