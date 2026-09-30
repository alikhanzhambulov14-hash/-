import SpriteKit

// MARK: - Data Models

enum PlantType: String, CaseIterable {

    // Base plants & Fusions combined for simplicity
    case pudding
    case icelotus
    case icecattail
    case ironpeaz
    case starpea
    case mark
    case seanut
    case ironpuff
    case leafupper
    case pinefurnace
    case wateringcangold
    case lanternblover
    case tallnut
    case golddoom
    case k
    case squashmelon
    case scaredyshroom
    case lotusbamboo
    case threesquash
    case hypnocattailgirl
    case blacktrain
    case cherryumbrella
    case hypnochomper
    case cattailplant
    case unitywatermarkproto
    case q
    case signboard
    case endoflamegirl
    case blover
    case cabbagepot
    case doomgarlic
    case landsubmarine
    case potatomine
    case squashtorch
    case topleft
    case minisandmonster
    case goldcabbage
    case bucketpaper
    case doompot
    case bottonright
    case nutfume
    case bignut
    case superjalanut
    case snowmonster
    case ultimatecattail
    case cherrymine
    case garlicsniper
    case melonjump
    case cabbagepult
    case achievement
    case coachpaper
    case iceseashroom
    case goldiceshroom
    case cattaillour
    case threespike
    case uifoldoutclosed
    case icecannon
    case chomperpumpkin
    case tground
    case petjackbox
    case threekelp
    case solarstar
    case levelup
    case superlevatation
    case bluelight
    case silvergarlic
    case colorfulfume
    case kelpmine
    case threetorch
    case zambonismoke
    case hypnosplit
    case bigblack
    case simplefilebrowsermoreoptions
    case laserumbrella
    case thornsspruce
    case splashbullet
    case seamine
    case hypnopuff
    case scaredypumpkin
    case seapumpkin
    case simplefilebrowserdrag
    case poolsparkly
    case solarlily
    case flyingthreepeater
    case tallfirenut
    case ultimategarlicsplit
    case ironpeabullet
    case moneymelon
    case hugewave
    case doomumbrella
    case superbomb
    case luckyblover
    case thorns
    case horseboss
    case silversunflower
    case beach
    case fire
    case lv
    case snowbossaword
    case firesniper
    case ultimatemagnet
    case ultimatepumpkin
    case footballdolphin
    case torchseashroom
    case redjackson
    case whiteellipse
    case peasmallpuff
    case diamondimitater
    case doomcactus
    case snowdrown
    case gravenut
    case peapot
    case sunshroom
    case superthreepeater
    case hypnogarlic
    case abyssswordstar
    case footballboss
    case hypnoemperor
    case caltroppot
    case moneysunflower
    case icedoom
    case silvercabbage
    case potatofume
    case jalatorch
    case startready
    case ultimateportalnut
    case lanternumbrella
    case doublepuff
    case biggloom
    case melonpumpkin
    case lanternpumpkin
    case ultimatefootball
    case hypnoqueen
    case biggatlingpea
    case ifvblover
    case melonpot
    case obsidianspike
    case szw
    case sunpot
    case superhypnodoom
    case ironpeashooter
    case flagfootball
    case ultimatelanternsplit
    case fill
    case doomsniper
    case fishrod
    case doomseashroom
    case fumepumpkin
    case gardenbattle
    case bamboodragon
    case melonnut
    case ultimategloom
    case puffdoom
    case ultimatesnipergatling
    case dolldiamond
    case doom
    case cactus
    case frontbottom
    case pickaxestarbullet
    case extremesnowpea
    case jackboxstarbullet
    case hugenut
    case magnetfume
    case potatopumpkin
    case chompersquash
    case jalapumpkin
    case target
    case goldcorncannon
    case ultimatechomper
    case obsidianwallnut
    case chomper
    case umbrellafume
    case shulkbamboo
    case twinflowerpreview
    case suniceshroom
    case ultimatebiggatling
    case bamboospruce
    case imitaterpuffs
    case legionsniper
    case cherrychomper
    case bigcoinshroom
    case dust
    case goldpot
    case hypnopea
    case sealantern
    case potatosquashbody
    case doomgatling
    case ifvpumpkin
    case goldhypnoshroom
    case izmap
    case nutchomper
    case lanternpea
    case potatobullet
    case deathmine
    case sniperchomper
    case bigboom
    case cornfume
    case supercaltroppot
    case cabbagecaltrop
    case starfume
    case petdrown
    case torchsunflower
    case unitywatermarkedu
    case sunnut
    case electriconion
    case multiselectiontoggleoff
    case caltropfume
    case snowgatlingpuff
    case goldsunflower
    case supertorch
    case h
    case diamonddoll
    case icecabbage
    case ultimategatling
    case sunpumpkin
    case sandjackson
    case squashcabbage
    case threepeater
    case bigpot
    case helmetfume
    case dropdownarrow
    case magiclandie
    case magnetmelon
    case watercan
    case waterfurnace
    case imitatewheat
    case cherryblover
    case bloverumbrella
    case hypnosquash
    case jalapeashooter
    case dolphinrider
    case hypnogatling
    case pool
    case sunjalapeno
    case goldgarlic
    case lotusaloes
    case ultimatesungatlingpuff
    case ultimateexplodecannon
    case doomtorch
    case doomjalapeno
    case torchfume
    case cornpult
    case obsidianinp
    case garlicrepeater
    case leafmid
    case nutmine
    case firekelp
    case dollgold
    case garlicfume
    case shulkfurnace
    case twinmarigold
    case uicheckmark
    case goldthreetorch
    case nuclearsquash
    case wheat
    case g
    case peapumpkin
    case ironcorn
    case smallpuff
    case conveyorbelt
    case tallicenut
    case smallumbrella
    case doombullet
    case hypnorepeater
    case icesquash
    case superblackhorse
    case doompea
    case ultimatemelon
    case superhypnogatling
    case almanacplant
    case sunblue
    case scaredypot
    case hypnojalapeno
    case nutumbrella
    case flagmeterparts
    case graves
    case doomstar
    case jalasquash
    case squalour
    case garlicgatling
    case uisprite
    case icelaserumbrella
    case threespikebullet
    case unitywatermarksmall
    case thronsaloes
    case peanut
    case ultimatetorch
    case blackflagfootball
    case fumechomper
    case garlicpea
    case spikerock
    case cherryscaredy
    case deathchomper
    case starfruit
    case finalfume
    case obsidianpotatonut
    case threetang
    case redemeraldumbrella
    case hypnotorch
    case ultimatefootballdrown
    case ultimatefireseashroom
    case potatodoom
    case blackhorse
    case icecherry
    case ultimatebamboo
    case solarpot
    case grassdark
    case hypnoblover
    case portalcorn
    case cherrysupergatling
    case doomcabbage
    case diamondpotatonut
    case emeraldumbrella
    case hypnoshroom
    case doomshroom
    case glow
    case jigsawpresent
    case kbcak
    case tanglekelp
    case ultimatesunmagnet
    case mindcontrol
    case doomplantern
    case blackfootball
    case redpot
    case supermelon
    case thronsshulk
    case ultimatebigchomper
    case lawnshooter
    case rsunny
    case ultimategatlingblover
    case icepot
    case peachomper
    case ultimateplantern
    case sbangdai
    case pickaxehat
    case wintermelon
    case icehypno
    case imitaterclouds
    case obsidianjalapeno
    case pethorse
    case torchmine
    case eyebow
    case puffchomper
    case moneygarlic
    case fumeshroom
    case goldphonograph
    case bloverpult
    case cherrypaper
    case silvermelon
    case unitywatermarktrialbig
    case machinelevatation
    case ultimatesunnut
    case peafume
    case squashpumpkin
    case supergatling
    case threeplantern
    case hypnopot
    case snowpeashooter
    case magnetblover
    case ultimatespring
    case garlicsplit
    case gardenprotection
    case ktop
    case kelptorch
    case cherrynut
    case scaredystar
    case threenut
    case ultimatedolphin
    case minisnowmonster
    case doomchomper
    case pumpiner
    case ultimatehypnopumpkin
    case melonumbrella
    case wateringcan
    case superfertilizer
    case snowsplit
    case startorch
    case summonedhorse
    case jalagatling
    case soft
    case circle
    case hypnopumpkin
    case solarsunflower
    case sright
    case ultimatedoomgatling
    case superchomper
    case qzright
    case wh
    case silverpot
    case firefume
    case superblackfootball
    case suncaltrop
    case whitefootball
    case ultimatecorn
    case jiyu
    case preview
    case sl
    case normalminigames
    case sunstar
    case sunbomb
    case d
    case portalpolevaulter
    case superkirov
    case chompershooter
    case moneycorn
    case ultimatemachinenut
    case superthreegatling
    case cactusstar
    case jackboxdoom
    case portaldoom
    case iceshroom
    case sunblover
    case ultimatehorse
    case cherrypumpkin
    case supersnowgatling
    case shovel
    case greencherry
    case supersunnut
    case icedoomgloom
    case garlicpot
    case checkmark
    case superhurricaneblover
    case iceplantern
    case cabbagecannon
    case doompeashooter
    case dm
    case puffpumpkin
    case moneynut
    case ultimatedoomscared
    case bigchomper
    case cherrygatling
    case scarypot
    case seastar
    case jackboxpogo
    case presentopen
    case machine
    case superspruce
    case magnetpumpkin
    case superfurnace
    case torchfirepumpkin
    case fertilizer
    case hypnopeashooter
    case qtop
    case squashtang
    case swordstar
    case garlic
    case bucketdoom
    case scaredydoom
    case puffsquash
    case tallnutfootballz
    case goldmagnet
    case trackbullet
    case nutpot
    case ultimatecornfume
    case enderpumpkin
    case hypnofirepea
    case supercaltrop
    case gravesunshroom
    case yellowlight
    case cornpot
    case cornpuff
    case lanternpot
    case seamagnet
    case moneyumbrella
    case sunexplosionpowie
    case doommelon
    case portalsniper
    case splitpuff
    case threemelon
    case hurricaneblover
    case firecabbage
    case magnetcorn
    case silverhypnoshroom
    case cactusblover
    case ironstar
    case melonpult
    case phonograph
    case cornnut
    case projectilepea
    case snowflakes
    case starsquash
    case startplant
    case shulklotus
    case waterbamboo
    case potatochomper
    case ultimatefly
    case a
    case gravebuster
    case pickaxepumpkin
    case potatopuff
    case pickaxe
    case sniperscaredy
    case gatlingpuff
    case pot
    case arrow
    case square
    case hat
    case randomlevels
    case goldcorn
    case lanterngatling
    case supertallnut
    case superhorse
    case sprout
    case goldhypnodoom
    case lanternmagnet
    case ultimatestartorch
    case peasunflower
    case nightpool
    case normallegion
    case garlictorch
    case pinkonion
    case sniperpea
    case ulimatewintermelon
    case cherrythreepeater
    case icecactus
    case areatex
    case superkelp
    case silverdoll
    case travellevels
    case rain
    case scaredypotato
    case sickle
    case sniperpot
    case kelpnut
    case presentz
    case sunchomper
    case scaredfume
    case icefumeshroom
    case projectilecactus
    case yellowfootball
    case piaofustone
    case ultimatehypnodoom
    case puffnut
    case diamoncone
    case superstarbullet
    case sheng
    case cherryhypno
    case jalaspike
    case unitywatermarktrial
    case ifvstar
    case cactusfume
    case healthslider
    case splitpea
    case temperparticle
    case ironmelon
    case doomthreepeater
    case cobcannon
    case flagmeterlevelprogress
    case sniperpuff
    case superpolevaulter
    case doomfume
    case ultimatekelp
    case threemine
    case doomcorn
    case bucketnut
    case bottonmid
    case icespike
    case firecherry
    case moneymeloneffect
    case unitywatermarkdev
    case dirt
    case superumbrella
    case cactusumbrellaleaf
    case cherrypot
    case icepumpkin
    case petfootball
    case garlicmelon
    case jackboxpumpkin
    case peamine
    case multiselectiontoggleon
    case goldmelon
    case sproing
    case bloverpot
    case nutpumpkin
    case trainingdummy
    case explosionpowie
    case ultimatepoisonfume
    case seablover
    case simheiatlas
    case cherrypuff
    case doompumpkin
    case icepuff
    case melonblover
    case seashroom
    case frozenpear
    case gatlingpea
    case jalacorn
    case scaredyblover
    case doomsquash
    case piackaxestar
    case icespikerock
    case gbody
    case icegloom
    case fireend
    case scaredysun
    case thornslotus
    case hypnomine
    case stonedancer
    case garlicthreepeater
    case seascaedyshroom
    case f
    case hypnomelon
    case shulkflower
    case bigpumpkin
    case supergatlingpumpkin
    case travelexperiences
    case superpumpkin
    case enderpumpiner
    case unitysplashholographictrackingloss
    case darkthreepeater
    case shat
    case cherrybomb
    case ultimatepuff
    case jalatang
    case squash
    case doomcherry
    case starpuff
    case meloncaltrop
    case doublesnow
    case cherrystar
    case potatosquash
    case roof
    case caltropkelp
    case knob
    case passionfruit
    case ultimatejalapeno
    case cursorclick
    case peablover
    case sunbank
    case garlicultimatechomper
    case garlicblover
    case rightmid
    case icestar
    case towerenter
    case silvercorn
    case dollsilver
    case cabbagenut
    case magnetdoom
    case superdoomscaredy
    case icedoomspark
    case bamboodeath
    case ultimateminigun
    case footballdrown
    case finalwave
    case cherryshooter
    case chrysantheautumn
    case hypnocattailbullet
    case shootingday
    case jalapeno
    case ifvironpuff
    case day
    case magicsnow
    case lanternshine
    case blovermine
    case icecaltrop
    case night
    case pow
    case superseashroom
    case ironnut
    case supermachinenut
    case ultimatecabbagecannon
    case supernutshooter
    case icedoomfume
    case threepot
    case firecaltrop
    case puffseashroom
    case scaredynut
    case silvericeshroom
    case goldbungi
    case silverumbrella
    case minigames
    case icemine
    case lanterncactus
    case smalliceshroom
    case cabbageumbrella
    case apple
    case hypnomagnet
    case jackboxstar
    case marigold
    case umbrellapot
    case seacurtus
    case ironpumpkin
    case icepeach
    case cherryjalapeno
    case goddoom
    case nutblover
    case ultimatehypno
    case sb
    case lanternsplit
    case yellowdoom
    case bigdoomstar
    case umbrellaleaf
    case cleaner
    case squashspike
    case starblover
    case abyssbuffbank
    case cornblover
    case watershulk
    case dolphinpaper
    case endoflame
    case corncaltrop
    case flagmeter
    case liberationsanssdfatlas
    case caltrop
    case corncabbage
    case advanturechallenges
    case firecannon
    case icefurnace
    case normaladvanture
    case squashnut
    case ultimatehugenut
    case scaredyhypno
    case redsplat
    case `super`
    case quickjackson
    case ultimatemeloncannon
    case cherrytorch
    case firepea
    case kelpfume
    case lotusspruce
    case sunhypno
    case meloncannon
    case sunseashroom
    case presentopenz
    case wallnutparticleslarge
    case cabbagefume
    case emojione
    case doompaper
    case aquarium
    case cactusnut
    case searchtex
    case tree
    case cactuscaltrop
    case fillbank
    case topright
    case wallnut
    case firespike
    case cabbageblover
    case seafume
    case ultimatehelmetgatling
    case nutshooter
    case doublepea
    case garlicstar
    case snowmonsterrider
    case firenut
    case gloomshroom
    case hypnonut
    case jalamine
    case present
    case waterspruce
    case firecattail
    case portalnut
    case peashooterz
    case imitater
    case seachomper
    case sunflower
    case lanternchomper
    case portalmelon
    case cherrysplit
    case ironhead
    case peashooter
    case lilypad
    case flowerpot
    case projectilesnowpea
    case cactuspumpkin
    case ironsquash
    case jalastar
    case defaultparticlesystem
    case seedbank
    case ultimatesunflower
    case garliccabbage
    case mixbomb
    case ultimatecactus
    case mushroomgarden
    case starnut
    case puffjalapeno
    case goldumbrella
    case snowpool
    case ultimateseashroom
    case bank
    case moneyhypno
    case hhh
    case uimask
    case snowgatling
    case doomsunflower
    case water
    case doomblover
    case magnetshroom
    case ironcone
    case jaladoubleshooter
    case bottonleft
    case peasplat
    case xxspot
    case hamburger
    case lanternfume
    case magnetstarbullet
    case allpeater
    case dong
    case fireseashroom
    case caltropnut
    case squashcorn
    case hypnodoom
    case coinshroom
    case cabbagepuff
    case treasuremine
    case headstar
    case icescaredyshroom
    case superfume
    case cherrysquash
    case ifvpotatopumpkin
    case flagchallenges
    case warningsign
    case duskroof
    case redlunarcabbage
    case superhypno
    case jigsawsprites
    case bigstar
    case blackelephant
    case threepumpkin
    case icecorn
    case normalcharred
    case threegoldplantern
    case bigsunshroom
    case kelpseed
    case ultimatespruce
    case jacksondriverboss
    case garliccorn
    case ultimatefume
    case cherrymagnet
    case bamboo
    case sungatlingpuff
    case plantern
    case cornmelon
    case peasquash
    case bungeetarget
    case hammer
    case snowdolphinrider
    case hypnofume
    case leaflower
    case ultimatepresentkelp
    case firespikerock
    case moneycabbage
    case seapot
    case melonpuff
    case forwardarrow
    case extrapot
    case icetorch
    case shootingplayer
    case ultimateiceshroom
    case protal
    case firegloom
    case explosionspudow
    case nucleardoomcherry
    case resizecursor
    case supersubmarine
    case nightsnow
    case sprucefurnace
    case particles
    case purplenutparticles
    case snow
    case dancepol
    case gravesunflower
    case corn
    case furskirt
    case lanternrepeater
    case obsidianwheat
    case starpumpkin
    case cursordefault
    case superdriver
    case ultimatesnowgatlingpuff
    case suncabbage
    case icebean
    case projtilecabbage
    case ancientsunnut
    case ultimateblover
    case unitywatermarkpluginbeta
    case startset
    case supergatlingfume
    case garlicumbrella
    case bucketfume
    case silverdoom
    case golddoll
    case lanternstar
    case starhypno
    case doomkelp
    case jacksondriver
    case magnetcactus
    case sunmagnet
    case cherryultimatepumpkin
    case squashkelp
    case ultimatecannon
    case pumpkin
    case cherryfume
    case jalasplit
    case sunmine
    case ultimatesunbullet
    case qqqq
    case goldbugspray
    case bloverpumpkin
    case helmetgatling
    case superstar
    case starsniper
    case diamond
    case leftmid
    case lunarcabbage
    case threecorn
    case torchpumpkin
    case ultimatefurnace
    case unitywatermarkbeta
    case swordhealth
    case goldfertilize
    case garlicpumpkin
    case melonfume
    case cabbagemelon
    case redpea
    case shovelbank
    case kelppuff
    case spruceshulk
    case supercherryshooter
    case kirovairship
    case moneypot
    case ultimateicedoom
    case cherrysubmarine
    case cornumbrella
    case torchwood
    case ashthreepeater
    case nuttorch
    case pickaxeclothe
    case ifvwingman
    case peascaredy
    case seasquash
    case wateraloes
    case wheatprotection
    case threecabbage
    case iceblover
    case spruceshooter
    case supergatlingpeamine
    case ironstarbullet
    case ultimatejacksondriver
    case thornsbamboo
    case points
    case waterround
    case watersplash
    case bedrocktallnut
    case doomnut
    case ultimatejalapuff
    case squashblover
    case sunsquash
    case ultimatestar
    case shooting
    case moneyiceshroom
    case uifoldoutopened
    case magnetnut
    case firemelon
    case firesquash
    case ice
    case garlicnut
    case poolcleaner
    case solarcabbage
    case explosioncloud
    case seahypno
    case lanternnut
    case bubblecannon
    case leafleft
    case petkirov
    case gatlingblackfootball
    case jigpresent
    case ultimatejalanut
    case ultimatebigsniper
    case qzleft
    case magnetstar
    case z
    case superbombthrower
    case shoot
    case chomperscaredy
    case bamboofurnace

    var textureName: String {
        return self.rawValue
    }
    var cost: Int {
        return 100
    }
    var hp: Int {
        if self.rawValue.contains("nut") { return 4000 }
        if self.rawValue.contains("tallnut") { return 8000 }
        return 300
    }
    case snowpea
    case repeater
    case puffshroom
    case iceShooter
    case sunPea
    case peaNut
    case gatlingPea
    case allPeater
    case winterMelon
    case fumePea
    case firePea
    case chomperPea
    case iceNut
    case sunNut
}

enum ZombieType: String, CaseIterable {

    case jalasquashzombie
    case flagzombie
    case boatimp
    case snowshieldzombie
    case bluegargantuar
    case armoredimpzombie
    case supersnowmonsterzombie
    case obsidianclawzombie
    case squashzombie
    case sunnutzombie
    case ironpeadoorzombie
    case snowgunzombie
    case snowdrownzombie
    case superpolozombie
    case ironpeazombie
    case impzombie
    case endoflamezombie
    case normalzombie
    case supermachinenutzombie
    case ultimateendoflamezombie
    case tallfirenutzombie
    case kirovzombie
    case zombieladderhead
    case superjackboxzombie
    case jalapenozombie
    case zombiehead
    case cherrynutzombie
    case cherryshooterzombie
    case doorzombie
    case ultimategargantuar
    case zombiearm
    case drowngargantuar
    case goldbungizombie
    case zombiefootballhead
    case zombiepogohead
    case superpogozombie
    case randomzombie
    case ultimatelegionzombie
    case impking
    case ultimatejackboxzombie
    case pogozombie
    case jackboxzombie
    case blackelephantzombie
    case blacktrainzombie
    case superpenguinzombie
    case ultimatefootballzombie
    case armedgargantuar
    case petimp
    case drownzombie
    case iceclawzombie
    case dolphingatlingzombie
    case drownpultzombie
    case superdancepolzombie
    case snowzombie
    case zombiediggerarm
    case wallnutzombie
    case snownormalzombie
    case zombiejackboxarm
    case redzombieloonnut
    case cherrypaperzombie
    case levatationzombie
    case gatlingpeazombie
    case superladderzombie
    case machinespiderzombie
    case peashooterzombie
    case jackboxjumpzombie
    case zombieglove
    case zombiedolphinriderhead
    case peazombie
    case dolphinpeazombie
    case ultimategoldgargantuar
    case irongargantuar
    case jacksonzombie
    case silverzombie
    case obsidianimpzombie
    case horsezombie
    case cherrycatapultzombie
    case polfootballzombie
    case quickjacksonzombie
    case gatlingfootballzombie
    case hypnojalapenozombie
    case zombieduck
    case bucketzombie
    case ultimateimpking
    case randomgargantuar
    case randompluszombie
    case ladderzombie
    case snowconezombie
    case bedrocksnowzombie
    case qingzombie
    case driverzombie
    case spiderzombie
    case ultimateswordzombie
    case redgargantuar
    case squalourzombie
    case zombiepogo
    case ironredgargantuar
    case polzombie
    case zombieyetihead
    case projectilezombie
    case supercherryzombie
    case zombiepolevaulterhead
    case pickaxezombie
    case ultiwatergargantuar
    case penguinzombie
    case snorklezombie
    case conezombie
    case zombie
    case bungizombie
    case tallnutfootballzombie
    case newyearzombie
    case blackjackboxzombie
    case protalzombie
    case polevaulterzombie
    case cherrypeazombie
    case legionzombie
    case doomzombie
    case greengargantuar
    case ultimatepaperzombie
    case ultimatesnowzombie
    case supersunnutzombie
    case zombieendoflame
    case minerzombie
    case zombiedriver
    case snowmonsterzombie
    case legionsniperzombie
    case moneyzombies
    case yellowgargantuar
    case elitepaperzombie
    case redirongargantuar
    case paperzombie
    case catapultzombie
    case chickenimp
    case zombiediggerhead
    case zombiefliter
    case goldzombie
    case supercherryshooterzombie
    case goldgargantuar
    case hypnojalapenopickaxezombie
    case bucketzombieduck
    case obsidiantallnutzombie
    case zombieimphead
    case zombieloonnut
    case tallicenutzombie
    case footballzombie
    case ultimatekirovzombie
    case elephantzombie
    case submarinezombie
    case ultimatemachinenutzombie
    case ironconezombie
    case zombieboss
    case zombiedancerhead
    case snowgatlingpeazombie
    case conezombieduck
    case bucketnutzombie
    case snowbucketzombie
    case waterjackboxjumpzombie
    case supergargantuar
    case gargantuar
    case zombienotesmall
    case diamondrandomzombie
    case petgargantuar
    case machinenutzombie
    case dancepolzombie

    var textureName: String {
        return self.rawValue
    }
    var hp: Int {
        if self.rawValue.contains("bucket") { return 1300 }
        if self.rawValue.contains("cone") { return 560 }
        if self.rawValue.contains("gargantuar") { return 3000 }
        if self.rawValue.contains("football") { return 1600 }
        return 200
    }
    var speed: CGFloat {
        if self.rawValue.contains("football") { return 28 }
        if self.rawValue.contains("flag") { return 22 }
        return 15
    }
    case basic
    case cone
    case bucket
    case football
    case flag
}

// We will simplify FusionType to just be a helper that returns a PlantType instead, 
// because all plants and fusions are now in PlantType.
class FusionManager {
    static func fuse(_ a: PlantType, _ b: PlantType) -> PlantType? {
        // A simple fusion matcher based on names
        // e.g. "Cabbage" + "Blover" -> "CabbageBlover"
        let name1 = a.rawValue
        let name2 = b.rawValue
        
        // Let's try combining their prefixes
        // In PvZFusion, usually it's just Name1Name2, but we don't have perfect capitalization in rawValue.
        // We will just do a linear scan (inefficient but works for 1000 items)
        let combined = name1 + name2
        
        for p in PlantType.allCases {
            let pr = p.rawValue
            // Check if both parts are in the target string
            // Very basic heuristic
            if pr.contains(name1) && pr.contains(name2) && pr.count <= combined.count + 4 {
                return p
            }
        }
        return nil
    }
}

// MARK: - Game Entities

class PlantEntity {
    var isAsleep: Bool = false
    var type: PlantType!
    
    var hp: Int
    var row: Int
    var col: Int
    var node: SKNode
    var shootTimer: TimeInterval = 0
    var sunTimer: TimeInterval = 0

    init(type: PlantType, row: Int, col: Int, node: SKNode) {
        self.type = type
        self.hp = type.hp
        self.row = row
        self.col = col
        
        self.node = node
        let env = LevelManager.shared.getCurrentLevelData().environment
        if type.rawValue.contains("shroom") && (env == .day || env == .pool || env == .roof) {
            self.isAsleep = true
            self.node.alpha = 0.5
        }


    }
    init(fusion: PlantType, row: Int, col: Int, node: SKNode) {
        self.type = fusion
        self.hp = fusion.hp
        self.row = row
        self.col = col
        
        self.node = node


    }
    var canShoot: Bool {
        if [.sunPea, .iceShooter, .peaNut, .gatlingPea, .allPeater, .winterMelon, .fumePea, .firePea, .chomperPea].contains(type) { return true }
        return type == .peashooter || type == .snowpea || type == .repeater || type == .threepeater || type == .fumeshroom || type == .melonpult || type == .cabbagepult || type == .puffshroom
    }
    var shootsIce: Bool {
        if type == .iceShooter || type == .iceNut || type == .winterMelon { return true }
        return type == .snowpea
    }
    var producesSun: Bool {
        if type == .sunPea || type == .sunNut { return true }
        return type == .sunflower || type == .sunshroom
    }
    var shootInterval: TimeInterval {
        if type == .gatlingPea { return 0.4 }
        if type == .repeater || type == .allPeater { return 0.8 }
        return 1.4
    }
}

class ZombieEntity {
    var type: ZombieType
    var hp: Int
    var row: Int
    var node: SKNode
    var speed: CGFloat
    var frozenTimer: TimeInterval = 0
    var isDead = false

    init(type: ZombieType, row: Int, node: SKNode) {
        self.type = type
        self.hp = type.hp
        self.row = row
        
        self.node = node


        self.speed = type.speed
    }
}

class Projectile {
    var node: SKNode
    var row: Int
    var isIce: Bool
    var damage: Int
    var isDead = false

    init(node: SKNode, row: Int, isIce: Bool, damage: Int = 20) {
        
        self.node = node


        self.row = row
        self.isIce = isIce
        self.damage = damage
    }
}

class SunDrop {
    var node: SKNode
    var targetY: CGFloat
    var collected = false

    init(node: SKNode, targetY: CGFloat) {
        
        self.node = node


        self.targetY = targetY
    }
}

class MowerEntity {
    var row: Int
    var node: SKNode
    var isActive = false
    var isDead = false

    init(row: Int, node: SKNode) {
        self.row = row
        
        self.node = node


    }
}

// MARK: - Game Scene

class GameScene: SKScene {
    var rows = 5
    var cols = 9
    let cellW: CGFloat = 85
    let cellH: CGFloat = 100
    let gridOffsetX: CGFloat = 180
    let gridOffsetY: CGFloat = 120

    var sun = 500
    var plants: [[PlantEntity?]] = []
    var zombies: [ZombieEntity] = []
    var projectiles: [Projectile] = []
    var sunDrops: [SunDrop] = []
    var mowers: [MowerEntity] = []
    var selectedPlant: PlantType? = nil
    var isShovelSelected = false
    var shovelIcon: SKSpriteNode?
    var shovelBank: SKSpriteNode?
    
    var selectedSeeds: [PlantType] = PlantType.allCases
    
    var plantButtons: [SKNode] = []
    var selectionIndicator: SKShapeNode?
    weak var gameVC: GameViewController?
    var isGamePaused = false
    
    var totalZombiesToSpawn = 0
    var zombiesSpawned = 0
    var isLevelComplete = false
    
    
    func setupEnvironment() {
        let env = LevelManager.shared.getCurrentLevelData().environment
        var bgName = "Background"
        
        switch env {
        case .day:
            rows = 5
            bgName = "Almanac_GroundDay"
        case .night:
            rows = 5
            bgName = "Almanac_GroundNight"
        case .pool:
            rows = 6
            bgName = "BigPool_land"
        case .fog:
            rows = 6
            bgName = "BigPool_land" // Add fog overlay later
        case .roof:
            rows = 5
            bgName = "Almanac_GroundRoof"
        }
        
        // Update background
        if let bg = self.childNode(withName: "background") as? SKSpriteNode {
            bg.texture = SKTexture(imageNamed: bgName)
        } else {
            let background = SKSpriteNode(imageNamed: bgName)
            background.name = "background"
            background.position = CGPoint(x: size.width/2, y: size.height/2)
            background.zPosition = -10
            background.size = size
            addChild(background)
        }
    }

    override func didMove(to view: SKView) {
        setupEnvironment()
        totalZombiesToSpawn = LevelManager.shared.getZombieCountForCurrentLevel()
        
        plants = Array(repeating: Array(repeating: nil, count: cols), count: rows)
        setupBackground()
        setupHUD()
        setupPlantBar()
        setupMowers()
        startSpawning()
        
        gameVC?.updateSun(sun)
    }
    
    func setupMowers() {
        for row in 0..<rows {
            let mower = SKSpriteNode(imageNamed: "mower")
            mower.setScale(0.7)
            let my = gridOffsetY + CGFloat(row) * cellH + cellH / 2
            let mx = gridOffsetX - 80
            mower.position = CGPoint(x: mx, y: my)
            mower.zPosition = 50
            addChild(mower)
            mowers.append(MowerEntity(row: row, node: mower))
        }
    }

    func setupBackground() {
        let bg = SKSpriteNode(imageNamed: "lawn")
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.zPosition = -10
        // scale to fit
        bg.xScale = size.width / bg.size.width
        bg.yScale = size.height / bg.size.height
        if bg.texture == nil {
            backgroundColor = SKColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1)
        } else {
            addChild(bg)
        }
    }

    func setupHUD() {
        let seedBankBg = SKSpriteNode(imageNamed: "seedbank")
        seedBankBg.anchorPoint = CGPoint(x: 0, y: 1)
        seedBankBg.position = CGPoint(x: 0, y: size.height)
        seedBankBg.zPosition = 80
        seedBankBg.setScale(0.8)
        addChild(seedBankBg)

        let sbank = SKSpriteNode(imageNamed: "shovelbank")
        sbank.position = CGPoint(x: size.width - 150, y: size.height - 50)
        sbank.zPosition = 100
        sbank.setScale(0.8)
        addChild(sbank)
        shovelBank = sbank
        
        let shovel = SKSpriteNode(imageNamed: "shovel")
        shovel.position = sbank.position
        shovel.zPosition = 101
        shovel.setScale(0.8)
        shovel.name = "shovel"
        addChild(shovel)
        shovelIcon = shovel
    }

    func setupPlantBar() {
        let types = selectedSeeds
        let startX: CGFloat = 130
        
        for (i, pt) in types.enumerated() {
            let row = i / 7
            let col = i % 7
            let bx = startX + CGFloat(col) * 70
            let by = size.height - 40 - CGFloat(row) * 90
            
            let card = SKSpriteNode(imageNamed: "seedpacket")
            if card.texture == nil {
                card.color = .brown
                card.size = CGSize(width: 60, height: 80)
            } else {
                card.setScale(0.7)
            }
            card.position = CGPoint(x: bx, y: by)
            card.zPosition = 90
            card.name = "plant_\(pt.rawValue)"

            let icon = SKSpriteNode(imageNamed: pt.textureName)
            if icon.texture == nil {
                let lbl = SKLabelNode(text: "?")
                lbl.verticalAlignmentMode = .center
                icon.addChild(lbl)
            } else {
                icon.setScale(0.4)
            }
            icon.zPosition = 91
            icon.position = card.position
            icon.name = "plant_\(pt.rawValue)"
            addChild(icon)

            addChild(card)
            plantButtons.append(card)
        }
    }

    func gridPos(row: Int, col: Int) -> CGPoint {
        return CGPoint(x: gridOffsetX + CGFloat(col) * cellW + cellW/2,
                       y: gridOffsetY + CGFloat(rows - 1 - row) * cellH + cellH/2)
    }

    func gridCell(at point: CGPoint) -> (row: Int, col: Int)? {
        let c = Int((point.x - gridOffsetX) / cellW)
        let r = rows - 1 - Int((point.y - gridOffsetY) / cellH)
        if r >= 0 && r < rows && c >= 0 && c < cols { return (r, c) }
        return nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)

        let tapped = nodes(at: loc)

        // Collect Sun
        for sun in sunDrops where !sun.collected {
            let dist = hypot(sun.node.position.x - loc.x, sun.node.position.y - loc.y)
            if sun.node.frame.contains(loc) || dist < 50 {
                collectSun(sun)
                return
            }
        }

        // Shovel Tool
        if tapped.contains(where: { $0.name == "shovel" }) {
            isShovelSelected = true
            selectedPlant = nil
            shovelIcon?.position = loc
            selectionIndicator?.removeFromParent()
            return
        }
        
        if isShovelSelected {
            if let (r, c) = gridCell(at: loc), let existing = plants[r][c] {
                existing.node.removeFromParent()
                plants[r][c] = nil
            }
            isShovelSelected = false
            shovelIcon?.position = shovelBank?.position ?? .zero
            return
        }

        // Select Plant
        for node in tapped {
            if let name = node.name, name.hasPrefix("plant_") {
                let typeName = name.replacingOccurrences(of: "plant_", with: "")
                if let pt = PlantType(rawValue: typeName), self.sun >= pt.cost {
                    selectedPlant = pt
                    isShovelSelected = false
                    updateSelectionHighlight(node.position)
                    gameVC?.showFusionHint()
                }
                return
            }
        }

        // Place Plant
        if let (r, c) = gridCell(at: loc), let sp = selectedPlant {
            placePlant(sp, row: r, col: c)
        }
    }

    func updateSelectionHighlight(_ pos: CGPoint) {
        selectionIndicator?.removeFromParent()
        let highlight = SKShapeNode(rectOf: CGSize(width: 65, height: 85), cornerRadius: 4)
        highlight.strokeColor = .systemGreen
        highlight.lineWidth = 3
        highlight.position = pos
        highlight.zPosition = 101
        addChild(highlight)
        selectionIndicator = highlight
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)
        if isShovelSelected {
            shovelIcon?.position = loc
        }
    }

    func placePlant(_ type: PlantType, row: Int, col: Int) {
        if let existing = plants[row][col] {
            if let existType = existing.type, let fusionResult = FusionManager.fuse(existType, type) {
                sun -= type.cost
                existing.node.removeFromParent()
                let newNode = spawnPlantNode(texture: fusionResult.textureName, row: row, col: col, isFusion: true)
                let plant = PlantEntity(fusion: fusionResult, row: row, col: col, node: newNode)
                plants[row][col] = plant
                selectedPlant = nil
                selectionIndicator?.removeFromParent()
                updateSun()
            }
            return
        }

        if type == .cherrybomb {
            sun -= type.cost
            cherrybombExplode(row: row, col: col)
            selectedPlant = nil
            selectionIndicator?.removeFromParent()
            updateSun()
            return
        }

        if type == .jalapeno {
            sun -= type.cost
            jalapenoBurn(row: row)
            selectedPlant = nil
            selectionIndicator?.removeFromParent()
            updateSun()
            return
        }

        sun -= type.cost
        let node = spawnPlantNode(texture: type.textureName, row: row, col: col, isFusion: false)
        plants[row][col] = PlantEntity(type: type, row: row, col: col, node: node)
        
        selectedPlant = nil
        selectionIndicator?.removeFromParent()
        updateSun()
    }

    func jalapenoBurn(row: Int) {
        let y = gridPos(row: row, col: 0).y
        let fire = SKShapeNode(rectOf: CGSize(width: size.width, height: cellH))
        fire.fillColor = SKColor.orange.withAlphaComponent(0.8)
        fire.strokeColor = .red
        fire.position = CGPoint(x: size.width / 2, y: y)
        fire.zPosition = 60
        addChild(fire)
        fire.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.6),
            SKAction.removeFromParent()
        ]))

        for z in zombies where z.row == row {
            z.hp = 0
            z.isDead = true
        }
    }

    
    func canPlant(type: PlantType, atRow row: Int, col: Int) -> Bool {
        let env = LevelManager.shared.getCurrentLevelData().environment
        let isWater = (env == .pool || env == .fog) && (row == 2 || row == 3)
        let isRoof = (env == .roof)
        
        let nodeAtPos = plants[row][col]
        
        if isWater && type != .lilypad {
            if nodeAtPos?.type != .lilypad {
                return false
            }
        }
        
        if isRoof && type != .flowerpot {
            if nodeAtPos?.type != .flowerpot {
                return false
            }
        }
        
        return true
    }

    func spawnPlantNode(texture: String, row: Int, col: Int, isFusion: Bool) -> SKNode {
        let pos = gridPos(row: row, col: col)
        let sprite = SKSpriteNode(imageNamed: texture)
        sprite.position = pos
        sprite.zPosition = 10
        if sprite.texture == nil {
            sprite.color = .green
            sprite.size = CGSize(width: 50, height: 50)
        } else {
            sprite.setScale(isFusion ? 0.8 : 0.6)
        }
        addChild(sprite)
        
        sprite.setScale(0)
        sprite.run(SKAction.scale(to: isFusion ? 0.8 : 0.6, duration: 0.2))
        
        if isFusion {
            let flash = SKShapeNode(circleOfRadius: 60)
            flash.fillColor = .white
            flash.position = pos
            flash.zPosition = 50
            addChild(flash)
            flash.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()]))
        }
        
        return sprite
    }

    func cherrybombExplode(row: Int, col: Int) {
        let center = gridPos(row: row, col: col)
        let boom = SKShapeNode(circleOfRadius: 120)
        boom.fillColor = .red
        boom.position = center
        boom.zPosition = 60
        addChild(boom)
        boom.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.4), SKAction.removeFromParent()]))

        for z in zombies {
            if abs(z.node.position.x - center.x) < 150 && abs(z.node.position.y - center.y) < 150 {
                z.hp = 0
            }
        }
    }

    func startSpawning() {
        var waveActions: [SKAction] = []
        var remaining = totalZombiesToSpawn
        var waveDelay = 15.0
        
        while remaining > 0 {
            let toSpawn = min(remaining, Int.random(in: 2...5))
            remaining -= toSpawn
            waveActions.append(SKAction.wait(forDuration: waveDelay))
            waveActions.append(SKAction.run { [weak self] in self?.spawnWave(count: toSpawn) })
            waveDelay = 20.0
        }
        
        run(SKAction.sequence(waveActions))
        
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 6.0),
            SKAction.run { [weak self] in self?.spawnSkySun() }
        ])))
    }

    func spawnWave(count: Int) {
        for _ in 0..<count {
            if zombiesSpawned >= totalZombiesToSpawn { break }
            zombiesSpawned += 1
            
            let delay = Double.random(in: 0...5)
            run(SKAction.sequence([
                SKAction.wait(forDuration: delay),
                SKAction.run { [weak self] in self?.spawnZombie() }
            ]))
        }
    }

    func spawnZombie() {
        let row = Int.random(in: 0..<rows)
        let roll = Double.random(in: 0...1)
        let type: ZombieType
        if roll < 0.40 {
            type = .zombie
        } else if roll < 0.68 {
            type = .conezombie
        } else if roll < 0.85 {
            type = .bucketzombie
        } else if roll < 0.94 {
            type = .footballzombie
        } else {
            type = .flagzombie
        }

        let sprite = SKSpriteNode(imageNamed: type.textureName)
        sprite.position = CGPoint(x: size.width + 50, y: gridPos(row: row, col: 0).y)
        sprite.zPosition = 15
        if sprite.texture == nil {
            sprite.color = .gray
            sprite.size = CGSize(width: 40, height: 80)
        } else {
            sprite.setScale(0.6)
        }
        addChild(sprite)
        zombies.append(ZombieEntity(type: type, row: row, node: sprite))
    }

    override func update(_ currentTime: TimeInterval) {
        if isGamePaused { return }
        let dt = 1.0 / 60.0

        // Plants
        for r in 0..<rows {
            for c in 0..<cols {
                guard let p = plants[r][c] else { continue }
                if p.canShoot {
                    p.shootTimer += dt
                    if p.shootTimer >= p.shootInterval {
                        p.shootTimer = 0
                        if zombies.contains(where: { $0.row == r && $0.node.position.x > p.node.position.x && !$0.isDead }) {
                            shootPea(from: p)
                        }
                    }
                }
                if p.producesSun {
                    p.sunTimer += dt
                    if p.sunTimer >= 8.0 {
                        p.sunTimer = 0
                        spawnSun(at: p.node.position)
                    }
                }
            }
        }

        // Zombies
        for z in Array(zombies) where !z.isDead {
            // Mower collision
            if let mower = mowers.first(where: { $0.row == z.row && !$0.isDead }) {
                if !mower.isActive && z.node.position.x < mower.node.position.x + 30 {
                    mower.isActive = true
                }
                
                if mower.isActive && abs(mower.node.position.x - z.node.position.x) < 40 {
                    z.isDead = true
                    z.node.run(SKAction.sequence([
                        SKAction.fadeOut(withDuration: 0.5),
                        SKAction.removeFromParent()
                    ]))
                }
            }

            var collided = false
            let cx = Int((z.node.position.x - gridOffsetX) / cellW)
            if cx >= 0 && cx < cols {
                if let plant = plants[z.row][cx] {
                    collided = true
                    plant.hp -= 1 // Simplified eating, assuming 60 ticks per sec
                    if plant.hp <= 0 {
                        plant.node.removeFromParent()
                        plants[z.row][cx] = nil
                    }
                }
            }
            
            if !collided {
                z.node.position.x -= z.speed * dt
            }

            if z.node.position.x < 50 {
                gameOver()
            }
        }

        // Projectiles
        for p in projectiles {
            p.node.position.x += 300 * dt
            for z in zombies where z.row == p.row && !z.isDead {
                if abs(z.node.position.x - p.node.position.x) < 30 {
                    z.hp -= p.damage
                    p.isDead = true
                    if p.isIce { z.frozenTimer = 3.0 }
                    break
                }
            }
        }

        projectiles.removeAll { p in
            if p.isDead || p.node.position.x > size.width {
                p.node.removeFromParent()
                return true
            }
            return false
        }

        zombies.removeAll { z in
            if z.hp <= 0 || z.isDead {
                z.node.removeFromParent()
                return true
            }
            return false
        }
        
        // Mower Movement
        for m in mowers where m.isActive && !m.isDead {
            m.node.position.x += dt * 300
            if m.node.position.x > size.width + 100 {
                m.isDead = true
                m.node.removeFromParent()
            }
        }
        
        mowers.removeAll { $0.isDead }
        
        if zombiesSpawned >= totalZombiesToSpawn && zombies.isEmpty && !isLevelComplete {
            isLevelComplete = true
            levelComplete()
        }
    }
    
    func gameOver() {
        if isGamePaused { return }
        isGamePaused = true
        gameVC?.showResult(title: "ЗОМБИ СЪЕЛИ ВАШИ МОЗГИ!")
    }
    
    func levelComplete() {
        if isGamePaused { return }
        isGamePaused = true
        LevelManager.shared.completeLevel()
        gameVC?.showResult(title: "УРОВЕНЬ ПРОЙДЕН!")
    }

    func shootPea(from plant: PlantEntity) {
        if plant.type == .threepeater {
            for r in [plant.row - 1, plant.row, plant.row + 1] where r >= 0 && r < rows {
                spawnProjectile(row: r, startPos: plant.node.position, isIce: plant.shootsIce, damage: 25)
            }
            return
        }
        
        let count = (plant.type == .gatlingPea) ? 4 : ((plant.type == .repeater || plant.type == .allPeater) ? 2 : 1)
        for i in 0..<count {
            run(SKAction.sequence([
                SKAction.wait(forDuration: Double(i) * 0.15),
                SKAction.run { [weak self] in
                    self?.spawnProjectile(row: plant.row, startPos: plant.node.position, isIce: plant.shootsIce, damage: (plant.type == .gatlingPea ? 30 : 25))
                }
            ]))
        }
    }

    func spawnProjectile(row: Int, startPos: CGPoint, isIce: Bool, damage: Int) {
        let node = SKSpriteNode(imageNamed: "bullet_pea")
        node.position = CGPoint(x: startPos.x + 20, y: gridPos(row: row, col: 0).y)
        node.zPosition = 12
        if node.texture == nil {
            node.color = isIce ? .cyan : .green
            node.size = CGSize(width: 15, height: 15)
        }
        addChild(node)
        projectiles.append(Projectile(node: node, row: row, isIce: isIce, damage: damage))
    }

    func spawnSun(at pos: CGPoint) {
        let node = SKSpriteNode(imageNamed: "sun")
        node.position = pos
        node.zPosition = 20
        if node.texture == nil {
            node.color = .yellow
            node.size = CGSize(width: 40, height: 40)
        } else {
            node.setScale(0.5)
        }
        addChild(node)
        
        let drop = SunDrop(node: node, targetY: pos.y - 20)
        sunDrops.append(drop)
        node.run(SKAction.moveBy(x: CGFloat.random(in: -30...30), y: -30, duration: 0.5))
    }

    func spawnSkySun() {
        let x = CGFloat.random(in: 200...(size.width - 100))
        let node = SKSpriteNode(imageNamed: "sun")
        node.position = CGPoint(x: x, y: size.height + 50)
        node.zPosition = 20
        if node.texture == nil { node.color = .yellow; node.size = CGSize(width: 40, height: 40) } else { node.setScale(0.5) }
        addChild(node)
        
        let targetY = CGFloat.random(in: 100...400)
        let drop = SunDrop(node: node, targetY: targetY)
        sunDrops.append(drop)
        node.run(SKAction.moveTo(y: targetY, duration: 4.0))
    }

    func collectSun(_ drop: SunDrop) {
        drop.collected = true
        sun += 50
        updateSun()
        drop.node.run(SKAction.sequence([
            SKAction.move(to: CGPoint(x: 50, y: size.height - 40), duration: 0.3),
            SKAction.removeFromParent()
        ]))
    }

    func updateSun() {
        gameVC?.updateSun(sun)
    }
}
