(import curses
        curses.panel
        [time [sleep]]
        [config [read-config]])

(defn log [text]
  (with [fd (open "log.txt" "w+")]
    (fd.write text)))

(defclass Board []
  [window None]
  [config None]
  [max-width 0]
  [max-height 0]

  (defn --init-- [self window config]
    (setv self.window window)
    (setv self.config config))

  (defn run [self]
    (setv limits (self.window.getmaxyx))
    (setv self.max-height (get limits 0))
    (setv self.max-width (get limits 1))
    (curses.cbreak)
    (curses.raw)
    (self.window.leaveok 1)
    (curses.curs_set 0)
    (sleep 5)
    (log (str limits))))

(defn board [window prefs]
  (setv app (Board window prefs))
  (app.run))

(defn render []
  (setv prefs (read-config))
  (curses.wrapper board prefs))
