#[
Will not compile if you don't enable SSL:

nim c -d:ssl -r -o:bin/http_request http_request.nim
]#

import httpclient, times, strformat, strutils, uri, parsecfg

let appToken = loadConfig("webapp/config.ini").getSectionValue("", "auth_token")
const baseUrl = "https://data.cityofchicago.org/resource/xqx5-8hwx.json?"
let afterDate = now() - 3.months
let afterDateStr = format(afterDate, "yyyy-MM-dd") & "T00:00:00.000"
var query = &"""
  application_type = 'ISSUE' AND
  license_status = 'AAI' AND
  license_start_date >= '{afterDateStr}' AND
  within_circle(location, 41.972116, -87.689468, 1600)
"""
query = query.replace("\p", "").unindent
let params = {
  "$$app_token": appToken,
  "$where": query
}

proc getQueryString(params: openarray[(string, string)]): string =
  result = ""
  for pair in params:
    let (k, v) = pair
    result.add(k & "=" & uri.encodeUrl(v) & "&")

let url = baseUrl & getQueryString(params)

let client = newHttpClient()
let content = client.getContent(url)
writeFile("licenses.json", content)
