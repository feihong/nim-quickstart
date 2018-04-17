#[
nim c -r -o:webapp app.nim
]#

import strutils, strformat
import asyncdispatch, asyncfile
import jester
import hanzi, licenses


include "page.tmpl"

settings:
  port = Port(8000)

routes:
  get "/":
    resp html_page("Home", """
      <h1>Home</h1>

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
    let count = if @"count" == "":
                  5
                else:
                  parseInt(@"count")
    resp html_page("Random Hanzi", &"<p style='font-size: 4rem'>{hanziString(count)}</h1>")

  get "/licenses/":
    # let licenses = await getLicenses()
    resp "what"

  get "/licenses.json":
    let file = openAsync("licenses.json", fmRead)
    let payload = await file.readAll()
    resp payload, "application/json"

runForever()
