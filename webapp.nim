import jester, asyncdispatch, htmlgen


let settings = newSettings(port = Port(8000))

routes:
  get "/":
    resp h1("Hello world")

runForever()
