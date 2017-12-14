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
      [(= "left" self.mode) (, (- self.max-height 1) (int (/ self.max-width 2)) 0 0)]
      [(= "right" self.mode) (, (- self.max-height 1) (int (/ self.max-width 2)) 0 (int (/ self.max-width 2)))]))
    (setv self.window (apply curses.newwin self.dims))
    (self.window.leaveok 1)
    (self.window.keypad 1)
    (curses.init-pair 1 curses.COLOR-BLUE curses.COLOR-BLACK)
    (self.window.bkgd (curses.color-pair 1))
    (self.window.box)
    (self.window.refresh)))

(defclass Board []
  [window None]
  [config None]
  [max-width 0]
  [max-height 0]
  [left-pane None]
  [right-pane None]

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
    (setv self.right-pane (Pane "right" self))
    (sleep 5)))

(defn board [window prefs]
  (setv app (Board window prefs))
  (app.run))

(defn render []
  (setv prefs (read-config))
  (curses.wrapper board prefs))
