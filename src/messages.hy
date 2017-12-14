(import curses
        curses.panel)

(defn confirm [parent-window title question &optional [default 0]]
  (setv selected-button (| curses.A-BOLD (curses.color-pair 1)))
  (setv not-selected-button (| curses.A-BOLD (curses.color-pair 2)))
  (setv height 5)
  (setv width (min (max 34 (+ (len question) 5)) (- parent-window.max-width 2)))
  (setv window (curses.newwin
    height
    width
    (int (/ (- app.max-height - height) 2))
    (int (/ (- app.max-width - width) 2))))
  (setv panel-window (curses.panel.new-panel window)
  (panel.window.top)
  (window.bkgd (curses.color-pair 2))
  (window.erase)
  (window.box 0 0)
  (window.addstr
    0
    (int (/ (- (- width (len title)) 2) 2))
    title
    (| (curses.color-pair 2) curses.A-BOLD))
  (window.addstr 1 2 (+ question "?"))
  (window.refresh))

  (setv row (+ (int (/ (- parent-window.max-height height) 2)) 3))
  (setv column (int (/ (- parent-window.max-width width) 2)))
  (setv column-1 (+ column (int (/ width 5)) 1))
  (setv column-2 (- (+ column (int (/ (* width 4) 5))) 6))
  (window.keypad 1)
  (setv answer default)
  (while True
    (do
      (setv (, attr-yes attr-no)
        (if (= 1 answer)
          (, selected-button not-selected-button)
          (, not-selected-button selected-button)))
      (setv yes-button (curses.newpad 1 8))
      (yes-button.addstr 0 0 "[ Yes ]" attr-yes)
      (yes-button.refresh 0 0 row column-1 (+ row 1) (+ column-1 6))
      (setv no-button (curses.newpad 1 7))
      (no-button.addstr 0 0 "[ No ]" attr-no)
      (no-button.refresh 0 0 row column-2 (+ row 1) (+ column-2 5))

      (setv char (win.getch))
      (cond
        [(in char (, curses.KEY-UP curses.KEY-DOWN curses.KEY-LEFT curses.KEY-RIGHT 9))
          (setv answer (not answer))]
        [(in char (, (ord "Y") (ord "y")))
          (do
            (setv answer 1)
            (break))]
        [(in char (, (ord "N") (ord "n")))
          (do
            (setv answer 0)
            (break))]
        [(in char (, 0x03 0x1B))
          (do
            (setv answer -1)
            (break))]
        [(in char (, 10 13))
          (break)]
        [True (curses.beep)])))
  (panel-window.hide)
  answer)
