import strutils
import json
import jsony
import typedefs
import puppy

proc newCoCClient*(token: string): CoCClient =
    result.token = token
    var headers: HttpHeaders
    headers["Authorization"] = "Bearer " & token
    headers["Accept"] = "application/json"
    headers["Content-Type"] = "application/json"
    headers["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 OPR/106.0.0.0"
    result.headers = headers

proc getClanInfo*(coc_client: var CoCClient, clanTag: string): Clan =
    var url = (API_URL & "/clans/" & clanTag.replace("#", "%23"))
    let response = get(url, coc_client.headers)
    var json = fromJson(response.body)
    if response.code != 200:
        raise newException(CoCException, "Failed to get clan info: " & json["message"].getStr())
    return (response.body).fromJson(Clan)

proc getCurrentWar*(coc_client: var CoCClient, clanTag: string): ClanWar =
    var url = (API_URL & "/clans/" & clanTag.replace("#", "%23") & "/currentwar")
    let response = get(url, coc_client.headers)
    var json = fromJson(response.body)
    if response.code != 200:
        raise newException(CoCException, "Failed to get current war info: " & json["message"].getStr())
    return (response.body).fromJson(ClanWar)

proc getCurrentWarLeagueGroup*(coc_client: var CoCClient, clanTag: string): ClanWarLeagueGroup =
    var url = (API_URL & "/clans/" & clanTag.replace("#", "%23") & "/currentwar/leaguegroup")
    let response = get(url, coc_client.headers)
    echo response.body
    var json = fromJson(response.body)
    if response.code != 200:
        raise newException(CoCException, "Failed to get war logs: " & json["message"].getStr())
    return (response.body).fromJson(ClanWarLeagueGroup)

proc getWarLogs*(coc_client: var CoCClient, clanTag: string): ClanWarLog =
    var url = (API_URL & "/clans/" & clanTag.replace("#", "%23") & "/warlog")
    let response = get(url, coc_client.headers)
    var json = fromJson(response.body)
    if response.code != 200:
        raise newException(CoCException, "Failed to get war logs: " & json["message"].getStr())
    return (response.body).fromJson(ClanWarLog)

proc getWarLog*(coc_client: var CoCClient, clanTag: string, warTag: string): ClanWarLogEntry =
    var url = (API_URL & "/clans/" & clanTag.replace("#", "%23") & "/warlog/" & warTag)
    let response = get(url, coc_client.headers)
    var json = fromJson(response.body)
    if response.code != 200:
        raise newException(CoCException, "Failed to get war log: " & json["message"].getStr())
    return (response.body).fromJson(ClanWarLogEntry)

proc getCapitalRaidSeasons*(coc_client: var CoCClient, clanTag: string): ClanCapitalRaidSeasonList =
    var url = (API_URL & "/clans/" & clanTag.replace("#", "%23") & "/capitalraidseasons")
    let response = get(url, coc_client.headers)
    var json = fromJson(response.body)
    if response.code != 200:
        raise newException(CoCException, "Failed to get capital raid seasons: " & json["message"].getStr())
    return (response.body).fromJson(ClanCapitalRaidSeasonList)

proc getClanMembers*(coc_client: var CoCClient, clanTag: string): ClanMemberList =
    var url = (API_URL & "/clans/" & clanTag.replace("#", "%23") & "/members")
    let response = get(url, coc_client.headers)
    var json = fromJson(response.body)
    if response.code != 200:
        raise newException(CoCException, "Failed to get clan members: " & json["message"].getStr())
    return (response.body).fromJson(ClanMemberList)


proc getPlayerInfo*(coc_client: var CoCClient, playerTag: string): Player =
    var url = (API_URL & "/players/" & playerTag.replace("#", "%23"))
    let response = get(url, coc_client.headers)
    var json = fromJson(response.body)
    if response.code != 200:
        raise newException(CoCException, "Failed to get player info: " & json["message"].getStr())
    return (response.body).fromJson(Player)

proc verifyPlayerToken*(coc_client: var CoCClient, playerTag, token: string): VerifyTokenResponse =
    var url = (API_URL & "/players/" & playerTag.replace("#", "%23") & "/verifytoken")
    let body = %*{"token": token}
    let response = post(url, coc_client.headers, $body)
    var json = fromJson(response.body)
    if response.code != 200:
        raise newException(CoCException, "Failed to verify player token: " & json["message"].getStr())
    return (response.body).fromJson(VerifyTokenResponse)

proc searchClans*(coc_client: var CoCClient, name: string, limit = 10): ClanList =
    var url = (API_URL & "/clans?name=" & name & "&limit=" & $limit)
    let response = get(url, coc_client.headers)
    var json = fromJson(response.body)
    if response.code != 200:
        raise newException(CoCException, "Failed to search clans: " & json["message"].getStr())
    return (response.body).fromJson(ClanList)