;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
;;

(setq toggle-debug-on-error 1)
(setq comp-native-compilation t)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;;(setq doom-theme 'catppuccin)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

(require 'projectile)
(projectile-mode +1)

(setq
 projectile-project-search-path '("~/SynologyDrive/Path/projects/" "~/projects/" "~/SynologyDrive/projects/"))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Mappings
(map! :leader
      (:prefix ("f" . "file")
       :desc "Find file with fzf" "f" #'counsel-fzf))

;; Show the tabs
(tab-bar-mode)

;; Shows workspaces on the minibuffer at the bottom
(after! persp-mode
  (defun display-workspaces-in-minibuffer ()
    (with-current-buffer " *Minibuf-0*"
      (erase-buffer)
      (insert (+workspace--tabline))))
  (run-with-idle-timer 1 t #'display-workspaces-in-minibuffer)
  (+workspace/display))

;; Transparency
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))


;; org-roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/SynologyDrive/Documents/org/roam")
  (org-id-locations-file "~/SynologyDrive/Documents/org/roam/.orgids")
  :config
  (org-roam-setup))

;; Org mode
(setq org-agenda-files '("~/SynologyDrive/Documents/org/tasks" "~/SynologyDrive/Documents/org/roam"))
(setq org-directory "~/SynologyDrive/Documents/org/org/")
(setq org-agenda-start-with-log-mode t)
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-refile-targets
      '(
        ("archive.org" :maxlevel . 1)
        ("tasks.org" :maxlevel . 1)
        ("spaceboi.org" :maxlevel . 1)
        ("hostman.org" :maxlevel . 1)
        )
      )
;; save files when we org-refile
(advice-add 'org-refile :after 'org-save-all-org-buffers)

(dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.1)
                (org-level-3 . 1.05)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
  (set-face-attribute (car face) nil :weight 'regular :height (cdr face)))

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
;; ;; (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
;; (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
;; (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
;; (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

(after! org
  (add-hook 'org-mode-hook
            (lambda ()
              (org-indent-mode)
              (variable-pitch-mode 1)
              (auto-fill-mode -1)
              (visual-line-mode 1)
              (text-scale-set 2)
              (visual-fill-column-mode)
              (setq-default visual-fill-column-center-text t)
              (setq display-line-numbers nil)
              )
            )

  )

;; Org Capture templates
;; Template breakdown:
;; "* TODO %?"   => Creates a heading with "TODO" and places the cursor (%?) for task input.
;; "%U"          => Inserts the inactive timestamp.
;; "%a"          => Inserts a contextual link/annotation.
;; "%i"          => Inserts any initially selected text.

(setq org-capture-templates
      `(("t" "Tasks / Projects")
        ("tt" "Task" entry (file+olp "~/SynologyDrive/Documents/org/tasks/tasks.org" "Inbox")
         "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
        ("ts" "Task - SpaceBoi" entry (file+olp "~/SynologyDrive/Documents/org/tasks/spaceboi.org" "Inbox")
         "* TODO %?" :empty-lines 1)
        ("th" "Task - HostMan" entry (file+olp "~/SynologyDrive/Documents/org/tasks/hostman.org" "Inbox")
         "* TODO %?" :empty-lines 1)

        ("j" "Journal Entries")
        ("jj" "Journal" entry
         (file+olp+datetree "~/SynologyDrive/Documents/org/org/journal.org")
         "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
         ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
         :clock-in :clock-resume
         :empty-lines 1)

        ("jm" "Meeting" entry
         (file+olp+datetree "~/SynologyDrive/Documents/org/org/journal.org")
         "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
         :clock-in :clock-resume
         :empty-lines 1)
        )
      )

(org-babel-do-load-languages
 'org-babel-load-languages
 '((restclient . t)))

;; copilot
;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ;; Either form below works—no extra quote for the function:
              ("C-y" . copilot-accept-completion)
              ("C-<tab>" . copilot-accept-completion-by-word)))

;; disable auto format on html files
;; (add-hook 'html-mode-hook
;;           (lambda ()
;;             (remove-hook 'before-save-hook #'format-all-buffer t)))

;; (add-hook 'html-mode-hook
;;           (lambda ()
;;             (remove-hook 'before-save-hook #'format-all-buffer t)))
;; (add-hook 'mhtml-mode-hook (lambda () (format-all-mode -1)))
;; (add-hook 'mhtml-mode-hook
;;           (lambda ()
;;             (remove-hook 'before-save-hook #'format-all-buffer t)))
;; (setq +format-on-save-enabled-modes
;;       '(not emacs-lisp-mode  ; elisp's mechanisms are good enough
;; 	sql-mode         ; sqlformat is currently broken
;; 	tex-mode         ; latexindent is broken
;; 	latex-mode
;;         ))



;; (add-hook 'python-mode-hook #'format-all-mode)

(setq +format-on-save-disabled-modes
      '(sql-mode           ; sqlformat is currently broken
        tex-mode           ; latexindent is broken
        latex-mode
        LaTeX-mode
        org-msg-edit-mode
        html-mode
        mhtml-mode
        web-mode-hook)) ; doesn't need a formatter

;; godot
;; Treesitter grammar files
(setq treesit-extra-load-path '("/home/dkraklan/Desktop/Godot_Versions/tree-sitter-gdscript/src/"))
;; Path to godot executable
(setq gdscript-godot-executable "/home/dkraklan/Desktop/Godot_Versions/Godot_v4.4.1-stable_linux.x86_64")
;; path to docs
(setq gdscript-docs-local-path "/home/dkraklan/Desktop/Godot_Versions/docs/4.4/")

;; Python poetry fix
;; We've disabled this hook as otherwise it loads the venv for every python file, it also seems to load every poetry env for every project that projectile is aware of.
;; to get into the enviroment and get the LSP workign with it do the following
;; M-x poetry-venv-workon
;; M-x lsp-restart-workspace

(after! python
  (remove-hook! 'python-mode-hook 'poetry-tracking-mode))

;; exwm - Emacs X Window Manager
(use-package exwm
  :config
  ;; Set the default number of workspaces
  (setq exwm-workspace-number 10)

  ;; When window "class" updates, use it to set the buffer name
  (add-hook 'exwm-update-class-hook
            (lambda () (exwm-workspace-rename-buffer exwm-class-name)))

  ;; These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
        '(?\C-x
          ?\C-u
          ?\C-h
          ?\M-x
          ?\M-`
          ?\M-&
          ?\M-:
          ?\C-\M-j  ;; Buffer list
          ?\C-\ ))  ;; Ctrl+Space

  ;; Explicitly set char mode to line mode keybinding
  (define-key exwm-mode-map (kbd "C-c C-k") 'exwm-input-release-keyboard)

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)
  ;; Set up global key bindings
  (setq exwm-input-global-keys
        `(
          ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
          ([?\s-r] . exwm-reset)

          ;; Move between windows
          ([s-left] . windmove-left)
          ([s-right] . windmove-right)
          ([s-up] . windmove-up)
          ([s-down] . windmove-down)

          ;; Launch applications via shell command
          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))

          ;; Switch workspace
          ([?\s-w] . exwm-workspace-switch)

          ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

  ;; EXWM System Tray
  (require 'exwm-systemtray)
  (exwm-systemtray-mode 1)

  ;; RANDR configuration
  (require 'exwm-randr)
  (setq exwm-randr-workspace-monitor-plist '(0 "DP-4"
                                             1 "DP-4"
                                             2 "DP-4"
                                             3 "DP-4"
                                             4 "DP-4"
                                             5 "DP-2"
                                             6 "DP-2"
                                             7 "DP-2"
                                             8 "DP-2"
                                             9 "DP-2"))

  (add-hook 'exwm-randr-screen-change-hook
            (lambda ()
              (start-process-shell-command
               "xrandr" nil "xrandr --output DP-4 --primary --auto --output DP-2 --right-of DP-4 --auto")))

  ;; Enable EXWM-RANDR first
  (exwm-randr-mode 1)

  ;; Line mode to char mode key binding
  (exwm-input-set-key (kbd "C-c C-q") 'exwm-input-grab-keyboard)

  ;; Char mode to line mode key binding
  (exwm-input-set-key (kbd "C-c C-k") 'exwm-input-release-keyboard)

  ;; Customization
  (setq display-time-mode t)


  ;; Finally enable EXWM
  (exwm-enable))


(defun gator/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

(defun gator/exwm-init-hook ()
  ;; Make workspace 1 be the one where we land at startup
  (exwm-workspace-switch-create 1)

  ;; Open eshell by default
  ;;(eshell)

  ;; Launch apps that will run in the background
  (gator/run-in-background "nm-applet"))


;; When EXWM finishes initialization, do some extra setup
(add-hook 'exwm-init-hook #'gator/exwm-init-hook)
