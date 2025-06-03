# NeoMedia - Media Processing Service

## 🎯 Overview

**NeoMedia** provides comprehensive media processing infrastructure for Neo dApps, offering real-time image and video transformation, intelligent compression, format conversion, and global CDN delivery with TEE-protected processing pipelines and automated optimization.

## 🚀 Purpose

Modern dApps require sophisticated media handling capabilities for user-generated content, NFT assets, and multimedia experiences. NeoMedia eliminates the complexity of media processing by providing automated optimization, format conversion, and global delivery that scales from small applications to enterprise platforms.

## ✨ Key Features

### **🖼️ Advanced Image Processing**
- Real-time image resizing and cropping
- Format conversion (JPEG, PNG, WebP, AVIF)
- Intelligent compression and quality optimization
- Background removal and AI-powered enhancement

### **🎬 Video Processing & Streaming**
- Video transcoding and format conversion
- Adaptive bitrate streaming (HLS, DASH)
- Thumbnail and preview generation
- Real-time video optimization

### **🤖 AI-Powered Enhancement**
- Automatic image enhancement and upscaling
- Object detection and content recognition
- Smart cropping with facial recognition
- Automated alt-text generation for accessibility

### **🌍 Global CDN Distribution**
- Edge caching for ultra-fast delivery
- Geographic optimization and routing
- Bandwidth adaptive delivery
- Real-time performance analytics

## 📊 Technical Specifications

### **Processing Types**
```typescript
enum ProcessingType {
  IMAGE_RESIZE = 'image_resize',
  IMAGE_CROP = 'image_crop',
  IMAGE_COMPRESS = 'image_compress',
  FORMAT_CONVERT = 'format_convert',
  VIDEO_TRANSCODE = 'video_transcode',
  THUMBNAIL_GENERATE = 'thumbnail_generate',
  AI_ENHANCE = 'ai_enhance',
  BACKGROUND_REMOVE = 'background_remove'
}
```

### **API Endpoints**

#### **Process Image**
```http
POST /api/v1/media/process/image
Content-Type: multipart/form-data
Authorization: Bearer <api_key>

FormData:
- image: <binary_image_data>
- operations: {
    "resize": {"width": 800, "height": 600, "mode": "fit"},
    "format": "webp",
    "quality": 85,
    "compress": true
  }

Response:
{
  "job_id": "job_abc123",
  "status": "processing",
  "input_url": "https://cdn.neomedia.r3e.network/input/abc123.jpg",
  "estimated_completion": "2024-01-15T10:31:30Z",
  "webhook_url": "https://yourapp.com/webhook/media"
}
```

#### **Get Processed Media**
```http
GET /api/v1/media/jobs/{job_id}
Authorization: Bearer <api_key>

Response:
{
  "job_id": "job_abc123",
  "status": "completed",
  "input_size": 2048576,
  "output_size": 512000,
  "compression_ratio": "75%",
  "processing_time": "2.3s",
  "outputs": [
    {
      "url": "https://cdn.neomedia.r3e.network/output/abc123_800x600.webp",
      "format": "webp",
      "dimensions": {"width": 800, "height": 600},
      "size": 512000
    }
  ],
  "completed_at": "2024-01-15T10:31:15Z"
}
```

#### **Batch Process**
```http
POST /api/v1/media/batch
Content-Type: application/json
Authorization: Bearer <api_key>

{
  "operations": [
    {
      "input_url": "https://storage.mydapp.com/image1.jpg",
      "operations": {"resize": {"width": 400}, "format": "webp"}
    },
    {
      "input_url": "https://storage.mydapp.com/video1.mp4",
      "operations": {"transcode": {"format": "mp4", "quality": "720p"}}
    }
  ],
  "webhook_url": "https://yourapp.com/batch-complete"
}
```

### **SDK Integration**

#### **JavaScript/TypeScript**
```typescript
import { NeoMedia } from '@r3e/neo-media';

// Initialize media processor
const mediaProcessor = new NeoMedia({
  apiKey: 'your-api-key',
  cdnDomain: 'https://cdn.neomedia.r3e.network'
});

// Process single image
const processedImage = await mediaProcessor.processImage(imageFile, {
  resize: { width: 800, height: 600, mode: 'fit' },
  format: 'webp',
  quality: 85,
  compress: true,
  onProgress: (progress) => {
    console.log(`Processing: ${progress}%`);
  }
});

console.log('Processed image URL:', processedImage.url);

// Generate responsive image set
const responsiveImages = await mediaProcessor.generateResponsiveSet(imageFile, {
  breakpoints: [400, 800, 1200, 1600],
  formats: ['webp', 'jpeg'],
  quality: 85
});

// Process video
const processedVideo = await mediaProcessor.processVideo(videoFile, {
  transcode: {
    formats: ['mp4', 'webm'],
    qualities: ['480p', '720p', '1080p']
  },
  thumbnail: {
    count: 10,
    format: 'jpeg'
  },
  generatePreview: true
});

// AI-powered enhancements
const enhancedImage = await mediaProcessor.enhanceImage(imageFile, {
  upscale: true,
  denoise: true,
  autoEnhance: true,
  removeBackground: false
});
```

#### **React Integration**
```typescript
import { useNeoMedia } from '@r3e/neo-media-react';

function MediaUploadComponent() {
  const {
    processImage,
    processVideo,
    isProcessing,
    progress,
    generateThumbnail
  } = useNeoMedia();

  const handleImageUpload = async (file: File) => {
    try {
      const result = await processImage(file, {
        resize: { width: 800 },
        format: 'webp',
        quality: 85,
        onProgress: (progress) => {
          console.log(`Processing: ${progress}%`);
        }
      });

      return result;
    } catch (error) {
      console.error('Processing failed:', error);
    }
  };

  const handleVideoUpload = async (file: File) => {
    try {
      const result = await processVideo(file, {
        transcode: {
          format: 'mp4',
          quality: '720p'
        },
        thumbnail: {
          timestamp: '00:00:05',
          format: 'jpeg'
        }
      });

      return result;
    } catch (error) {
      console.error('Video processing failed:', error);
    }
  };

  return (
    <div className="media-upload">
      <div className="upload-zone">
        <input
          type="file"
          accept="image/*,video/*"
          onChange={async (e) => {
            const file = e.target.files?.[0];
            if (!file) return;

            if (file.type.startsWith('image/')) {
              await handleImageUpload(file);
            } else if (file.type.startsWith('video/')) {
              await handleVideoUpload(file);
            }
          }}
          disabled={isProcessing}
        />
      </div>

      {isProcessing && (
        <div className="processing-progress">
          <div className="progress-bar">
            <div style={{ width: `${progress}%` }} />
          </div>
          <span>{progress}% processed</span>
        </div>
      )}
    </div>
  );
}

function ResponsiveImage({ src, alt }: { src: string, alt: string }) {
  return (
    <picture>
      <source
        srcSet={`${src}?w=400&f=webp 400w, ${src}?w=800&f=webp 800w, ${src}?w=1200&f=webp 1200w`}
        type="image/webp"
      />
      <source
        srcSet={`${src}?w=400&f=jpeg 400w, ${src}?w=800&f=jpeg 800w, ${src}?w=1200&f=jpeg 1200w`}
        type="image/jpeg"
      />
      <img
        src={`${src}?w=800&f=jpeg`}
        alt={alt}
        loading="lazy"
        style={{ width: '100%', height: 'auto' }}
      />
    </picture>
  );
}
```

#### **Vue.js Integration**
```typescript
import { useNeoMedia } from '@r3e/neo-media-vue';

export default {
  setup() {
    const {
      processImage,
      generateThumbnails,
      batchProcess,
      getOptimizedUrl
    } = useNeoMedia();

    const createImageGallery = async (imageFiles: File[]) => {
      // Process all images in batch
      const batchResult = await batchProcess(
        imageFiles.map(file => ({
          file,
          operations: {
            resize: { width: 800, height: 600, mode: 'fit' },
            format: 'webp',
            quality: 85
          }
        }))
      );

      // Generate thumbnails
      const thumbnails = await generateThumbnails(imageFiles, {
        size: { width: 200, height: 200 },
        format: 'webp',
        quality: 80
      });

      return {
        fullSize: batchResult,
        thumbnails
      };
    };

    const getResponsiveImageUrl = (baseUrl: string, width: number) => {
      return getOptimizedUrl(baseUrl, {
        width,
        format: 'webp',
        quality: 85
      });
    };

    return {
      createImageGallery,
      getResponsiveImageUrl,
      processImage
    };
  }
};
```

#### **Rust Backend Integration**
```rust
use neo_media::{MediaClient, ProcessingOptions, ImageOperations};

let media_client = MediaClient::new("your-api-key");

// Process image
let processing_options = ProcessingOptions {
    operations: vec![
        ImageOperations::Resize { width: 800, height: 600, mode: "fit" },
        ImageOperations::Format { format: "webp" },
        ImageOperations::Compress { quality: 85 }
    ],
    webhook_url: Some("https://yourapp.com/webhook".to_string()),
};

let job = media_client.process_image(&image_data, processing_options).await?;
println!("Processing job started: {}", job.job_id);

// Wait for completion
let result = media_client.wait_for_completion(&job.job_id).await?;
println!("Processed image URL: {}", result.outputs[0].url);
```

## 🔧 Configuration Options

### **Processing Configuration**
```typescript
const processingConfig = {
  image: {
    default_format: 'webp',
    fallback_format: 'jpeg',
    default_quality: 85,
    max_dimensions: { width: 4000, height: 4000 },
    auto_orient: true,
    strip_metadata: true
  },
  video: {
    default_codec: 'h264',
    default_quality: '720p',
    max_duration: 600, // 10 minutes
    generate_thumbnails: true,
    adaptive_streaming: true
  },
  ai_enhancement: {
    enabled: true,
    auto_enhance: false, // Require explicit request
    upscale_limit: '4x',
    background_removal: true
  }
};
```

### **CDN Configuration**
```typescript
const cdnConfig = {
  global_distribution: true,
  edge_locations: ['us-east', 'us-west', 'eu-west', 'ap-southeast'],
  cache_settings: {
    browser_cache: '1y',
    edge_cache: '30d',
    origin_cache: '7d'
  },
  bandwidth_optimization: {
    adaptive_quality: true,
    progressive_loading: true,
    lazy_loading_support: true
  }
};
```

## 🛡️ Security Features

### **TEE-Protected Processing**
- Media processing within Intel SGX enclaves
- Encrypted media data during processing
- Secure temporary storage with auto-deletion
- Tamper-proof processing pipelines

### **Content Security**
```typescript
const securityFeatures = {
  content_scanning: {
    enabled: true,
    detect_explicit: true,
    detect_violence: true,
    detect_illegal: true,
    quarantine_suspicious: true
  },
  watermarking: {
    invisible_watermarks: true,
    copyright_protection: true,
    source_tracking: true
  },
  access_control: {
    signed_urls: true,
    time_limited_access: true,
    ip_restrictions: true,
    referer_protection: true
  }
};
```

### **Data Privacy**
```typescript
const privacyControls = {
  metadata_handling: {
    strip_exif: true,
    strip_location: true,
    strip_camera_info: true,
    preserve_copyright: false
  },
  processing_logs: {
    retention_period: '30d',
    anonymize_urls: true,
    encrypt_logs: true
  }
};
```

## 💰 Pricing Model

### **Starter** - Free
- 1 GB processing per month
- Basic image operations
- Standard CDN delivery
- Community support

### **Professional** - $29/month
- 50 GB processing per month
- Advanced image & video processing
- AI-powered enhancements
- Priority CDN delivery
- Email support
- $0.50/GB overage

### **Business** - $99/month
- 200 GB processing per month
- Real-time processing APIs
- Custom watermarking
- Advanced analytics
- Priority support
- $0.40/GB overage

### **Enterprise** - $299/month
- 1 TB processing per month
- White-label processing
- Dedicated processing clusters
- SLA guarantees
- 24/7 support
- $0.30/GB overage

## 🚀 Quick Start Guide

### **1. Install SDK**
```bash
npm install @r3e/neo-media
```

### **2. Initialize Client**
```typescript
import { NeoMedia } from '@r3e/neo-media';

const media = new NeoMedia({
  apiKey: process.env.NEO_MEDIA_API_KEY
});
```

### **3. Process Your First Image**
```typescript
const result = await media.processImage(imageFile, {
  resize: { width: 800 },
  format: 'webp',
  quality: 85
});

console.log('Optimized image:', result.url);
```

### **4. Generate Responsive Images**
```typescript
const responsive = await media.generateResponsiveSet(imageFile, {
  breakpoints: [400, 800, 1200],
  formats: ['webp', 'jpeg']
});
```

## 🔗 Integration Examples

### **NFT Marketplace Integration**
```typescript
class NFTMediaProcessor {
  private media: NeoMedia;

  constructor() {
    this.media = new NeoMedia({
      apiKey: process.env.MEDIA_API_KEY
    });
  }

  async processNFTImage(imageFile: File, metadata: NFTMetadata) {
    // Generate multiple formats and sizes for NFT display
    const processedImages = await this.media.batchProcess([
      {
        input: imageFile,
        operations: {
          resize: { width: 1200, height: 1200, mode: 'fit' },
          format: 'webp',
          quality: 95
        },
        tags: ['nft', 'high_quality']
      },
      {
        input: imageFile,
        operations: {
          resize: { width: 400, height: 400, mode: 'fit' },
          format: 'webp',
          quality: 85
        },
        tags: ['nft', 'thumbnail']
      },
      {
        input: imageFile,
        operations: {
          resize: { width: 100, height: 100, mode: 'fit' },
          format: 'webp',
          quality: 80
        },
        tags: ['nft', 'icon']
      }
    ]);

    // Add invisible watermark for copyright protection
    const watermarked = await this.media.addWatermark(processedImages[0].url, {
      type: 'invisible',
      data: {
        creator: metadata.creator,
        collection: metadata.collection,
        token_id: metadata.tokenId
      }
    });

    return {
      highRes: watermarked.url,
      thumbnail: processedImages[1].url,
      icon: processedImages[2].url
    };
  }

  async processNFTVideo(videoFile: File) {
    return await this.media.processVideo(videoFile, {
      transcode: {
        formats: ['mp4', 'webm'],
        qualities: ['720p', '1080p']
      },
      thumbnail: {
        count: 5,
        format: 'webp'
      },
      preview: {
        duration: 10, // 10 second preview
        format: 'gif'
      }
    });
  }
}
```

### **Social Media Platform Integration**
```typescript
class SocialMediaProcessor {
  private media: NeoMedia;

  async uploadUserContent(userId: string, file: File, contentType: 'post' | 'avatar' | 'cover') {
    const specifications = {
      post: {
        maxWidth: 1080,
        aspectRatios: ['1:1', '4:5', '16:9'],
        formats: ['webp', 'jpeg']
      },
      avatar: {
        sizes: [50, 100, 200, 400],
        aspectRatio: '1:1',
        format: 'webp'
      },
      cover: {
        width: 1500,
        height: 500,
        format: 'webp'
      }
    };

    const spec = specifications[contentType];
    
    if (contentType === 'avatar') {
      // Generate multiple avatar sizes
      const avatars = await Promise.all(
        spec.sizes.map(size => 
          this.media.processImage(file, {
            resize: { width: size, height: size, mode: 'fill' },
            format: spec.format,
            quality: 90,
            smartCrop: true // AI-powered face detection
          })
        )
      );

      return avatars;
    }

    // AI-powered content enhancement
    const enhanced = await this.media.enhanceImage(file, {
      autoEnhance: true,
      smartCrop: contentType === 'post',
      generateAltText: true // For accessibility
    });

    return enhanced;
  }

  async moderateContent(imageUrl: string) {
    const moderation = await this.media.moderateContent(imageUrl, {
      detectExplicit: true,
      detectViolence: true,
      detectText: true, // OCR for text in images
      detectFaces: true
    });

    return {
      approved: moderation.risk_score < 0.3,
      riskScore: moderation.risk_score,
      flags: moderation.detected_content
    };
  }
}
```

### **Gaming dApp Integration**
```typescript
class GameMediaManager {
  private media: NeoMedia;

  async processGameAssets(gameAssets: GameAsset[]) {
    // Batch process game assets with optimizations
    const processedAssets = await this.media.batchProcess(
      gameAssets.map(asset => ({
        input: asset.file,
        operations: {
          resize: this.getAssetDimensions(asset.type),
          format: this.getOptimalFormat(asset.type),
          compress: true,
          optimize: 'gaming' // Gaming-specific optimizations
        },
        metadata: {
          game_id: asset.gameId,
          asset_type: asset.type,
          version: asset.version
        }
      }))
    );

    // Generate progressive loading versions
    const progressiveAssets = await Promise.all(
      processedAssets.map(asset => 
        this.media.generateProgressiveVersions(asset.url, {
          qualities: [25, 50, 75, 100],
          formats: ['webp', 'jpeg']
        })
      )
    );

    return progressiveAssets;
  }

  async createGameTrailer(gameplayVideos: File[]) {
    // Auto-generate game trailer from gameplay footage
    const trailer = await this.media.createVideoMontage(gameplayVideos, {
      duration: 30, // 30 second trailer
      transitions: 'dynamic',
      music: 'epic_gaming',
      highlights: 'auto_detect', // AI detects exciting moments
      format: 'mp4',
      quality: '1080p'
    });

    // Generate multiple versions for different platforms
    const versions = await this.media.batchTranscode(trailer.url, [
      { format: 'mp4', quality: '720p', platform: 'web' },
      { format: 'mp4', quality: '1080p', platform: 'youtube' },
      { format: 'webm', quality: '720p', platform: 'twitter' }
    ]);

    return versions;
  }
}
```

## 🔍 Troubleshooting

### **Common Issues**

#### **Processing Failures**
```typescript
// Handle processing failures with retry logic
const processWithRetry = async (file: File, operations: any, maxRetries = 3) => {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await media.processImage(file, operations);
    } catch (error) {
      if (error.code === 'UNSUPPORTED_FORMAT') {
        // Convert to supported format first
        const converted = await media.convertFormat(file, 'jpeg');
        return await media.processImage(converted, operations);
      } else if (error.code === 'FILE_TOO_LARGE') {
        // Reduce quality and retry
        operations.quality = Math.max(operations.quality - 20, 30);
        if (attempt === maxRetries) throw error;
      } else {
        throw error;
      }
    }
  }
};
```

#### **Performance Optimization**
```typescript
// Optimize processing for better performance
const optimizeProcessing = async (files: File[]) => {
  // Process in batches to avoid overwhelming the service
  const batchSize = 10;
  const results = [];

  for (let i = 0; i < files.length; i += batchSize) {
    const batch = files.slice(i, i + batchSize);
    const batchResults = await media.batchProcess(
      batch.map(file => ({
        input: file,
        operations: {
          resize: { width: 800 },
          format: 'webp',
          quality: 85
        },
        priority: 'bulk' // Lower priority for batch operations
      }))
    );
    
    results.push(...batchResults);
    
    // Small delay between batches to prevent rate limiting
    if (i + batchSize < files.length) {
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
  }

  return results;
};
```

#### **CDN Issues**
```typescript
// Handle CDN delivery issues
const getOptimizedImageUrl = (baseUrl: string, options: any) => {
  const params = new URLSearchParams({
    w: options.width?.toString() || '',
    h: options.height?.toString() || '',
    f: options.format || 'webp',
    q: options.quality?.toString() || '85'
  });

  // Add fallback CDN endpoints
  const cdnEndpoints = [
    'https://cdn1.neomedia.r3e.network',
    'https://cdn2.neomedia.r3e.network',
    'https://cdn3.neomedia.r3e.network'
  ];

  // Try different CDN endpoints for reliability
  const primaryUrl = `${cdnEndpoints[0]}${baseUrl}?${params}`;
  
  return {
    primary: primaryUrl,
    fallbacks: cdnEndpoints.slice(1).map(cdn => `${cdn}${baseUrl}?${params}`)
  };
};
```

## 📞 Support & Resources

- **Documentation**: [docs.neomedia.r3e.network](https://docs.neomedia.r3e.network)
- **Processing Dashboard**: [dashboard.neomedia.r3e.network](https://dashboard.neomedia.r3e.network)
- **API Reference**: [api.neomedia.r3e.network](https://api.neomedia.r3e.network)
- **CDN Status**: [status.neomedia.r3e.network](https://status.neomedia.r3e.network)
- **Media Gallery**: [gallery.neomedia.r3e.network](https://gallery.neomedia.r3e.network)
- **Discord Support**: [discord.gg/r3e-network](https://discord.gg/r3e-network)
- **Email**: [media@r3e.network](mailto:media@r3e.network)

---

**NeoMedia transforms media handling for Neo dApps with intelligent processing, global delivery, and AI-powered enhancements that provide optimal user experiences across all devices and platforms.** 