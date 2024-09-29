import json
import sequtils
import jsony
import puppy

const COC_WEBAPI = "https://developer.clashofclans.com"

type
    CoCWebException* = object of ValueError
    WebClient* = object
        headers*: HttpHeaders
        mail*, password*: string

    APIKey* = object
        cidrRanges*: seq[string]
        description*, developerId*, id*, key*, name*, origins*: string
        scopes*: seq[string]
        tier*: string
        validUntil*: string


proc newWebClient*(): WebClient =
    var headers: HttpHeaders
    headers["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 OPR/107.0.0.0"
    headers["X-Requested-With"] = "XMLHttpRequest"
    headers["Content-Type"] = "application/json"
    headers["Origin"] = COC_WEBAPI
    headers["Referer"] = COC_WEBAPI & "/"
    result = WebClient(headers: headers)

proc login*(wclient: var WebClient, mail, password: string): void =
    wclient.mail = mail
    wclient.password = password
    let url = COC_WEBAPI & "/api/login"
    let data = %*{
        "email": mail,
        "password": password
    }
    let response = post(url, wclient.headers, $data)
    if response.code != 200:
        raise newException(CoCWebException, "Login failed")
    wclient.headers["Cookie"] = response.headers["Set-Cookie"]


proc verifyLogin*(wclient: var WebClient): bool =
    let response = post(COC_WEBAPI & "/api/account/load", wclient.headers, $ %*{})
    response.code == 200

proc getAPIKeys*(wclient: var WebClient): seq[APIKey] =
    let response = post(COC_WEBAPI & "/api/apikey/list", wclient.headers, $ %*{})
    if response.code != 200:
        raise newException(CoCWebException, "Failed to get API keys")
    let data = parseJson(response.body)
    
    return ($data["keys"]).fromJson(seq[APIKey])

proc createAPIKey*(wclient: var WebClient, name, description: string, ips: seq[string]): void =
    let url = COC_WEBAPI & "/api/apikey/create"
    let data = %*{
        "name": name,
        "description": description,
        "cidrRanges": ips,
        "scopes": nil
    }
    let response = post(url, wclient.headers, $data)
    if response.code != 200:
        raise newException(CoCWebException, "Failed to create API key")

proc deleteAPIKey*(wclient: var WebClient, key: APIKey): void =
    let url = COC_WEBAPI & "/api/apikey/revoke"
    let data = %*{
        "id": key.id
    }
    let response = post(url, wclient.headers, $data)
    if response.code != 200:
        raise newException(CoCWebException, "Failed to delete API key")

proc deleteAPIKey*(wclient: var WebClient, keyID: string): void =
    let url = COC_WEBAPI & "/api/apikey/revoke"
    let data = %*{
        "id": keyID
    }
    let response = post(url, wclient.headers, $data)
    if response.code != 200:
        raise newException(CoCWebException, "Failed to delete API key")

proc getCurrentIP*(): string =
    let response = get("https://api.ipify.org")
    if response.code != 200:
        raise newException(CoCWebException, "Failed to get current IP")
    return response.body

proc getValidKeys*(wclient: var WebClient): seq[APIKey] =
    let keys = getAPIKeys(wclient)
    let currentIP = getCurrentIP()
    return keys.filterIt(it.cidrRanges.contains(currentIP))