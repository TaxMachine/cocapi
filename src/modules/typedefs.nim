import options
import tables
import puppy

const API_URL* = "https://api.clashofclans.com/v1"

type
    CoCException* = object of IOError
    CoCclient* = object
        token*: string
        headers*: HttpHeaders

    IconUrls* = object
        small*: string
        medium*: string

    Label* = object
        id*: int
        name*: string
        iconUrls*: IconUrls

    Language* = object
        name*: string
        id*: int
        languageCode*: string

    Location* = object
        localizedName*: string
        id*: int
        name*: string
        isCountry*: bool
        countryCode*: string

    ClanDistrictData* = object
        name*: string
        id*: int
        districtHallLevel*: int

    ClanCapital* = object
        capitalHallLevel*: int
        districts*: seq[ClanDistrictData]

    BadgeUrls* = object
        small*: string
        large*: string
        medium*: string

    League* = object
        id*: int
        name*: string
        iconUrls*: IconUrls

    BuilderBaseLeague* = object
        id*: int
        name*: string

    PlayerHouseElement* = object
        id*: int
        `type`*: string

    PlayerHouse* = object
        elements*: seq[PlayerHouseElement]

    WarLeague* = object
        id*: int
        name*: string

    CapitalLeague* = object
        id*: int
        name*: string

    ClanMember* = object
        league*: League
        builderBaseLeague*: BuilderBaseLeague
        tag*: string
        name*: string
        role*: string
        townHallLevel*: int
        expLevel*: int
        clanRank*: int
        previousClanRank*: int
        donations*: int
        donationsReceived*: int
        trophies*: int
        builderBaseTrophies*: int
        playerHouse*: PlayerHouse


    Clan* = object
        warLeague*: WarLeague
        capitalLeague*: CapitalLeague
        memberList*: seq[ClanMember]
        tag*: string
        chatLanguage*: Language
        clanBuilderBasePoints*: int
        clanCapitalPoints*: int
        requiredTrophies*: int
        requiredBuilderBaseTrophies*: int
        requiredTownhallLevel*: int
        isFamilyFriendly*: bool
        isWarLogPublic*: bool
        warFrequency*: string
        clanLevel*: int
        warWinStreak*: int
        warWins*: int
        warTies*: int
        warLosses*: int
        clanPoints*: int
        labels*: seq[Label]
        name*: string
        location*: Location
        `type`*: string
        members*: int
        description*: string
        clanCapital*: ClanCapital
        badgeUrls*: BadgeUrls

    ClanWarAttack* = object
        order*: int
        attackerTag*: string
        defenderTag*: string
        stars*: int
        destructionPercentage*: float
        duration*: int

    ClanWarMember* = object
        tag*: string
        name*: string
        mapPosition*: int
        townhallLevel*: int
        opponentAttacks*: int
        bestOpponentAttack*: ClanWarAttack
        attacks*: seq[ClanWarAttack]

    WarClan* = object
        destructionPercentage*: float
        tag*: string
        name*: string
        badgeUrls*: BadgeUrls
        clanLevel*: int
        attacks*: int
        stars*: int
        expEarned*: int
        members*: seq[ClanWarMember]

    ClanWar* = object
        clan*: WarClan
        opponent*: WarClan
        teamSize*: int
        attacksPerMember*: int
        startTime*: string
        state*: string
        endTime*: string
        preparationStartTime*: string

    ClanWarLeagueRound* = object
        warTags*: seq[string]

    ClanWarLeagueClanMember* = object
        tag*: string
        townHallLevel*: int
        name*: string

    ClanWarLeagueClan* = object
        tag*: string
        clanLevel*: int
        name*: string
        members*: seq[ClanWarLeagueClanMember]
        badgeUrls*: BadgeUrls

    ClanWarLeagueGroup* = object
        state*: string
        tag*: string
        season*: string
        rounds*: seq[ClanWarLeagueRound]
        clans*: seq[ClanWarLeagueClan]

    ClanWarLogEntry* = object
        clan*: WarClan
        opponent*: WarClan
        teamSize*: int
        attacksPerMember*: int
        endTime*: string
        result*: string

    Paging* = object
        cursors*: Table[string, string]

    ClanWarLog* = object
        items*: seq[ClanWarLogEntry]
        paging*: Paging

    ClanCapitalRaidSeasonClanInfo* = object
        tag*: string
        name*: string
        level*: int
        badgeUrls*: BadgeUrls

    ClanCapitalRaidSeasonAttack* = object
        attacker*: ClanCapitalRaidSeasonClanInfo
        destructionPercent*: int
        stars*: int

    ClanCapitalRaidSeasonDistrict* = object
        stars*: int
        name*: string
        id*: int
        destructionPercent*: int
        attackCount*: int
        totalLooted*: int
        attacks*: seq[ClanCapitalRaidSeasonAttack]
        districtHallLevel*: int

    ClanCapitalRaidSeasonAttackEntry* = object
        defender*: ClanCapitalRaidSeasonClanInfo
        attackCount*: int
        districtCount*: int
        districtDestroyed*: int
        districts*: seq[ClanCapitalRaidSeasonDistrict]

    ClanCapitalRaidSeasonDefenseEntry* = object
        attacker*: ClanCapitalRaidSeasonClanInfo
        attackCount*: int
        districtCount*: int
        districtsDestroyed*: int
        districts*: seq[ClanCapitalRaidSeasonDistrict]

    ClanCapitalRaidSeasonMember* = object
        tag*: string
        name*: string
        attacks*: int
        attackLimit*: int
        bonusAttackLimit*: int
        capitalResourcesLooted*: int

    ClanCapitalRaidSeason* = object
        attackLog*: seq[ClanCapitalRaidSeasonAttackEntry]
        defenseLog*: seq[ClanCapitalRaidSeasonDefenseEntry]
        state*: string
        startTime*: string
        endTime*: string
        capitalTotalLoot*: int
        raidsCompleted*: int
        totalAttacks*: int
        enemyDistrictsDestroyed*: int
        offensiveRewards*: int
        defensiveRewards*: int
        members*: seq[ClanCapitalRaidSeasonMember]

    ClanCapitalRaidSeasonList* = object
        items*: seq[ClanCapitalRaidSeason]
        paging*: Paging

    ClanMemberList* = object
        items*: seq[ClanMember]
        paging*: Paging

    PlayerClan* = object
        tag*: string
        clanLevel*: int
        name*: string
        badgeUrls*: BadgeUrls

    LegendLeagueTournamentSeasonResult* = object
        trophies*: int
        id*: string
        rank*: int

    PlayerLegendStatistics* = object
        currentSeason*: LegendLeagueTournamentSeasonResult
        bestSeason*: LegendLeagueTournamentSeasonResult
        previousBuilderBaseSeason*: LegendLeagueTournamentSeasonResult
        bestBuilderBaseSeason*: LegendLeagueTournamentSeasonResult
        legendTrophies*: int
        previousSeason*: LegendLeagueTournamentSeasonResult

    HeroEquipment* = object
        name*: string
        level*: int
        maxLevel*: int
        village*: string

    PlayerItemLevel* = object
        level*: int
        name*: string
        maxLevel*: int
        village*: string
        superTroopIsActive*: Option[bool]
        equipment*: Option[seq[HeroEquipment]]

    PlayerAchievement* = object
        stars*: int
        value*: int
        name*: string
        target*: int
        info*: string
        completionInfo*: string
        village*: string

    Player* = object
        league*: League
        clan*: PlayerClan
        builderBaseLeague*: BuilderBaseLeague
        role*: string
        warPreference*: string
        attackWins*: int
        defenseWins*: int
        townHallLevel*: int
        townHallWeaponLevel*: int
        legendStatistics*: PlayerLegendStatistics
        troops*: seq[PlayerItemLevel]
        heroes*: seq[PlayerItemLevel]
        heroEquipment*: seq[PlayerItemLevel]
        spells*: seq[PlayerItemLevel]
        labels*: seq[Label]
        tag*: string
        name*: string
        expLevel*: int
        trophies*: int
        bestTrophies*: int
        donations*: int
        donationsReceived*: int
        builderHallLevel*: int
        builderBaseTrophies*: int
        bestBuilderBaseTrophies*: int
        warStars*: int
        achievements*: seq[PlayerAchievement]
        clanCapitalContributions*: int
        playerHouse*: PlayerHouse

    VerifyTokenResponse* = object
        tag*: string
        token*: string
        status*: string

    ClanList* = object
        items*: seq[Clan]
        paging*: Paging