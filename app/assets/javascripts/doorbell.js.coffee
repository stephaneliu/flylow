window.doorbellOptions = appKey: "NmQgKGyvkae8bEMW9CBbYQkLMoXyYpacP1KbOJduz3NwWbTxSmo5v1xItYip24v0"
((d, t) ->
  g       = d.createElement(t)
  g.id    = "doorbellScript"
  g.type  = "text/javascript"
  g.async = true
  g.src   = "https://doorbell.io/button/67"
  (d.getElementsByTagName("head")[0] or d.getElementsByTagName("body")[0]).appendChild g) document, "script"
