;;; -*- lexical-binding: t; -*-
;; Enable native compilation for better performance
(setq comp-native-compilation t)
;; when using EXWM i had to enable these 3 otherwise the screen wouldn't update
(setq redisplay-dont-pause t)
(setq inhibit-redisplay nil)
(setq idle-update-delay 0.5)

;; Set the default theme
(setq doom-theme 'doom-one)

;; Enable line numbers globally (use 'relative for relative line numbers)
(setq display-line-numbers-type t)

;; Set transparency for the Emacs frame
(set-frame-parameter (selected-frame) 'alpha '(90 . 90)) ;; used on x11 builds
(add-to-list 'default-frame-alist '(alpha-background . 90)) ;; used on GTK builds

;; had to add this on arch as syntax highlighting wasn't working.
(global-font-lock-mode 1)

;; (when (member "Roboto" (font-family-list))
;;   ;; setting this breaks the whichkey menu for some reason
;;   ;; (set-face-attribute 'default nil :font "Roboto" :height 108)
;;   (set-face-attribute 'fixed-pitch nil :family "Roboto"))

;; (when (member "Source Sans Pro" (font-family-list))
;;   (set-face-attribute 'variable-pitch nil :family "Source Sans Pro" :height 1.18))

;; Initialize projectile
(require 'projectile)
(projectile-mode +1)

;; Set project search paths
(setq
 projectile-project-search-path '("~/SynologyDrive/Path/projects/" "~/projects/" "~/SynologyDrive/projects/"))

;; File finding with fzf
;; Buffer switching with counsel
(map! :leader
      (:prefix ("b" . "buffer")
       :desc "Switch buffer using counsel" "B" #'counsel-switch-buffer))

(map! :leader
      :desc "Find file with fzf" "SPC" #'counsel-fzf)

(if (eq system-type 'darwin)
    (defvar tailscale-path "/Applications/Tailscale.app/Contents/MacOS/Tailscale"
      "Path to Tailscale executable on macOS.")
  (defvar tailscale-path "tailscale"
    "Path to Tailscale executable on other systems."))

(defun tailscale--switch (user)
  "Internal helper to switch to USER Tailscale account and show result."
  (let* ((cmd (format "%s switch %s" tailscale-path user))
         (result (string-trim (shell-command-to-string cmd))))
    (message "%s" result)))

(defun tailscale-switch-work ()
  "Switch Tailscale profile to work."
  (interactive)
  (tailscale--switch "dylan@path.net"))

(defun tailscale-switch-personal ()
  "Switch Tailscale profile to personal."
  (interactive)
  (tailscale--switch "dylan@dkraklan.me"))

(defun tailscale-up ()
  "bring tailscale up."
  (interactive)
  (let* ((cmd (format "%s up" tailscale-path))
         (result (string-trim (shell-command-to-string cmd))))
    (message "%s" result)))


(defun tailscale-down ()
  "bring tailscale down."
  (interactive)
  (let* ((cmd (format "%s down" tailscale-path))
         (result (string-trim (shell-command-to-string cmd))))
    (message "%s" result)))

;; Configure counsel to only show app names (not full paths) in app launcher
(use-package! counsel
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only))

;; Shows workspaces on the minibuffer at the bottom
(after! persp-mode
  (defun display-workspaces-in-minibuffer ()
    (with-current-buffer " *Minibuf-0*"
      (erase-buffer)
      (insert (+workspace--tabline))))
  (run-with-idle-timer 0.5 nil #'display-workspaces-in-minibuffer)
  (+workspace/display))

(after! treemacs-all-the-icons
  (treemacs-modify-theme "all-the-icons"
    :config
    (treemacs-create-icon
     :icon (format "%s\t%s\t"
                   (all-the-icons-octicon "chevron-right"
                                          :height 0.75
                                          :v-adjust 0.1
                                          :face 'treemacs-all-the-icons-file-face)
                   (all-the-icons-octicon "file-directory"
                                          :height 0.95
                                          :v-adjust 0
                                          :face 'treemacs-all-the-icons-file-face))
     :extensions ("docs" "doc" "documentation"))))

(setq markdown-fontify-code-blocks-natively nil)

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/SynologyDrive/Documents/org/roam")
  (org-id-locations-file "~/SynologyDrive/Documents/org/roam/.orgids")
  (org-roam-completion-everywhere t)
  ;; Use explicit widths so the title column doesn't get squashed by Vertico/`*`-fill quirks
  (org-roam-node-display-template
   (concat "${title:80} " (propertize "${tags:30}" 'face 'org-tag)))
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
("l" "programming language" plain
 "* Characteristics\n\n- Family: %?\n- Inspired by: \n\n* Reference:\n\n"
 :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
 :unnarrowed t)
("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
 :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+category: ${title}\n#+filetags: Project")
 :unnarrowed t)
        ))
  (org-roam-dailies-capture-templates
   '(("d" "default" entry
      "* %?"
      :target (file+head "%<%Y-%m-%d>.org"
                         "#+title: %<%Y-%m-%d>\n"))
     ("t" "todo" entry
      "* TODO %?\nSCHEDULED: %t"
      :target (file+head+olp "%<%Y-%m-%d>.org"
                             "#+title: %<%Y-%m-%d>\n"
                             ("Tasks")))))
  :config
  (require 'org-roam-dailies)
  (org-roam-setup))

;; The buffer you put this code in must have lexical-binding set to t!
;; See the final configuration at the end for more details.

(defun my/org-roam-filter-by-tag (tag-name)
  (lambda (node)
    (member tag-name (org-roam-node-tags node))))

(defun my/org-roam-list-notes-by-tag (tag-name)
  (mapcar #'org-roam-node-file
          (seq-filter
           (my/org-roam-filter-by-tag tag-name)
           (org-roam-node-list))))

(defun my/org-roam-refresh-agenda-list ()
  (interactive)
  (setq org-agenda-files
        (delete-dups
         (append
          (my/org-roam-list-notes-by-tag "Project")
          (file-expand-wildcards
           (concat (file-name-as-directory
                    (expand-file-name "daily" org-roam-directory))
                   "*.org"))))))

;; Build the agenda list the first time for the session
(my/org-roam-refresh-agenda-list)

;; Hook to auto-add captured project files to org-agenda-files
(defun my/org-roam-project-finalize-hook ()
  "Adds the captured project file to `org-agenda-files' if the
capture was not aborted."
  (unless org-note-abort
    (with-current-buffer (org-capture-get :buffer)
      (add-to-list 'org-agenda-files (buffer-file-name)))))

;; Capture a TODO into a Project-tagged roam node's Tasks heading
(defun my/org-roam-capture-task ()
  (interactive)
  (add-hook 'org-capture-after-finalize-hook #'my/org-roam-project-finalize-hook)
  (org-roam-capture- :node (org-roam-node-read
                            nil
                            (my/org-roam-filter-by-tag "Project"))
                     :templates '(("p" "project" plain "** TODO %?"
                                   :if-new (file+head+olp "%<%Y%m%d%H%M%S>-${slug}.org"
                                                          "#+title: ${title}\n#+category: ${title}\n#+filetags: Project"
                                                          ("Tasks"))))))

;; Capture a TODO into today's org-roam daily file
(defun my/org-roam-capture-daily-todo ()
  "Capture a TODO into today's org-roam daily file under a Tasks heading."
  (interactive)
  (org-roam-dailies-capture-today nil "t"))

;; Keybindingj
(map! :leader
      (:prefix ("n" . "notes")
       (:prefix ("r" . "roam")
        :desc "Capture task to project" "t" #'my/org-roam-capture-task)))
(map! :leader
      (:prefix ("n" . "notes")
       (:prefix ("r" . "roam")
        :desc "Capture TODO to daily" "a" #'my/org-roam-capture-daily-todo)))

;; Org mode files and directories
;; (setq org-agenda-files '("~/SynologyDrive/Documents/org/tasks" "~/SynologyDrive/Documents/org/roam"))
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

(setq org-todo-keywords '((sequence "TODO(t)" "PROJ(p)" "LOOP(r)" "STRT(s)" "WAIT(w)" "HOLD(h)" "IDEA(i)" "BUG(b)"
           "|" "DONE(d)" "KILL(k)")
 (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")
 (sequence "|" "OKAY(o)" "YES(y)" "NO(n)"))

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
        ))

;; Configure languages for org-babel code execution
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (restclient . t)
   (shell . t)
   )
 )
;; Disable evaluation for all src blocks by default
(after! org
  ;; Set the default "don't evaluate" behavior
  (setq org-confirm-babel-evaluate nil
        org-babel-default-header-args '((:eval . "never")))

  ;; Optional: Add a security hook to prevent accidental evaluation
  (defun my/org-confirm-babel-evaluate (lang body)
    "Prompt for confirmation before executing code blocks."
    (not (string= lang "emacs-lisp")))

  (setq org-confirm-babel-evaluate #'my/org-confirm-babel-evaluate))

;; use the major mode for the relevant language in src blocks
(setq org-src-fontify-natively t
	  org-src-tab-acts-natively t
      org-edit-src-content-indentation 0)

;; hide emphasis markers
(setq org-hide-emphasis-markers t)
(set-face-attribute 'org-block nil            :foreground nil :inherit
'fixed-pitch :height 0.85)
(set-face-attribute 'org-code nil             :inherit '(shadow fixed-pitch) :height 0.85)
;; (set-face-attribute 'org-indent nil           :inherit '(org-hide fixed-pitch) :height 0.85)
(set-face-attribute 'org-verbatim nil         :inherit '(shadow fixed-pitch) :height 0.85)
(set-face-attribute 'org-special-keyword nil  :inherit '(font-lock-comment-face
fixed-pitch))
(set-face-attribute 'org-meta-line nil        :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil         :inherit 'fixed-pitch)


(require 'org-indent)
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))

;;(add-hook 'org-mode-hook 'variable-pitch-mode)

(setq org-adapt-indentation t
      org-hide-leading-stars t
      org-pretty-entities t
	  org-ellipsis "  ·")
;; Heading sizes for better visual hierarchy
(dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.1)
                (org-level-3 . 1.05)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
  (set-face-attribute (car face) nil :weight 'regular :height (cdr face)))

;; Make the document title a bit bigger
(set-face-attribute 'org-document-title nil  :weight
'bold :height 1.8)

;; Org mode hooks for better reading and writing experience
(after! org
  (add-hook 'org-mode-hook
            (lambda ()
              (org-indent-mode)
              (variable-pitch-mode 1)
              (auto-fill-mode -1)
              (visual-line-mode 1)
              ;; (text-scale-set 2)
              (visual-fill-column-mode)
              (setq-default visual-fill-column-center-text t
                            visual-fill-column-width 150)
              (setq display-line-numbers nil)
              ;; Add this to your configuration to ensure tables use fixed-pitch font
              (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
              )
            ))

(with-eval-after-load 'org (global-org-modern-mode))

(use-package! agent-shell
  :commands (agent-shell)
  :config
  ;; Use login-based auth (picks up your existing claude CLI session)
  (setq agent-shell-anthropic-authentication
        (agent-shell-anthropic-make-authentication :login t)))

;; Disable auto-formatting in specific modes
(setq +format-on-save-disabled-modes
      '(sql-mode           ; sqlformat is currently broken
        tex-mode           ; latexindent is broken
        latex-mode
        LaTeX-mode
        org-msg-edit-mode
        html-mode
        mhtml-mode
        web-mode-hook)) ; doesn't need a formatter

(after! lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-show-with-cursor t
        lsp-ui-doc-show-with-mouse t
        lsp-ui-doc-delay 0.2
        lsp-ui-doc-position 'at-point)) ;; or 'top 'bottom 'left 'right

;; Godot game development configuration
;; Treesitter grammar files
;;(setq treesit-extra-load-path '("/home/dkraklan/Desktop/Godot_Versions/tree-sitter-gdscript/src/"))
;; Path to godot executable
;;(setq gdscript-godot-executable "/home/dkraklan/Desktop/Godot_Versions/Godot_v4.4.1-stable_linux.x86_64")
;; path to docs
;;(setq gdscript-docs-local-path "/home/dkraklan/Desktop/Godot_Versions/docs/4.4/")

;; Python poetry fix
;; We've disabled this hook as otherwise it loads the venv for every python file, it also seems to load every poetry env for every project that projectile is aware of.
;; to get into the enviroment and get the LSP workign with it do the following
;; M-x poetry-venv-workon
;; M-x lsp-restart-workspace

(after! python
  (remove-hook! 'python-mode-hook 'poetry-tracking-mode))

;; EXWM initialization hook
(defun gator/exwm-init-hook ()
  ;; Make workspace 1 be the one where we land at startup
  (exwm-workspace-switch-create 1)

  ;; Open eshell by default
  ;;(+doom-dashboard/open)

  ;; Time
  (setq display-time-day-and-date t)
  (setq display-time-load-average t)
  (setq display-time-mode t)
  (display-time)

  ;; Show all exwm buffers always
  ;; (setq exwm-workspace-show-all-buffers t)

  ;; mouse follows focus
  (setq exwm-workspace-warp-cursor t)

  ;; start polybar
  (gator/start-panel)
  ;; Launch apps that will run in the background
  (gator/run-in-background "nm-applet")
  ;; audio control
  (gator/run-in-background "pasystray")
  ;; bluetooth control
  (gator/run-in-background "blueman-applet")
  ;; Dunst for notifications
  (gator/run-in-background "dunst")
  ;; Synology drive
  (gator/run-in-background "synology-drive")
  )

;; Function to run commands in the background
(defun gator/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

;; Set buffer names based on window class
(defun gator/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

;; Update buffer names for specific applications with more detail
(defun gator/exwm-update-title ()
  (pcase exwm-class-name
    ("Brave-browser" (exwm-workspace-rename-buffer (format "Brave: %s" exwm-title)))))

;; Configure windows based on their class
;; Flag to track if we've already moved a Brave browser window
(defvar gator/brave-window-moved nil
  "Flag to track if we've already moved a Brave browser window.")

(defun gator/configure-window-by-class ()
  "Configure windows by class, only moving the first Brave browser instance."
  (interactive)
  (pcase exwm-class-name
    ("Brave-browser"
     (when (not gator/brave-window-moved)
       (exwm-workspace-move-window 3)
       (setq gator/brave-window-moved t)))
    ("org.wezfurlong.wezterm" (exwm-workspace-move-window 2))
    ("mpv" (exwm-floating-toggle-floating)
     (exwm-layout-toggle-mode-line))))

;; Reset the flag when EXWM is restarted
(defun gator/reset-brave-window-flag ()
  "Reset the Brave window moved flag when EXWM starts."
  (setq gator/brave-window-moved nil))

;; Desktop environment controls (brightness, volume, etc.)
(use-package desktop-environment
  :after exwm
  :config (desktop-environment-mode)
  :custom
  (desktop-environment-brightness-small-increment "2%+")
  (desktop-environment-brightness-small-decrement "2%-")
  (desktop-environment-brightness-normal-increment "5%+")
  (desktop-environment-brightness-normal-decrement "5%-"))

;; Start server for polybar to connect to
(server-start)

;; Variables and functions for polybar management
(defvar gator/polybar-process nil
  "Holds the process of the running Polybar instance, if any")

(defun gator/kill-panel ()
  (interactive)
  (when gator/polybar-process
    (ignore-errors
      (kill-process gator/polybar-process)))
  (setq gator/polybar-process nil))

(defun gator/start-panel ()
  (interactive)
  (gator/kill-panel)
  (setq gator/polybar-process (start-process-shell-command "polybar" nil "polybar -r panel")))

;; Functions for polybar workspace indicators
(defun gator/polybar-exwm-workspace ()
  (pcase exwm-workspace-current-index
    (0 "0")
    (1 "")
    (2 "")
    (3 "")
    (4 "4")
    (5 "")
    (6 "6")
    (7 "7")
    (8 "8")

        ))

(defun gator/send-polybar-hook (module-name hook-index)
  (start-process-shell-command "polybar-msg" nil (format "polybar-msg hook %s %s" module-name hook-index)))

(defun gator/send-polybar-exwm-workspace ()
  (gator/send-polybar-hook "exwm-workspace" 1))

;; Function for controlling dunst notifications
(defun gator/dunstctl (command)
  (start-process-shell-command "dunstctl" nil (concat "dunstctl " command)))

(unless (eq system-type 'darwin)
  (when (locate-library "mu4e") ;; Only run if mu4e is installed
    (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")

    (setq mu4e-index-cleanup nil
          mu4e-index-lazy-check t)

    (use-package! mu4e
      :ensure nil
      :defer 20
      :config
      (setq mu4e-change-filenames-when-moving t
            mu4e-search-query-in-title t
            mu4e-update-interval (* 10 60)
            mu4e-get-mail-command "mbsync -a"
            mu4e-maildir "~/Mail"

            user-mail-address "dylan@dkraklan.me"
            user-full-name "Dylan Kraklan"
            auth-sources '("~/.authinfo.gpg")

            send-mail-function 'smtpmail-send-it
            message-send-mail-function 'smtpmail-send-it
            smtpmail-smtp-server "smtp.gmail.com"
            smtpmail-smtp-user "dylan@dkraklan.me"
            smtpmail-smtp-service 465
            smtpmail-stream-type 'ssl
            smtpmail-debug-info t
            smtpmail-debug-verb t

            mu4e-sent-messages-behavior 'delete

            mu4e-maildir-shortcuts
            '((:maildir "/Inbox"               :key ?i)
              (:maildir "/[Gmail]/Sent Mail"   :key ?s)
              (:maildir "/[Gmail]/Trash"       :key ?t)
              (:maildir "/[Gmail]/Drafts"      :key ?d)
              (:maildir "/[Gmail]/All Mail"    :key ?a)
              (:maildir "/[Gmail]/Spam"        :key ?S))

            mu4e-bookmarks
            '((:name "Unread messages" :query "flag:unread AND NOT flag:trashed AND NOT maildir:/[Gmail]/Spam" :key ?i)
              (:name "Today's messages" :query "date:today..now" :key ?t)
              (:name "Last 7 days" :query "date:7d..now" :hide-unread t :key ?w)
              (:name "Messages with images" :query "mime:image/*" :key ?p))))

    ;; run mu4e in the background (non-interactively)
    (mu4e t)))

(when (eq system-type 'darwin)
  (add-to-list 'default-frame-alist '(undecorated-round . t)))
