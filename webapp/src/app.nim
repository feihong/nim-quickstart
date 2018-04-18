#[
nim c -r -o:webapp app.nim
]#

import strutils, strformat, sequtils, parsecfg
import asyncdispatch, asyncfile
import jester
import hanzi, licenses

include "page.tmpl"
include "license_page.tmpl"

let cfg = loadConfig("config.ini")

settings:
  port = cfg.getSectionValue("server", "port").parseInt.Port

routes:
  get "/":
    resp html_page("Home", """
      <h1 class="title">Home</h1>

      <ul>
        <li>
          <a href="hanzi/">Random Hanzi</a>
        </li>
        <li>
          <a href="licenses/">Business Licenses</a>
        </li>
      </ul>
    """)

  get "/hanzi/@count?":
    let count = if @"count" == "": 5
                else: parseInt(@"count")
    resp html_page("Random Hanzi", &"""
      <h1 class="title">随机的汉子</h1>
      <div style='font-size: 4rem'>{hanziString(count)}</div>""")

  get "/licenses/":
    # let licenses =
    # let names = map(licenses, proc (x: BusinessLicense): string = x.doing_business_as_name)
    let body = license_page(await getLicenses())
    resp html_page("Licenses", body)

  get "/licenses.json":
    let file = openAsync("licenses.json", fmRead)
    let payload = await file.readAll()
    resp payload, "application/json"

runForever()
