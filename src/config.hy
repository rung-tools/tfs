(import [validators]
        [os.path [expanduser]]
        json)

(defn config [args]
  (unless (validators.url args.url)
    (raise (Exception (+ "invalid url: " args.url))))
  (setv json-string
    (json.dumps {"username" args.username
                 "token" args.token
                 "url" args.url}))
  (with [fd (open (+ (expanduser "~") "/.tfsconfig") "w+")]
    (fd.write json-string)))
