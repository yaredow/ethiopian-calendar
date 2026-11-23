.pragma library

const amharicMonths = [
  "መስከረም", "ጥቅምት", "ኅዳር", "ታኅሣሥ", "ጥር", "የካቲት", 
  "መጋቢት", "ሚያዝያ", "ግንቦት", "ሰኔ", "ሐምሌ", "ነሐሴ", "ጳጉሜን"
];

const amharicMonthsEn = [
  "Meskerem", "Tikimt", "Hidar", "Tahsas", "Tir", "Yakatit",
  "Magabit", "Miyazya", "Ginbot", "Sene", "Hamle", "Nehase", "Pagumē"
];

const amharicDays = [
  "እሑድ", "ሰኞ", "ማክሰኞ", "ረቡዕ", "ሐሙስ", "ዓርብ", "ቅዳሜ"
];

const amharicDaysShort = [
  "እ", "ሰ", "ማ", "ረ", "ሐ", "ዓ", "ቅ"
];

const amharicDaysEn = [
  "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
];

const gregorianMonths = [
  "January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];

function getEvangelist(year) {
  var rem = ((year % 4) + 4) % 4;
  if (rem === 0) return "ዘመነ ማቴዎስ (Matthew)";
  if (rem === 1) return "ዘመነ ማርቆስ (Mark)";
  if (rem === 2) return "ዘመነ ሉቃስ (Luke)";
  return "ዘመነ ዮሐንስ (John · Leap)";
}

// Daily Saint / Tabot Commemorations (የዕለቱ ታቦት / ቅዱሳን መታሰቢያ 1-30)
const dailySaints = {
  1: "ልደታ ለማርያም / ቅዱስ ኤልያስ",
  2: "ቅዱስ ታዴዎስ ሐዋርያ",
  3: "በዓታ ለማርያም",
  4: "ዮሐንስ ወልደ ነጐድጓድ",
  5: "አቡነ ገብረ መንፈስ ቅዱስ / ጴጥሮስ ወጳውሎስ",
  6: "ደብረ ቁስቋም (ኢየሱስ)",
  7: "ቅድስት ሥላሴ",
  8: "አርባዕቱ እንስሳ (ኪሩቤል)",
  9: "ሠለስቱ ምዕት / ቶማስ ሐዋርያ",
  10: "መስቀለ ክርስቶስ",
  11: "ቅድስት ሐና ወኢያቄም / ፋሲለደስ",
  12: "ቅዱስ ሚካኤል",
  13: "ቅዱስ ሩፋኤል / እግዚአብሔር አብ",
  14: "አቡነ አረጋዊ / ገብረ ክርስቶስ",
  15: "ቅዱስ ቂርቆስ ወኢየሉጣ",
  16: "ኪዳነ ምሕረት",
  17: "ቅዱስ እስጢፋኖስ / አባ ገሪማ",
  18: "ተክለ አልፋ / ፊልጶስ ሐዋርያ",
  19: "ቅዱስ ገብርኤል",
  20: "ሕንፀተ ቤተክርስቲያን (ኤፌሶን)",
  21: "እግዝእትነ ማርያም (ማኅደረ መለኮት)",
  22: "ቅዱስ ዑራኤል / ደቅስዮስ",
  23: "ቅዱስ ጊዮርጊስ",
  24: "አቡነ ተክለ ሃይማኖት",
  25: "ቅዱስ መርቆሬዎስ",
  26: "አቡነ ሐብተ ማርያም / ቶማስ ዘመርዓስ",
  27: "መድኃኔዓለም",
  28: "አማኑኤል",
  29: "በዓለ ወልድ (የልደት መታሰቢያ)",
  30: "ቅዱስ ዮሐንስ መጥምቅ"
};

// 33 Amharic Consonant Families with 7 vowel orders + Phonetic transliterations
const fidelFamilies = [
  { name: "h", row: ["ሀ", "ሁ", "ሂ", "ሃ", "ሄ", "ህ", "ሆ"], sounds: ["he", "hu", "hi", "ha", "hie", "h", "ho"] },
  { name: "l", row: ["ለ", "ሉ", "ሊ", "ላ", "ሌ", "ል", "ሎ"], sounds: ["le", "lu", "li", "la", "lie", "l", "lo"] },
  { name: "hh", row: ["ሐ", "ሑ", "ሒ", "ሓ", "ሔ", "ሕ", "ሖ"], sounds: ["hhe", "hhu", "hhi", "hha", "hhie", "hh", "hho"] },
  { name: "m", row: ["መ", "ሙ", "ሚ", "ማ", "ሜ", "ም", "ሞ"], sounds: ["me", "mu", "mi", "ma", "mie", "m", "mo"] },
  { name: "ss", row: ["ሠ", "ሡ", "ሢ", "ሣ", "ሤ", "ሥ", "ሦ"], sounds: ["sse", "ssu", "ssi", "ssa", "ssie", "ss", "sso"] },
  { name: "r", row: ["ረ", "ሩ", "ሪ", "ራ", "ሬ", "ር", "ሮ"], sounds: ["re", "ru", "ri", "ra", "rie", "r", "ro"] },
  { name: "s", row: ["ሰ", "ሱ", "ሲ", "ሳ", "ሴ", "ስ", "ሶ"], sounds: ["se", "su", "si", "sa", "sie", "s", "so"] },
  { name: "sh", row: ["ሸ", "ሹ", "ሺ", "ሻ", "ሼ", "ሽ", "ሾ"], sounds: ["she", "shu", "shi", "sha", "shie", "sh", "sho"] },
  { name: "q", row: ["ቀ", "ቁ", "ቂ", "ቃ", "ቄ", "ቅ", "ቆ"], sounds: ["qe", "qu", "qi", "qa", "qie", "q", "qo"] },
  { name: "b", row: ["በ", "ቡ", "ቢ", "ባ", "ቤ", "ብ", "ቦ"], sounds: ["be", "bu", "bi", "ba", "bie", "b", "bo"] },
  { name: "v", row: ["ቨ", "ቩ", "ቪ", "ቫ", "ቬ", "ቭ", "ቮ"], sounds: ["ve", "vu", "vi", "va", "vie", "v", "vo"] },
  { name: "t", row: ["ተ", "ቱ", "ቲ", "ታ", "ቴ", "ት", "ቶ"], sounds: ["te", "tu", "ti", "ta", "tie", "t", "to"] },
  { name: "ch", row: ["ቸ", "ቹ", "ቺ", "ቻ", "ቼ", "ች", "ቾ"], sounds: ["che", "chu", "chi", "cha", "chie", "ch", "cho"] },
  { name: "h", row: ["ኀ", "ኁ", "ኂ", "ኃ", "ኄ", "ኅ", "ኆ"], sounds: ["he", "hu", "hi", "ha", "hie", "h", "ho"] },
  { name: "n", row: ["ነ", "ኑ", "ኒ", "ና", "ኔ", "ን", "ኖ"], sounds: ["ne", "nu", "ni", "na", "nie", "n", "no"] },
  { name: "gn", row: ["ኘ", "ኙ", "ኚ", "ኛ", "ኜ", "ኝ", "ኞ"], sounds: ["gne", "gnu", "gni", "gna", "gnie", "gn", "gno"] },
  { name: "a", row: ["አ", "ኡ", "ኢ", "ኣ", "ኤ", "እ", "ኦ"], sounds: ["a", "u", "i", "aa", "e", "e/i", "o"] },
  { name: "k", row: ["ከ", "ኩ", "ኪ", "ካ", "ኬ", "ክ", "ኮ"], sounds: ["ke", "ku", "ki", "ka", "kie", "k", "ko"] },
  { name: "h", row: ["ኸ", "ኹ", "ኺ", "ኻ", "ኼ", "ኽ", "ኾ"], sounds: ["he", "hu", "hi", "ha", "hie", "h", "ho"] },
  { name: "w", row: ["ወ", "ዉ", "ዊ", "ዋ", "ዌ", "ው", "ዎ"], sounds: ["we", "wu", "wi", "wa", "wie", "w", "wo"] },
  { name: "aa", row: ["ዐ", "ዑ", "ዒ", "ዓ", "ዔ", "ዕ", "ዖ"], sounds: ["aa", "u", "i", "a", "e", "e", "o"] },
  { name: "z", row: ["ዘ", "ዙ", "ዚ", "ዛ", "ዜ", "ዝ", "ዞ"], sounds: ["ze", "zu", "zi", "za", "zie", "z", "zo"] },
  { name: "zh", row: ["ዠ", "ዡ", "ዢ", "ዣ", "ዤ", "ዥ", "ዦ"], sounds: ["zhe", "zhu", "zhi", "zha", "zhie", "zh", "zho"] },
  { name: "y", row: ["የ", "ዩ", "ዪ", "ያ", "ዬ", "ይ", "ዮ"], sounds: ["ye", "yu", "yi", "ya", "yie", "y", "yo"] },
  { name: "d", row: ["ደ", "ዱ", "ዲ", "ዳ", "ዴ", "ድ", "ዶ"], sounds: ["de", "du", "di", "da", "die", "d", "do"] },
  { name: "j", row: ["ጀ", "ጁ", "ጂ", "ጃ", "ጄ", "ጅ", "ጆ"], sounds: ["je", "ju", "ji", "ja", "jie", "j", "jo"] },
  { name: "g", row: ["ገ", "ጉ", "ጊ", "ጋ", "ጌ", "ግ", "ጎ"], sounds: ["ge", "gu", "gi", "ga", "gie", "g", "go"] },
  { name: "t", row: ["ጠ", "ጡ", "ጢ", "ጣ", "ጤ", "ጥ", "ጦ"], sounds: ["t'e", "t'u", "t'i", "t'a", "t'ie", "t'", "t'o"] },
  { name: "ch", row: ["ጨ", "ጩ", "ጪ", "ጫ", "ጬ", "ጭ", "ጮ"], sounds: ["ch'e", "ch'u", "ch'i", "ch'a", "ch'ie", "ch'", "ch'o"] },
  { name: "p", row: ["ጰ", "ጱ", "ጲ", "ጳ", "ጴ", "ጵ", "ጶ"], sounds: ["p'e", "p'u", "p'i", "p'a", "p'ie", "p'", "p'o"] },
  { name: "ts", row: ["ጸ", "ጹ", "ጺ", "ጻ", "ጼ", "ጽ", "ጾ"], sounds: ["tse", "tsu", "tsi", "tsa", "tsie", "ts", "tso"] },
  { name: "ts", row: ["ፀ", "ፁ", "ፂ", "ፃ", "ፄ", "ፅ", "ፆ"], sounds: ["tse", "tsu", "tsi", "tsa", "tsie", "ts", "tso"] },
  { name: "f", row: ["ፈ", "ፉ", "ፊ", "ፋ", "ፌ", "ፍ", "ፎ"], sounds: ["fe", "fu", "fi", "fa", "fie", "f", "fo"] },
  { name: "p", row: ["ፐ", "ፑ", "ፒ", "ፓ", "ፔ", "ፕ", "ፖ"], sounds: ["pe", "pu", "pi", "pa", "pie", "p", "po"] }
];

// Labialized Diphthongs (ዲቃላ ፊደላት)
const diphthongs = [
  { char: "ሏ", sound: "lua" }, { char: "ሟ", sound: "mua" }, { char: "ሯ", sound: "rua" },
  { char: "ሷ", sound: "sua" }, { char: "ሿ", sound: "shua" }, { char: "ቋ", sound: "qua" },
  { char: "ቧ", sound: "bua" }, { char: "ቷ", sound: "tua" }, { char: "ቿ", sound: "chua" },
  { char: "ኋ", sound: "hua" }, { char: "ኗ", sound: "nua" }, { char: "ኟ", sound: "gnua" },
  { char: "ኳ", sound: "kua" }, { char: "ዟ", sound: "zua" }, { char: "ዷ", sound: "dua" },
  { char: "ጇ", sound: "jua" }, { char: "ጓ", sound: "gua" }, { char: "ጧ", sound: "t'ua" },
  { char: "ጯ", sound: "ch'ua" }, { char: "ጿ", sound: "tsua" }, { char: "ፏ", sound: "fua" }
];

// Ge'ez Numbers (ቁጥሮች)
const geezNumeralsList = [
  { char: "፩", val: "1" }, { char: "፪", val: "2" }, { char: "፫", val: "3" },
  { char: "፬", val: "4" }, { char: "፭", val: "5" }, { char: "፮", val: "6" },
  { char: "፯", val: "7" }, { char: "፰", val: "8" }, { char: "፱", val: "9" },
  { char: "፲", val: "10" }, { char: "፳", val: "20" }, { char: "፴", val: "30" },
  { char: "፵", val: "40" }, { char: "፶", val: "50" }, { char: "፷", val: "60" },
  { char: "፸", val: "70" }, { char: "፹", val: "80" }, { char: "፺", val: "90" },
  { char: "፻", val: "100" }
];

// Curated Facts About Ethiopia & The Calendar (Educational & Compact)
const ethiopianFacts = [
  {
    titleEn: "Why is Ethiopia 7–8 Years Behind?",
    titleAm: "የ7-8 ዓመታት ልዩነት",
    descEn: "Ethiopia calculates Jesus's birth using the ancient Alexandrian calendar (400 AD) rather than the Roman calculation (525 AD), creating a 7–8 year gap.",
    descAm: "የኢትዮጵያ ዘመን አቆጣጠር የክርስቶስን ልደት በጥንታዊው የአሌክሳንድሪያ ቀመር በማስላቱ ከጎርጎሪዮሳውያን የ7-8 ዓመታት ልዩነት አለው።"
  },
  {
    titleEn: "Sunrise 12-Hour Clock (6 AM = Hour 0)",
    titleAm: "የሰዓት ቆጠራ ከፀሐይ መውጣት",
    descEn: "With constant equatorial daylight, time starts at sunrise (6:00 AM = 12:00 dawn). 7:00 AM international time is 1:00 AM in Ethiopian time.",
    descAm: "ከምድር ወገብ አቅራቢያ በመሆኗ የሰዓት ቆጠራ ከፀሐይ መውጣት (12:00 ንጋት) ይጀምራል፤ የፈረንጁ 7:00 ጥዋት የኢትዮጵያ 1:00 ጥዋት ነው።"
  },
  {
    titleEn: "13 Months: The 30-Day Calendar",
    titleAm: "13 ወራትና ጳጉሜን",
    descEn: "The calendar has 12 months of exactly 30 days plus a 13th month, Pagumē (5 or 6 leap days), giving rise to '13 Months of Sunshine'.",
    descAm: "12ቱ ወራት እያንዳንዳቸው 30 ቀናት ሲኖሯቸው፣ ቀሪዎቹ 5 ወይም 6 ቀናት 13ኛዋን ወር ጳጉሜንን ይፈጥራሉ።"
  },
  {
    titleEn: "Africa's Only Living Native Script",
    titleAm: "የግዕዝ ፊደል ሥርዓት",
    descEn: "Ge'ez (Fidel) is Africa's only surviving indigenous alphabet. Written left-to-right, each base consonant modifies into 7 distinct vowel forms.",
    descAm: "የግዕዝ ፊደል ብቸኛው ሕያው የአፍሪካ ሀገር በቀል የጽሕፈት ሥርዓት ሲሆን፣ እያንዳንዱ ሆሄ 7 የድምፅ ቅርጾች አሉት።"
  },
  {
    titleEn: "The Birthplace of Coffee (Kaffa)",
    titleAm: "የቡና መገኛ ከፋ",
    descEn: "Coffee Arabica originated in Kaffa's ancient forests. Ethiopia is renowned for its sacred, hospitable 3-round coffee brewing ceremony.",
    descAm: "አረቢካ ቡና የተገኘው በከፋ ደኖች ሲሆን፣ ሀገሪቱ በባህላዊው ባለ ሦስት ዙር የቡና ማፍላት ሥነ-ሥርዓቷ ትታወቃለች።"
  },
  {
    titleEn: "Cradle of Humanity (Lucy / Dinknesh)",
    titleAm: "የሰው ልጅ መገኛ ድንቅነሽ",
    descEn: "The 3.2-million-year-old fossil Lucy (Dinknesh, meaning 'you are marvelous') was found in Afar, cementing Ethiopia as humanity's cradle.",
    descAm: "3.2 ሚሊዮን ዓመት ያስቆጠረችው ድንቅነሽ (Lucy) በአፋር ክልል ተገኝታ ኢትዮጵያ የሰው ልጅ መገኛ መሆኗን አረጋግጣለች።"
  },
  {
    titleEn: "Never Colonized & Pan-African Colors",
    titleAm: "የዐድዋ ድልና ቀለማት",
    descEn: "Ethiopia defeated colonial invasion at the Battle of Adwa (1896). Its green, yellow, and red colors inspired over 20 African national flags.",
    descAm: "ኢትዮጵያ በዐድዋ ጦርነት ወራሪን ድል በማድረግ ነፃነቷን አስጠብቃለች፤ ቀለሞቿም ለበርካታ የአፍሪካ ሀገራት አርማ ሆነዋል።"
  },
  {
    titleEn: "September New Year (Enkutatash)",
    titleAm: "አዲስ ዓመት እንቁጣጣሽ",
    descEn: "New Year falls on September 11/12, marking the end of the torrential rainy season and the blooming of golden Adey Abeba daisies.",
    descAm: "የኢትዮጵያ አዲስ ዓመት (እንቁጣጣሽ) በመስከረም 1 ቀን የክረምቱ ማብቃትና የአደይ አበባ መፈካትን በማብሰር ይከበራል።"
  },
  {
    titleEn: "Lalibela Rock-Hewn Churches",
    titleAm: "የላሊበላ ውቅር አብያተ ክርስቲያናት",
    descEn: "In the 12th century, 11 monolithic churches were chiseled top-down directly out of solid volcanic bedrock without mortar or timber.",
    descAm: "በ12ኛው መቶ ክፍለ ዘመን ከአንድ ወጥ አለት ከላይ ወደ ታች ተፈልፍለው የተሰሩ 11 ድንቅ የመካከለኛው ዘመን አብያተ ክርስቲያናት።"
  },
  {
    titleEn: "Source of the Blue Nile (Abay)",
    titleAm: "የዐባይ ወንዝ መነሻ",
    descEn: "Lake Tana and the Ethiopian highlands feed the Blue Nile, providing more than 80% of the Nile's total water down to Sudan and Egypt.",
    descAm: "ጣና ሐይቅ እና የኢትዮጵያ ተራሮች ለዓባይ ወንዝ መነሻ ሲሆኑ፣ ለናይል ወንዝ ከ80% በላይ የሚሆነውን ውሃ ያበረክታሉ።"
  },
  {
    titleEn: "The Danakil Depression",
    titleAm: "ዳሎልና ኤርታሌ",
    descEn: "One of the lowest and hottest places on Earth (-125m), Danakil features active bubbling lava lakes, acid pools, and neon sulfur springs.",
    descAm: "ከባሕር ጠለል በታች 125 ሜትር ዝቅተኛና እጅግ ሞቃታማ ስፍራ ሲሆን፣ የላቫ ሐይቆችና በቀለማት ያሸበረቁ ፍልውሃዎች አሉት።"
  },
  {
    titleEn: "The Ark of the Covenant in Aksum",
    titleAm: "ጽላተ ኪዳን በአክሱም",
    descEn: "According to ancient history and the Kebra Nagast, the Biblical Ark of the Covenant is guarded at the Church of St. Mary of Zion in Aksum.",
    descAm: "በኢትዮጵያ ታሪክ እና በክብረ ነገሥት መሠረት፣ ታቦተ ጽዮን (የቃል ኪዳኑ ታቦት) በአክሱም ጽዮን ቤተክርስቲያን ትገኛለች።"
  },
  {
    titleEn: "Abebe Bikila: Barefoot Olympic Gold",
    titleAm: "አበበ ቢቂላ",
    descEn: "In the 1960 Rome Olympics, Abebe Bikila became the first Black African Olympic gold medalist, running the full marathon barefoot.",
    descAm: "በ1960 የሮም ኦሎምፒክ አበበ ቢቂላ ማራቶንን በባዶ እግሩ በመሮጥ የመጀመሪያውን የአፍሪካ የወርቅ ሜዳሊያ አሸንፏል።"
  },
  {
    titleEn: "Rare Endemic Simien Wildlife",
    titleAm: "ብርቅዬ የዱር እንስሳት",
    descEn: "The Afro-alpine highlands shelter unique endemic wildlife found nowhere else: the Ethiopian Wolf, Walia Ibex, and Gelada Baboon.",
    descAm: "የስሜን ተራሮች በዓለም ላይ በኢትዮጵያ ብቻ የሚገኙ ብርቅዬ እንስሳት (ቀይ ቀበሮ፣ ዋልያ እና ጭላዳ ዝንጀሮ) መኖሪያ ናቸው።"
  }
];

function toAmharicNumeral(num) {
    if (num < 1) return "";
    const units = ["", "፩", "፪", "፫", "፬", "፭", "፮", "፯", "፰", "፱"];
    const tens = ["", "፲", "፳", "፴", "፵", "፶", "፷", "፸", "፹", "፺"];
    
    let result = "";
    if (num >= 100) {
        result += toAmharicNumeral(Math.floor(num / 100)) + "፻";
        num %= 100;
    }
    if (num >= 10) {
        result += tens[Math.floor(num / 10)];
        num %= 10;
    }
    if (num > 0) {
        result += units[num];
    }
    if (result.startsWith("፩፻")) {
        result = result.substring(1);
    }
    return result || "0";
}

function isGregorianLeap(year) {
    return (year % 4 === 0 && year % 100 !== 0) || (year % 400 === 0);
}

function ethiopianToGregorian(year, month, day) {
    var gYear = year + 7;
    var newYearDay = isGregorianLeap(gYear + 1) ? 12 : 11;
    var dayOffset = (month - 1) * 30 + (day - 1);
    return new Date(gYear, 8, newYearDay + dayOffset, 12, 0, 0);
}

function getEthiopianDate(date) {
    if (!date) date = new Date();
    
    var targetDate = new Date(date.getFullYear(), date.getMonth(), date.getDate(), 12, 0, 0);
    var gYear = targetDate.getFullYear();
    
    var newYearDay = isGregorianLeap(gYear + 1) ? 12 : 11;
    var newYearDate = new Date(gYear, 8, newYearDay, 12, 0, 0);
    
    var ethYear;
    var daysSinceNewYear;
    
    if (targetDate < newYearDate) {
        ethYear = gYear - 8;
        var prevNewYearDay = isGregorianLeap(gYear) ? 12 : 11;
        var prevNewYearDate = new Date(gYear - 1, 8, prevNewYearDay, 12, 0, 0);
        daysSinceNewYear = Math.round((targetDate.getTime() - prevNewYearDate.getTime()) / 86400000);
    } else {
        ethYear = gYear - 7;
        daysSinceNewYear = Math.round((targetDate.getTime() - newYearDate.getTime()) / 86400000);
    }
    
    var ethMonth = Math.floor(daysSinceNewYear / 30) + 1;
    var ethDay = (daysSinceNewYear % 30) + 1;
    var isEthLeapYear = (ethYear % 4 === 3);
    
    return {
        year: ethYear,
        month: ethMonth,
        day: ethDay,
        dayOfWeek: targetDate.getDay(),
        isLeapYear: isEthLeapYear
    };
}

function getEthiopianTime(date) {
    if (!date) date = new Date();
    var hours = date.getHours();
    var minutes = date.getMinutes();
    
    var ethHour = (hours + 6) % 12;
    if (ethHour === 0) ethHour = 12;
    
    var isDay = (hours >= 6 && hours < 18);
    var period = isDay ? "ቀን" : "ማታ";
    var padMin = minutes < 10 ? "0" + minutes : String(minutes);
    
    return {
        hour: ethHour,
        minute: minutes,
        minuteStr: padMin,
        period: period,
        formatted: ethHour + ":" + padMin + " " + period
    };
}

// Confirmed Ethiopian Islamic Affairs Supreme Council (Majlis) moon-sighted
// Gregorian dates keyed by "hijriYear-hijriMonth-hijriDay". Unlisted years
// fall back to the tabular Hijri calculation below (+/- 1 day).
const CONFIRMED_HIJRI_OVERRIDES = {
    "1447-3-12": [2025, 9, 4],   // Mawlid 2025
    "1447-10-1": [2026, 3, 20],  // Eid al-Fitr 2026
    "1447-12-10": [2026, 5, 27], // Eid al-Adha 2026
    "1448-3-12": [2026, 8, 25]   // Mawlid 2026
};

var _yearHolidayCache = {};

// Orthodox Easter (Fasika) via Meeus Julian Computus (matches Bahire Hasab)
function getOrthodoxEasterGregorian(gYear) {
    var a = gYear % 4;
    var b = gYear % 7;
    var c = gYear % 19;
    var d = (19 * c + 15) % 30;
    var e = (2 * a + 4 * b - d + 34) % 7;
    var month = Math.floor((d + e + 114) / 31); // 3=March, 4=April (Julian)
    var day = ((d + e + 114) % 31) + 1;
    var julianToGregOffset = Math.floor(gYear / 100) - Math.floor(gYear / 400) - 2;
    return new Date(gYear, month - 1, day + julianToGregOffset, 12, 0, 0);
}

// Tabular (Kuwaiti/Civil) Hijri to Gregorian Date
function hijriToGregorian(hYear, hMonth, hDay) {
    var jd = Math.floor((11 * hYear + 3) / 30) +
             354 * hYear +
             30 * hMonth -
             Math.floor((hMonth - 1) / 2) +
             hDay + 1948440 - 385;
    var l = jd + 68569;
    var n = Math.floor((4 * l) / 146097);
    l = l - Math.floor((146097 * n + 3) / 4);
    var i = Math.floor((4000 * (l + 1)) / 1461001);
    l = l - Math.floor((1461 * i) / 4) + 31;
    var j = Math.floor((80 * l) / 2447);
    var day = l - Math.floor((2447 * j) / 80);
    l = Math.floor(j / 11);
    var month = j + 2 - 12 * l;
    var year = 100 * (n - 49) + i + l;
    return new Date(year, month - 1, day, 12, 0, 0);
}

function getYearHolidays(ethYear) {
    if (_yearHolidayCache[ethYear]) return _yearHolidayCache[ethYear];

    var map = {};
    function add(month, day, name, type) {
        var key = month + "-" + day;
        if (!map[key]) map[key] = [];
        map[key].push({ name: name, type: type });
    }
    function addByGregorian(gDate, name, type) {
        var eth = getEthiopianDate(gDate);
        if (eth.year === ethYear) add(eth.month, eth.day, name, type);
    }

    // 1. Fixed Official Public Holidays (Proclamation No. 1334/2024)
    // In Zemene Matewos (ethYear % 4 === 0, Meskerem 1 = Sep 12), Genna falls on Tahsas 28 (Jan 7)
    var gennaDay = (ethYear % 4 === 0) ? 28 : 29;
    add(1, 1, "እንቁጣጣሽ (አዲስ ዓመት · New Year)", "public");
    add(1, 17, "መስቀል (Finding of the True Cross)", "public");
    add(4, gennaDay, "ገና (የልደት በዓል · Christmas)", "public");
    add(5, 11, "ጥምቀት (Epiphany)", "public");
    add(6, 23, "የዐድዋ ድል በዓል (Adwa Victory Day)", "public");
    add(8, 23, "የሠራተኞች ቀን (Labour Day)", "public");
    add(8, 27, "የአርበኞች ቀን (Patriots' Victory Day)", "public");

    // 2. Movable Orthodox Public Holidays & Major Observances (Bahire Hasab)
    var easterGregYear = ethYear + 8;
    var fasikaG = getOrthodoxEasterGregorian(easterGregYear);
    var sikletG = new Date(fasikaG.getFullYear(), fasikaG.getMonth(), fasikaG.getDate() - 2, 12, 0, 0);
    var hosannaG = new Date(fasikaG.getFullYear(), fasikaG.getMonth(), fasikaG.getDate() - 7, 12, 0, 0);
    addByGregorian(sikletG, "ስቅለት (Good Friday)", "public");
    addByGregorian(fasikaG, "ፋሲካ (Ethiopian Easter)", "public");
    addByGregorian(hosannaG, "ሆሳዕና (Palm Sunday)", "religious");

    // 3. Movable Islamic Public Holidays (Hijri + Confirmed Majlis Overrides)
    var startGYear = ethYear + 7;
    var approxHYear = Math.floor((startGYear - 622) * (33 / 32));
    var islamicSpecs = [
        { m: 3, d: 12, name: "መውሊድ (Mawlid · Prophet's Birthday)" },
        { m: 10, d: 1, name: "ዒድ አል ፈጥር (Eid al-Fitr)" },
        { m: 12, d: 10, name: "ዒድ አል አድሐ (ዓረፋ · Eid al-Adha)" }
    ];
    for (var hy = approxHYear - 1; hy <= approxHYear + 2; hy++) {
        for (var s = 0; s < islamicSpecs.length; s++) {
            var spec = islamicSpecs[s];
            var ov = CONFIRMED_HIJRI_OVERRIDES[hy + "-" + spec.m + "-" + spec.d];
            var gDate = ov ? new Date(ov[0], ov[1] - 1, ov[2], 12, 0, 0)
                           : hijriToGregorian(hy, spec.m, spec.d);
            addByGregorian(gDate, spec.name, "public");
        }
    }

    // 4. Cultural & Religious Observances
    // Irreecha Birraa: first Sunday of October (Hora Harsadi) & Saturday before (Hora Finfinnee)
    var oct1 = new Date(startGYear, 9, 1, 12, 0, 0);
    var firstSunDay = 1 + ((7 - oct1.getDay()) % 7);
    var harsadiG = new Date(startGYear, 9, firstSunDay, 12, 0, 0);
    var finfinneeG = new Date(startGYear, 9, firstSunDay - 1, 12, 0, 0);
    addByGregorian(finfinneeG, "ኢሬቻ — ሆራ ፊንፊኔ (Irreecha · Hora Finfinnee)", "cultural");
    addByGregorian(harsadiG, "ኢሬቻ — ሆራ ሐርሰዲ (Irreecha · Hora Harsadi)", "cultural");

    add(1, 16, "ደመራ (Demera · Meskel Eve)", "religious");
    add(12, 13, "ደብረ ታቦር (ቡሄ · Buhe)", "religious");
    add(12, 16, "ዕርገተ ማርያም (ፍልሰታ / አሸንዳ)", "religious");

    _yearHolidayCache[ethYear] = map;
    return map;
}

function getHolidaysForDay(ethYear, month, day) {
    var yearMap = getYearHolidays(ethYear);
    return yearMap[month + "-" + day] || [];
}

function getHoliday(month, day, yearOrIsLeap) {
    if (typeof yearOrIsLeap === "number" && yearOrIsLeap > 100) {
        var list = getHolidaysForDay(yearOrIsLeap, month, day);
        if (list.length === 0) return null;
        return list.map(function(item) { return item.name; }).join(" · ");
    }
    var gennaDay = yearOrIsLeap ? 28 : 29;
    var fallback = {
        "1-1": "እንቁጣጣሽ (አዲስ ዓመት)",
        "1-17": "መስቀል (የደመራ በዓል)",
        ["4-" + gennaDay]: "ገና (የልደት በዓል)",
        "5-11": "ጥምቀት (የጥምቀት በዓል)",
        "6-23": "የዐድዋ ድል በዓል",
        "8-23": "የሠራተኞች ቀን",
        "8-27": "የአርበኞች ቀን",
        "12-13": "ደብረ ታቦር (ቡሄ)",
        "12-16": "ዕርገተ ማርያም (ፍልሰታ)"
    };
    return fallback[month + "-" + day] || null;
}

function getDailySaint(day) {
    return dailySaints[day] || null;
}

function getGridPaddingForMonth(year, month) {
    var firstDay = ethiopianToGregorian(year, month, 1);
    return firstDay.getDay(); // 0 = Sunday, ..., 6 = Saturday
}

function getYearCalendarData(year) {
    var isLeap = (year % 4 === 3);
    var months = [];
    
    for (var m = 1; m <= 13; m++) {
        var daysInMonth = (m === 13) ? (isLeap ? 6 : 5) : 30;
        var padding = getGridPaddingForMonth(year, m);
        var startGregorian = ethiopianToGregorian(year, m, 1);
        var endGregorian = ethiopianToGregorian(year, m, daysInMonth);
        
        var gregSpan = startGregorian.toLocaleDateString(Qt.locale("en_US"), "MMM") + " – " + 
                       endGregorian.toLocaleDateString(Qt.locale("en_US"), "MMM");
        
        var daysList = [];
        for (var d = 1; d <= daysInMonth; d++) {
            daysList.push(d);
        }
        
        months.push({
            monthIndex: m,
            nameAm: amharicMonths[m - 1],
            gregorianSpan: gregSpan,
            padding: padding,
            daysCount: daysInMonth,
            days: daysList
        });
    }
    
    return months;
}
