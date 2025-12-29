import '../models/simulation.dart';
import '../models/module.dart';

/// Coffee Shop Scenarios (20 scenarios with cascading effects)
final List<Scenario> coffeeScenarios = [
  // Week 1: Opening week challenges
  const Scenario(
    id: 'coffee-w1-staff',
    week: 1,
    module: ModuleId.hr,
    urgent: false,
    situation: 'Opening day is tomorrow. Your barista calls in sick. They sound genuinely ill. Morning rush starts at 7 AM.',
    choices: [
      ScenarioChoice(
        text: 'Work the counter yourself',
        consequences: Consequences(
          cash: 0,
          reputation: 5,
          morale: -10,
          message: "You handled it, but you're exhausted. Staff sees you'll cover for them - good and bad.",
        ),
      ),
      ScenarioChoice(
        text: 'Call in a friend as emergency help',
        consequences: Consequences(
          cash: -2000,
          reputation: 0,
          morale: 5,
          message: 'Friend helped but made some mistakes. Customers noticed but were patient.',
        ),
      ),
      ScenarioChoice(
        text: 'Open late at 10 AM instead',
        consequences: Consequences(
          cash: -5000,
          reputation: -15,
          morale: 0,
          message: 'Lost the entire morning rush. Several customers posted "closed on opening day?" online.',
        ),
        triggers: ['coffee-w2-review-bad'],
      ),
      ScenarioChoice(
        text: 'Close for the day, reschedule grand opening',
        consequences: Consequences(
          cash: -8000,
          reputation: -25,
          morale: -5,
          message: 'Marketing wasted. Customers who showed up are frustrated. Word spreads.',
        ),
        triggers: ['coffee-w2-review-bad', 'coffee-w3-trust-issue'],
      ),
    ],
  ),
  const Scenario(
    id: 'coffee-w1-supplier',
    week: 1,
    module: ModuleId.operations,
    urgent: false,
    situation: 'Your coffee bean supplier offers a deal: pay 3 months upfront for 25% discount. Your budget is tight but the savings are real.',
    choices: [
      ScenarioChoice(
        text: 'Pay upfront - savings are too good',
        consequences: Consequences(
          cash: -45000,
          reputation: 0,
          morale: 0,
          message: 'Locked in good prices. But cash is now very tight for emergencies.',
        ),
        triggers: ['coffee-w4-cash-crunch'],
      ),
      ScenarioChoice(
        text: 'Negotiate for 1 month upfront, 15% discount',
        consequences: Consequences(
          cash: -18000,
          reputation: 0,
          morale: 5,
          message: 'Supplier respected the negotiation. Moderate savings, better cash flow.',
        ),
      ),
      ScenarioChoice(
        text: 'Decline - pay monthly at full price',
        consequences: Consequences(
          cash: -15000,
          reputation: 0,
          morale: 0,
          message: 'Full flexibility but higher costs. Every baht counts early on.',
        ),
      ),
      ScenarioChoice(
        text: 'Shop around for cheaper suppliers',
        consequences: Consequences(
          cash: -12000,
          reputation: -5,
          morale: 0,
          message: 'Found cheaper beans but quality is noticeably lower. Some customers comment.',
        ),
        triggers: ['coffee-w3-quality-complaint'],
      ),
    ],
  ),

  // Week 2: Building momentum or dealing with fallout
  const Scenario(
    id: 'coffee-w2-review-bad',
    week: 2,
    module: ModuleId.customerService,
    urgent: true,
    situation: 'A 1-star review appeared: "Unreliable hours, won\'t be back." It\'s getting likes. How do you respond?',
    triggeredBy: 'coffee-w1-staff',
    choices: [
      ScenarioChoice(
        text: 'Public apology + offer free drink to come back',
        consequences: Consequences(
          cash: -500,
          reputation: 10,
          morale: 5,
          message: 'Reviewer updated to 3 stars. Others commented "great response from owner."',
        ),
      ),
      ScenarioChoice(
        text: 'Respond explaining what happened professionally',
        consequences: Consequences(
          cash: 0,
          reputation: 5,
          morale: 0,
          message: "Neutral response. Some understood, some didn't care.",
        ),
      ),
      ScenarioChoice(
        text: "Ignore it - one review won't matter",
        consequences: Consequences(
          cash: 0,
          reputation: -10,
          morale: 0,
          message: 'More negative reviews piled on. "Yeah I had the same experience."',
        ),
        triggers: ['coffee-w4-reputation-spiral'],
      ),
      ScenarioChoice(
        text: 'Report the review as unfair',
        consequences: Consequences(
          cash: 0,
          reputation: -15,
          morale: -5,
          message: 'Review stayed up. Reviewer edited to add "owner tried to remove my honest review."',
        ),
      ),
    ],
  ),
  const Scenario(
    id: 'coffee-w2-pricing',
    week: 2,
    module: ModuleId.sales,
    urgent: false,
    situation: 'You\'re selling 50 cups/day but expected 80. Customers mention your prices are "a bit high" compared to the chain nearby.',
    choices: [
      ScenarioChoice(
        text: 'Drop prices 15% to compete',
        consequences: Consequences(
          cash: -8000,
          reputation: 5,
          morale: 0,
          message: 'Volume up 40% but margins crushed. Working harder for less profit.',
        ),
      ),
      ScenarioChoice(
        text: 'Keep prices, add loyalty card (10th free)',
        consequences: Consequences(
          cash: -3000,
          reputation: 10,
          morale: 5,
          message: 'Regulars love it. Repeat visits increasing. Playing the long game.',
        ),
      ),
      ScenarioChoice(
        text: 'Keep prices, improve quality/experience',
        consequences: Consequences(
          cash: -5000,
          reputation: 15,
          morale: 10,
          message: 'Word spreading about quality. Slower growth but premium positioning.',
        ),
      ),
      ScenarioChoice(
        text: 'Raise prices and position as premium',
        consequences: Consequences(
          cash: 2000,
          reputation: -10,
          morale: 0,
          message: 'Lost price-sensitive customers. Need to attract different crowd.',
        ),
        triggers: ['coffee-w4-positioning-shift'],
      ),
    ],
  ),

  // Week 3: Growing pains
  const Scenario(
    id: 'coffee-w3-quality-complaint',
    week: 3,
    module: ModuleId.product,
    urgent: false,
    situation: 'Multiple customers this week said the coffee "tastes different" or "not as good as before." Your cheaper beans are showing.',
    triggeredBy: 'coffee-w1-supplier',
    choices: [
      ScenarioChoice(
        text: 'Switch back to premium beans immediately',
        consequences: Consequences(
          cash: -8000,
          reputation: 5,
          morale: 5,
          message: 'Quality restored. Lost some margin but kept your regulars.',
        ),
      ),
      ScenarioChoice(
        text: 'Blend cheap and premium 50/50',
        consequences: Consequences(
          cash: -4000,
          reputation: 0,
          morale: 0,
          message: 'Acceptable compromise. Not great, not terrible.',
        ),
      ),
      ScenarioChoice(
        text: 'Keep cheap beans, train baristas to compensate',
        consequences: Consequences(
          cash: -1000,
          reputation: -10,
          morale: -5,
          message: "Can't train away bad beans. Complaints continue.",
        ),
        triggers: ['coffee-w5-quality-crisis'],
      ),
      ScenarioChoice(
        text: 'Create "house blend" brand, market it as unique',
        consequences: Consequences(
          cash: -2000,
          reputation: 5,
          morale: 5,
          message: "Spin worked partially. Some buy it, purists don't.",
        ),
      ),
    ],
  ),
  const Scenario(
    id: 'coffee-w3-trust-issue',
    week: 3,
    module: ModuleId.hr,
    urgent: false,
    situation: 'Your staff heard about the rocky opening. One says "I\'m not sure this place will make it." Morale is shaky.',
    triggeredBy: 'coffee-w1-staff',
    choices: [
      ScenarioChoice(
        text: 'Team meeting: share real numbers, rally together',
        consequences: Consequences(
          cash: 0,
          reputation: 0,
          morale: 20,
          message: 'Transparency built trust. Team feels invested in success now.',
        ),
      ),
      ScenarioChoice(
        text: 'Give everyone a small bonus to boost morale',
        consequences: Consequences(
          cash: -5000,
          reputation: 0,
          morale: 10,
          message: 'Appreciated but temporary fix. Need to address root concerns.',
        ),
      ),
      ScenarioChoice(
        text: 'Replace the negative person',
        consequences: Consequences(
          cash: -3000,
          reputation: 0,
          morale: -15,
          message: 'Others are now scared to speak up. Quiet resentment brewing.',
        ),
        triggers: ['coffee-w5-staff-exodus'],
      ),
      ScenarioChoice(
        text: 'Ignore it - focus on customers, not internal drama',
        consequences: Consequences(
          cash: 0,
          reputation: 0,
          morale: -10,
          message: 'Whispers continue. Atmosphere affecting customer experience.',
        ),
      ),
    ],
  ),

  // Week 4: Critical decisions
  const Scenario(
    id: 'coffee-w4-cash-crunch',
    week: 4,
    module: ModuleId.finance,
    urgent: true,
    situation: 'Rent is due in 3 days. You\'re ฿15,000 short after the supplier prepayment. Options are limited.',
    triggeredBy: 'coffee-w1-supplier',
    choices: [
      ScenarioChoice(
        text: 'Ask landlord for 1-week extension',
        consequences: Consequences(
          cash: 0,
          reputation: -5,
          morale: 0,
          message: 'Landlord agreed but noted it on your file. Trust slightly damaged.',
        ),
      ),
      ScenarioChoice(
        text: 'Personal loan from family/friends',
        consequences: Consequences(
          cash: 15000,
          reputation: 0,
          morale: -5,
          message: 'Covered this month but added personal pressure. Need to pay back.',
        ),
      ),
      ScenarioChoice(
        text: 'Put it on credit card (high interest)',
        consequences: Consequences(
          cash: 15000,
          reputation: 0,
          morale: 0,
          message: 'Immediate fix but 18% interest. Debt spiral risk.',
        ),
        triggers: ['coffee-w6-debt-pressure'],
      ),
      ScenarioChoice(
        text: 'Sell some equipment at loss',
        consequences: Consequences(
          cash: 10000,
          reputation: 0,
          morale: -10,
          message: 'Sold backup espresso machine. Hope nothing breaks now.',
        ),
      ),
    ],
  ),
  const Scenario(
    id: 'coffee-w4-reputation-spiral',
    week: 4,
    module: ModuleId.marketing,
    urgent: true,
    situation: 'Your Google rating dropped to 3.2 stars. New customers are choosing competitors. Foot traffic down 30%.',
    triggeredBy: 'coffee-w2-review-bad',
    choices: [
      ScenarioChoice(
        text: 'Launch "comeback campaign" - 50% off week',
        consequences: Consequences(
          cash: -15000,
          reputation: 15,
          morale: 5,
          message: 'Crowded but low margins. Some became regulars, most were one-timers.',
        ),
      ),
      ScenarioChoice(
        text: 'Ask loyal customers to leave honest reviews',
        consequences: Consequences(
          cash: 0,
          reputation: 10,
          morale: 5,
          message: 'Genuine reviews helped. Slow recovery but authentic.',
        ),
      ),
      ScenarioChoice(
        text: 'Hire micro-influencer for promotion',
        consequences: Consequences(
          cash: -8000,
          reputation: 20,
          morale: 5,
          message: 'Influencer post brought new crowd. Worth the investment.',
        ),
      ),
      ScenarioChoice(
        text: 'Focus on quality, let reputation recover naturally',
        consequences: Consequences(
          cash: 0,
          reputation: 5,
          morale: 0,
          message: 'Slow recovery. Cash flow suffering while waiting.',
        ),
      ),
    ],
  ),
  const Scenario(
    id: 'coffee-w4-positioning-shift',
    week: 4,
    module: ModuleId.strategy,
    urgent: false,
    situation: 'Your premium pricing pushed away casual customers. You need to attract people who value quality over price.',
    triggeredBy: 'coffee-w2-pricing',
    choices: [
      ScenarioChoice(
        text: 'Partner with nearby coworking space',
        consequences: Consequences(
          cash: -3000,
          reputation: 15,
          morale: 5,
          message: 'Steady stream of remote workers. They spend more and stay longer.',
        ),
      ),
      ScenarioChoice(
        text: 'Add specialty drinks menu (seasonal, unique)',
        consequences: Consequences(
          cash: -5000,
          reputation: 10,
          morale: 10,
          message: 'Instagram-worthy drinks bringing in new demographic.',
        ),
      ),
      ScenarioChoice(
        text: 'Host coffee tasting events',
        consequences: Consequences(
          cash: -2000,
          reputation: 20,
          morale: 5,
          message: 'Built community of coffee enthusiasts. Word-of-mouth strong.',
        ),
      ),
      ScenarioChoice(
        text: 'Reverse course - drop to competitive pricing',
        consequences: Consequences(
          cash: -10000,
          reputation: -5,
          morale: -5,
          message: 'Confusing brand message. Neither premium nor budget.',
        ),
      ),
    ],
  ),

  // Week 5: Competition arrives
  const Scenario(
    id: 'coffee-w5-competitor',
    week: 5,
    module: ModuleId.strategy,
    urgent: true,
    situation: 'A chain coffee shop is opening 50 meters away next month. They\'re advertising "Grand Opening: 50% off everything for 2 weeks."',
    choices: [
      ScenarioChoice(
        text: 'Match their discount during their opening',
        consequences: Consequences(
          cash: -20000,
          reputation: 0,
          morale: -10,
          message: "Price war hurts. They have deeper pockets. You're bleeding cash.",
        ),
        triggers: ['coffee-w7-price-war'],
      ),
      ScenarioChoice(
        text: 'Double down on community - "Support Local" campaign',
        consequences: Consequences(
          cash: -5000,
          reputation: 20,
          morale: 15,
          message: 'Neighborhood rallied. Local press covered the story. Chain is the outsider.',
        ),
      ),
      ScenarioChoice(
        text: "Differentiate - add food menu they don't have",
        consequences: Consequences(
          cash: -15000,
          reputation: 10,
          morale: 5,
          message: 'Now offering breakfast. Different value proposition.',
        ),
      ),
      ScenarioChoice(
        text: 'Do nothing - trust your regulars',
        consequences: Consequences(
          cash: 0,
          reputation: -5,
          morale: 0,
          message: 'Lost some customers to novelty. Core stayed but growth stalled.',
        ),
      ),
    ],
  ),
  const Scenario(
    id: 'coffee-w5-quality-crisis',
    week: 5,
    module: ModuleId.product,
    urgent: true,
    situation: 'A food blogger posted "Worst coffee I\'ve had in Bangkok" with photos. 500 shares and counting. Your cheap beans backfired.',
    triggeredBy: 'coffee-w3-quality-complaint',
    choices: [
      ScenarioChoice(
        text: "Invite blogger back, show you've changed",
        consequences: Consequences(
          cash: -3000,
          reputation: 15,
          morale: 5,
          message: 'Blogger updated: "They listened and improved." Redemption arc.',
        ),
      ),
      ScenarioChoice(
        text: 'Public statement: "We hear you, we\'re fixing it"',
        consequences: Consequences(
          cash: -10000,
          reputation: 5,
          morale: 0,
          message: 'Switched to premium beans. Actions speak louder than words.',
        ),
      ),
      ScenarioChoice(
        text: 'Ignore it - will blow over',
        consequences: Consequences(
          cash: 0,
          reputation: -25,
          morale: -10,
          message: 'Didn\'t blow over. Became a meme. "Bangkok\'s worst coffee shop."',
        ),
        triggers: ['coffee-w7-reputation-death'],
      ),
      ScenarioChoice(
        text: 'Threaten legal action for defamation',
        consequences: Consequences(
          cash: -5000,
          reputation: -30,
          morale: -15,
          message: 'Streisand effect. Now it\'s "coffee shop that threatens customers."',
        ),
      ),
    ],
  ),
  const Scenario(
    id: 'coffee-w5-staff-exodus',
    week: 5,
    module: ModuleId.hr,
    urgent: true,
    situation: 'Your two best employees are leaving. They found jobs at the new chain for 20% more pay. You have 1 week notice.',
    triggeredBy: 'coffee-w3-trust-issue',
    choices: [
      ScenarioChoice(
        text: 'Match the salary increase',
        consequences: Consequences(
          cash: -8000,
          reputation: 0,
          morale: 15,
          message: 'Expensive but kept your trained team. They feel valued.',
        ),
      ),
      ScenarioChoice(
        text: 'Counter with smaller raise + ownership stake',
        consequences: Consequences(
          cash: -4000,
          reputation: 0,
          morale: 20,
          message: "They're now invested in success. Loyalty strengthened.",
        ),
      ),
      ScenarioChoice(
        text: 'Let them go, hire replacements',
        consequences: Consequences(
          cash: -5000,
          reputation: -10,
          morale: -10,
          message: 'Training new staff takes weeks. Quality dropped. Customers noticed.',
        ),
        triggers: ['coffee-w7-service-quality-drop'],
      ),
      ScenarioChoice(
        text: 'Guilt trip them about loyalty',
        consequences: Consequences(
          cash: 0,
          reputation: 0,
          morale: -20,
          message: "They left anyway, plus told others you're manipulative. Bad rep.",
        ),
      ),
    ],
  ),

  // Week 6: Make or break
  const Scenario(
    id: 'coffee-w6-debt-pressure',
    week: 6,
    module: ModuleId.finance,
    urgent: true,
    situation: 'Credit card bill arrived: ฿18,000 with interest. Rent due again in 2 weeks. You\'re in a debt spiral.',
    triggeredBy: 'coffee-w4-cash-crunch',
    choices: [
      ScenarioChoice(
        text: 'Take small business loan to consolidate',
        consequences: Consequences(
          cash: 50000,
          reputation: 0,
          morale: 5,
          message: 'Breathing room but now have loan payments. Need to grow revenue.',
        ),
      ),
      ScenarioChoice(
        text: 'Drastic cost cuts - reduce hours, staff',
        consequences: Consequences(
          cash: 15000,
          reputation: -10,
          morale: -15,
          message: 'Saved money but fewer customers, unhappy staff. Downward spiral.',
        ),
        triggers: ['coffee-w8-death-spiral'],
      ),
      ScenarioChoice(
        text: 'Launch crowdfunding/pre-sale campaign',
        consequences: Consequences(
          cash: 25000,
          reputation: 10,
          morale: 10,
          message: 'Community supported you. Pressure to deliver on promises.',
        ),
      ),
      ScenarioChoice(
        text: 'Find investor/partner',
        consequences: Consequences(
          cash: 100000,
          reputation: 5,
          morale: 5,
          message: 'Got funding but gave up 30% equity. Not your solo dream anymore.',
        ),
      ),
    ],
  ),
  const Scenario(
    id: 'coffee-w6-opportunity',
    week: 6,
    module: ModuleId.partnerships,
    urgent: false,
    situation: "A delivery app wants you as exclusive partner. They'll waive fees for 3 months but you can't be on other apps.",
    choices: [
      ScenarioChoice(
        text: 'Accept exclusive deal',
        consequences: Consequences(
          cash: 10000,
          reputation: 5,
          morale: 0,
          message: 'Good fee savings but limited reach. Dependent on one platform.',
        ),
      ),
      ScenarioChoice(
        text: 'Counter: non-exclusive with reduced fees',
        consequences: Consequences(
          cash: 5000,
          reputation: 0,
          morale: 5,
          message: 'They agreed to 50% fee reduction, non-exclusive. Best of both.',
        ),
      ),
      ScenarioChoice(
        text: 'Decline - focus on walk-in customers',
        consequences: Consequences(
          cash: 0,
          reputation: 0,
          morale: 0,
          message: 'Missed delivery trend. Competitors getting those orders.',
        ),
      ),
      ScenarioChoice(
        text: 'Build your own delivery with Line/WhatsApp',
        consequences: Consequences(
          cash: -3000,
          reputation: 10,
          morale: 5,
          message: 'More work but no commission fees. Direct customer relationships.',
        ),
      ),
    ],
  ),

  // Week 7-8: Consequences compound
  const Scenario(
    id: 'coffee-w7-price-war',
    week: 7,
    module: ModuleId.finance,
    urgent: true,
    situation: "The price war continues. You're losing ฿500/day. The chain shows no signs of stopping their promotions.",
    triggeredBy: 'coffee-w5-competitor',
    choices: [
      ScenarioChoice(
        text: 'End the price war, return to normal prices',
        consequences: Consequences(
          cash: 5000,
          reputation: -5,
          morale: 5,
          message: 'Stopped bleeding. Lost price-sensitive customers but margins recovered.',
        ),
      ),
      ScenarioChoice(
        text: 'Go harder - 70% off everything',
        consequences: Consequences(
          cash: -25000,
          reputation: 0,
          morale: -15,
          message: "Unsustainable. You're racing to bankruptcy.",
        ),
        triggers: ['coffee-w8-near-death'],
      ),
      ScenarioChoice(
        text: 'Pivot completely - become evening bar/cafe',
        consequences: Consequences(
          cash: -10000,
          reputation: 15,
          morale: 10,
          message: 'Different market, no competition. Risky but innovative.',
        ),
      ),
      ScenarioChoice(
        text: 'Merge with another local cafe for strength',
        consequences: Consequences(
          cash: 0,
          reputation: 5,
          morale: 0,
          message: 'Combined resources. Shared identity challenge but more resilient.',
        ),
      ),
    ],
  ),
  const Scenario(
    id: 'coffee-w7-reputation-death',
    week: 7,
    module: ModuleId.marketing,
    urgent: true,
    situation: 'You\'re known as "Bangkok\'s worst coffee shop." Google reviews: 2.1 stars. Foot traffic near zero.',
    triggeredBy: 'coffee-w5-quality-crisis',
    choices: [
      ScenarioChoice(
        text: 'Complete rebrand - new name, new everything',
        consequences: Consequences(
          cash: -30000,
          reputation: 0,
          morale: 5,
          message: 'Starting fresh but lost all previous brand building. Expensive reset.',
        ),
      ),
      ScenarioChoice(
        text: 'Close for 2 weeks, reopen with "Under New Management"',
        consequences: Consequences(
          cash: -15000,
          reputation: 10,
          morale: 0,
          message: 'Some believed the change. Skeptics remain. Partial recovery.',
        ),
      ),
      ScenarioChoice(
        text: 'Lean into it - "Most Hated Coffee Shop" ironic marketing',
        consequences: Consequences(
          cash: -5000,
          reputation: 25,
          morale: 15,
          message: 'Curiosity brought people in. Some stayed. Viral redemption.',
        ),
      ),
      ScenarioChoice(
        text: 'Accept defeat, start planning exit',
        consequences: Consequences(
          cash: 0,
          reputation: 0,
          morale: -25,
          message: "Team senses you've given up. Self-fulfilling prophecy.",
        ),
        triggers: ['coffee-w8-death-spiral'],
      ),
    ],
  ),
  const Scenario(
    id: 'coffee-w7-service-quality-drop',
    week: 7,
    module: ModuleId.operations,
    urgent: false,
    situation: 'New staff is struggling. Wait times doubled. Regular customers are getting frustrated.',
    triggeredBy: 'coffee-w5-staff-exodus',
    choices: [
      ScenarioChoice(
        text: 'Intensive training week - close early to practice',
        consequences: Consequences(
          cash: -5000,
          reputation: 5,
          morale: 10,
          message: 'Short-term pain, long-term gain. Team improving.',
        ),
      ),
      ScenarioChoice(
        text: 'Simplify menu to speed up service',
        consequences: Consequences(
          cash: 0,
          reputation: 0,
          morale: 5,
          message: 'Faster service but lost unique items. Trade-off.',
        ),
      ),
      ScenarioChoice(
        text: 'Hire experienced manager to run floor',
        consequences: Consequences(
          cash: -15000,
          reputation: 10,
          morale: 5,
          message: 'Professional operations now. Expensive but worth it.',
        ),
      ),
      ScenarioChoice(
        text: "Just push through - they'll learn eventually",
        consequences: Consequences(
          cash: 0,
          reputation: -15,
          morale: -5,
          message: 'Eventually is too late. Regulars found alternatives.',
        ),
      ),
    ],
  ),

  // Week 8: Final scenarios
  const Scenario(
    id: 'coffee-w8-near-death',
    week: 8,
    module: ModuleId.strategy,
    urgent: true,
    situation: 'Cash: Almost zero. Reputation: Damaged. You have enough for 1 more week of operations.',
    triggeredBy: 'coffee-w7-price-war',
    choices: [
      ScenarioChoice(
        text: 'All-in marketing push - last stand',
        consequences: Consequences(
          cash: -10000,
          reputation: 20,
          morale: 10,
          message: 'Went viral for the hustle. Community showed up. Survived another month.',
        ),
      ),
      ScenarioChoice(
        text: 'Negotiate with landlord - swap equity for rent relief',
        consequences: Consequences(
          cash: 20000,
          reputation: 0,
          morale: 0,
          message: "Landlord now owns 25%. You're still operating but not fully in control.",
        ),
      ),
      ScenarioChoice(
        text: 'Close gracefully - pay debts, keep reputation',
        consequences: Consequences(
          cash: 0,
          reputation: 10,
          morale: 0,
          message: 'Ended on your terms. Learned lessons. Door open for future ventures.',
        ),
      ),
      ScenarioChoice(
        text: 'Ghost everything - disappear',
        consequences: Consequences(
          cash: 0,
          reputation: -50,
          morale: -30,
          message: 'Burned bridges. Legal issues. Personal reputation destroyed.',
        ),
      ),
    ],
  ),
  const Scenario(
    id: 'coffee-w8-death-spiral',
    week: 8,
    module: ModuleId.finance,
    urgent: true,
    situation: "You can't make rent or payroll. Suppliers are calling. It's over unless something changes dramatically.",
    triggeredBy: 'coffee-w6-debt-pressure',
    choices: [
      ScenarioChoice(
        text: 'Emergency family loan',
        consequences: Consequences(
          cash: 50000,
          reputation: 0,
          morale: -10,
          message: 'Saved but at what personal cost? Pressure is immense.',
        ),
      ),
      ScenarioChoice(
        text: 'Declare bankruptcy, close shop',
        consequences: Consequences(
          cash: 0,
          reputation: -10,
          morale: -20,
          message: 'Legal protection but personal failure. Business is over.',
        ),
      ),
      ScenarioChoice(
        text: 'Sell to the chain competitor',
        consequences: Consequences(
          cash: 30000,
          reputation: 0,
          morale: -15,
          message: 'They bought your location. You got something. Pride hurts.',
        ),
      ),
      ScenarioChoice(
        text: 'Hail Mary: reality show pitch about struggling cafe',
        consequences: Consequences(
          cash: 0,
          reputation: 30,
          morale: 20,
          message: 'Against all odds, a producer is interested. Story continues...',
        ),
      ),
    ],
  ),
];

/// Get scenarios adapted for business type
List<Scenario> getScenarios(BusinessSetup setup) {
  return coffeeScenarios
      .map((s) => s.adaptForBusinessType(setup.type))
      .toList();
}

/// Get scenarios for a specific week, including triggered ones
List<Scenario> getScenariosForWeek(
  List<Scenario> allScenarios,
  int week,
  List<String> triggeredIds,
) {
  final weekScenarios = allScenarios.where((s) => s.week == week).toList();
  final triggered = allScenarios.where((s) =>
      s.triggeredBy != null && triggeredIds.contains(s.id)).toList();
  
  // Combine and dedupe
  final combined = {...weekScenarios, ...triggered}.toList();
  
  // Sort: urgent first
  combined.sort((a, b) => (b.urgent ? 1 : 0) - (a.urgent ? 1 : 0));
  
  return combined;
}

/// Constants
const int maxWeeks = 8;
