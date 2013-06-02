#encoding: utf-8
module Faker
  # Based on from http://slipsum.com and http://theleague2012.com/?p=8169
  module SamuelJackson
    extend ModuleUtils
    extend self

    def word
      WORDS.sample
    end

    def words(num = 3)
      WORDS.sample(num)
    end

    def sentence
      SENTENCES.sample
    end

    alias_method :phrase, :sentence

    def sentences(num = 3)
      SENTENCES.sample(num)
    end

    alias_method :phrases, :sentences

    def paragraph
      PARAGRAPHS.sample
    end

    def paragraphs(num = 3)
      PARAGRAPHS.sample(num)
    end

    WORDS = k %w{
      9-1-holy AK-47 American Apollo Basterds Berlin English German God Goddammit
      Goddamn Harlem Jheri Lord MDMA Olympus Ruth SWAT Superfly TV Tec-9 Teletubbies
      Texas Zeus absolutely accept accident accidents acid act actually adrenaline
      advertised again against aim alert already alright also always amphetamines
      angels anger animals another answer antwone anybody anything arch-villain's
      around as asking ass asses asshole assholes assumption attempt avalanche baby
      back bacteria bad ballpark bar barking barn bars base basketball battles beat
      behind believe best bet betray better bigger bitch black blank blessed blood
      blowed blowed-up blown body bolt bones book booty both box boy boys brain brains
      break breaking bring broke brother brother's brotherfucker brothers bull bulls
      bullshit bum burger burgers burn butt called came candle candy captured case
      casino cat cause cavalry cave celebrity cells chaos charity cheese chick chicken
      child children chill choke choking chracter clear climb clipped coach coaster
      cocaine college color comes comic coming command concentration connected cool
      cost could courtesy cousin crap crappy crime cross cure curl curve cut dad damn
      dare darkness day dead deal decide decided degrees demeanor deserve destroy
      detail dick did die died different differently differs directly dog dogs doin'
      doing dollars don't done door dopamine double down drifter drink drown drugs
      dumb duty each easy eat ecstasy either elevator else end ends enemy enlisted
      especiallyevil exact except exceptional explosive expression eyes face fact
      falling fast father federal feet felony fences fifty fight find finder fingers
      firing fish flight flush foot force forever france freezing fried friend fuck
      fuckin' fucking fuh-eva furious furnace fury games gang gator getting
      girlfriend's give givin' giving glass glaze go god goddamn goes going gonna good
      government great group gun guns guys hacker hadn't hallucinogenic hand happen
      hard-ass hate head heard helicopter hell helmet help hero heroes heroin hesitate
      him himself his hold holies holiest home homeless honey hood hope hour house how
      hundred hunt ice idea including increase inequities infant inside instead
      investigating iron issues just keep keeper kid kill killed killer killers
      killing kilt king kiss kneecaps know known knows lacking last late laugh lay
      league leave legends lethal lie lies life light lightning lions listen little
      live lived living locked look lost lot lotta love lower lungs made make makes
      man massage matter may maybe mean mechanical men method middle mind mistake
      money morning moron motherfucker motherfuckers motherfuckin' motherfucking moths
      moves much murder mushroom-cloud-layin' music nail name named need needed
      needless neither never nice nickel nickel-plated nigga night nine nonsense oath
      office officers old opiates opposite order outside over pancakes paralyze park
      parking part parts passed path pay people perfect perfectly period permanent
      personal pet picked pickin' pilot pilots piss pit place plain plan plane plastic
      play played players playing please point poison police poorer popular position
      positively pound pounder pounds pour power pretty price printed prison probably
      problem product programs proud pull punished pussy putting quarter quarters
      question quit rainbow react reason refuse remarkable remember remembers repeat
      rest revenge rewarded right righteous righteousness rise roll room rules run
      running scariest security selfish sensation sense serious serotonin sex shadow
      shakes shark shepherds shirt shit shoot shopping shot shotguns should should've
      shove show show's showed shows sick sides sideways sign simple since sink sir
      sit sitting skills skull slender slide smoked snakes snow soldiers some somebody
      someone someplace something sometime sometimes sorry sort soul speak speed sport
      spray squid stand standards standing starred start stay stick stickin' still
      stopping store stories strangers strap strength strike strong stronger students
      substitutes suffers suit sun super superhero survived swallow swear swim
      switchin' synapses syrup tag take taste tasty teach television tell
      temperature's temperatures ten than thang that thee there they'll thing think
      thirteen thrill time's times tips tired today together toilet tongue tons too
      took touch touchin' town toy training transitional trash tries truly trust
      trusted truth try trying turned two tyranny uncle's understand understood
      unfortunate universe unreal upon used usually utilize utilizes uuummmm valley
      vegetarian vengeance very viruses washin' waste wasted watch water weak wearing
      week weighed well-laid whip white wicked wife's wild wings wisdom workshop world
      worst wrong year yes zoo
    }
    SENTENCES = k "No, motherfucker.
Oh, I'm sorry, did I break your concentration?
Bitch, be cool!
Mama, I smoked the color TV!
Everybody strap in. I'm about to open some fucking windows!
Was that a goddamn shark broke through that door?
I'm serious as a heart attack.
I can do that.
Is she dead, yes or no?
Hold on to your butts!
Are you ready for the truth?
We happy?
I gotta piss.
No man, I don't eat pork.
The path of the righteous man is beset on all sides by the iniquities of the selfish and the tyranny of evil men.
And you will know My name is the Lord when I lay My vengeance upon thee.
Do you see any Teletubbies in here?
Do you see a slender plastic tag clipped to my shirt with my name printed on it?
Do you see a little Asian child with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it?
Well, that's what you see at a toy store.
And you must think you're in a toy store, because you're here shopping for an infant named Jeb.
Your bones don't break, mine do.
Your cells react to bacteria and viruses differently than mine.
You don't get sick, I do.
But for some reason, you and I react the exact same way to water.
We swallow it too fast, we choke.
We get some in our lungs, we drown.
However unreal it may seem, we are connected, you and I.
We're on the same curve, just on opposite ends.
Now that we know who you are, I know who I am.
Because of the kids.
They called me Mr Glass.
You think water moves fast?
You should see ice.
It moves like it has a mind.
Like it knows it killed the world once and got a taste for murder.
After the avalanche, it took us a week to climb out.
Now, I don't know exactly when we turned on each other, but I know that seven of us survived the slide... and only five made it out.
Now we took an oath, that I'm breaking now.
We said we'd say it was the snow that killed the other two, but it wasn't.
Nature is lethal but it doesn't hold a candle to man.
Motherfucker do that shit to me, he better paralyze my ass, 'cause I'll kill the motherfucker, know what I'm sayin'?
Now that there is the Tec-9, a crappy spray gun from South Miami.
This gun is advertised as the most popular gun in American crime.
Do you believe that shit?
It actually says that in the little book that comes with it: the most popular gun in American crime.
Like they're actually proud of that shit.
My money's in that office, right?
If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there.
Then I'm gonna shoot that bitch in the kneecaps, find out where my goddamn money is.
She gonna tell me too.
Hey, look at me when I'm talking to you, motherfucker.
You understand?
Hey, sewer rat may taste like pumpkin pie, but I'd never know 'cause I wouldn't eat the filthy motherfucker.
Just 'cause you pour syrup on something doesn't make it pancakes!
The very best there is.
When you absolutely, positively got to kill every motherfucker in the room, accept no substitutes.
Whoa.
Y'all take a chill.
You got to cool that shit off.
And that's the double-truth, Ruth.
Yeah, Zeus! As in, father of Apollo?
Mount Olympus?
Don't fuck with me or I'll shove a lightning bolt up your ass!
I remember my first time, it was out behind my uncle's barn with my second cousin.
She was two tons if she weighed a pound, I could have done better for myself.
Enough is enough! I have had it with these motherfucking snakes on this motherfucking plane!
But you are aware that there’s an invention called television and on this invention they show shows.
You're the weak.
And I am the tyranny of evil men.
But I'm tryin', Ringo.
I'm tryin' real hard to be the shepherd.
I don't want to hear about no motherfucking ifs.
All I want to hear from your ass is, you ain't got no problem, Jules.
Get the fuck out my face with that shit.
The motherfucker said that shit never had to pick up itty-bitty pieces of skull on account of your dumb ass.
".split("\n")
    PARAGRAPHS = k "Normally, both your asses would be dead as fucking fried chicken, but you happen to pull this shit while I'm in a transitional period so I don't wanna kill you, I wanna help you.But I can't give you this case, it don't belong to me. Besides, I've already been through too much shit this morning over this case to hand it over to your dumb ass.
Well, the way they make shows is, they make one show. That show's called a pilot. Then they show that show to the people who make shows, and on the strength of that one show they decide if they're going to make more shows. Some pilots get picked and become television programs. Some don't, become nothing. She starred in one of the ones that became nothing.
The path of the righteous man is beset on all sides by the iniquities of the selfish and the tyranny of evil men. Blessed is he who, in the name of charity and good will, shepherds the weak through the valley of darkness, for he is truly his brother's keeper and the finder of lost children. And I will strike down upon thee with great vengeance and furious anger those who would attempt to poison and destroy My brothers. And you will know My name is the Lord when I lay My vengeance upon thee.
Do you see any Teletubbies in here? Do you see a slender plastic tag clipped to my shirt with my name printed on it? Do you see a little Asian child with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? Well, that's what you see at a toy store. And you must think you're in a toy store, because you're here shopping for an infant named Jeb.
Your bones don't break, mine do. That's clear. Your cells react to bacteria and viruses differently than mine. You don't get sick, I do. That's also clear. But for some reason, you and I react the exact same way to water. We swallow it too fast, we choke. We get some in our lungs, we drown. However unreal it may seem, we are connected, you and I. We're on the same curve, just on opposite ends. Now that we know who you are, I know who I am. I'm not a mistake! It all makes sense! In a comic, you know how you can tell who the arch-villain's going to be? He's the exact opposite of the hero. And most times they're friends, like you and me! I should've known way back when... You know why, David? Because of the kids. They called me Mr Glass.
You think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder. After the avalanche, it took us a week to climb out. Now, I don't know exactly when we turned on each other, but I know that seven of us survived the slide... and only five made it out. Now we took an oath, that I'm breaking now. We said we'd say it was the snow that killed the other two, but it wasn't. Nature is lethal but it doesn't hold a candle to man.
Look, just because I don't be givin' no man a foot massage don't make it right for Marsellus to throw Antwone into a glass motherfuckin' house, fuckin' up the way the nigger talks. Motherfucker do that shit to me, he better paralyze my ass, 'cause I'll kill the motherfucker, know what I'm sayin'?
Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. Do you believe that shit? It actually says that in the little book that comes with it: the most popular gun in American crime. Like they're actually proud of that shit.
My money's in that office, right? If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there. Then I'm gonna shoot that bitch in the kneecaps, find out where my goddamn money is. She gonna tell me too. Hey, look at me when I'm talking to you, motherfucker. You listen: we go in there, and that nigga Winston or anybody else is in there, you the first motherfucker to get shot. You understand?
Hey, sewer rat may taste like pumpkin pie, but I'd never know 'cause I wouldn't eat the filthy motherfucker.
Just 'cause you pour syrup on something doesn't make it pancakes!
AK-47. The very best there is. When you absolutely, positively got to kill every motherfucker in the room, accept no substitutes.
Whoa. Y'all take a chill. You got to cool that shit off. And that's the double-truth, Ruth.
Yeah, Zeus! As in, father of Apollo? Mount Olympus? Don't fuck with me or I'll shove a lightning bolt up your ass!
I remember my first time, it was out behind my uncle's barn with my second cousin. She was two tons if she weighed a pound, I could have done better for myself.
Enough is enough! I have had it with these motherfucking snakes on this motherfucking plane!
But you are aware that there’s an invention called television and on this invention they show shows.
The truth is. You're the weak. And I am the tyranny of evil men. But I'm tryin', Ringo. I'm tryin' real hard to be the shepherd.
I don't want to hear about no motherfucking ifs. All I want to hear from your ass is, you ain't got no problem, Jules.
Get the fuck out my face with that shit. The motherfucker said that shit never had to pick up itty-bitty pieces of skull on account of your dumb ass.
".split("\n")
  end
end
