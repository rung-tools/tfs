(import curses
        curses.panel
        [time [sleep]]
        [config [read-config]])

(defn log [text]
  (with [fd (open "log.txt" "w+")]
    (fd.write text)))

(defclass Pane []
  [app None]

  (defn --init-- [self mode app]
    (setv self.app app)
    (setv self.mode mode)
    (setv self.dims (, 0 0 0 0))
    (setv self.max-height app.max-height)
    (setv self.max-width app.max-width)
    (self.init-ui))

  (defn init-ui [self]
    (setv self.dims (cond
      [(= "left" self.mode) (, (- self.max-height 2) (int (/ self.max-width 2)) 1 0)]))
    (setv self.window (apply curses.newwin self.dims))
    (self.window.leaveok 1)
    (self.window.keypad 1)
    (self.window.bkgd curses.COLOR_GREEN)))

(defclass Board []
  [window None]
  [config None]
  [max-width 0]
  [max-height 0]
  [left-pane None]

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
    (setv self.left-pane (Pane "left" self))
    (sleep 5)))

(defn board [window prefs]
  (setv app (Board window prefs))
  (app.run))

(defn render []
  (setv prefs (read-config))
  (curses.wrapper board prefs))
