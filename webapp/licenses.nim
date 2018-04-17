import
  httpclient, times, uri, strformat, strutils, parsecfg, json
import asyncdispatch, asyncfile

const baseUrl = "https://data.cityofchicago.org/resource/xqx5-8hwx.json?"
let cfg = loadConfig("config.ini")
let appToken = cfg.getSectionValue("licenses", "auth_token")
let latitude = cfg.getSectionValue("licenses", "latitude")
let longitude = cfg.getSectionValue("licenses", "longitude")
let radius = cfg.getSectionValue("licenses", "radius")

type
  BusinessLicense* = object
    doing_business_as_name*: string
    legal_name*: string
    address*: string
    business_activity*: string
    date_issued*: string
    longitude: string
    latitude: string

proc getQueryString(params: openarray[(string, string)]): string =
  result = ""
  for pair in params:
    let (k, v) = pair
    result.add(k & "=" & uri.encodeUrl(v) & "&")

proc downloadLicenses(): Future[string] {.async.} =
  let afterDate = now() - 3.months
  let afterDateStr = format(afterDate, "yyyy-MM-dd") & "T00:00:00.000"
  let query = &"""
    application_type = 'ISSUE' AND
    license_status = 'AAI' AND
    license_start_date >= '{afterDateStr}' AND
    within_circle(location, {latitude}, {longitude}, {radius})
  """
  let params = {
    "$$app_token": appToken,
    "$where": query.replace("\p", "").unindent
  }

  let url = baseUrl & getQueryString(params)

  let client = newAsyncHttpClient()
  let content = await client.getContent(url)
  let file = openAsync("licenses.json", fmWrite)
  await file.write(content)

  return content

proc decodeLicenses(jsonStr: string): seq[BusinessLicense] =
  let jsonNode = parseJson(jsonStr)
  return jsonNode.to(seq[BusinessLicense])

proc getLicenses*(): Future[seq[BusinessLicense]] {.async.} =
  let file = openAsync("licenses.json", fmRead)
  return decodeLicenses(await file.readAll())
