# NeoStorage - Decentralized Storage Service

## 🎯 Overview

**NeoStorage** provides enterprise-grade decentralized storage infrastructure for Neo dApps, offering IPFS-based file storage, content addressing, automatic redundancy, and seamless CDN integration with TEE-protected data encryption and access control.

## 🚀 Purpose

Traditional cloud storage creates single points of failure and vendor lock-in for dApps. NeoStorage eliminates these risks by providing decentralized, content-addressed storage that's permanently accessible, globally distributed, and cost-effective while maintaining enterprise-grade security and performance.

## ✨ Key Features

### **🌐 IPFS-Based Architecture**
- Content-addressed storage with cryptographic verification
- Automatic data deduplication and compression
- Global peer-to-peer distribution network
- Immutable content addressing and versioning

### **⚡ Performance Optimization**
- Intelligent CDN layer for faster content delivery
- Automatic caching and geographic distribution
- Optimized retrieval paths and load balancing
- Progressive loading for large files

### **🔐 Enterprise Security**
- Client-side encryption before upload
- Fine-grained access control and permissions
- TEE-protected key management
- Audit trails and compliance reporting

### **💾 Data Management**
- Automated backup and redundancy
- Storage analytics and usage monitoring
- Lifecycle management and archival
- Cross-platform synchronization

## 📊 Technical Specifications

### **Storage Types**
```typescript
enum StorageType {
  PUBLIC = 'public',           // Publicly accessible content
  PRIVATE = 'private',         // Encrypted private content
  SHARED = 'shared',          // Shared with specific users
  TEMPORARY = 'temporary',     // Auto-expire content
  IMMUTABLE = 'immutable',    // Write-once, read-many
  VERSIONED = 'versioned'     // Version-controlled content
}
```

### **API Endpoints**

#### **Upload File**
```http
POST /api/v1/storage/upload
Content-Type: multipart/form-data
Authorization: Bearer <api_key>

FormData:
- file: <binary_data>
- metadata: {
    "type": "private",
    "ttl": "30d",
    "access_permissions": ["user1", "user2"]
  }

Response:
{
  "cid": "QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG",
  "url": "https://gateway.neostorage.r3e.network/ipfs/QmYw...",
  "size": 1024576,
  "type": "private",
  "created_at": "2024-01-15T10:30:00Z"
}
```

#### **Download File**
```http
GET /api/v1/storage/{cid}
Authorization: Bearer <api_key>

Response: <binary_data>
Headers:
- Content-Type: application/octet-stream
- Content-Length: 1024576
- Cache-Control: public, max-age=31536000
```

#### **File Metadata**
```http
GET /api/v1/storage/{cid}/metadata
Authorization: Bearer <api_key>

Response:
{
  "cid": "QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG",
  "size": 1024576,
  "type": "private",
  "mime_type": "image/jpeg",
  "created_at": "2024-01-15T10:30:00Z",
  "last_accessed": "2024-01-15T12:45:00Z",
  "access_count": 15,
  "redundancy_level": 5
}
```

### **SDK Integration**

#### **JavaScript/TypeScript**
```typescript
import { NeoStorage } from '@r3e/neo-storage';

// Initialize storage client
const storage = new NeoStorage({
  apiKey: 'your-api-key',
  gateway: 'https://gateway.neostorage.r3e.network',
  encryption: true
});

// Upload file
const uploadResult = await storage.upload(fileBlob, {
  type: 'private',
  metadata: {
    title: 'User Avatar',
    description: 'Profile picture for user',
    tags: ['avatar', 'profile']
  },
  accessControl: {
    owner: userAddress,
    shared_with: ['friend1_address', 'friend2_address']
  }
});

console.log('File uploaded:', uploadResult.cid);

// Download file
const fileBlob = await storage.download(uploadResult.cid);

// Get file URL for direct access
const publicUrl = storage.getPublicUrl(uploadResult.cid);

// Upload directory
const directoryResult = await storage.uploadDirectory(fileArray, {
  preserveStructure: true,
  type: 'public'
});
```

#### **React Integration**
```typescript
import { useNeoStorage } from '@r3e/neo-storage-react';

function FileUploadComponent() {
  const {
    upload,
    download,
    isUploading,
    uploadProgress,
    getFileUrl
  } = useNeoStorage();

  const handleFileUpload = async (file: File) => {
    try {
      const result = await upload(file, {
        type: 'private',
        onProgress: (progress) => {
          console.log(`Upload progress: ${progress}%`);
        }
      });
      
      console.log('File uploaded successfully:', result.cid);
      return result;
    } catch (error) {
      console.error('Upload failed:', error);
    }
  };

  const handleFileDownload = async (cid: string) => {
    try {
      const blob = await download(cid);
      const url = URL.createObjectURL(blob);
      
      // Trigger download
      const a = document.createElement('a');
      a.href = url;
      a.download = 'downloaded-file';
      a.click();
    } catch (error) {
      console.error('Download failed:', error);
    }
  };

  return (
    <div className="file-upload">
      <input
        type="file"
        onChange={(e) => {
          if (e.target.files?.[0]) {
            handleFileUpload(e.target.files[0]);
          }
        }}
        disabled={isUploading}
      />
      
      {isUploading && (
        <div className="upload-progress">
          <div style={{ width: `${uploadProgress}%` }} />
          <span>{uploadProgress}%</span>
        </div>
      )}
    </div>
  );
}
```

#### **Vue.js Integration**
```typescript
import { useNeoStorage } from '@r3e/neo-storage-vue';

export default {
  setup() {
    const {
      upload,
      uploadMultiple,
      createFolder,
      getStorageUsage
    } = useNeoStorage();

    const uploadFiles = async (files: FileList) => {
      const results = await uploadMultiple(Array.from(files), {
        type: 'public',
        concurrent: 3 // Upload 3 files at a time
      });
      
      return results;
    };

    return {
      upload,
      uploadFiles,
      createFolder,
      getStorageUsage
    };
  }
};
```

#### **Rust Backend Integration**
```rust
use neo_storage::{StorageClient, UploadOptions, AccessLevel};

let storage_client = StorageClient::new("your-api-key");

// Upload file
let upload_options = UploadOptions {
    storage_type: AccessLevel::Private,
    ttl: Some(Duration::days(30)),
    metadata: Some(json!({
        "description": "Contract deployment artifact"
    })),
};

let upload_result = storage_client.upload_file(&file_path, upload_options).await?;
println!("Uploaded file CID: {}", upload_result.cid);

// Download file
let file_data = storage_client.download_file(&upload_result.cid).await?;
```

## 🔧 Configuration Options

### **Storage Configuration**
```typescript
const storageConfig = {
  default_storage_type: 'private',
  encryption: {
    enabled: true,
    algorithm: 'AES-256-GCM',
    key_derivation: 'PBKDF2'
  },
  redundancy: {
    min_replicas: 3,
    target_replicas: 5,
    geo_distribution: true
  },
  performance: {
    enable_cdn: true,
    cache_duration: '7d',
    compression: 'gzip'
  }
};
```

### **Access Control**
```typescript
const accessControlRules = {
  public: {
    read: 'anyone',
    write: 'owner'
  },
  private: {
    read: 'owner',
    write: 'owner'
  },
  shared: {
    read: ['owner', ...shared_users],
    write: 'owner'
  },
  organization: {
    read: 'organization_members',
    write: 'organization_admins'
  }
};
```

## 🛡️ Security Features

### **Client-Side Encryption**
```typescript
// Automatic encryption before upload
const encryptedUpload = await storage.upload(fileBlob, {
  encryption: {
    enabled: true,
    password: userPassword, // Optional user-provided password
    derive_from_wallet: true // Use wallet signature for key derivation
  }
});

// Decryption happens automatically on download
const decryptedBlob = await storage.download(cid, {
  password: userPassword // Required if password was used
});
```

### **Access Token Management**
```typescript
// Generate time-limited access tokens
const accessToken = await storage.generateAccessToken({
  cid: fileCid,
  permissions: ['read'],
  expires_in: '1h',
  allowed_origins: ['https://mydapp.com']
});

// Use token for direct access
const fileUrl = `${gateway}/ipfs/${cid}?token=${accessToken}`;
```

### **Audit Logging**
```typescript
// Get access logs for file
const accessLogs = await storage.getAccessLogs(cid, {
  from: '2024-01-01',
  to: '2024-01-31'
});

// Monitor for unauthorized access attempts
storage.on('unauthorized_access', (event) => {
  console.warn('Unauthorized access attempt:', event);
  alertSecurityTeam(event);
});
```

## 💰 Pricing Model

### **Starter** - Free
- 1 GB storage included
- Basic IPFS pinning
- Public CDN access
- Community support

### **Developer** - $9/month
- 10 GB storage included
- Private file encryption
- Advanced CDN features
- Email support
- $0.10/GB overage

### **Professional** - $49/month
- 100 GB storage included
- Custom access controls
- Analytics dashboard
- Priority support
- $0.08/GB overage

### **Enterprise** - $199/month
- 1 TB storage included
- Advanced security features
- Dedicated infrastructure
- 24/7 support
- $0.05/GB overage

## 🚀 Quick Start Guide

### **1. Install SDK**
```bash
npm install @r3e/neo-storage
```

### **2. Initialize Client**
```typescript
import { NeoStorage } from '@r3e/neo-storage';

const storage = new NeoStorage({
  apiKey: process.env.NEO_STORAGE_API_KEY,
  encryption: true
});
```

### **3. Upload Your First File**
```typescript
const file = document.getElementById('fileInput').files[0];
const result = await storage.upload(file, {
  type: 'private',
  metadata: { description: 'My first upload' }
});

console.log('File uploaded:', result.cid);
```

### **4. Access Your File**
```typescript
// Direct download
const fileBlob = await storage.download(result.cid);

// Or get public URL
const url = storage.getPublicUrl(result.cid);
```

## 🔗 Integration Examples

### **NFT Marketplace Integration**
```typescript
class NFTStorageManager {
  private storage: NeoStorage;

  constructor() {
    this.storage = new NeoStorage({
      apiKey: process.env.STORAGE_API_KEY,
      encryption: true
    });
  }

  async uploadNFTAssets(imageFile: File, metadataFile: File) {
    // Upload image with high redundancy
    const imageResult = await this.storage.upload(imageFile, {
      type: 'immutable',
      redundancy: 10, // High redundancy for valuable assets
      metadata: {
        content_type: 'nft_image',
        permanent: true
      }
    });

    // Upload metadata referencing image
    const metadata = {
      ...JSON.parse(await metadataFile.text()),
      image: `ipfs://${imageResult.cid}`
    };

    const metadataResult = await this.storage.uploadJson(metadata, {
      type: 'immutable',
      redundancy: 10
    });

    return {
      imageCid: imageResult.cid,
      metadataCid: metadataResult.cid,
      tokenUri: `ipfs://${metadataResult.cid}`
    };
  }

  async createNFTCollection(assets: Array<{image: File, metadata: any}>) {
    const uploadPromises = assets.map(async (asset, index) => {
      const imageResult = await this.storage.upload(asset.image, {
        type: 'immutable',
        metadata: { collection_index: index }
      });

      const metadataResult = await this.storage.uploadJson({
        ...asset.metadata,
        image: `ipfs://${imageResult.cid}`
      }, { type: 'immutable' });

      return {
        tokenId: index,
        imageCid: imageResult.cid,
        metadataCid: metadataResult.cid
      };
    });

    return await Promise.all(uploadPromises);
  }
}
```

### **Social DApp Integration**
```typescript
class SocialMediaStorage {
  private storage: NeoStorage;

  async uploadUserContent(userId: string, content: File, type: 'post' | 'avatar' | 'video') {
    const uploadOptions = {
      type: type === 'avatar' ? 'public' : 'shared',
      metadata: {
        user_id: userId,
        content_type: type,
        uploaded_at: new Date().toISOString()
      },
      access_control: {
        owner: userId,
        shared_with: type === 'post' ? ['followers'] : []
      }
    };

    const result = await this.storage.upload(content, uploadOptions);

    // Create thumbnail for images/videos
    if (type === 'post' && content.type.startsWith('image/')) {
      const thumbnail = await this.createThumbnail(content);
      const thumbnailResult = await this.storage.upload(thumbnail, {
        ...uploadOptions,
        metadata: {
          ...uploadOptions.metadata,
          is_thumbnail: true,
          original_cid: result.cid
        }
      });

      return {
        ...result,
        thumbnail_cid: thumbnailResult.cid
      };
    }

    return result;
  }

  async setupUserMediaLibrary(userId: string) {
    // Create user's media folders
    const folders = await Promise.all([
      this.storage.createFolder(`users/${userId}/avatars`),
      this.storage.createFolder(`users/${userId}/posts`),
      this.storage.createFolder(`users/${userId}/videos`)
    ]);

    return { folders };
  }
}
```

### **Gaming dApp Integration**
```typescript
class GameAssetStorage {
  private storage: NeoStorage;

  async uploadGameAssets(gameId: string, assets: GameAsset[]) {
    // Upload game assets with version control
    const uploadPromises = assets.map(async (asset) => {
      return await this.storage.upload(asset.file, {
        type: 'versioned',
        metadata: {
          game_id: gameId,
          asset_type: asset.type,
          version: asset.version,
          checksum: await this.calculateChecksum(asset.file)
        }
      });
    });

    const results = await Promise.all(uploadPromises);
    
    // Create game manifest
    const manifest = {
      game_id: gameId,
      version: '1.0.0',
      assets: results.map((result, index) => ({
        type: assets[index].type,
        cid: result.cid,
        size: result.size
      }))
    };

    const manifestResult = await this.storage.uploadJson(manifest, {
      type: 'versioned'
    });

    return { manifest_cid: manifestResult.cid, assets: results };
  }

  async downloadGameAssets(manifestCid: string) {
    const manifest = await this.storage.downloadJson(manifestCid);
    
    // Download all assets in parallel
    const assetPromises = manifest.assets.map(async (asset: any) => {
      const blob = await this.storage.download(asset.cid);
      return {
        type: asset.type,
        blob,
        cid: asset.cid
      };
    });

    return await Promise.all(assetPromises);
  }
}
```

## 🔍 Troubleshooting

### **Common Issues**

#### **Upload Failures**
```typescript
// Retry upload with exponential backoff
const uploadWithRetry = async (file: File, options: any, maxRetries = 3) => {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await storage.upload(file, options);
    } catch (error) {
      if (attempt === maxRetries) throw error;
      
      const delay = Math.pow(2, attempt) * 1000;
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }
};
```

#### **Large File Uploads**
```typescript
// Use chunked uploads for large files
const uploadLargeFile = async (file: File) => {
  if (file.size > 100 * 1024 * 1024) { // 100MB
    return await storage.uploadChunked(file, {
      chunkSize: 10 * 1024 * 1024, // 10MB chunks
      onProgress: (progress) => {
        console.log(`Upload progress: ${progress}%`);
      }
    });
  } else {
    return await storage.upload(file);
  }
};
```

#### **Access Denied Errors**
```typescript
// Handle access control errors
const downloadWithFallback = async (cid: string) => {
  try {
    return await storage.download(cid);
  } catch (error) {
    if (error.code === 'ACCESS_DENIED') {
      // Request access from owner
      await storage.requestAccess(cid, {
        reason: 'Need access to view shared content'
      });
      throw new Error('Access requested, please wait for approval');
    }
    throw error;
  }
};
```

## 📞 Support & Resources

- **Documentation**: [docs.neostorage.r3e.network](https://docs.neostorage.r3e.network)
- **Storage Dashboard**: [dashboard.neostorage.r3e.network](https://dashboard.neostorage.r3e.network)
- **API Reference**: [api.neostorage.r3e.network](https://api.neostorage.r3e.network)
- **Gateway Status**: [status.neostorage.r3e.network](https://status.neostorage.r3e.network)
- **IPFS Explorer**: [explorer.neostorage.r3e.network](https://explorer.neostorage.r3e.network)
- **Discord Support**: [discord.gg/r3e-network](https://discord.gg/r3e-network)
- **Email**: [storage@r3e.network](mailto:storage@r3e.network)

---

**NeoStorage provides enterprise-grade decentralized storage that eliminates single points of failure while delivering the performance and security that modern dApps require.** 