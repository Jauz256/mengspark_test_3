import '../models/founder.dart';

/// All founders data - based on real founder interviews
final List<Founder> foundersData = [
  const Founder(
    id: 'edward-tirtanata',
    name: 'Edward Tirtanata',
    company: 'Kopi Kenangan',
    photo: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=400',
    startedWith: '\$15,000',
    nowWorth: '\$1B+',
    background: 'Finance degree (Northeastern University), previously ran a failing tea business',
    setup: "Edward just watched his tea business (Lewis & Carroll) plateau after 5 stores. Premium tea at Rp40-60K/cup wasn't scaling. His family had already gone through bankruptcy once. He had limited capital and needed to find something that worked.",
    decisions: [
      FounderDecision(
        situation: '''Edward's tea chain Lewis & Carroll has 5 locations. Each store is "nowhere near as profitable" as expected. He realizes the premium tea market in Indonesia is tapped out. His friend James suggests they look at coffee instead.

Coffee seems saturated — Starbucks, local cafes, street vendors everywhere. But Edward notices something: Starbucks costs Rp40-50K (\$3-4) per cup. That's 30% of Indonesia's daily minimum wage. Street coffee costs Rp3K but tastes like instant.

What would YOU do?''',
        choices: [
          'Stay with tea — pivot to lower prices to compete better',
          'Enter coffee — but go premium to compete with Starbucks quality',
          'Enter coffee — find the gap between Starbucks and street vendors',
          'Exit F&B entirely — the market is too competitive',
        ],
        correctIndex: 2,
        whatFounderDid: 'Enter the gap between Starbucks and street vendors',
        whyItWorked: '''"If every cup of coffee costs you \$4, and you drink it for 30 days, that's exactly 1/3 of minimum wage." Edward saw that millions of Indonesians wanted better coffee than street vendors but couldn't afford Starbucks. The middle market was empty.''',
        outcome: "This positioning became Kopi Kenangan's core strategy — quality coffee at Rp18-20K (\$1.20). They found an underserved market of millions.",
      ),
      FounderDecision(
        situation: '''Edward has Rp150 million (\$15,000) to open his first coffee shop. Traditional cafes spend heavily on: rent for large spaces, comfortable seating, interior design, Wi-Fi infrastructure.

With limited capital, he can't afford a full cafe setup AND premium ingredients. He has to choose where to invest.

What would YOU do?''',
        choices: [
          'Full cafe experience — sofas, Wi-Fi, Instagram-worthy design',
          'Grab-and-go only — tiny space, no seating, invest in ingredients',
          'Hybrid — some seating but minimal, balance both',
          'Start with a cart/kiosk — even lower overhead',
        ],
        correctIndex: 1,
        whatFounderDid: 'Grab-and-go, zero seating — all money into ingredients',
        whyItWorked: '''"Instead of focusing on the sofa or fast Wi-Fi, we're gonna focus on a good, high-quality cup of coffee." He bought La Marzocco machines (thousands of dollars) and premium Greenfields milk. The tiny footprint meant lower rent and faster payback.''',
        outcome: 'First store broke even in 3 months. The grab-and-go model let them scale to 200+ locations in 2 years.',
      ),
      FounderDecision(
        situation: '''Edward's previous business was called "Lewis & Carroll" — an English name inspired by tea houses in Boston. He later admitted: "Hearing the name alone, people thought it was scary and expensive."

Most Indonesian coffee shops use foreign-sounding names to seem premium. But Edward wants to appeal to everyday Indonesians, not just expats and elites.

What would YOU do?''',
        choices: [
          'Use an English name — sounds premium and international',
          'Use an Indonesian name — relatable but might seem cheap',
          'Use a made-up/abstract name — unique but no immediate meaning',
          "Use founder's name — personal but limited",
        ],
        correctIndex: 1,
        whatFounderDid: 'Indonesian name: "Kopi Kenangan" (Coffee Memories)',
        whyItWorked: '''"I realized nobody is using an Indonesian name. The word 'kenangan' (memory/nostalgia) can trigger thoughts of unforgettable moments." The name felt warm and local. It differentiated instantly from every foreign-named competitor.''',
        outcome: 'Customers felt the brand was "for them" — not imported luxury. The name became part of viral conversations.',
      ),
      FounderDecision(
        situation: '''The first store is about to open. Edward needs to name his signature drink — a palm sugar milk coffee made with fresh milk instead of condensed milk.

Most coffee shops use generic names: Latte, Cappuccino, "House Blend." These don't stand out. Edward wants something people will talk about.

What would YOU do?''',
        choices: [
          'Descriptive name — "Palm Sugar Milk Coffee"',
          'Premium name — "Signature Reserve Blend"',
          'Funny/emotional name — something that makes people react',
          'Simple name — "Kopi Susu #1"',
        ],
        correctIndex: 2,
        whatFounderDid: 'Named it "Kopi Kenangan Mantan" (Memory of Ex-Girlfriend Coffee)',
        whyItWorked: '''"I asked James, what's the most memorable memory you have? He said: my ex-girlfriend. So we named it that." Customers started posting: "This coffee tastes like my ex — sweet at the beginning, bitter at the end." Free viral marketing.''',
        outcome: 'Zero marketing budget at launch. The name alone generated organic social media posts. First day: 700 cups sold. 60-70% came through delivery apps — people ordering just to see what "ex-girlfriend coffee" tasted like.',
      ),
      FounderDecision(
        situation: '''First store opens in Standard Chartered Tower, South Jakarta (office building location). Walk-in traffic is limited to office workers during certain hours.

Traditional cafes rely on foot traffic. But Edward notices Gojek and Grab (Indonesia's ride-hailing apps) are rapidly expanding food delivery.

What would YOU do?''',
        choices: [
          'Focus on walk-ins — build the cafe experience first',
          'Heavy delivery focus — optimize for online orders from day one',
          '50/50 split — serve both equally',
          'Delivery only — no storefront at all',
        ],
        correctIndex: 1,
        whatFounderDid: 'Heavy delivery focus from day one',
        whyItWorked: '"Almost 60-70% of first day sales came from online ojek applications." Most competitors saw delivery as secondary. Edward built his operations around it — fast prep, delivery-friendly packaging, app integration.',
        outcome: 'This became critical during COVID when 50% of stores closed temporarily. The delivery infrastructure was already built. Kopi Kenangan tripled store count during the pandemic while competitors struggled.',
      ),
    ],
  ),
];

/// Get founder by ID
Founder? getFounderById(String id) {
  try {
    return foundersData.firstWhere((f) => f.id == id);
  } catch (e) {
    return null;
  }
}
