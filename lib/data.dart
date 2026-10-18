class Link {
  final String label, url;
  const Link(this.label, this.url);
}

class Cred {
  final String name, emoji, who, how, caution;
  final List<Link> find;
  final List<String> check;
  final List<Link> sources;
  const Cred(this.name, this.emoji, this.who, this.how, this.caution, this.find, this.check, this.sources);
}

const creds = <Cred>[
  Cred(
    'OSHA 10 / 30-hour', '🦺',
    'OSHA-authorized trainers (in person) and OSHA-authorized online providers. OSHA lists them on its own site.',
    'Take the class from an OSHA-authorized trainer, or online from one of the providers OSHA lists.',
    'OSHA says it "cannot validate training offered by vendors other than those listed" on its online providers page.',
    [Link('OSHA: Find a trainer (classroom)', 'https://www.osha.gov/training/outreach/find-a-trainer/'), Link('OSHA: Authorized online providers', 'https://www.osha.gov/training/outreach/training-providers')],
    ['Is the provider on OSHA\'s online providers page, or is the trainer found through OSHA\'s Find a Trainer?', 'Is it the Construction course, not General Industry? Check the course name.', 'Open OSHA\'s page yourself. Do not rely on a logo or claim on the provider\'s own site.'],
    [Link('OSHA authorized online providers', 'https://www.osha.gov/training/outreach/training-providers'), Link('OSHA Find a Trainer', 'https://www.osha.gov/training/outreach/find-a-trainer/')],
  ),
  Cred(
    'Forklift operator', '🏗️',
    'Your employer. Under OSHA 1910.178(l) the employer certifies that each operator was trained and evaluated.',
    'Training plus an evaluation, then the employer writes the certification. There is no federal list of forklift "card" issuers.',
    'A card from an outside class may help, but the rule puts the certification on the employer.',
    [Link('OSHA 1910.178 (powered industrial trucks)', 'https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.178')],
    ['Does the certification show your name, the training date, the evaluation date and who trained or evaluated you? The rule lists these.', 'Was the evaluation done on the type of truck you will use? Ask the employer.', 'Keep a copy. A new employer may need to evaluate you again.'],
    [Link('OSHA 1910.178(l)', 'https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.178')],
  ),
  Cred(
    'Crane operator (NCCCO)', '🏗',
    'NCCCO, the National Commission for the Certification of Crane Operators. It runs the exams and lists practical test sites.',
    'Pass NCCCO written and practical exams. The practical exam is taken at a listed test site.',
    'Test sites are listed by NCCCO. Check availability there, nothing is booked from this app.',
    [Link('NCCCO: Find practical test sites', 'https://nccco.org/nccco/get-cco-certified/find-cco-test-locations/find-practical-test-sites')],
    ['Is the test site on NCCCO\'s own list?', 'Does the program match the crane type you operate? See NCCCO\'s certification programs.', 'Ask NCCCO, not the training company, whether a certification is current.'],
    [Link('NCCCO practical test sites', 'https://nccco.org/nccco/get-cco-certified/find-cco-test-locations/find-practical-test-sites')],
  ),
  Cred(
    'Certified welder (AWS)', '🔥',
    'AWS, the American Welding Society. Testing happens at an AWS Accredited Test Facility.',
    'Find an Accredited Test Facility with the AWS locator, then take the welding test there.',
    'Testing for a specific code or process is set by the test facility and AWS. Ask which one you need.',
    [Link('AWS: Accredited Test Facility locator', 'https://my.aws.org/certification/atflocator')],
    ['Is the facility in the AWS ATF locator?', 'Does the test match the code or process your employer asked for?', 'Ask what you receive afterwards and how it is verified.'],
    [Link('AWS ATF locator', 'https://my.aws.org/certification/atflocator')],
  ),
  Cred(
    'NCCER craft credential', '🧰',
    'NCCER through its accredited training centers (sponsors).',
    'Enrol in an NCCER-accredited center for the craft and level. NCCER has a center finder.',
    'Centers differ by craft. Ask the center which crafts and levels it runs.',
    [Link('NCCER: Find a center', 'https://www.nccer.org/find-a-center/')],
    ['Is the center on NCCER\'s Find a Center page?', 'Does it run your craft and level?', 'Ask how your completion is recorded with NCCER.'],
    [Link('NCCER Find a Center', 'https://www.nccer.org/find-a-center/')],
  ),
  Cred(
    'Apprenticeship', '🎓',
    'Program sponsors: unions, contractor associations and employers. Registered programs are listed on Apprenticeship.gov.',
    'Search the Apprenticeship.gov job finder for registered programs near you, then apply to the sponsor.',
    'Program requirements differ by type and region (BLS).',
    [Link('Apprenticeship.gov: job finder', 'https://www.apprenticeship.gov/apprenticeship-job-finder'), Link('CareerOneStop: certification finder', 'https://www.careeronestop.org/Toolkit/Training/find-certifications.aspx')],
    ['Is the program on Apprenticeship.gov?', 'Does it say how many training hours and pay steps it has?', 'Ask the sponsor what credential you receive at the end.'],
    [Link('Apprenticeship.gov job finder', 'https://www.apprenticeship.gov/apprenticeship-job-finder'), Link('CareerOneStop certification finder', 'https://www.careeronestop.org/Toolkit/Training/find-certifications.aspx')],
  ),
];

class Claim {
  final String said, verdict, why;
  final bool flag;
  final Link? src;
  const Claim(this.said, this.flag, this.verdict, this.why, [this.src]);
}

const claims = <Claim>[
  Claim('"We are an official DOL / OSHA card provider" for an online course (not on OSHA\'s online list)', true, 'Check before you pay',
      'OSHA lists its authorized online providers and says it cannot validate training from vendors that are not on that list. This list is for online courses. For a classroom course, use OSHA Find a Trainer instead. A website describing itself as official is a claim, not proof.',
      Link('OSHA authorized online providers', 'https://www.osha.gov/training/outreach/training-providers')),
  Claim('"Pay today, your forklift card is instant, no hands-on test"', true, 'Check before you pay',
      'OSHA 1910.178(l) requires training and an evaluation, and the employer certifies it. A card with no evaluation does not match what the rule describes.',
      Link('OSHA 1910.178', 'https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.178')),
  Claim('Provider is on OSHA\'s online providers page', false, 'Good sign, still read the course name',
      'OSHA says its listed providers are the current authorized online providers. Make sure the course is Construction if you work in construction.',
      Link('OSHA authorized online providers', 'https://www.osha.gov/training/outreach/training-providers')),
  Claim('Test site appears on NCCCO\'s practical test site list', false, 'Good sign',
      'NCCCO publishes the practical test sites. Check the date and the crane type there.',
      Link('NCCCO practical test sites', 'https://nccco.org/nccco/get-cco-certified/find-cco-test-locations/find-practical-test-sites')),
  Claim('Welding school says its test counts toward AWS certification, but you cannot find it in the AWS locator', true, 'Ask before you pay',
      'Not being in the locator does not prove a problem. The list may not show every site, and a school may only train. Ask which AWS Accredited Test Facility gives the test, then look that facility up in the AWS locator.',
      Link('AWS ATF locator', 'https://my.aws.org/certification/atflocator')),
];
