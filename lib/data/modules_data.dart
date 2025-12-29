import '../models/module.dart';

/// All learning modules with flashcards
final List<Module> modulesData = [
  const Module(
    id: ModuleId.finance,
    name: 'Finance',
    icon: '💰',
    flashcards: [
      Flashcard(
        front: 'What is Cash Flow?',
        back: 'Money moving in and out of your business. Positive = more coming in. Negative = more going out.',
        example: 'You make ฿100K/month but spend ฿120K → Negative cash flow of ฿20K',
      ),
      Flashcard(
        front: 'What is Burn Rate?',
        back: 'How fast you spend money each month when not profitable yet.',
        example: '฿150K in bank, spending ฿50K/month = 3 months runway',
      ),
      Flashcard(
        front: 'What is Break-Even Point?',
        back: 'When revenue equals costs. No profit, no loss.',
        example: 'Fixed costs ฿30K + selling at ฿100/unit with ฿40 cost = need 500 sales to break even',
      ),
      Flashcard(
        front: 'What is Profit Margin?',
        back: 'Percentage of revenue that becomes profit after costs.',
        example: 'Sell coffee at ฿80, costs ฿30 to make = ฿50 profit = 62.5% margin',
      ),
      Flashcard(
        front: 'Fixed vs Variable Costs?',
        back: 'Fixed: Same every month (rent). Variable: Changes with sales (ingredients).',
        example: 'Rent ฿25K (fixed) + Coffee beans ฿15/cup (variable)',
      ),
    ],
  ),
  const Module(
    id: ModuleId.marketing,
    name: 'Marketing',
    icon: '📢',
    flashcards: [
      Flashcard(
        front: 'What is CAC?',
        back: 'Customer Acquisition Cost. How much you spend to get one new customer.',
        example: 'Spend ฿10K on ads, get 50 customers = ฿200 CAC',
      ),
      Flashcard(
        front: 'What is LTV?',
        back: 'Lifetime Value. Total money a customer spends with you over time.',
        example: 'Customer buys ฿80 coffee 3x/week for 1 year = ฿12,480 LTV',
      ),
      Flashcard(
        front: 'LTV:CAC Ratio?',
        back: 'How much value you get vs cost to acquire. 3:1 or higher is healthy.',
        example: 'LTV ฿12K, CAC ฿200 = 60:1 ratio (excellent)',
      ),
      Flashcard(
        front: 'What is Conversion Rate?',
        back: 'Percentage of people who take desired action (buy, sign up, etc).',
        example: '1000 see your ad, 30 buy = 3% conversion rate',
      ),
      Flashcard(
        front: 'Organic vs Paid Marketing?',
        back: 'Organic: Free reach (SEO, word-of-mouth). Paid: Spend money for reach (ads).',
        example: 'Instagram post (organic) vs Facebook Ad (paid)',
      ),
    ],
  ),
  const Module(
    id: ModuleId.hr,
    name: 'HR & Team',
    icon: '👥',
    flashcards: [
      Flashcard(
        front: 'True Cost of an Employee?',
        back: 'Salary + benefits + training + equipment + management time. Usually 1.3-1.5x salary.',
        example: '฿20K salary → real cost ฿26-30K/month',
      ),
      Flashcard(
        front: 'What is Employee Morale?',
        back: 'How motivated and satisfied your team feels. Low morale = low productivity + quitting.',
        example: 'Overworked staff → mistakes → customers complain → more stress',
      ),
      Flashcard(
        front: 'Cost of Turnover?',
        back: 'Losing an employee costs 50-200% of their salary (recruiting, training, lost productivity).',
        example: 'Barista quits → 2 weeks finding replacement + 1 month training',
      ),
      Flashcard(
        front: 'When to Hire vs Outsource?',
        back: 'Hire: Core skills, long-term need. Outsource: Specialized, temporary, or non-core.',
        example: 'Hire: Barista (core). Outsource: Accountant (specialized)',
      ),
      Flashcard(
        front: 'What is Culture Fit?',
        back: 'How well someone matches your company values and work style.',
        example: 'Fast-paced startup needs self-starters, not people who wait for instructions',
      ),
    ],
  ),
  const Module(
    id: ModuleId.operations,
    name: 'Operations',
    icon: '📦',
    flashcards: [
      Flashcard(
        front: 'What is Inventory Turnover?',
        back: 'How many times you sell through inventory per year. Higher = better cash flow.',
        example: 'Coffee beans: Buy ฿10K/month, sell through monthly = 12x turnover',
      ),
      Flashcard(
        front: 'Just-in-Time vs Buffer Stock?',
        back: 'JIT: Order only what you need. Buffer: Keep extra for unexpected demand.',
        example: 'JIT saves money but risky if supplier delays. Buffer costs more but safer.',
      ),
      Flashcard(
        front: 'What is a Bottleneck?',
        back: 'The slowest part of your process that limits total output.',
        example: 'Can make 100 coffees/hour but cashier can only process 60 orders',
      ),
      Flashcard(
        front: 'Quality vs Speed Trade-off?',
        back: 'Faster often means lower quality. Find the balance customers accept.',
        example: 'Latte art takes 30 sec. Skip it during rush? Depends on brand promise.',
      ),
      Flashcard(
        front: 'Supplier Dependency Risk?',
        back: 'Relying on one supplier is risky. They can raise prices or fail to deliver.',
        example: 'Single milk supplier raises prices 30% → your margins collapse',
      ),
    ],
  ),
  const Module(
    id: ModuleId.legal,
    name: 'Legal',
    icon: '📄',
    flashcards: [
      Flashcard(
        front: 'Business Licenses Needed?',
        back: 'Varies by business: Food license, VAT registration, company registration, etc.',
        example: 'Coffee shop: Food safety cert + business license + health inspection',
      ),
      Flashcard(
        front: 'What is Liability?',
        back: 'Legal responsibility for damages. Can be personal or limited to company.',
        example: 'Customer gets sick → who pays? You personally or just the company?',
      ),
      Flashcard(
        front: 'Contract Basics?',
        back: 'Written agreement defining obligations. Always get important deals in writing.',
        example: 'Landlord promises 2-year rent freeze → get it in the lease contract',
      ),
      Flashcard(
        front: 'Employment Law Basics?',
        back: 'Minimum wage, overtime, leave policies, termination rules vary by country.',
        example: 'Thailand: 15 days notice for termination, severance after 120 days',
      ),
      Flashcard(
        front: 'IP Protection?',
        back: 'Trademarks (brand), patents (inventions), copyrights (content). Register to protect.',
        example: 'Register your business name as trademark before someone else does',
      ),
    ],
  ),
  const Module(
    id: ModuleId.sales,
    name: 'Sales',
    icon: '🛒',
    flashcards: [
      Flashcard(
        front: 'What is a Sales Funnel?',
        back: 'Journey from awareness → interest → decision → purchase. People drop off at each stage.',
        example: '1000 see ad → 100 visit → 30 try sample → 10 become regulars',
      ),
      Flashcard(
        front: 'Pricing Psychology?',
        back: '฿99 feels much cheaper than ฿100. Anchor high, discount down. Bundle for value.',
        example: 'Show ฿150 crossed out, now ฿99 feels like a deal',
      ),
      Flashcard(
        front: 'Upselling vs Cross-selling?',
        back: 'Upsell: Bigger version. Cross-sell: Related items.',
        example: 'Upsell: "Make it large?" Cross-sell: "Add a pastry?"',
      ),
      Flashcard(
        front: 'What is Churn?',
        back: 'Percentage of customers who stop buying. Lower churn = more stable revenue.',
        example: '100 customers, 10 leave this month = 10% monthly churn',
      ),
      Flashcard(
        front: 'Repeat vs New Customers?',
        back: 'Keeping existing customers 5-25x cheaper than acquiring new ones.',
        example: 'Loyalty card → 10th coffee free → customer keeps coming back',
      ),
    ],
  ),
  const Module(
    id: ModuleId.product,
    name: 'Product',
    icon: '🛠',
    flashcards: [
      Flashcard(
        front: 'What is MVP?',
        back: 'Minimum Viable Product. Smallest version that delivers core value to test the market.',
        example: 'Coffee cart before full cafe → test demand with low investment',
      ),
      Flashcard(
        front: 'What is Product-Market Fit?',
        back: 'When your product strongly satisfies market demand. People actively want it.',
        example: 'Customers tell friends, retention is high, growth is organic',
      ),
      Flashcard(
        front: 'Feature Creep?',
        back: 'Adding too many features that dilute focus and increase complexity.',
        example: '15 coffee options confuses customers. Better: 5 great options.',
      ),
      Flashcard(
        front: 'Iteration vs Pivot?',
        back: 'Iterate: Small improvements. Pivot: Fundamental change in direction.',
        example: 'New flavor = iteration. Switch from cafe to coffee delivery = pivot.',
      ),
      Flashcard(
        front: 'Quality vs Speed to Market?',
        back: "Launch fast to learn, but not so bad it damages reputation.",
        example: 'Soft launch to friends first, fix issues, then grand opening',
      ),
    ],
  ),
  const Module(
    id: ModuleId.partnerships,
    name: 'Partnerships',
    icon: '🤝',
    flashcards: [
      Flashcard(
        front: 'Equity Split with Co-founders?',
        back: 'Based on contribution: idea, money, time, skills. Vest over time (usually 4 years).',
        example: '50/50 split with 4-year vesting → leave after 1 year = keep 12.5%',
      ),
      Flashcard(
        front: 'Strategic Partnership vs Vendor?',
        back: 'Partner: Shared goals, mutual benefit. Vendor: Transactional, you pay for service.',
        example: 'Partner: Cross-promote with gym. Vendor: Buy beans from supplier.',
      ),
      Flashcard(
        front: 'Partnership Red Flags?',
        back: 'Misaligned goals, unclear roles, no exit terms, different work ethics.',
        example: 'Partner wants slow growth, you want fast → conflict guaranteed',
      ),
      Flashcard(
        front: 'Dependency Risk?',
        back: 'Too reliant on one partner = vulnerable if relationship ends.',
        example: '80% revenue from one corporate client → they leave, you collapse',
      ),
      Flashcard(
        front: 'Written Agreements?',
        back: 'Always document: roles, equity, decisions, exits. "Trust but verify."',
        example: 'Friends start business, no contract → fight over money later',
      ),
    ],
  ),
  const Module(
    id: ModuleId.customerService,
    name: 'Customer Service',
    icon: '💬',
    flashcards: [
      Flashcard(
        front: 'Cost of Bad Review?',
        back: 'One bad review can cost 30 potential customers. Online reputation is critical.',
        example: '1-star Google review visible to everyone searching for you',
      ),
      Flashcard(
        front: 'Service Recovery Paradox?',
        back: 'Customers who had a problem resolved well become MORE loyal than those who never had issues.',
        example: 'Wrong order → free replacement + apology → customer loves you more',
      ),
      Flashcard(
        front: 'Response Time Expectations?',
        back: 'Social media: 1 hour. Email: 24 hours. Phone: immediate. Slow = lost trust.',
        example: 'Complaint on Facebook unanswered for 2 days → public embarrassment',
      ),
      Flashcard(
        front: 'When to Refund?',
        back: 'When cost of fighting < cost of bad review + lost customer lifetime value.',
        example: '฿80 refund vs angry customer telling 10 friends → refund is cheaper',
      ),
      Flashcard(
        front: 'Feedback Loop?',
        back: 'Collect complaints → identify patterns → fix root cause → prevent future issues.',
        example: '5 complaints about slow service → hire more staff during peak hours',
      ),
    ],
  ),
  const Module(
    id: ModuleId.facilities,
    name: 'Facilities',
    icon: '🏢',
    flashcards: [
      Flashcard(
        front: 'Location Economics?',
        back: 'High foot traffic = high rent but more customers. Calculate revenue potential vs cost.',
        example: 'Mall: ฿80K rent, 500 customers/day. Side street: ฿20K rent, 50 customers/day.',
      ),
      Flashcard(
        front: 'Lease Terms to Watch?',
        back: 'Length, rent increases, renovation rules, subletting, early termination.',
        example: '3-year lease with 10% annual increase → Year 3 rent 21% higher',
      ),
      Flashcard(
        front: 'Build-out Costs?',
        back: 'Converting empty space to your business. Can be ฿100K-1M+ depending on needs.',
        example: 'Coffee shop: Plumbing, electrical, counters, equipment installation',
      ),
      Flashcard(
        front: 'When to Expand?',
        back: 'When current location is consistently at capacity AND you have systems to replicate.',
        example: 'Line out the door daily + documented recipes + trained manager = ready',
      ),
      Flashcard(
        front: 'Work from Home vs Office?',
        back: 'WFH: Lower cost, flexible. Office: Team culture, client meetings, focus.',
        example: 'E-commerce: Start WFH. Scale to warehouse when inventory grows.',
      ),
    ],
  ),
  const Module(
    id: ModuleId.technology,
    name: 'Technology',
    icon: '💻',
    flashcards: [
      Flashcard(
        front: 'Build vs Buy?',
        back: 'Build: Custom but expensive. Buy: Cheaper but less flexible. Buy first, build later.',
        example: 'Use Shopify (buy) before custom website (build)',
      ),
      Flashcard(
        front: 'Tech Debt?',
        back: 'Quick fixes now that create problems later. Like financial debt but with code/systems.',
        example: 'Manual inventory tracking → works for 10 items, nightmare at 1000',
      ),
      Flashcard(
        front: 'Automation ROI?',
        back: 'Calculate: Hours saved × hourly cost × months. Worth it if > tool cost.',
        example: 'Tool costs ฿500/month, saves 10 hours at ฿100/hour = ฿1000 saved',
      ),
      Flashcard(
        front: 'Data Security Basics?',
        back: 'Customer data is your responsibility. Breaches = fines + lost trust.',
        example: 'Store passwords hashed, use HTTPS, backup regularly',
      ),
      Flashcard(
        front: 'Offline Backup Plan?',
        back: 'What happens when internet/POS/systems go down? Have manual backup.',
        example: 'WiFi dies → can you still take cash and record orders on paper?',
      ),
    ],
  ),
  const Module(
    id: ModuleId.strategy,
    name: 'Strategy',
    icon: '📊',
    flashcards: [
      Flashcard(
        front: 'When to Pivot?',
        back: "When data shows current path won't work, not just when it's hard.",
        example: '6 months, 0 traction, tried 5 approaches → maybe wrong product',
      ),
      Flashcard(
        front: 'Competition Response?',
        back: "Don't react to every move. Focus on your strengths, not their weaknesses.",
        example: 'Competitor drops prices → you improve quality instead of matching',
      ),
      Flashcard(
        front: 'Growth vs Profitability?',
        back: 'Growth burns cash for market share. Profit is sustainable. Balance depends on stage.',
        example: 'Early: Grow to capture market. Later: Optimize for profit.',
      ),
      Flashcard(
        front: 'First Mover vs Fast Follower?',
        back: 'First: High risk, define market. Follower: Learn from their mistakes, execute better.',
        example: "Facebook wasn't first social network. They just did it better.",
      ),
      Flashcard(
        front: 'Exit Strategy?',
        back: 'How you eventually leave: Sell, IPO, hand to family, close. Plan affects decisions.',
        example: 'Want to sell in 5 years → build systems that work without you',
      ),
    ],
  ),
];

/// Get module by ID
Module? getModuleById(ModuleId id) {
  try {
    return modulesData.firstWhere((m) => m.id == id);
  } catch (e) {
    return null;
  }
}

/// Calculate module progress percentage
double getModuleProgress(List<ModuleId> completedModules) {
  return (completedModules.length / modulesData.length) * 100;
}
