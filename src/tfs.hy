(import [argparse [ArgumentParser]])

(defn config [args]
  (print args))

(defn make-config-parser [parser]
  (setv config-parser (.add-parser parser "config"
    :help "configure connection to TFS"))
  (.add-argument config_parser "--username"
    :help "TFS username"
    :required True)
  (.add-argument config_parser "--token"
    :help "TFS personal access token"
    :required True)
  (.add-argument config_parser "--url"
    :help "TFS API URL, for example, http://<domain>.com/tfs"
    :required True)
  (.set-defaults config-parser :which "config"))

(defmain [&rest _]
  (setv parser (ArgumentParser))
  (setv subparser (.add-subparsers parser))
  (make-config-parser subparser)
  (setv args (parser.parse-args))
  (cond [(= args.which "config") (config args)]))
