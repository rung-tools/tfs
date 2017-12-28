(import json
        requests)

(defclass Client []
  [url None]
  [username None]
  [token None]

  (defn --init-- [self url username token]
    (setv self.url url)
    (setv self.username username)
    (setv self.token token))

  (defn get [self path]
    (setv url (+ self.url path))
    (setv auth (, self.username self.token))
    (setv response (requests.get url :auth auth))
    (json.loads response.text)))
