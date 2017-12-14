#!/usr/bin/env hy
(import [argparse [ArgumentParser]]
        [config [config]]
        [termcolor [cprint]]
        sys)

(defn show-error [message]
  (cprint (+ "✗ Error: " (str message)) "red" :file sys.stderr)
  (exit 1))

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
    :help "TFS api url, for example, http://<domain>.com/tfs"
    :required True)
  (.set-defaults config-parser :which "config"))

(defmain [&rest _]
  (setv parser (ArgumentParser))
  (setv subparser (.add-subparsers parser))
  (make-config-parser subparser)
  (setv args (parser.parse-args))
  (try
    (cond [(= args.which "config") (config args)])
    (except [e Exception]
      (show-error e))))
