;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;    Files & Directories    ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(let ((backup-dir "~/.cache/emacs/backups/")
      (auto-saves-dir "~/.cache/emacs/auto-saves/"))

  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))

  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")))

(setq backup-by-copying t                               ; don't de-link hard links
      delete-old-versions t                             ; clean up the backups
      version-control t                                 ; use version numbers on backups,
      kept-new-versions 5                               ; keep some new versions
      kept-old-versions 2)                              ; and some old ones, too


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;    Graphical User Interface    ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when window-system                                     ; window dimensions, font, and UI
  (setq default-frame-alist
    '((top . 80) (left . 300) (width . 85) (height . 45)))
  (set-face-attribute 'default nil :font "Menlo" :height 160)
  (load-theme 'tango-dark)                              ; built-in theme (easy on the eye)
  (scroll-bar-mode -1)                                  ; don't show scroll bar on right
  (tool-bar-mode -1)                                    ; don't show "File, Edit, ..." icons
  (tooltip-mode -1)                                     ; don't show info at mouse pointer
  (set-fringe-mode 10)                                  ; show borders on either side of frame
  (menu-bar-mode -1)                                    ; don't show "File, Edit, ..." options
)

(defun make-offset-frame (&optional x y)
  "Ensure that successive frames don't overlap"
  (let* ((params  (frame-parameters))
         (ctop    (or (cdr (assoc 'top params))   0))
         (cleft   (or (cdr (assoc 'left params))  0)))
    (setq x  (or x  30)
          y  (or y  30))
    (make-frame (append `((top . ,(+ ctop y)) (left . ,(+ cleft x)))
                        default-frame-alist))))

(defun my-make-frame-command (&optional x y)
  "Make new frames as per above function"
  (interactive)
  (make-offset-frame x y))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;    Global Defaults    ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; use "esc" instead of "C-g" to cancel / quit
(global-set-key (kbd "C-x 5 2") 'my-make-frame-command) ; overwrite default make new frame command with custom function

(setq-default
  inhibit-startup-screen     t
  initial-scratch-message    ""                         ; no message on scratch buffer
  initial-major-mode         'text-mode                 ; start in text mode
  delete-selection-mode      t                          ; highlighted characters will be replaced on key press
  delete-trailing-whitespace t                          ; remove all whitespace from the end of each line in all buffers
  select-enable-clipboard    t                          ; enable system clipboard
  show-paren-delay           0                          ; needs to be set before show-paren-mode
  sentence-end-double-space  nil                        ; sentences end with single space after period
  confirm-kill-emacs         'y-or-n-p                  ; always confirm on exit
  help-window-select         t                          ; help window will become active if opened
  word-wrap                  t                          ; wrap words to next line if they don't fit in the window
)

(set-default-coding-systems 'utf-8)                     ; UTF-8 file encoding
(defalias 'yes-or-no-p 'y-or-n-p)                       ; confirmation with 'y' / 'n' instead of 'yes' / 'no'
(global-auto-revert-mode t)                             ; refresh current buffer on file change
(show-paren-mode 1)                                     ; highlight matching parenthesis without delay
(column-number-mode)                                    ; show column numbers

(global-display-line-numbers-mode t)                    ; show row numbers everywhere except org mode and terminal emulator
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(defun untabify-except-makefiles ()
  "Replace tabs with spaces in all buffers except in makefiles."
  (unless (derived-mode-p 'makefile-mode)
    (untabify (point-min) (point-max))))

(add-hook 'before-save-hook 'untabify-except-makefiles) ; convert all tabs to spaces on save
