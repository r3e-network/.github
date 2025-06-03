# NeoSearch - Data Indexing & Search Service

## 🎯 Overview

**NeoSearch** provides enterprise-grade data indexing and search capabilities for Neo dApps, offering real-time blockchain data indexing, GraphQL APIs, full-text search, and advanced query optimization with TEE-protected data processing and intelligent caching.

## 🚀 Purpose

Modern dApps require sophisticated data search and indexing capabilities to provide fast, relevant results from blockchain data, transaction histories, and user-generated content. NeoSearch eliminates the complexity of building search infrastructure by providing scalable, real-time indexing with powerful query capabilities and enterprise-grade performance.

## ✨ Key Features

### **⚡ Real-Time Blockchain Indexing**
- Live blockchain data synchronization and indexing
- Smart contract event tracking and searchability  
- Transaction history indexing with metadata
- Cross-chain data aggregation and search

### **🔍 Advanced Search Capabilities**
- Full-text search with relevance scoring
- Faceted search and filtering
- Auto-complete and search suggestions
- Semantic search with AI-powered matching

### **📊 Flexible Query APIs**
- RESTful search APIs with pagination
- GraphQL query interface with schema flexibility
- SQL-like query language for complex operations
- Real-time search result subscriptions

### **🚀 Performance & Scalability**
- Distributed indexing across multiple nodes
- Intelligent caching and query optimization
- Sub-millisecond search response times
- Auto-scaling based on query load

## 📊 Technical Specifications

### **Index Types**
```typescript
enum IndexType {
  BLOCKCHAIN_DATA = 'blockchain_data',     // Blocks, transactions, events
  SMART_CONTRACTS = 'smart_contracts',    // Contract calls and events
  USER_CONTENT = 'user_content',          // User-generated content
  NFT_METADATA = 'nft_metadata',          // NFT data and attributes
  TRANSACTION_LOGS = 'transaction_logs',  // Detailed transaction data
  FULL_TEXT = 'full_text',               // Text content search
  GEOSPATIAL = 'geospatial',             // Location-based data
  TIME_SERIES = 'time_series'            // Time-based metrics
}
```

### **API Endpoints**

#### **Search Query**
```http
POST /api/v1/search
Content-Type: application/json
Authorization: Bearer <api_key>

{
  "query": "NFT marketplace transactions",
  "filters": {
    "contract_address": "0x123abc...",
    "date_range": {
      "from": "2024-01-01T00:00:00Z",
      "to": "2024-01-15T23:59:59Z"
    },
    "transaction_type": ["mint", "transfer"]
  },
  "sort": [
    {"field": "timestamp", "order": "desc"},
    {"field": "value", "order": "desc"}
  ],
  "limit": 50,
  "offset": 0,
  "highlight": true
}

Response:
{
  "total_hits": 1247,
  "search_time_ms": 23,
  "results": [
    {
      "id": "tx_abc123",
      "score": 0.95,
      "type": "transaction",
      "data": {
        "hash": "0xabc123...",
        "from": "NXXzKhzgs8EQtpNrNdvLfPjBQU3Cq3Kt1i",
        "to": "0x456def...",
        "value": "100.5",
        "timestamp": "2024-01-15T10:30:00Z",
        "contract_address": "0x123abc..."
      },
      "highlight": {
        "description": "NFT <em>marketplace</em> <em>transaction</em> for rare collectible"
      }
    }
  ],
  "facets": {
    "transaction_type": {"mint": 450, "transfer": 650, "sale": 147},
    "value_range": {"0-10": 800, "10-100": 350, "100+": 97}
  }
}
```

#### **GraphQL Query**
```http
POST /api/v1/graphql
Content-Type: application/json
Authorization: Bearer <api_key>

{
  "query": "
    query SearchTransactions($filters: TransactionFilters!) {
      searchTransactions(filters: $filters) {
        totalCount
        edges {
          node {
            hash
            from
            to
            value
            timestamp
            contract {
              address
              name
              type
            }
            events {
              name
              parameters
            }
          }
          cursor
        }
        pageInfo {
          hasNextPage
          hasPreviousPage
          startCursor
          endCursor
        }
      }
    }
  ",
  "variables": {
    "filters": {
      "contractAddress": "0x123abc...",
      "dateRange": {
        "from": "2024-01-01T00:00:00Z",
        "to": "2024-01-15T23:59:59Z"
      }
    }
  }
}
```

#### **Create Index**
```http
POST /api/v1/indices
Content-Type: application/json
Authorization: Bearer <api_key>

{
  "name": "my_dapp_transactions",
  "type": "blockchain_data",
  "schema": {
    "fields": {
      "hash": {"type": "keyword", "indexed": true},
      "from": {"type": "keyword", "indexed": true},
      "to": {"type": "keyword", "indexed": true},
      "value": {"type": "number", "indexed": true},
      "timestamp": {"type": "date", "indexed": true},
      "description": {"type": "text", "analyzer": "standard"}
    }
  },
  "settings": {
    "shards": 3,
    "replicas": 1,
    "refresh_interval": "1s"
  }
}
```

### **SDK Integration**

#### **JavaScript/TypeScript**
```typescript
import { NeoSearch } from '@r3e/neo-search';

// Initialize search client
const search = new NeoSearch({
  apiKey: 'your-api-key',
  endpoint: 'https://search.r3e.network'
});

// Basic search
const results = await search.query({
  query: 'DeFi lending transactions',
  filters: {
    contract_address: '0x123abc...',
    value_range: { min: 1000, max: 50000 }
  },
  sort: [{ field: 'timestamp', order: 'desc' }],
  limit: 20
});

console.log(`Found ${results.totalHits} transactions`);

// Advanced search with facets
const advancedResults = await search.query({
  query: 'NFT marketplace',
  filters: {
    date_range: {
      from: '2024-01-01',
      to: '2024-01-31'
    }
  },
  facets: [
    'transaction_type',
    'value_range',
    'contract_address'
  ],
  highlight: {
    fields: ['description', 'metadata']
  }
});

// GraphQL query
const graphqlResults = await search.graphql(`
  query {
    searchNFTs(
      query: "rare collectibles",
      first: 10,
      filters: { rarity: "legendary" }
    ) {
      nodes {
        tokenId
        name
        description
        attributes {
          trait_type
          value
        }
        owner
        lastSalePrice
      }
    }
  }
`);

// Real-time search subscriptions
search.subscribe({
  query: 'new NFT mints',
  filters: { contract_address: '0x123abc...' },
  onResult: (result) => {
    console.log('New NFT minted:', result);
  },
  onError: (error) => {
    console.error('Subscription error:', error);
  }
});

// Auto-complete suggestions
const suggestions = await search.suggest({
  query: 'defi',
  field: 'description',
  size: 5
});
```

#### **React Integration**
```typescript
import { useNeoSearch } from '@r3e/neo-search-react';

function SearchInterface() {
  const {
    search,
    results,
    facets,
    isLoading,
    isError,
    totalHits
  } = useNeoSearch();

  const [query, setQuery] = useState('');
  const [filters, setFilters] = useState({});

  const handleSearch = async () => {
    await search({
      query,
      filters,
      facets: ['transaction_type', 'value_range'],
      sort: [{ field: 'timestamp', order: 'desc' }]
    });
  };

  return (
    <div className="search-interface">
      <div className="search-bar">
        <input
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Search transactions, NFTs, contracts..."
          onKeyPress={(e) => e.key === 'Enter' && handleSearch()}
        />
        <button onClick={handleSearch} disabled={isLoading}>
          {isLoading ? 'Searching...' : 'Search'}
        </button>
      </div>

      <div className="search-results">
        <div className="results-info">
          Found {totalHits} results
        </div>

        <div className="results-content">
          <div className="facets">
            <h3>Filters</h3>
            {facets.transaction_type && (
              <FacetGroup
                title="Transaction Type"
                facet={facets.transaction_type}
                onFilter={(value) => setFilters({...filters, transaction_type: value})}
              />
            )}
            {facets.value_range && (
              <FacetGroup
                title="Value Range"
                facet={facets.value_range}
                onFilter={(value) => setFilters({...filters, value_range: value})}
              />
            )}
          </div>

          <div className="results-list">
            {results.map((result) => (
              <SearchResultCard key={result.id} result={result} />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

function SearchResultCard({ result }: { result: any }) {
  return (
    <div className="result-card">
      <div className="result-header">
        <span className="result-type">{result.type}</span>
        <span className="result-score">Score: {result.score}</span>
      </div>
      <div className="result-content">
        <h4>{result.data.hash}</h4>
        <p>From: {result.data.from}</p>
        <p>To: {result.data.to}</p>
        <p>Value: {result.data.value}</p>
        <p>Time: {new Date(result.data.timestamp).toLocaleString()}</p>
        {result.highlight && (
          <div 
            className="highlight" 
            dangerouslySetInnerHTML={{ __html: result.highlight.description }}
          />
        )}
      </div>
    </div>
  );
}
```

#### **Vue.js Integration**
```typescript
import { useNeoSearch } from '@r3e/neo-search-vue';

export default {
  setup() {
    const {
      search,
      searchGraphQL,
      createIndex,
      getSearchSuggestions
    } = useNeoSearch();

    const performSearch = async (searchParams: any) => {
      const results = await search({
        query: searchParams.query,
        filters: searchParams.filters,
        facets: ['category', 'price_range', 'date'],
        sort: [{ field: 'relevance', order: 'desc' }],
        highlight: {
          fields: ['title', 'description'],
          fragment_size: 150
        }
      });

      return results;
    };

    const setupCustomIndex = async () => {
      // Create custom index for specific dApp data
      await createIndex({
        name: 'my_dapp_users',
        type: 'user_content',
        schema: {
          fields: {
            user_id: { type: 'keyword', indexed: true },
            username: { type: 'text', analyzer: 'standard' },
            profile_data: { type: 'text', analyzer: 'standard' },
            join_date: { type: 'date', indexed: true },
            activity_score: { type: 'number', indexed: true }
          }
        },
        settings: {
          analysis: {
            analyzer: {
              user_analyzer: {
                type: 'custom',
                tokenizer: 'standard',
                filters: ['lowercase', 'user_synonyms']
              }
            }
          }
        }
      });
    };

    const searchWithAutoComplete = async (partialQuery: string) => {
      const suggestions = await getSearchSuggestions({
        query: partialQuery,
        field: 'description',
        size: 8,
        fuzzy: true
      });

      return suggestions;
    };

    return {
      performSearch,
      setupCustomIndex,
      searchWithAutoComplete,
      searchGraphQL
    };
  }
};
```

#### **Rust Backend Integration**
```rust
use neo_search::{SearchClient, Query, Filter, Sort, IndexConfig};

let search_client = SearchClient::new("your-api-key");

// Create search query
let query = Query::builder()
    .text("DeFi lending protocols")
    .filter(Filter::term("category", "defi"))
    .filter(Filter::range("value", 1000.0..50000.0))
    .sort(Sort::by_field("timestamp").descending())
    .size(50)
    .build();

let results = search_client.search(query).await?;

for result in results.hits {
    println!("Found: {} (score: {})", result.id, result.score);
}

// Create custom index
let index_config = IndexConfig::builder()
    .name("smart_contract_events")
    .index_type("blockchain_data")
    .field("contract_address", "keyword")
    .field("event_name", "keyword")
    .field("parameters", "text")
    .field("block_number", "number")
    .field("timestamp", "date")
    .build();

search_client.create_index(index_config).await?;

// Index new data
let document = json!({
    "contract_address": "0x123abc...",
    "event_name": "Transfer",
    "parameters": {
        "from": "0x456def...",
        "to": "0x789ghi...",
        "amount": "1000000000"
    },
    "block_number": 12345678,
    "timestamp": "2024-01-15T10:30:00Z"
});

search_client.index_document("smart_contract_events", &document).await?;
```

## 🔧 Configuration Options

### **Index Configuration**
```typescript
const indexConfig = {
  performance: {
    shards: 3,              // Number of index shards
    replicas: 1,            // Number of replicas
    refresh_interval: '1s', // How often to refresh index
    batch_size: 1000        // Batch size for indexing
  },
  analysis: {
    analyzers: {
      standard_analyzer: {
        type: 'standard',
        stopwords: ['the', 'and', 'or', 'but']
      },
      blockchain_analyzer: {
        type: 'custom',
        tokenizer: 'keyword',
        filters: ['lowercase', 'address_filter']
      }
    },
    normalizers: {
      address_normalizer: {
        type: 'custom',
        filters: ['lowercase']
      }
    }
  },
  mappings: {
    dynamic: 'strict',
    properties: {
      timestamp: { type: 'date', format: 'iso8601' },
      address: { type: 'keyword', normalizer: 'address_normalizer' },
      amount: { type: 'scaled_float', scaling_factor: 100 }
    }
  }
};
```

### **Search Configuration**
```typescript
const searchConfig = {
  query_settings: {
    default_size: 20,
    max_size: 1000,
    timeout: '30s',
    track_total_hits: true
  },
  highlighting: {
    pre_tags: ['<em>'],
    post_tags: ['</em>'],
    fragment_size: 150,
    number_of_fragments: 3
  },
  aggregations: {
    max_buckets: 10000,
    date_histogram_interval: '1d'
  },
  caching: {
    query_cache: true,
    request_cache: true,
    cache_ttl: '5m'
  }
};
```

## 🛡️ Security Features

### **TEE-Protected Data Processing**
- Search query processing within Intel SGX enclaves
- Encrypted index storage and transmission
- Protected API key management
- Secure data anonymization for sensitive content

### **Access Control & Privacy**
```typescript
const securityFeatures = {
  access_control: {
    role_based_permissions: true,
    index_level_security: true,
    query_filtering: true,
    audit_logging: true
  },
  data_protection: {
    field_level_encryption: true,
    pii_detection: true,
    data_masking: true,
    retention_policies: true
  },
  compliance: {
    gdpr_right_to_deletion: true,
    data_processing_logs: true,
    consent_management: true
  }
};
```

### **Query Security**
```typescript
const querySecurityConfig = {
  rate_limiting: {
    queries_per_minute: 1000,
    burst_limit: 100,
    ip_based_limits: true
  },
  input_validation: {
    query_sanitization: true,
    injection_prevention: true,
    size_limits: {
      max_query_length: 10000,
      max_filter_depth: 10
    }
  }
};
```

## 💰 Pricing Model

### **Developer** - Free
- Up to 10,000 search queries per month
- 1 GB indexed data
- Basic search features
- Community support

### **Professional** - $99/month
- Up to 1,000,000 search queries per month
- 50 GB indexed data
- Advanced search features (facets, highlighting)
- GraphQL API access
- Email support
- $0.10 per additional 1,000 queries

### **Business** - $299/month
- Up to 10,000,000 search queries per month
- 500 GB indexed data
- Real-time indexing
- Custom analyzers
- Priority support
- SLA guarantees
- $0.05 per additional 1,000 queries

### **Enterprise** - $999/month
- Unlimited search queries
- Unlimited indexed data
- Dedicated search clusters
- Custom integrations
- 24/7 support
- On-premise deployment options

## 🚀 Quick Start Guide

### **1. Install SDK**
```bash
npm install @r3e/neo-search
```

### **2. Initialize Client**
```typescript
import { NeoSearch } from '@r3e/neo-search';

const search = new NeoSearch({
  apiKey: process.env.NEO_SEARCH_API_KEY
});
```

### **3. Create Your First Index**
```typescript
await search.createIndex({
  name: 'my_transactions',
  type: 'blockchain_data',
  schema: {
    fields: {
      hash: { type: 'keyword' },
      from: { type: 'keyword' },
      to: { type: 'keyword' },
      value: { type: 'number' },
      timestamp: { type: 'date' }
    }
  }
});
```

### **4. Search Your Data**
```typescript
const results = await search.query({
  query: 'large transactions',
  filters: { value_range: { min: 1000 } },
  sort: [{ field: 'timestamp', order: 'desc' }]
});

console.log(`Found ${results.totalHits} results`);
```

## 🔗 Integration Examples

### **DeFi Protocol Analytics**
```typescript
class DeFiSearchAnalytics {
  private search: NeoSearch;

  constructor() {
    this.search = new NeoSearch({
      apiKey: process.env.SEARCH_API_KEY
    });
  }

  async setupDeFiIndexes() {
    // Create specialized indexes for DeFi data
    await this.search.createIndex({
      name: 'defi_transactions',
      type: 'blockchain_data',
      schema: {
        fields: {
          protocol: { type: 'keyword', indexed: true },
          transaction_type: { type: 'keyword', indexed: true },
          token_pair: { type: 'keyword', indexed: true },
          amount_in: { type: 'number', indexed: true },
          amount_out: { type: 'number', indexed: true },
          slippage: { type: 'number', indexed: true },
          gas_fee: { type: 'number', indexed: true },
          timestamp: { type: 'date', indexed: true },
          user_address: { type: 'keyword', indexed: true }
        }
      }
    });

    await this.search.createIndex({
      name: 'liquidity_pools',
      type: 'blockchain_data',
      schema: {
        fields: {
          pool_address: { type: 'keyword', indexed: true },
          token_a: { type: 'keyword', indexed: true },
          token_b: { type: 'keyword', indexed: true },
          total_value_locked: { type: 'number', indexed: true },
          volume_24h: { type: 'number', indexed: true },
          fees_24h: { type: 'number', indexed: true },
          apy: { type: 'number', indexed: true }
        }
      }
    });
  }

  async searchHighVolumeSwaps(timeframe: string) {
    return await this.search.query({
      index: 'defi_transactions',
      query: 'swap transactions',
      filters: {
        transaction_type: 'swap',
        amount_in: { min: 10000 },
        timestamp: { 
          from: this.getTimeframeStart(timeframe),
          to: new Date()
        }
      },
      facets: ['protocol', 'token_pair', 'slippage_range'],
      sort: [{ field: 'amount_in', order: 'desc' }],
      size: 100
    });
  }

  async findArbitrageOpportunities() {
    // Complex search for potential arbitrage opportunities
    const graphqlQuery = `
      query FindArbitrage {
        searchLiquidityPools(
          filters: {
            totalValueLocked: { min: 100000 }
            volume24h: { min: 50000 }
          }
          first: 50
        ) {
          nodes {
            poolAddress
            tokenA
            tokenB
            totalValueLocked
            currentPrice
            volume24h
            fees24h
          }
        }
      }
    `;

    return await this.search.graphql(graphqlQuery);
  }

  async trackLiquidationEvents() {
    // Set up real-time monitoring for liquidation events
    return this.search.subscribe({
      index: 'defi_transactions',
      query: 'liquidation events',
      filters: {
        transaction_type: 'liquidation',
        amount_liquidated: { min: 50000 }
      },
      onResult: (liquidation) => {
        this.handleLiquidationAlert(liquidation);
      }
    });
  }
}
```

### **NFT Marketplace Search**
```typescript
class NFTMarketplaceSearch {
  private search: NeoSearch;

  async setupNFTSearch() {
    await this.search.createIndex({
      name: 'nft_collections',
      type: 'nft_metadata',
      schema: {
        fields: {
          collection_name: { type: 'text', analyzer: 'standard' },
          token_id: { type: 'keyword', indexed: true },
          name: { type: 'text', analyzer: 'nft_analyzer' },
          description: { type: 'text', analyzer: 'standard' },
          image_url: { type: 'keyword' },
          attributes: { type: 'nested' },
          owner: { type: 'keyword', indexed: true },
          price: { type: 'number', indexed: true },
          currency: { type: 'keyword', indexed: true },
          rarity_score: { type: 'number', indexed: true },
          listing_date: { type: 'date', indexed: true }
        }
      },
      settings: {
        analysis: {
          analyzer: {
            nft_analyzer: {
              type: 'custom',
              tokenizer: 'standard',
              filters: ['lowercase', 'nft_synonyms']
            }
          }
        }
      }
    });
  }

  async searchNFTs(searchParams: NFTSearchParams) {
    const results = await this.search.query({
      index: 'nft_collections',
      query: searchParams.query,
      filters: {
        collection_name: searchParams.collection,
        price: searchParams.priceRange,
        attributes: searchParams.attributes,
        rarity_score: searchParams.rarityRange
      },
      facets: [
        'collection_name',
        'attributes.trait_type',
        'attributes.value',
        'price_range',
        'rarity_tier'
      ],
      sort: this.buildSortCriteria(searchParams.sortBy),
      highlight: {
        fields: ['name', 'description'],
        fragment_size: 100
      }
    });

    return this.enhanceNFTResults(results);
  }

  async findSimilarNFTs(nftId: string) {
    // Use ML-powered semantic search to find similar NFTs
    return await this.search.moreLikeThis({
      index: 'nft_collections',
      id: nftId,
      fields: ['name', 'description', 'attributes'],
      min_term_frequency: 1,
      max_query_terms: 25
    });
  }

  async getCollectionAnalytics(collectionName: string) {
    const graphqlQuery = `
      query CollectionAnalytics($collection: String!) {
        searchNFTs(filters: { collectionName: $collection }) {
          totalCount
          aggregations {
            priceStats {
              min
              max
              avg
              median
            }
            rarityDistribution {
              buckets {
                key
                count
              }
            }
            salesVolume24h
            floorPrice
          }
        }
      }
    `;

    return await this.search.graphql(graphqlQuery, {
      collection: collectionName
    });
  }
}
```

### **Gaming Platform Search**
```typescript
class GameSearchEngine {
  private search: NeoSearch;

  async setupGameIndexes() {
    // Player profiles and achievements
    await this.search.createIndex({
      name: 'game_players',
      type: 'user_content',
      schema: {
        fields: {
          player_id: { type: 'keyword', indexed: true },
          username: { type: 'text', analyzer: 'username_analyzer' },
          level: { type: 'number', indexed: true },
          experience_points: { type: 'number', indexed: true },
          achievements: { type: 'nested' },
          guild: { type: 'keyword', indexed: true },
          join_date: { type: 'date', indexed: true },
          last_active: { type: 'date', indexed: true }
        }
      }
    });

    // Game items and assets
    await this.search.createIndex({
      name: 'game_items',
      type: 'user_content',
      schema: {
        fields: {
          item_id: { type: 'keyword', indexed: true },
          name: { type: 'text', analyzer: 'standard' },
          type: { type: 'keyword', indexed: true },
          rarity: { type: 'keyword', indexed: true },
          stats: { type: 'nested' },
          owner: { type: 'keyword', indexed: true },
          tradeable: { type: 'boolean', indexed: true },
          market_value: { type: 'number', indexed: true }
        }
      }
    });
  }

  async findPlayers(searchCriteria: PlayerSearchCriteria) {
    return await this.search.query({
      index: 'game_players',
      query: searchCriteria.username,
      filters: {
        level: searchCriteria.levelRange,
        guild: searchCriteria.guild,
        achievements: {
          nested: {
            path: 'achievements',
            query: {
              bool: {
                must: [
                  { term: { 'achievements.type': searchCriteria.achievementType } }
                ]
              }
            }
          }
        }
      },
      facets: ['level_range', 'guild', 'achievement_count'],
      sort: [{ field: 'experience_points', order: 'desc' }]
    });
  }

  async searchGameItems(itemQuery: string, filters: any) {
    const results = await this.search.query({
      index: 'game_items',
      query: itemQuery,
      filters: {
        type: filters.itemType,
        rarity: filters.rarity,
        tradeable: filters.tradeable,
        market_value: filters.priceRange,
        stats: {
          nested: {
            path: 'stats',
            query: this.buildStatsQuery(filters.requiredStats)
          }
        }
      },
      facets: ['type', 'rarity', 'owner_count'],
      sort: [{ field: 'market_value', order: 'desc' }]
    });

    return results;
  }

  async getLeaderboards(category: string, timeframe: string) {
    const aggregationQuery = {
      index: 'game_players',
      aggs: {
        top_players: {
          terms: {
            field: 'player_id',
            size: 100,
            order: { total_score: 'desc' }
          },
          aggs: {
            total_score: {
              sum: { field: 'experience_points' }
            },
            achievements_count: {
              value_count: { field: 'achievements' }
            }
          }
        }
      }
    };

    return await this.search.aggregate(aggregationQuery);
  }
}
```

## 🔍 Troubleshooting

### **Common Issues**

#### **Slow Search Performance**
```typescript
// Optimize search performance
const optimizeSearchPerformance = async () => {
  // Use filters instead of queries when possible
  const optimizedQuery = {
    query: {
      bool: {
        filter: [
          { term: { status: 'active' } },
          { range: { price: { gte: 100 } } }
        ],
        must: [
          { match: { description: 'rare collectible' } }
        ]
      }
    }
  };

  // Enable caching for frequently used queries
  const cachedSearch = await search.query({
    ...searchParams,
    cache: true,
    cache_ttl: '5m'
  });

  return cachedSearch;
};
```

#### **Index Management**
```typescript
// Handle large datasets efficiently
const manageIndexes = async () => {
  // Use index aliases for seamless updates
  await search.createIndexAlias({
    alias: 'current_transactions',
    index: 'transactions_2024_01'
  });

  // Rotate indexes for time-series data
  await search.rotateIndex({
    pattern: 'transactions_*',
    retention_days: 90,
    new_index_settings: {
      shards: 3,
      replicas: 1
    }
  });

  // Monitor index health
  const health = await search.getIndexHealth('my_index');
  if (health.status === 'yellow') {
    console.warn('Index health degraded:', health.issues);
  }
};
```

#### **Memory and Resource Optimization**
```typescript
// Optimize for resource usage
const optimizeResources = async () => {
  // Use scroll API for large result sets
  const scrollResults = await search.scroll({
    query: largeQuery,
    scroll_size: 1000,
    scroll_timeout: '5m'
  });

  // Process results in batches
  for await (const batch of scrollResults) {
    await processBatch(batch);
  }

  // Clean up scroll context
  await search.clearScroll(scrollResults.scrollId);
};
```

## 📞 Support & Resources

- **Documentation**: [docs.neosearch.r3e.network](https://docs.neosearch.r3e.network)
- **Search Console**: [console.neosearch.r3e.network](https://console.neosearch.r3e.network)
- **API Reference**: [api.neosearch.r3e.network](https://api.neosearch.r3e.network)
- **GraphQL Playground**: [graphql.neosearch.r3e.network](https://graphql.neosearch.r3e.network)
- **Query Builder**: [builder.neosearch.r3e.network](https://builder.neosearch.r3e.network)
- **Discord Support**: [discord.gg/r3e-network](https://discord.gg/r3e-network)
- **Email**: [search@r3e.network](mailto:search@r3e.network)

---

**NeoSearch provides enterprise-grade search and indexing capabilities that enable Neo dApps to deliver fast, relevant, and scalable search experiences across all types of blockchain and user-generated data.** 