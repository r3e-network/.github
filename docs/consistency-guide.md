# R3E Labs Documentation Consistency Guide

## Project Naming Standards

### Official Project Names
Use these exact names across all documentation:

1. **Neo N3 C++ Full Node** - Enterprise performance full node
2. **Neo N3 Rust Full Node** - Memory-safe modern full node  
3. **Neo N3 MCP Server** - AI-native blockchain integration
4. **Neo Rust Smart Contract DevPack** - Rust for smart contracts
5. **Neo Rust SDK** - Multi-chain Rust development
6. **OpenR3E** - Secure contract libraries for Neo N3 dApps
7. **Neo Service Layer** - Secure oracle & infrastructure platform

### Acceptable Abbreviations
Only use these in specific contexts (tables, technical diagrams):
- **C++ Node** (Technology Matrix only)
- **Rust Node** (Technology Matrix only)
- **MCP Server** (Technology Matrix only)
- **DevPack** (Never use - always full name)
- **Service Layer** (Technology Matrix only)

## Repository Names

### GitHub Repository URLs
- `neo-n3-cpp-node` → https://github.com/r3e-network/neo-n3-cpp-node
- `neo-n3-rust-node` → https://github.com/r3e-network/neo-n3-rust-node
- `neo-n3-mcp` → https://github.com/r3e-network/neo-n3-mcp
- `neo-contract-rs` → https://github.com/r3e-network/neo-contract-rs
- `NeoRust` → https://github.com/r3e-network/NeoRust
- `openr3e` → https://github.com/r3e-network/openr3e
- `neo-service-layer` → https://github.com/r3e-network/neo-service-layer

### Website URLs
- Neo N3 MCP Server: https://neomcp.xyz
- Neo Rust Smart Contract DevPack: https://neo-rust.netlify.app
- Neo Rust SDK: https://neorust.netlify.app
- OpenR3E: https://docs.openr3e.org

## Project Categories

### Core Infrastructure Projects
- Neo N3 C++ Full Node
- Neo N3 Rust Full Node

### Developer Experience Projects
- Neo N3 MCP Server
- Neo Rust Smart Contract DevPack
- Neo Rust SDK
- OpenR3E

### Enterprise Infrastructure
- Neo Service Layer

## Technology Stacks

### Consistent Technology Descriptions
- **Neo N3 C++ Full Node**: C++20, CMake, OpenSSL, Boost, RocksDB, gRPC
- **Neo N3 Rust Full Node**: Rust, Tokio, WebAssembly, Prometheus, OpenTelemetry
- **Neo N3 MCP Server**: TypeScript, Model Context Protocol, Neo N3 RPC
- **Neo Rust Smart Contract DevPack**: Rust, NeoVM, Custom compiler, Testing frameworks
- **Neo Rust SDK**: Rust, Async/await, Type-safe APIs, Connection pooling
- **OpenR3E**: C#, .NET, Neo DevPack, Security auditing tools
- **Neo Service Layer**: C#, Intel SGX, Occlum LibOS, Cryptographic proofs

## Performance Metrics

### Standardized Performance Targets
- **Neo N3 C++ Full Node**: 10,000+ TPS, <50ms block validation
- **Neo N3 Rust Full Node**: 5,000+ TPS, <100ms block validation
- **Neo N3 MCP Server**: 34 tools, 9 resources
- **OpenR3E**: 50% gas reduction, 95% test coverage
- **Neo Service Layer**: 15+ secure services with TEE

## Project Descriptions

### Core Value Propositions
Each project should be described with these key elements:

1. **Purpose**: What problem it solves
2. **Target Users**: Who benefits from it
3. **Key Features**: Main capabilities (3-4 bullet points)
4. **Technology Stack**: Technical implementation details
5. **Perfect For**: Use case examples

### Tone Guidelines
- **Professional but approachable**
- **Technical but accessible**
- **Benefit-focused, not feature-focused**
- **Consistent voice across all projects**

## Project Status Standards

### Development Status Categories
- **✅ Complete** - Feature is fully implemented and tested
- **🚧 In Progress** - Actively being developed
- **⏳ Planned** - Scheduled for future development

### Current Status (Q1 2025)
- **Neo N3 C++ Full Node**: In Development
- **Neo N3 Rust Full Node**: In Development
- **Neo N3 MCP Server**: Production
- **Neo Rust Smart Contract DevPack**: Production
- **Neo Rust SDK**: Production
- **OpenR3E**: Production
- **Neo Service Layer**: Production

## Animation and UI Standards

### Website Animation Delays
Project cards should use consistent 50ms intervals:
- Card 1: 0ms (default)
- Card 2: 50ms
- Card 3: 100ms
- Card 4: 150ms
- Card 5: 200ms
- Card 6: 250ms
- Card 7: 300ms

### Icon Assignments
- **Neo N3 C++ Full Node**: `cpu` (performance focus)
- **Neo N3 Rust Full Node**: `shield` (safety focus)
- **Neo N3 MCP Server**: `server` (service focus)
- **Neo Rust Smart Contract DevPack**: `code` (development focus)
- **Neo Rust SDK**: `package` (library focus)
- **OpenR3E**: `shield-check` (security focus)
- **Neo Service Layer**: `layers` (infrastructure focus)

## Documentation File Standards

### Required Documentation Files
Each project should have:
1. **Primary Documentation**: `docs/{project-name}.md`
2. **README Integration**: Section in `profile/README.md`
3. **Website Card**: Entry in `website/index.html`
4. **Overview Entry**: Section in `docs/project-overview.md`
5. **Checklist Entry**: Item in `CHECKLIST.md`

### Documentation Structure
```
docs/
├── project-overview.md          # Master overview of all projects
├── neo-n3-cpp-node.md          # C++ full node specification
├── neo-n3-rust-node.md         # Rust full node specification  
├── openr3e.md                  # OpenR3E secure contract libraries
├── consistency-guide.md        # This document
└── architecture-guide.md       # System architecture (future)
```

## Quality Assurance Checklist

### Before Publishing
- [ ] Project names are consistent across all files
- [ ] Repository URLs are correct and consistent
- [ ] Performance metrics match across documents
- [ ] Technology stacks are accurately described
- [ ] Animation delays are properly spaced
- [ ] Project categories are consistent
- [ ] All links are functional
- [ ] Descriptions maintain consistent tone
- [ ] Status indicators are up to date
- [ ] Total project count is accurate (7 projects)

### Regular Maintenance
- [ ] Quarterly review of project statuses
- [ ] Annual review of performance metrics
- [ ] Update links when websites change
- [ ] Maintain consistency when adding new projects
- [ ] Verify external links are still functional

## Contact Information

**Consistency Issues**: Report to [jimmy@r3e.network](mailto:jimmy@r3e.network)
**Documentation Updates**: Follow documentation-first development approach
**Review Process**: All documentation changes should be reviewed for consistency

---

**Maintaining consistency across the R3E Labs ecosystem ensures professional presentation and clear communication of our comprehensive Neo blockchain infrastructure.** 