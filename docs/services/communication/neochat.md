# NeoChat - Messaging Infrastructure Service

## 🎯 Overview

**NeoChat** provides comprehensive messaging infrastructure for Neo dApps, offering real-time P2P messaging, group chats, file sharing, and blockchain-native communication with TEE-protected message encryption and decentralized identity integration.

## 🚀 Purpose

Modern dApps require sophisticated communication capabilities for user interaction, community building, and collaboration. NeoChat eliminates the complexity of building messaging infrastructure by providing secure, scalable, and blockchain-native communication that integrates seamlessly with wallet identities and smart contracts.

## ✨ Key Features

### **💬 Real-Time Messaging**
- Instant P2P messaging with sub-second delivery
- Group chats and channels with unlimited participants
- Message threading and conversation organization
- Rich media support (images, files, links, embeds)

### **🔐 Blockchain-Native Security**
- End-to-end encryption using wallet-based keys
- Message signing and verification
- Decentralized identity integration
- Zero-knowledge proof support for anonymous messaging

### **🌐 Advanced Communication Features**
- Voice and video calling capabilities
- Screen sharing and collaborative features
- Message reactions and emoji support
- Typing indicators and read receipts

### **📱 Cross-Platform Integration**
- Web SDK with React/Vue components
- Mobile SDK for iOS and Android
- Desktop application support
- Progressive Web App (PWA) capabilities

## 📊 Technical Specifications

### **Message Types**
```typescript
enum MessageType {
  TEXT = 'text',                   // Plain text messages
  RICH_TEXT = 'rich_text',        // Formatted text with markdown
  IMAGE = 'image',                // Image attachments
  FILE = 'file',                  // File attachments
  VOICE = 'voice',                // Voice recordings
  VIDEO = 'video',                // Video messages
  LINK = 'link',                  // Shared links with previews
  TRANSACTION = 'transaction',     // Blockchain transaction references
  CONTRACT_CALL = 'contract_call', // Smart contract interaction
  SYSTEM = 'system'               // System notifications
}
```

### **API Endpoints**

#### **Send Message**
```http
POST /api/v1/chat/messages
Content-Type: application/json
Authorization: Bearer <api_key>

{
  "conversation_id": "conv_abc123",
  "type": "text",
  "content": "Hello! Check out this new NFT collection",
  "attachments": [
    {
      "type": "link",
      "url": "https://marketplace.com/collection/123",
      "metadata": {
        "title": "Epic NFT Collection",
        "description": "Rare digital artworks"
      }
    }
  ],
  "reply_to": "msg_def456",
  "metadata": {
    "blockchain_ref": "0xabc123...",
    "expires_at": "2024-01-15T18:00:00Z"
  }
}

Response:
{
  "message_id": "msg_ghi789",
  "conversation_id": "conv_abc123",
  "sender": "NXXzKhzgs8EQtpNrNdvLfPjBQU3Cq3Kt1i",
  "timestamp": "2024-01-15T10:30:00Z",
  "status": "sent",
  "encryption_key_id": "key_123abc"
}
```

#### **Create Conversation**
```http
POST /api/v1/chat/conversations
Content-Type: application/json
Authorization: Bearer <api_key>

{
  "type": "group",
  "name": "DeFi Trading Discussion",
  "description": "Community chat for DeFi trading strategies",
  "participants": [
    "NXXzKhzgs8EQtpNrNdvLfPjBQU3Cq3Kt1i",
    "NYYaKhzgs8EQtpNrNdvLfPjBQU3Cq3Kt2j",
    "NZZaKhzgs8EQtpNrNdvLfPjBQU3Cq3Kt3k"
  ],
  "settings": {
    "encryption_enabled": true,
    "message_ttl": "7d",
    "admin_only_invite": false,
    "public_readable": false
  }
}

Response:
{
  "conversation_id": "conv_def456",
  "type": "group",
  "name": "DeFi Trading Discussion",
  "created_at": "2024-01-15T10:30:00Z",
  "participant_count": 3,
  "invite_code": "invite_abc123",
  "settings": {...}
}
```

#### **Real-Time Connection**
```typescript
// WebSocket connection for real-time messaging
const ws = new WebSocket('wss://chat.r3e.network/ws');

// Authentication
ws.send(JSON.stringify({
  type: 'auth',
  token: 'your-api-key',
  user_address: 'NXXzKhzgs8EQtpNrNdvLfPjBQU3Cq3Kt1i'
}));

// Subscribe to conversations
ws.send(JSON.stringify({
  type: 'subscribe',
  conversation_ids: ['conv_abc123', 'conv_def456']
}));

// Receive real-time messages
ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  handleIncomingMessage(data);
};
```

### **SDK Integration**

#### **JavaScript/TypeScript**
```typescript
import { NeoChat } from '@r3e/neo-chat';

// Initialize chat client
const chat = new NeoChat({
  apiKey: 'your-api-key',
  userAddress: userWalletAddress,
  autoConnect: true
});

// Send a message
const message = await chat.sendMessage({
  conversationId: 'conv_abc123',
  type: 'text',
  content: 'Hey everyone! Just made a successful DeFi trade 🎉'
});

// Send message with transaction reference
const txMessage = await chat.sendMessage({
  conversationId: 'conv_abc123',
  type: 'transaction',
  content: 'Check out my latest swap!',
  transactionHash: '0xabc123...',
  metadata: {
    tokenIn: 'GAS',
    tokenOut: 'NEO',
    amount: '100'
  }
});

// Create group conversation
const groupChat = await chat.createConversation({
  type: 'group',
  name: 'NFT Collectors',
  participants: [address1, address2, address3],
  settings: {
    encryptionEnabled: true,
    messageTTL: '30d'
  }
});

// Listen for incoming messages
chat.onMessage((message) => {
  console.log('New message:', message);
  
  if (message.type === 'transaction') {
    displayTransactionMessage(message);
  } else {
    displayTextMessage(message);
  }
});

// Handle typing indicators
chat.onTyping((typingInfo) => {
  updateTypingIndicator(typingInfo.conversationId, typingInfo.users);
});

// File sharing
const fileMessage = await chat.sendFile({
  conversationId: 'conv_abc123',
  file: selectedFile,
  caption: 'Here\'s the trading chart analysis',
  onProgress: (progress) => {
    updateUploadProgress(progress);
  }
});
```

#### **React Integration**
```typescript
import { useNeoChat } from '@r3e/neo-chat-react';

function ChatInterface() {
  const {
    conversations,
    messages,
    sendMessage,
    createConversation,
    joinConversation,
    isConnected,
    typingUsers
  } = useNeoChat();

  const [activeConversation, setActiveConversation] = useState(null);
  const [messageText, setMessageText] = useState('');

  const handleSendMessage = async () => {
    if (!messageText.trim() || !activeConversation) return;

    await sendMessage({
      conversationId: activeConversation.id,
      type: 'text',
      content: messageText
    });

    setMessageText('');
  };

  const handleFileShare = async (file: File) => {
    await sendMessage({
      conversationId: activeConversation.id,
      type: 'file',
      file: file,
      onProgress: (progress) => {
        console.log(`Upload progress: ${progress}%`);
      }
    });
  };

  return (
    <div className="chat-interface">
      <div className="sidebar">
        <div className="connection-status">
          {isConnected ? (
            <span className="connected">🟢 Connected</span>
          ) : (
            <span className="disconnected">🔴 Connecting...</span>
          )}
        </div>

        <ConversationList
          conversations={conversations}
          activeConversation={activeConversation}
          onSelect={setActiveConversation}
        />

        <button onClick={() => createConversation({
          type: 'group',
          name: 'New Group Chat'
        })}>
          Create Group
        </button>
      </div>

      <div className="main-chat">
        {activeConversation ? (
          <>
            <ChatHeader conversation={activeConversation} />
            
            <MessageList
              messages={messages[activeConversation.id] || []}
              typingUsers={typingUsers[activeConversation.id] || []}
            />

            <MessageInput
              value={messageText}
              onChange={setMessageText}
              onSend={handleSendMessage}
              onFileShare={handleFileShare}
              placeholder="Type your message..."
            />
          </>
        ) : (
          <div className="no-conversation">
            Select a conversation to start chatting
          </div>
        )}
      </div>
    </div>
  );
}

function MessageCard({ message }: { message: any }) {
  const isOwn = message.sender === userAddress;

  return (
    <div className={`message ${isOwn ? 'own' : 'other'}`}>
      <div className="message-header">
        <span className="sender">{formatAddress(message.sender)}</span>
        <span className="timestamp">{formatTime(message.timestamp)}</span>
      </div>

      <div className="message-content">
        {message.type === 'transaction' ? (
          <TransactionMessage
            content={message.content}
            transactionHash={message.transactionHash}
            metadata={message.metadata}
          />
        ) : message.type === 'file' ? (
          <FileMessage
            fileName={message.fileName}
            fileSize={message.fileSize}
            downloadUrl={message.downloadUrl}
          />
        ) : (
          <TextMessage content={message.content} />
        )}
      </div>

      {message.reactions && (
        <MessageReactions
          reactions={message.reactions}
          onReact={(emoji) => reactToMessage(message.id, emoji)}
        />
      )}
    </div>
  );
}
```

#### **Vue.js Integration**
```typescript
import { useNeoChat } from '@r3e/neo-chat-vue';

export default {
  setup() {
    const {
      sendMessage,
      createConversation,
      joinVoiceCall,
      shareScreen,
      getConversationHistory
    } = useNeoChat();

    const setupCommunityChat = async (communityData: any) => {
      // Create main community channel
      const mainChannel = await createConversation({
        type: 'channel',
        name: `${communityData.name} - General`,
        description: 'Main community discussion',
        settings: {
          publicReadable: true,
          adminOnlyPost: false,
          messageModeration: true
        }
      });

      // Create specialized channels
      const tradingChannel = await createConversation({
        type: 'channel',
        name: `${communityData.name} - Trading`,
        description: 'DeFi trading discussions and signals',
        settings: {
          tradingSignals: true,
          priceAlerts: true
        }
      });

      return { mainChannel, tradingChannel };
    };

    const handleVoiceCall = async (conversationId: string, participants: string[]) => {
      const voiceCall = await joinVoiceCall({
        conversationId,
        participants,
        settings: {
          audioOnly: true,
          recordingEnabled: false,
          backgroundNoise: 'suppress'
        }
      });

      return voiceCall;
    };

    const broadcastAnnouncement = async (announcement: string, channels: string[]) => {
      const promises = channels.map(channelId =>
        sendMessage({
          conversationId: channelId,
          type: 'system',
          content: announcement,
          priority: 'high',
          pinned: true
        })
      );

      return await Promise.all(promises);
    };

    return {
      setupCommunityChat,
      handleVoiceCall,
      broadcastAnnouncement,
      shareScreen
    };
  }
};
```

#### **Rust Backend Integration**
```rust
use neo_chat::{ChatClient, Message, Conversation, MessageType};

let chat_client = ChatClient::new("your-api-key");

// Send automated message
let message = Message::builder()
    .conversation_id("conv_abc123")
    .message_type(MessageType::Text)
    .content("🤖 Automated DeFi alert: High volume detected!")
    .metadata(json!({
        "alert_type": "volume_spike",
        "threshold": 1000000,
        "token_pair": "GAS/NEO"
    }))
    .build();

let sent_message = chat_client.send_message(message).await?;

// Create conversation programmatically
let conversation = Conversation::builder()
    .conversation_type("group")
    .name("DeFi Strategy Group")
    .participants(vec![
        "NXXzKhzgs8EQtpNrNdvLfPjBQU3Cq3Kt1i".to_string(),
        "NYYaKhzgs8EQtpNrNdvLfPjBQU3Cq3Kt2j".to_string()
    ])
    .settings(json!({
        "encryption_enabled": true,
        "bot_access": true,
        "trading_signals": true
    }))
    .build();

let created_conversation = chat_client.create_conversation(conversation).await?;

// Listen for incoming messages
let mut message_stream = chat_client.subscribe_messages(&["conv_abc123"]).await?;

while let Some(message) = message_stream.next().await {
    match message.message_type {
        MessageType::Transaction => {
            handle_transaction_message(&message).await?;
        },
        MessageType::Text => {
            process_text_message(&message).await?;
        },
        _ => {}
    }
}
```

## 🔧 Configuration Options

### **Chat Configuration**
```typescript
const chatConfig = {
  messaging: {
    max_message_length: 4000,
    message_retention: '90d',
    file_upload_limit: '100MB',
    supported_file_types: ['image/*', 'video/*', 'audio/*', 'application/pdf'],
    emoji_support: true,
    markdown_support: true
  },
  encryption: {
    default_encryption: true,
    key_rotation_interval: '30d',
    perfect_forward_secrecy: true,
    quantum_resistant: true
  },
  real_time: {
    websocket_timeout: '30s',
    heartbeat_interval: '25s',
    reconnect_attempts: 5,
    typing_timeout: '3s'
  }
};
```

### **Conversation Settings**
```typescript
const conversationSettings = {
  group_chat: {
    max_participants: 1000,
    admin_permissions: ['invite', 'kick', 'mute', 'pin_messages'],
    message_moderation: true,
    spam_detection: true
  },
  channels: {
    public_channels: true,
    channel_discovery: true,
    subscriber_limits: 10000,
    broadcast_mode: true
  },
  voice_video: {
    max_call_duration: '4h',
    max_participants: 50,
    recording_enabled: false,
    screen_sharing: true
  }
};
```

## 🛡️ Security Features

### **TEE-Protected Messaging**
- Message encryption and decryption within Intel SGX enclaves
- Protected key storage and management
- Secure message routing and delivery
- Tamper-proof conversation history

### **Blockchain-Native Security**
```typescript
const securityFeatures = {
  wallet_integration: {
    message_signing: true,
    identity_verification: true,
    address_based_auth: true,
    multi_wallet_support: true
  },
  encryption: {
    end_to_end_encryption: true,
    perfect_forward_secrecy: true,
    quantum_resistant_crypto: true,
    zero_knowledge_proofs: true
  },
  privacy: {
    anonymous_messaging: true,
    metadata_protection: true,
    ip_address_masking: true,
    message_disappearing: true
  }
};
```

### **Content Security**
```typescript
const contentSecurity = {
  moderation: {
    spam_detection: true,
    phishing_protection: true,
    malware_scanning: true,
    content_filtering: true
  },
  compliance: {
    message_archival: true,
    audit_logging: true,
    gdpr_compliance: true,
    data_retention_policies: true
  }
};
```

## 💰 Pricing Model

### **Community** - Free
- Up to 1,000 messages per month
- Basic P2P messaging
- 5 group conversations
- File sharing up to 10MB
- Community support

### **Professional** - $29/month
- Up to 100,000 messages per month
- Voice and video calling
- 50 group conversations
- File sharing up to 1GB
- Advanced encryption features
- Email support

### **Business** - $99/month
- Up to 1,000,000 messages per month
- Unlimited conversations
- Screen sharing and collaboration
- Custom branding
- Moderation tools
- Priority support

### **Enterprise** - $299/month
- Unlimited messaging
- White-label solution
- Advanced security features
- Custom integrations
- Dedicated infrastructure
- 24/7 support

## 🚀 Quick Start Guide

### **1. Install SDK**
```bash
npm install @r3e/neo-chat
```

### **2. Initialize Client**
```typescript
import { NeoChat } from '@r3e/neo-chat';

const chat = new NeoChat({
  apiKey: process.env.NEO_CHAT_API_KEY,
  userAddress: userWalletAddress
});
```

### **3. Create Your First Conversation**
```typescript
const conversation = await chat.createConversation({
  type: 'group',
  name: 'My First Chat',
  participants: [friendAddress1, friendAddress2]
});

console.log('Conversation created:', conversation.id);
```

### **4. Send Your First Message**
```typescript
await chat.sendMessage({
  conversationId: conversation.id,
  type: 'text',
  content: 'Hello, Neo community! 👋'
});
```

## 🔗 Integration Examples

### **DeFi Trading Community**
```typescript
class DeFiTradingChat {
  private chat: NeoChat;

  constructor() {
    this.chat = new NeoChat({
      apiKey: process.env.CHAT_API_KEY
    });
  }

  async setupTradingCommunity() {
    // Create main trading discussion
    const mainChat = await this.chat.createConversation({
      type: 'channel',
      name: 'DeFi Trading Hub',
      description: 'General trading discussion and market updates',
      settings: {
        publicReadable: true,
        tradingSignals: true,
        priceAlerts: true
      }
    });

    // Create VIP trader group
    const vipChat = await this.chat.createConversation({
      type: 'group',
      name: 'VIP Traders',
      description: 'Exclusive chat for high-volume traders',
      settings: {
        encryptionEnabled: true,
        adminOnlyInvite: true,
        premiumFeatures: true
      }
    });

    // Set up automated trading signals
    await this.setupTradingSignals(mainChat.id);

    return { mainChat, vipChat };
  }

  async broadcastTradingSignal(signal: TradingSignal) {
    const message = await this.chat.sendMessage({
      conversationId: this.tradingChannelId,
      type: 'transaction',
      content: `🚨 Trading Signal: ${signal.action} ${signal.token}`,
      metadata: {
        signal_type: signal.type,
        token: signal.token,
        entry_price: signal.entryPrice,
        target_price: signal.targetPrice,
        stop_loss: signal.stopLoss,
        confidence: signal.confidence
      },
      priority: 'high',
      pinned: true
    });

    // Send to VIP group with additional details
    if (signal.vipOnly) {
      await this.chat.sendMessage({
        conversationId: this.vipGroupId,
        type: 'text',
        content: `💎 VIP Signal Details:\n${signal.analysis}`,
        replyTo: message.id
      });
    }

    return message;
  }

  async handleTradingDiscussion(userId: string, message: string) {
    // Analyze message for trading intent
    const analysis = await this.analyzeTradingMessage(message);
    
    if (analysis.containsSignal) {
      await this.chat.sendMessage({
        conversationId: this.tradingChannelId,
        type: 'text',
        content: `📈 Signal detected from ${formatAddress(userId)}: ${analysis.summary}`,
        metadata: {
          original_message_id: message.id,
          signal_confidence: analysis.confidence
        }
      });
    }

    // Auto-react to high-quality analysis
    if (analysis.qualityScore > 0.8) {
      await this.chat.reactToMessage(message.id, '🔥');
    }
  }
}
```

### **NFT Community Platform**
```typescript
class NFTCommunityChat {
  private chat: NeoChat;

  async setupNFTCommunity(collectionAddress: string) {
    // Create collection-specific chat
    const collectionChat = await this.chat.createConversation({
      type: 'channel',
      name: 'NFT Collection Holders',
      description: 'Exclusive chat for NFT holders',
      settings: {
        nftGated: true,
        requiredNFT: collectionAddress,
        verificationRequired: true
      }
    });

    // Create marketplace discussion
    const marketplaceChat = await this.chat.createConversation({
      type: 'channel',
      name: 'NFT Marketplace',
      description: 'Buy, sell, and trade discussions',
      settings: {
        marketplaceIntegration: true,
        priceAlerts: true,
        salesNotifications: true
      }
    });

    return { collectionChat, marketplaceChat };
  }

  async shareNFTListing(listingData: NFTListing) {
    const message = await this.chat.sendMessage({
      conversationId: this.marketplaceChatId,
      type: 'link',
      content: `🎨 New NFT Listed: ${listingData.name}`,
      attachments: [{
        type: 'nft_listing',
        url: listingData.marketplaceUrl,
        metadata: {
          tokenId: listingData.tokenId,
          price: listingData.price,
          currency: listingData.currency,
          rarity: listingData.rarity,
          image: listingData.imageUrl
        }
      }]
    });

    return message;
  }

  async handleNFTSale(saleEvent: NFTSaleEvent) {
    // Notify collection holders
    await this.chat.sendMessage({
      conversationId: this.collectionChatId,
      type: 'system',
      content: `🎉 Sale: ${saleEvent.nftName} sold for ${saleEvent.price} ${saleEvent.currency}`,
      metadata: {
        transaction_hash: saleEvent.txHash,
        buyer: saleEvent.buyer,
        seller: saleEvent.seller,
        marketplace: saleEvent.marketplace
      }
    });

    // Update floor price discussions
    const floorPriceUpdate = await this.calculateFloorPrice(saleEvent.collectionAddress);
    if (floorPriceUpdate.changed) {
      await this.chat.sendMessage({
        conversationId: this.marketplaceChatId,
        type: 'text',
        content: `📊 Floor price updated: ${floorPriceUpdate.newFloor} ${saleEvent.currency}`,
        pinned: true
      });
    }
  }
}
```

### **Gaming Guild Communication**
```typescript
class GamingGuildChat {
  private chat: NeoChat;

  async setupGuildCommunication(guildData: GuildData) {
    // Main guild chat
    const guildChat = await this.chat.createConversation({
      type: 'group',
      name: `${guildData.name} Guild`,
      description: 'Main guild communication',
      participants: guildData.members,
      settings: {
        gameIntegration: true,
        achievementSharing: true,
        raidPlanning: true
      }
    });

    // Officer chat
    const officerChat = await this.chat.createConversation({
      type: 'group',
      name: `${guildData.name} Officers`,
      description: 'Guild leadership discussions',
      participants: guildData.officers,
      settings: {
        encryptionEnabled: true,
        adminOnlyInvite: true
      }
    });

    // Raid coordination
    const raidChat = await this.chat.createConversation({
      type: 'voice_channel',
      name: 'Raid Coordination',
      description: 'Voice chat for raid coordination',
      settings: {
        voiceActivated: true,
        raidTools: true,
        recordingEnabled: false
      }
    });

    return { guildChat, officerChat, raidChat };
  }

  async broadcastRaidInvite(raidData: RaidData) {
    const raidMessage = await this.chat.sendMessage({
      conversationId: this.guildChatId,
      type: 'system',
      content: `⚔️ Raid Starting: ${raidData.name}`,
      metadata: {
        raid_id: raidData.id,
        start_time: raidData.startTime,
        required_level: raidData.requiredLevel,
        max_participants: raidData.maxParticipants,
        rewards: raidData.expectedRewards
      },
      actions: [
        { type: 'join_raid', label: 'Join Raid' },
        { type: 'view_details', label: 'View Details' }
      ]
    });

    // Start voice channel for coordination
    await this.chat.joinVoiceCall({
      conversationId: this.raidChatId,
      autoJoin: raidData.participants,
      settings: {
        audioOnly: false,
        screenSharing: true,
        raidInterface: true
      }
    });

    return raidMessage;
  }

  async shareAchievement(playerId: string, achievement: Achievement) {
    await this.chat.sendMessage({
      conversationId: this.guildChatId,
      type: 'text',
      content: `🏆 ${formatPlayerName(playerId)} unlocked: ${achievement.name}!`,
      metadata: {
        achievement_id: achievement.id,
        rarity: achievement.rarity,
        points_awarded: achievement.points,
        nft_reward: achievement.nftReward
      },
      reactions: ['🎉', '🔥', '💪']
    });
  }
}
```

## 🔍 Troubleshooting

### **Common Issues**

#### **Connection Problems**
```typescript
// Handle connection issues with retry logic
const handleConnectionIssues = () => {
  chat.onConnectionStateChange((state) => {
    switch (state) {
      case 'disconnected':
        console.log('Chat disconnected, attempting reconnect...');
        chat.reconnect();
        break;
      case 'reconnecting':
        showReconnectingIndicator();
        break;
      case 'connected':
        hideReconnectingIndicator();
        console.log('Chat reconnected successfully');
        break;
    }
  });

  // Implement exponential backoff for reconnection
  chat.configureReconnection({
    maxAttempts: 10,
    baseDelay: 1000,
    maxDelay: 30000,
    exponentialBackoff: true
  });
};
```

#### **Message Delivery Issues**
```typescript
// Ensure reliable message delivery
const ensureMessageDelivery = async (message: any) => {
  try {
    const result = await chat.sendMessage(message);
    
    // Check delivery status
    const status = await chat.getMessageStatus(result.messageId);
    if (status !== 'delivered') {
      throw new Error('Message delivery failed');
    }
    
    return result;
  } catch (error) {
    // Retry with exponential backoff
    return await retryWithBackoff(() => chat.sendMessage(message), {
      maxAttempts: 3,
      baseDelay: 1000
    });
  }
};
```

#### **File Upload Optimization**
```typescript
// Optimize file uploads for large files
const optimizeFileUpload = async (file: File, conversationId: string) => {
  // Compress images before upload
  if (file.type.startsWith('image/')) {
    const compressedFile = await compressImage(file, {
      maxWidth: 1920,
      maxHeight: 1080,
      quality: 0.8
    });
    file = compressedFile;
  }

  // Use chunked upload for large files
  if (file.size > 10 * 1024 * 1024) { // 10MB
    return await chat.sendFileChunked({
      conversationId,
      file,
      chunkSize: 1024 * 1024, // 1MB chunks
      onProgress: (progress) => {
        updateUploadProgress(progress);
      }
    });
  }

  return await chat.sendFile({ conversationId, file });
};
```

## 📞 Support & Resources

- **Documentation**: [docs.neochat.r3e.network](https://docs.neochat.r3e.network)
- **Chat Dashboard**: [dashboard.neochat.r3e.network](https://dashboard.neochat.r3e.network)
- **API Reference**: [api.neochat.r3e.network](https://api.neochat.r3e.network)
- **WebRTC Status**: [webrtc.neochat.r3e.network](https://webrtc.neochat.r3e.network)
- **Widget Builder**: [widgets.neochat.r3e.network](https://widgets.neochat.r3e.network)
- **Discord Support**: [discord.gg/r3e-network](https://discord.gg/r3e-network)
- **Email**: [chat@r3e.network](mailto:chat@r3e.network)

---

**NeoChat provides comprehensive messaging infrastructure that enables Neo dApps to build vibrant communities with secure, real-time communication powered by blockchain-native identity and encryption.** 