# NeoQueue - Job Processing Service

## 🎯 Overview

**NeoQueue** provides enterprise-grade job processing and task scheduling for Neo dApps, offering reliable background job execution, priority queues, automated retries, and distributed processing with TEE-protected job data and real-time monitoring capabilities.

## 🚀 Purpose

Modern dApps require sophisticated background processing for computationally intensive tasks, scheduled operations, and asynchronous workflows. NeoQueue provides reliable, scalable job processing that handles everything from simple tasks to complex multi-stage workflows while ensuring data security and operational reliability.

## ✨ Key Features

### **🔄 Flexible Job Processing**
- Background job execution with multiple worker types
- Priority-based queue management
- Scheduled and recurring job support
- Batch job processing and workflows

### **⚡ High Performance & Scalability**
- Distributed processing across multiple workers
- Auto-scaling based on queue depth
- Load balancing and resource optimization
- Sub-second job dispatch and execution

### **🛡️ Reliability & Monitoring**
- Automatic retry mechanisms with exponential backoff
- Dead letter queues for failed jobs
- Real-time job monitoring and analytics
- Health checks and failure recovery

### **📊 Advanced Scheduling**
- Cron-style recurring jobs
- Delayed job execution
- Job dependencies and workflows
- Time-zone aware scheduling

## 📊 Technical Specifications

### **Job Types**
```typescript
enum JobType {
  IMMEDIATE = 'immediate',         // Execute as soon as possible
  SCHEDULED = 'scheduled',         // Execute at specific time
  RECURRING = 'recurring',         // Repeat on schedule
  WORKFLOW = 'workflow',           // Multi-step job chain
  BATCH = 'batch',                // Process multiple items
  PRIORITY = 'priority',           // High-priority execution
  BACKGROUND = 'background'        // Low-priority background task
}
```

### **API Endpoints**

#### **Create Job**
```http
POST /api/v1/queue/jobs
Content-Type: application/json
Authorization: Bearer <api_key>

{
  "type": "immediate",
  "queue": "default",
  "payload": {
    "action": "process_transaction",
    "transaction_hash": "0xabc123...",
    "callback_url": "https://mydapp.com/webhook/transaction"
  },
  "priority": 5,
  "max_retries": 3,
  "timeout": "300s",
  "metadata": {
    "user_id": "user123",
    "source": "api"
  }
}

Response:
{
  "job_id": "job_abc123",
  "status": "queued",
  "queue": "default",
  "priority": 5,
  "created_at": "2024-01-15T10:30:00Z",
  "estimated_execution": "2024-01-15T10:30:05Z"
}
```

#### **Schedule Recurring Job**
```http
POST /api/v1/queue/jobs/recurring
Content-Type: application/json
Authorization: Bearer <api_key>

{
  "name": "daily_analytics_report",
  "schedule": "0 9 * * *",  // Daily at 9 AM
  "timezone": "UTC",
  "payload": {
    "action": "generate_analytics_report",
    "report_type": "daily",
    "recipients": ["admin@mydapp.com"]
  },
  "queue": "analytics",
  "enabled": true
}

Response:
{
  "recurring_job_id": "recurring_abc123",
  "next_execution": "2024-01-16T09:00:00Z",
  "status": "active"
}
```

#### **Get Job Status**
```http
GET /api/v1/queue/jobs/{job_id}
Authorization: Bearer <api_key>

Response:
{
  "job_id": "job_abc123",
  "status": "completed",
  "queue": "default",
  "priority": 5,
  "created_at": "2024-01-15T10:30:00Z",
  "started_at": "2024-01-15T10:30:05Z",
  "completed_at": "2024-01-15T10:30:12Z",
  "duration": "7.2s",
  "result": {
    "success": true,
    "transaction_confirmed": true,
    "block_number": 12345678
  },
  "retry_count": 0,
  "worker_id": "worker_001"
}
```

### **SDK Integration**

#### **JavaScript/TypeScript**
```typescript
import { NeoQueue } from '@r3e/neo-queue';

// Initialize queue client
const queue = new NeoQueue({
  apiKey: 'your-api-key',
  defaultQueue: 'default'
});

// Create immediate job
const job = await queue.createJob({
  type: 'immediate',
  action: 'send_notification',
  payload: {
    userId: 'user123',
    message: 'Your transaction is confirmed!',
    channels: ['email', 'push']
  },
  priority: 7,
  maxRetries: 3
});

console.log('Job created:', job.jobId);

// Schedule delayed job
const delayedJob = await queue.scheduleJob({
  delay: '1h',
  action: 'reminder_notification',
  payload: {
    userId: 'user123',
    reminderType: 'staking_rewards'
  }
});

// Create recurring job
const recurringJob = await queue.createRecurringJob({
  name: 'weekly_portfolio_report',
  schedule: '0 9 * * MON', // Every Monday at 9 AM
  action: 'generate_portfolio_report',
  payload: {
    reportType: 'weekly',
    includeAnalytics: true
  }
});

// Create workflow (multi-step job)
const workflow = await queue.createWorkflow({
  name: 'user_onboarding',
  steps: [
    {
      action: 'create_wallet',
      payload: { userId: 'user123' }
    },
    {
      action: 'send_welcome_email',
      payload: { userId: 'user123' },
      dependsOn: 'create_wallet'
    },
    {
      action: 'setup_analytics_tracking',
      payload: { userId: 'user123' },
      dependsOn: 'create_wallet'
    }
  ]
});

// Monitor job progress
queue.onJobUpdate((jobUpdate) => {
  console.log(`Job ${jobUpdate.jobId} status: ${jobUpdate.status}`);
  
  if (jobUpdate.status === 'failed') {
    console.error('Job failed:', jobUpdate.error);
  }
});
```

#### **React Integration**
```typescript
import { useNeoQueue } from '@r3e/neo-queue-react';

function JobManagementDashboard() {
  const {
    createJob,
    getJobStatus,
    cancelJob,
    jobs,
    queueStats,
    isLoading
  } = useNeoQueue();

  const handleCreateBackgroundTask = async (taskData: any) => {
    try {
      const job = await createJob({
        type: 'background',
        action: 'process_large_dataset',
        payload: taskData,
        queue: 'heavy_processing',
        onProgress: (progress) => {
          console.log(`Task progress: ${progress}%`);
        }
      });

      console.log('Background task started:', job.jobId);
    } catch (error) {
      console.error('Failed to create job:', error);
    }
  };

  const handleScheduleMaintenanceTask = async () => {
    const job = await createJob({
      type: 'scheduled',
      scheduledAt: new Date(Date.now() + 2 * 60 * 60 * 1000), // 2 hours from now
      action: 'database_maintenance',
      payload: {
        operations: ['vacuum', 'reindex', 'analyze']
      },
      queue: 'maintenance'
    });

    console.log('Maintenance task scheduled:', job.jobId);
  };

  return (
    <div className="job-dashboard">
      <div className="queue-stats">
        <h3>Queue Statistics</h3>
        <div className="stats-grid">
          <div className="stat-card">
            <span>Pending Jobs</span>
            <span>{queueStats.pending}</span>
          </div>
          <div className="stat-card">
            <span>Processing Jobs</span>
            <span>{queueStats.processing}</span>
          </div>
          <div className="stat-card">
            <span>Completed Today</span>
            <span>{queueStats.completedToday}</span>
          </div>
        </div>
      </div>

      <div className="active-jobs">
        <h3>Active Jobs</h3>
        {jobs.map(job => (
          <JobCard
            key={job.jobId}
            job={job}
            onCancel={() => cancelJob(job.jobId)}
            onRetry={() => createJob({ ...job, maxRetries: job.maxRetries + 1 })}
          />
        ))}
      </div>

      <div className="job-actions">
        <button onClick={handleScheduleMaintenanceTask}>
          Schedule Maintenance
        </button>
        <button onClick={() => handleCreateBackgroundTask({})}>
          Start Background Task
        </button>
      </div>
    </div>
  );
}

function JobCard({ job, onCancel, onRetry }: { job: any, onCancel: () => void, onRetry: () => void }) {
  const getStatusColor = (status: string) => {
    switch (status) {
      case 'completed': return 'green';
      case 'failed': return 'red';
      case 'processing': return 'blue';
      default: return 'gray';
    }
  };

  return (
    <div className="job-card">
      <div className="job-header">
        <span className="job-id">{job.jobId}</span>
        <span 
          className="job-status" 
          style={{ color: getStatusColor(job.status) }}
        >
          {job.status}
        </span>
      </div>
      <div className="job-details">
        <div>Action: {job.action}</div>
        <div>Queue: {job.queue}</div>
        <div>Priority: {job.priority}</div>
        <div>Retries: {job.retryCount}/{job.maxRetries}</div>
      </div>
      <div className="job-actions">
        {job.status === 'failed' && (
          <button onClick={onRetry}>Retry</button>
        )}
        {['queued', 'processing'].includes(job.status) && (
          <button onClick={onCancel}>Cancel</button>
        )}
      </div>
    </div>
  );
}
```

#### **Vue.js Integration**
```typescript
import { useNeoQueue } from '@r3e/neo-queue-vue';

export default {
  setup() {
    const {
      createJob,
      createWorkflow,
      scheduleRecurringJob,
      monitorQueue
    } = useNeoQueue();

    const processUserActions = async (userActions: any[]) => {
      // Create batch job to process multiple user actions
      const batchJob = await createJob({
        type: 'batch',
        action: 'process_user_actions',
        payload: {
          actions: userActions,
          batchSize: 50
        },
        queue: 'user_processing',
        onBatchProgress: (completed, total) => {
          console.log(`Processed ${completed}/${total} actions`);
        }
      });

      return batchJob;
    };

    const setupAutomatedTasks = async () => {
      // Set up various recurring tasks
      await scheduleRecurringJob({
        name: 'hourly_data_sync',
        schedule: '0 * * * *', // Every hour
        action: 'sync_blockchain_data',
        queue: 'data_sync'
      });

      await scheduleRecurringJob({
        name: 'daily_cleanup',
        schedule: '0 2 * * *', // Daily at 2 AM
        action: 'cleanup_old_data',
        queue: 'maintenance'
      });

      await scheduleRecurringJob({
        name: 'weekly_analytics',
        schedule: '0 9 * * MON', // Monday at 9 AM
        action: 'generate_weekly_report',
        queue: 'analytics'
      });
    };

    const createComplexWorkflow = async (userId: string) => {
      // Create multi-step user onboarding workflow
      return await createWorkflow({
        name: 'complete_user_onboarding',
        steps: [
          {
            id: 'verify_email',
            action: 'send_verification_email',
            payload: { userId },
            timeout: '5m'
          },
          {
            id: 'create_wallet',
            action: 'generate_user_wallet',
            payload: { userId },
            dependsOn: ['verify_email']
          },
          {
            id: 'setup_profile',
            action: 'initialize_user_profile',
            payload: { userId },
            dependsOn: ['create_wallet']
          },
          {
            id: 'send_welcome',
            action: 'send_welcome_package',
            payload: { userId },
            dependsOn: ['setup_profile']
          }
        ],
        onStepComplete: (stepId, result) => {
          console.log(`Step ${stepId} completed:`, result);
        },
        onWorkflowComplete: (results) => {
          console.log('Onboarding workflow completed:', results);
        }
      });
    };

    return {
      processUserActions,
      setupAutomatedTasks,
      createComplexWorkflow,
      monitorQueue
    };
  }
};
```

#### **Rust Backend Integration**
```rust
use neo_queue::{QueueClient, Job, JobType, WorkflowBuilder};

let queue_client = QueueClient::new("your-api-key");

// Create immediate job
let job = Job::builder()
    .job_type(JobType::Immediate)
    .action("process_smart_contract_event")
    .payload(json!({
        "contract_address": "0x123abc...",
        "event_name": "Transfer",
        "block_number": 12345678
    }))
    .queue("contract_events")
    .priority(8)
    .max_retries(5)
    .build();

let created_job = queue_client.create_job(job).await?;
println!("Job created with ID: {}", created_job.job_id);

// Create workflow for complex processing
let workflow = WorkflowBuilder::new("data_pipeline")
    .add_step("extract", json!({
        "source": "blockchain",
        "start_block": 12345000,
        "end_block": 12346000
    }))
    .add_step("transform", json!({
        "operations": ["normalize", "aggregate", "enrich"]
    }))
    .depends_on("extract")
    .add_step("load", json!({
        "destination": "analytics_db",
        "table": "transaction_metrics"
    }))
    .depends_on("transform")
    .build();

let workflow_id = queue_client.create_workflow(workflow).await?;
println!("Workflow created: {}", workflow_id);

// Monitor job completion
let job_status = queue_client.wait_for_completion(&created_job.job_id).await?;
match job_status.status {
    JobStatus::Completed => println!("Job completed successfully"),
    JobStatus::Failed => println!("Job failed: {:?}", job_status.error),
    _ => println!("Job status: {:?}", job_status.status),
}
```

## 🔧 Configuration Options

### **Queue Configuration**
```typescript
const queueConfig = {
  default_queue: 'default',
  queues: {
    default: {
      max_workers: 10,
      worker_type: 'general',
      priority_range: [1, 10]
    },
    high_priority: {
      max_workers: 5,
      worker_type: 'fast',
      priority_range: [8, 10],
      auto_scale: true
    },
    heavy_processing: {
      max_workers: 3,
      worker_type: 'cpu_intensive',
      timeout: '30m',
      memory_limit: '8GB'
    },
    scheduled: {
      max_workers: 2,
      worker_type: 'scheduler',
      timezone: 'UTC'
    }
  },
  retry_strategy: {
    max_retries: 3,
    backoff_strategy: 'exponential',
    base_delay: '30s',
    max_delay: '10m'
  }
};
```

### **Worker Configuration**
```typescript
const workerConfig = {
  auto_scaling: {
    enabled: true,
    min_workers: 2,
    max_workers: 20,
    scale_up_threshold: 10, // jobs waiting
    scale_down_threshold: 2,
    scale_cooldown: '5m'
  },
  health_checks: {
    enabled: true,
    interval: '30s',
    timeout: '10s',
    unhealthy_threshold: 3
  },
  resource_limits: {
    cpu_limit: '2000m',
    memory_limit: '4Gi',
    execution_timeout: '30m'
  }
};
```

## 🛡️ Security Features

### **TEE-Protected Job Processing**
- Job payloads encrypted within Intel SGX enclaves
- Secure job result storage and transmission
- Protected API key and credential management
- Tamper-proof job execution logging

### **Access Control & Isolation**
```typescript
const securityFeatures = {
  job_isolation: {
    secure_containers: true,
    network_isolation: true,
    filesystem_isolation: true
  },
  access_control: {
    role_based_permissions: true,
    job_ownership_validation: true,
    queue_access_restrictions: true
  },
  data_protection: {
    payload_encryption: true,
    result_encryption: true,
    audit_logging: true,
    gdpr_compliance: true
  }
};
```

### **Compliance & Monitoring**
```typescript
const complianceFeatures = {
  audit_logging: {
    job_lifecycle_events: true,
    access_attempts: true,
    data_processing_records: true
  },
  data_retention: {
    job_history: '90d',
    failed_job_data: '30d',
    audit_logs: '1y'
  },
  compliance_standards: [
    'SOC2_TYPE2',
    'GDPR',
    'CCPA',
    'HIPAA'
  ]
};
```

## 💰 Pricing Model

### **Starter** - Free
- Up to 1,000 jobs per month
- Basic queue management
- 3 concurrent workers
- 7-day job history
- Community support

### **Professional** - $49/month
- Up to 50,000 jobs per month
- Advanced scheduling features
- 10 concurrent workers
- Workflow capabilities
- 30-day job history
- Email support
- $0.01 per additional job

### **Business** - $149/month
- Up to 500,000 jobs per month
- Priority queue access
- 50 concurrent workers
- Advanced analytics
- 90-day job history
- API access
- Priority support
- $0.005 per additional job

### **Enterprise** - $499/month
- Unlimited jobs
- Dedicated worker pools
- Custom worker configurations
- 1-year job history
- SLA guarantees
- 24/7 support
- On-premise deployment

## 🚀 Quick Start Guide

### **1. Install SDK**
```bash
npm install @r3e/neo-queue
```

### **2. Initialize Client**
```typescript
import { NeoQueue } from '@r3e/neo-queue';

const queue = new NeoQueue({
  apiKey: process.env.NEO_QUEUE_API_KEY
});
```

### **3. Create Your First Job**
```typescript
const job = await queue.createJob({
  action: 'send_email',
  payload: {
    to: 'user@example.com',
    subject: 'Welcome!',
    body: 'Thanks for joining our platform.'
  }
});

console.log('Job created:', job.jobId);
```

### **4. Monitor Job Progress**
```typescript
const status = await queue.getJobStatus(job.jobId);
console.log('Job status:', status.status);

// Or use real-time monitoring
queue.onJobUpdate((update) => {
  console.log(`Job ${update.jobId} is now ${update.status}`);
});
```

## 🔗 Integration Examples

### **DeFi Protocol Background Tasks**
```typescript
class DeFiJobProcessor {
  private queue: NeoQueue;

  constructor() {
    this.queue = new NeoQueue({
      apiKey: process.env.QUEUE_API_KEY
    });
  }

  async setupLiquidationMonitoring() {
    // Create recurring job to check for liquidation opportunities
    await this.queue.createRecurringJob({
      name: 'liquidation_monitor',
      schedule: '*/30 * * * * *', // Every 30 seconds
      action: 'check_liquidation_opportunities',
      queue: 'high_priority',
      payload: {
        protocols: ['compound', 'aave', 'maker'],
        min_collateral_ratio: 1.1
      }
    });

    // Process individual liquidations as high-priority jobs
    this.queue.registerHandler('execute_liquidation', async (payload) => {
      const { position, protocol } = payload;
      
      // Execute liquidation logic
      const result = await this.executeLiquidation(position, protocol);
      
      // Create follow-up job to distribute rewards
      if (result.success) {
        await this.queue.createJob({
          action: 'distribute_liquidation_rewards',
          payload: {
            liquidationId: result.liquidationId,
            rewards: result.rewards
          },
          priority: 8
        });
      }

      return result;
    });
  }

  async processYieldFarmingRewards() {
    // Create workflow for yield farming reward distribution
    return await this.queue.createWorkflow({
      name: 'yield_farming_rewards',
      steps: [
        {
          id: 'calculate_rewards',
          action: 'calculate_user_rewards',
          payload: { farmingPool: 'ETH-USDC', epoch: 'current' }
        },
        {
          id: 'validate_rewards',
          action: 'validate_reward_calculations',
          dependsOn: ['calculate_rewards']
        },
        {
          id: 'distribute_rewards',
          action: 'distribute_rewards_to_users',
          dependsOn: ['validate_rewards']
        },
        {
          id: 'update_metrics',
          action: 'update_farming_metrics',
          dependsOn: ['distribute_rewards']
        }
      ]
    });
  }

  async handleArbitrageOpportunities() {
    // Monitor and execute arbitrage opportunities
    await this.queue.registerHandler('arbitrage_opportunity', async (payload) => {
      const { tokenA, tokenB, exchanges, profitMargin } = payload;
      
      if (profitMargin < 0.5) {
        return { executed: false, reason: 'Insufficient profit margin' };
      }

      // Execute arbitrage with timeout
      const arbitrageJob = await this.queue.createJob({
        action: 'execute_arbitrage',
        payload: { tokenA, tokenB, exchanges },
        timeout: '60s',
        priority: 9
      });

      return await this.queue.waitForCompletion(arbitrageJob.jobId);
    });
  }
}
```

### **NFT Marketplace Automation**
```typescript
class NFTMarketplaceJobs {
  private queue: NeoQueue;

  async setupMarketplaceAutomation() {
    // Process NFT metadata and image optimization
    await this.queue.registerHandler('process_nft_upload', async (payload) => {
      const { nftId, imageUrl, metadata } = payload;
      
      // Create workflow for NFT processing
      return await this.queue.createWorkflow({
        name: `process_nft_${nftId}`,
        steps: [
          {
            id: 'validate_image',
            action: 'validate_nft_image',
            payload: { imageUrl }
          },
          {
            id: 'generate_thumbnails',
            action: 'generate_image_thumbnails',
            payload: { imageUrl, sizes: [150, 300, 600] },
            dependsOn: ['validate_image']
          },
          {
            id: 'extract_metadata',
            action: 'extract_image_metadata',
            payload: { imageUrl },
            dependsOn: ['validate_image']
          },
          {
            id: 'store_processed_nft',
            action: 'store_nft_data',
            payload: { nftId, metadata },
            dependsOn: ['generate_thumbnails', 'extract_metadata']
          }
        ]
      });
    });

    // Automated price discovery and recommendations
    await this.queue.createRecurringJob({
      name: 'price_discovery',
      schedule: '0 */6 * * *', // Every 6 hours
      action: 'calculate_nft_price_recommendations',
      payload: {
        collections: 'all',
        timeWindow: '24h'
      }
    });

    // Handle auction ending automation
    await this.queue.registerHandler('auction_ending_soon', async (payload) => {
      const { auctionId, timeRemaining } = payload;
      
      if (timeRemaining <= 300000) { // 5 minutes
        // Send notifications to interested bidders
        await this.queue.createJob({
          action: 'send_auction_ending_notifications',
          payload: { auctionId },
          priority: 8
        });
      }

      // Schedule final auction closure
      await this.queue.scheduleJob({
        scheduledAt: new Date(Date.now() + timeRemaining),
        action: 'close_auction',
        payload: { auctionId },
        priority: 9
      });
    });
  }

  async processRoyaltyDistributions() {
    // Batch process royalty payments
    return await this.queue.createJob({
      type: 'batch',
      action: 'distribute_royalties',
      payload: {
        period: 'daily',
        batchSize: 100
      },
      queue: 'financial'
    });
  }
}
```

### **Gaming dApp Task Management**
```typescript
class GameTaskProcessor {
  private queue: NeoQueue;

  async setupGameAutomation() {
    // Process player achievements
    await this.queue.registerHandler('player_achievement', async (payload) => {
      const { playerId, achievementId, gameData } = payload;
      
      const workflow = await this.queue.createWorkflow({
        name: `achievement_${playerId}_${achievementId}`,
        steps: [
          {
            id: 'validate_achievement',
            action: 'validate_player_achievement',
            payload: { playerId, achievementId, gameData }
          },
          {
            id: 'award_points',
            action: 'award_achievement_points',
            payload: { playerId, achievementId },
            dependsOn: ['validate_achievement']
          },
          {
            id: 'mint_reward_nft',
            action: 'mint_achievement_nft',
            payload: { playerId, achievementId },
            dependsOn: ['validate_achievement']
          },
          {
            id: 'notify_player',
            action: 'send_achievement_notification',
            payload: { playerId, achievementId },
            dependsOn: ['award_points', 'mint_reward_nft']
          }
        ]
      });

      return workflow;
    });

    // Daily leaderboard updates
    await this.queue.createRecurringJob({
      name: 'update_leaderboards',
      schedule: '0 0 * * *', // Daily at midnight
      action: 'calculate_daily_leaderboards',
      payload: {
        gameMode: 'all',
        resetDaily: true
      },
      queue: 'analytics'
    });

    // Game economy balancing
    await this.queue.createRecurringJob({
      name: 'economy_analysis',
      schedule: '0 */4 * * *', // Every 4 hours
      action: 'analyze_game_economy',
      payload: {
        metrics: ['token_supply', 'inflation_rate', 'player_wealth_distribution']
      }
    });
  }

  async processSeasonEndTasks() {
    // Complex multi-step season end processing
    return await this.queue.createWorkflow({
      name: 'season_end_processing',
      steps: [
        {
          id: 'freeze_scores',
          action: 'freeze_player_scores',
          payload: { season: 'current' }
        },
        {
          id: 'calculate_rewards',
          action: 'calculate_season_rewards',
          dependsOn: ['freeze_scores']
        },
        {
          id: 'distribute_tokens',
          action: 'distribute_season_tokens',
          dependsOn: ['calculate_rewards']
        },
        {
          id: 'mint_nft_rewards',
          action: 'mint_season_nft_rewards',
          dependsOn: ['calculate_rewards']
        },
        {
          id: 'reset_season',
          action: 'initialize_new_season',
          dependsOn: ['distribute_tokens', 'mint_nft_rewards']
        },
        {
          id: 'notify_players',
          action: 'send_season_end_notifications',
          dependsOn: ['reset_season']
        }
      ]
    });
  }
}
```

## 🔍 Troubleshooting

### **Common Issues**

#### **Job Failures and Retries**
```typescript
// Handle job failures with intelligent retry logic
const createJobWithRetry = async (jobData: any) => {
  const job = await queue.createJob({
    ...jobData,
    maxRetries: 5,
    retryStrategy: {
      type: 'exponential',
      baseDelay: '30s',
      maxDelay: '10m',
      retryConditions: [
        'network_timeout',
        'temporary_failure',
        'rate_limit_exceeded'
      ]
    },
    onRetry: (attempt, error) => {
      console.log(`Job retry attempt ${attempt}:`, error.message);
    }
  });

  return job;
};
```

#### **Queue Congestion**
```typescript
// Monitor and manage queue congestion
const monitorQueueHealth = async () => {
  const stats = await queue.getQueueStats();
  
  if (stats.pendingJobs > 1000) {
    // Auto-scale workers
    await queue.scaleWorkers({
      queue: 'default',
      targetWorkers: Math.min(stats.pendingJobs / 50, 50)
    });
    
    // Prioritize critical jobs
    await queue.adjustPriorities({
      queue: 'default',
      criteria: { action: 'critical_task' },
      newPriority: 10
    });
  }
};
```

#### **Memory and Resource Issues**
```typescript
// Optimize job processing for resource constraints
const optimizeJobProcessing = async () => {
  // Configure memory-efficient batch processing
  await queue.updateQueueConfig({
    queue: 'heavy_processing',
    batchSize: 10, // Process fewer items at once
    workerMemoryLimit: '2GB',
    enableMemoryMonitoring: true,
    onMemoryWarning: (usage) => {
      console.warn(`High memory usage: ${usage}%`);
    }
  });

  // Use streaming for large datasets
  await queue.registerHandler('process_large_dataset', async (payload) => {
    const { dataSource } = payload;
    
    return await queue.streamProcessor({
      source: dataSource,
      chunkSize: 1000,
      processor: async (chunk) => {
        return await processDataChunk(chunk);
      }
    });
  });
};
```

## 📞 Support & Resources

- **Documentation**: [docs.neoqueue.r3e.network](https://docs.neoqueue.r3e.network)
- **Queue Dashboard**: [dashboard.neoqueue.r3e.network](https://dashboard.neoqueue.r3e.network)
- **API Reference**: [api.neoqueue.r3e.network](https://api.neoqueue.r3e.network)
- **Worker Monitoring**: [workers.neoqueue.r3e.network](https://workers.neoqueue.r3e.network)
- **Job Templates**: [templates.neoqueue.r3e.network](https://templates.neoqueue.r3e.network)
- **Discord Support**: [discord.gg/r3e-network](https://discord.gg/r3e-network)
- **Email**: [queue@r3e.network](mailto:queue@r3e.network)

---

**NeoQueue provides reliable, scalable job processing infrastructure that enables Neo dApps to handle complex background tasks, workflows, and automation with enterprise-grade reliability and monitoring.** 