#[
Will not compile if you don't enable SSL:

nim c -d:ssl -r -o:bin/http_request http_request.nim
]#

import httpclient, times, strformat, strutils, uri

const appToken = ""
const baseUrl = "https://data.cityofchicago.org/resource/xqx5-8hwx.json?"
let afterDate = now() - 3.months
let afterDateStr = format(afterDate, "yyyy-MM-dd") & "T00:00:00.000"
var query = &"""
  application_type = 'ISSUE' AND
  license_status = 'AAI' AND
  license_start_date >= '{afterDateStr}' AND
  within_circle(location, 41.972116, -87.689468, 500)
"""
query = query.replace("\p", "").unindent
let params = {
  "$$app_token": appToken,
  "$where": query
}

proc getQueryString(params: openarray[(string, string)]): string =
  result = ""
  for i, pair in params:
    let (k, v) = pair
    result.add(k & "=" & uri.encodeUrl(v) & "&")

# echo getQueryString(params)
let url = baseUrl & getQueryString(params)

let client = newHttpClient()
echo client.getContent(url)
