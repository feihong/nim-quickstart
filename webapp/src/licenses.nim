import
  os, httpclient, times, uri, strformat, strutils, parsecfg, json, algorithm
import asyncdispatch, asyncfile

const baseUrl = "https://data.cityofchicago.org/resource/xqx5-8hwx.json?"
let cfg = loadConfig("config.ini")
let appToken = cfg.getSectionValue("licenses", "auth_token")
let latitude = cfg.getSectionValue("licenses", "latitude")
let longitude = cfg.getSectionValue("licenses", "longitude")
let radius = cfg.getSectionValue("licenses", "radius")

# In seconds
const recentThreshold = 6 * 60 * 60

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
  echo "Downloading licenses using ", url

  let client = newAsyncHttpClient()
  let content = await client.getContent(url)
  let file = openAsync("licenses.json", fmWrite)
  await file.write(content)

  return content

proc decodeLicenses(jsonStr: string): seq[BusinessLicense] =
  let jsonNode = parseJson(jsonStr)
  return jsonNode.to(seq[BusinessLicense])

proc licenseFileIsRecent(): bool =
  if not fileExists("licenses.json"):
    return false

  let createTime = getFileInfo("licenses.json").creationTime
  return (getTime().toUnix - createTime.toUnix) < recentThreshold

proc getLicenses*(): Future[seq[BusinessLicense]] {.async.} =
  if licenseFileIsRecent():
    echo "Fetching licenses from licenses.json"
    let file = openAsync("licenses.json", fmRead)
    result = decodeLicenses(await file.readAll())
    file.close()
  else:
    result = decodeLicenses(await downloadLicenses())

  for lic in result.mitems:
    # Chop off the time portion of the string
    lic.date_issued = lic.date_issued.substr(0, 9)

  # Sort by most recent first
  result.sort do (x, y: BusinessLicense) -> int:
    -cmp(x.date_issued, y.date_issued)
