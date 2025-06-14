#!/bin/bash

# Small Business Project Initialization Script

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Function to get user input with default value
get_input() {
    local prompt="$1"
    local default="$2"
    local variable="$3"
    
    if [ -n "$default" ]; then
        read -p "$prompt [$default]: " input
        if [ -z "$input" ]; then
            input="$default"
        fi
    else
        read -p "$prompt: " input
        while [ -z "$input" ]; do
            print_warning "This field is required"
            read -p "$prompt: " input
        done
    fi
    
    eval "$variable='$input'"
}

# Main initialization function
init_project() {
    print_header "Small Business Project Initialization"
    
    # Get project information
    get_input "Project name" "" PROJECT_NAME
    get_input "Project description" "" PROJECT_DESCRIPTION
    get_input "Target market" "" TARGET_MARKET
    get_input "Business model (SaaS/E-commerce/Service/Other)" "SaaS" BUSINESS_MODEL
    get_input "Expected team size" "5" TEAM_SIZE
    get_input "Target revenue (JPY/month)" "1000000" TARGET_REVENUE
    get_input "Development timeline (months)" "6" TIMELINE
    
    # Create project directory
    PROJECT_DIR="${PROJECT_NAME// /-}"
    PROJECT_DIR=$(echo "$PROJECT_DIR" | tr '[:upper:]' '[:lower:]')
    
    if [ -d "$PROJECT_DIR" ]; then
        print_warning "Directory $PROJECT_DIR already exists"
        get_input "Continue with existing directory? (y/n)" "n" CONTINUE
        if [ "$CONTINUE" != "y" ] && [ "$CONTINUE" != "Y" ]; then
            print_error "Project initialization cancelled"
            exit 1
        fi
    else
        mkdir -p "$PROJECT_DIR"
        print_status "Created project directory: $PROJECT_DIR"
    fi
    
    cd "$PROJECT_DIR"
    
    # Create directory structure
    print_status "Creating directory structure..."
    mkdir -p {docs,research,marketing,technical,financial,assets/{images,documents}}
    
    # Create main project file
    cat > "README.md" << EOF
# $PROJECT_NAME

## Project Overview
$PROJECT_DESCRIPTION

## Business Information
- **Target Market**: $TARGET_MARKET
- **Business Model**: $BUSINESS_MODEL
- **Expected Team Size**: $TEAM_SIZE people
- **Target Revenue**: ¥$TARGET_REVENUE/month
- **Development Timeline**: $TIMELINE months

## Project Structure
- \`docs/\` - Project documentation
- \`research/\` - Market research and analysis
- \`marketing/\` - Marketing strategy and materials
- \`technical/\` - Technical specifications and architecture
- \`financial/\` - Financial planning and projections
- \`assets/\` - Project assets (images, documents)

## Getting Started
1. Complete market research using templates in \`research/\`
2. Define personas and marketing strategy in \`marketing/\`
3. Plan technical architecture in \`technical/\`
4. Create financial projections in \`financial/\`

## Multi-Agent Development
This project is designed to work with the smallbiz-multi-agent system:
\`\`\`bash
cd path/to/smallbiz-multi-agent
./scripts/setup.sh
\`\`\`

Created on: $(date)
EOF
    
    # Create business model canvas
    cp "$(dirname "$0")/../templates/business-model-canvas.md" "docs/business-model-canvas.md"
    print_status "Created business model canvas template"
    
    # Create persona template
    cp "$(dirname "$0")/../templates/persona-template.md" "marketing/persona-template.md"
    print_status "Created persona template"
    
    # Create market research template
    cp "$(dirname "$0")/../templates/market-research-template.md" "research/market-research.md"
    print_status "Created market research template"
    
    # Create financial planning template
    cat > "financial/financial-plan.md" << EOF
# Financial Planning for $PROJECT_NAME

## Revenue Projections
### Monthly Revenue Target: ¥$TARGET_REVENUE

### Revenue Streams
1. **Primary Revenue Stream**
   - Type: [Subscription/One-time/Commission]
   - Price: ¥[amount]
   - Expected customers: [number]

2. **Secondary Revenue Stream**
   - Type: [Subscription/One-time/Commission]
   - Price: ¥[amount]
   - Expected customers: [number]

## Cost Structure
### Fixed Costs (Monthly)
- Personnel: ¥[amount]
- Infrastructure: ¥[amount]
- Office/Equipment: ¥[amount]
- Other: ¥[amount]

### Variable Costs (Monthly)
- Marketing: ¥[amount]
- Customer acquisition: ¥[amount]
- Third-party services: ¥[amount]
- Other: ¥[amount]

## Financial Projections (12 months)
| Month | Revenue | Fixed Costs | Variable Costs | Profit |
|-------|---------|-------------|----------------|--------|
| 1     | ¥       | ¥           | ¥              | ¥      |
| 2     | ¥       | ¥           | ¥              | ¥      |
| 3     | ¥       | ¥           | ¥              | ¥      |
| 6     | ¥       | ¥           | ¥              | ¥      |
| 12    | ¥       | ¥           | ¥              | ¥      |

## Break-even Analysis
- Break-even point: Month [number]
- Break-even revenue: ¥[amount]/month
- Customer acquisition needed: [number] customers

## Funding Requirements
- Initial investment: ¥[amount]
- Working capital: ¥[amount]
- Total funding needed: ¥[amount]
EOF
    
    # Create technical specification template
    cat > "technical/technical-spec.md" << EOF
# Technical Specification for $PROJECT_NAME

## System Architecture
### Technology Stack
- **Backend**: [Framework/Language]
- **Frontend**: [Framework/Language]
- **Database**: [Database type]
- **Infrastructure**: [Cloud provider]
- **Development Tools**: [Tools list]

### Deployment Strategy
- **Platform**: Cloudflare Workers (as per project standards)
- **Configuration**: wrangler.toml setup required
- **Environment Variables**: LINE Bot credentials, API keys
- **Routing**: Webhook endpoints configuration

## Development Timeline: $TIMELINE months
### Phase 1 (Month 1-2): Foundation
- [ ] Project setup and infrastructure
- [ ] Core architecture implementation
- [ ] Basic functionality development

### Phase 2 (Month 3-4): Feature Development
- [ ] Main features implementation
- [ ] User interface development
- [ ] Integration with external services

### Phase 3 (Month 5-6): Testing & Launch
- [ ] Testing and quality assurance
- [ ] Performance optimization
- [ ] Deployment and launch

## Team Requirements
- **Team Size**: $TEAM_SIZE people
- **Required Roles**:
  - Software Engineer (Full-stack)
  - Marketing/SNS Specialist
  - [Additional roles as needed]

## Technical Requirements
### Functional Requirements
1. [Requirement 1]
2. [Requirement 2]
3. [Requirement 3]

### Non-functional Requirements
- **Performance**: [Performance requirements]
- **Security**: [Security requirements]
- **Scalability**: [Scalability requirements]

## Integration Requirements
- **APIs**: [External API requirements]
- **Third-party Services**: [Service integrations]
- **Payment Processing**: [Payment requirements if applicable]
EOF
    
    # Create marketing strategy template
    cat > "marketing/marketing-strategy.md" << EOF
# Marketing Strategy for $PROJECT_NAME

## Target Market
$TARGET_MARKET

## Marketing Objectives
- **Revenue Target**: ¥$TARGET_REVENUE/month
- **Customer Acquisition**: [number] customers/month
- **Brand Awareness**: [specific goals]

## SNS Marketing Strategy
### Primary Platforms
#### Twitter/X
- **Objective**: [specific objective]
- **Content Strategy**: [content plan]
- **Posting Frequency**: [frequency]
- **Engagement Strategy**: [engagement plan]

#### Instagram
- **Objective**: [specific objective]
- **Content Strategy**: [visual content plan]
- **Posting Frequency**: [frequency]
- **Hashtag Strategy**: [hashtag plan]

#### LinkedIn (B2B focus)
- **Objective**: [professional networking]
- **Content Strategy**: [professional content]
- **Network Building**: [networking plan]

### Content Calendar
| Week | Twitter/X | Instagram | LinkedIn | Other |
|------|-----------|-----------|----------|-------|
| 1    | [content] | [content] | [content]| [content] |
| 2    | [content] | [content] | [content]| [content] |
| 3    | [content] | [content] | [content]| [content] |
| 4    | [content] | [content] | [content]| [content] |

## Customer Acquisition Strategy
### Channels
1. **Organic SNS**: [strategy]
2. **Paid Advertising**: [strategy]
3. **Content Marketing**: [strategy]
4. **Partnerships**: [strategy]

### Budget Allocation
- SNS Advertising: ¥[amount]/month
- Content Creation: ¥[amount]/month
- Influencer Partnerships: ¥[amount]/month
- Other: ¥[amount]/month

## Measurement & Analytics
### KPIs
- **Reach**: [target numbers]
- **Engagement**: [target rates]
- **Conversion**: [target rates]
- **Customer Acquisition Cost**: ¥[amount]

### Tools
- Analytics: [tool names]
- Social Media Management: [tool names]
- Customer Tracking: [tool names]
EOF
    
    # Create project checklist
    cat > "docs/project-checklist.md" << EOF
# Project Development Checklist for $PROJECT_NAME

## Phase 1: Research & Planning
### Market Research
- [ ] Complete market size analysis (TAM/SAM/SOM)
- [ ] Identify and analyze 5+ competitors
- [ ] Conduct customer interviews (minimum 10)
- [ ] Validate problem-solution fit
- [ ] Complete market research report

### Business Planning
- [ ] Define business model canvas
- [ ] Create detailed personas (2-3 primary)
- [ ] Develop value proposition
- [ ] Plan revenue streams
- [ ] Complete financial projections

### Technical Planning
- [ ] Define technical requirements
- [ ] Choose technology stack
- [ ] Design system architecture
- [ ] Estimate development effort
- [ ] Plan deployment strategy (Cloudflare Workers)

## Phase 2: Development Preparation
### Team Setup
- [ ] Recruit team members ($TEAM_SIZE people)
- [ ] Define roles and responsibilities
- [ ] Set up development environment
- [ ] Establish communication channels
- [ ] Create project management system

### Infrastructure Setup
- [ ] Set up Cloudflare Workers environment
- [ ] Configure wrangler.toml
- [ ] Set up development/staging/production environments
- [ ] Configure monitoring and logging
- [ ] Set up CI/CD pipeline

## Phase 3: MVP Development
### Core Features ($TIMELINE months timeline)
- [ ] Implement core functionality
- [ ] Develop user interface
- [ ] Integrate with external APIs
- [ ] Implement authentication/authorization
- [ ] Add basic analytics

### Testing & Quality Assurance
- [ ] Unit testing implementation
- [ ] Integration testing
- [ ] User acceptance testing
- [ ] Performance testing
- [ ] Security testing

## Phase 4: Marketing & Launch
### Pre-launch Marketing
- [ ] Create marketing materials
- [ ] Set up SNS accounts
- [ ] Build email list
- [ ] Create landing page
- [ ] Plan launch campaign

### Launch Execution
- [ ] Deploy to production
- [ ] Execute launch campaign
- [ ] Monitor system performance
- [ ] Collect user feedback
- [ ] Iterate based on feedback

## Phase 5: Growth & Optimization
### Performance Monitoring
- [ ] Track key metrics
- [ ] Monitor financial performance
- [ ] Analyze user behavior
- [ ] Optimize conversion funnel
- [ ] Plan feature improvements

### Business Development
- [ ] Expand marketing channels
- [ ] Develop partnerships
- [ ] Plan feature roadmap
- [ ] Consider scaling strategy
- [ ] Evaluate funding needs

## Success Metrics
- **Revenue**: ¥$TARGET_REVENUE/month by month [number]
- **Users**: [number] active users
- **Growth**: [percentage]% month-over-month growth
- **Team**: Maintain team of $TEAM_SIZE people
- **Timeline**: Complete MVP in $TIMELINE months

Created on: $(date)
EOF
    
    # Initialize git repository
    if [ ! -d ".git" ]; then
        git init
        cat > ".gitignore" << EOF
# Environment variables
.env
.env.local
.env.production

# Dependencies
node_modules/
venv/
__pycache__/

# Build outputs
dist/
build/
.next/

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Temporary files
*.tmp
*.temp

# Cloudflare Workers specific
.wrangler/
wrangler.toml.bak
EOF
        git add .
        git commit -m "Initial project setup for $PROJECT_NAME

- Created project structure
- Added templates for business planning
- Set up documentation framework
- Configured for Cloudflare Workers deployment"
        print_status "Initialized git repository"
    fi
    
    # Create wrangler.toml template
    cat > "wrangler.toml" << EOF
name = "${PROJECT_NAME// /-}"
main = "src/index.js"
compatibility_date = "2024-01-01"

[env.production]
name = "${PROJECT_NAME// /-}-production"

[env.staging]
name = "${PROJECT_NAME// /-}-staging"

# Environment variables (set via wrangler secret)
# EXAMPLE_SECRET = "value"

# KV Namespaces (if needed)
# [[kv_namespaces]]
# binding = "MY_KV"
# id = "your-kv-namespace-id"

# D1 Database (if needed)
# [[d1_databases]]
# binding = "DB"
# database_name = "your-database-name"
# database_id = "your-database-id"
EOF
    
    print_status "Created Cloudflare Workers configuration"
    
    # Final summary
    print_header "Project Initialization Complete!"
    echo ""
    print_status "Project: $PROJECT_NAME"
    print_status "Location: $(pwd)"
    print_status "Business Model: $BUSINESS_MODEL"
    print_status "Target Revenue: ¥$TARGET_REVENUE/month"
    print_status "Timeline: $TIMELINE months"
    echo ""
    print_status "Next Steps:"
    echo "  1. Review and complete the templates in docs/, research/, marketing/, technical/, and financial/"
    echo "  2. Start the multi-agent system: cd ../smallbiz-multi-agent && ./scripts/setup.sh"
    echo "  3. Use the project checklist in docs/project-checklist.md to track progress"
    echo "  4. Set up Cloudflare Workers: wrangler login && wrangler init"
    echo ""
    print_status "Happy building! 🚀"
}

# Check if script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    init_project
fi