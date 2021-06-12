(cond
 ((eq system-type 'windows-nt) (setq my/org-dir "~/Dropbox/Apps/MobileOrg/"))
  (t (setq my/org-dir "/mnt/c/Users/me/Dropbox/Apps/MobileOrg/"))
)

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 100 1000 1000))

(defun efs/display-startup-time ()
  (message "⏱ Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                     (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; Initialize package sources
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
;; (setq use-package-always-defer t)

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00"))

;; NOTE: If you want to move everything out of the ~/.emacs.d folder
;; reliably, set `user-emacs-directory` before loading no-littering!
;(setq user-emacs-directory "~/.cache/emacs")

(use-package no-littering)

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(defun my/base-font-size ()
  (pcase system-type ('windows-nt 115) (_ 125)))

(defvar runemacs/default-font-size (my/base-font-size))
(defvar efs/default-variable-font-size (my/base-font-size))

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                 treemacs-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(column-number-mode)
(global-display-line-numbers-mode t)

(set-face-attribute 'default nil :font "Fira Code Retina" :height runemacs/default-font-size)
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height runemacs/default-font-size)
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height runemacs/default-font-size :weight 'regular)


  (use-package unicode-fonts :ensure t :config (unicode-fonts-setup))

  (set-fontset-font t 'symbol "Emoji One")
  (set-fontset-font t '(#x1f300 . #x1fad0) (font-spec :family "Emoji One"))
     ;;(set-fontset-font t '(#x1f300 . #x1fad0) (font-spec :family "Cantarell"))

(setq unicode-fonts-block-font-mapping
      '(("Emoticons" ("Emoji One" "Noto Color Emoji")))
      unicode-fonts-fontset-names '("fontset-default"))

         ;; ("Apple Color Emoji" "Symbola" "Quivira")))

;; (use-package vertico
;;   :ensure t
;;   :bind (:map vertico-map
;;               ("C-j" . vertico-next)
;;               ("C-k" . vertico-previous)
;;               ("C-f" . vertico-exit)
;;               :map minibuffer-local-map
;;               ("C-m" . backward-kill-world))
;;   :custom (vertico-cycle t)
;;   :init (vertico-mode)
;;   )

;; (use-package savehist :init (savehist-mode))

;; (use-package marginalia
;;   :after vertico
;;   :ensure t
;;   :custom
;;   (marginalia-annotator '(marginalia-annotators-heavy marinalia-annotators-light nil))
;;   :init (marginalia-mode)
;;   )

;; (defun my/open-index ()
  ;;   "Index"
  ;;   (interactive)
  ;;   (find-file (expand-file-name "~/Dropbox/Apps/MobileOrg/index.org"))
  ;;   )

(defun my/open (a)
  (find-file (expand-file-name a))
  (message "Open")
  )


(defun my/org-file (name) (concat my/org-dir name))
(defun my/open-org (name) (my/open (my/org-file name)))


  (defun my/org-index () (interactive) (my/open-org "index.org") )
  (defun my/sleep () (interactive) (my/open-org "sleep.org") )
  (defun my/work-out () (interactive) (my/open-org "workout.org") )


      (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

        (use-package general
          :after evil
          :config
            (general-create-definer rune/leader-keys
              :keymaps '(normal insert visual emacs)
              :prefix "SPC"
              :global-prefix "C-SPC")

            (rune/leader-keys
              "t"  '(:ignore t :which-key "toggles")
              "tt" '(counsel-load-theme :which-key "choose theme")
              "fde" '(lambda () (interactive) (find-file (expand-file-name "~/.emacs.d/emacs.org")))
              "e"  '(:ignore t :which-key "eval")
              "eb" 'eval-buffer
              "es" 'eval-last-sexp
               "a"  '(:ignore t :which-key "app")
              "ao"  '(:ignore t :which-key "org")
              "aof"  '(:ignore t :which-key "files")
               "aofi" 'my/org-index
              "aofs" 'my/sleep
              "aofw" 'my/work-out
              "aox"  '(:ignore t :which-key "export")
	    "aoxh" 'org-html-export-to-html
              "aoa" 'org-agenda
               "g"  '(:ignore t :which-key "git")
             "gs" 'magit-status
              )
         )


        (use-package evil
          :init
          (setq evil-want-integration t)
          (setq evil-want-keybinding nil)
          (setq evil-want-C-u-scroll t)
          (setq evil-want-C-i-jump nil)

          :config
          (evil-mode 1)
          (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
          (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

          ;; Use visual line motions even outside of visual-line-mode buffers
          (evil-global-set-key 'motion "j" 'evil-next-visual-line)
          (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

          (evil-set-initial-state 'messages-buffer-mode 'normal)
          (evil-set-initial-state 'dashboard-mode 'normal)
        )

        (use-package evil-collection
          :after evil
          :config
          (evil-collection-init))

(use-package doom-themes
  :init (load-theme 'doom-palenight t))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

;; ;; Ivy Configuration -----------------------------------------------------------
(use-package ivy
  ;;:diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1)
  )

(use-package ivy-rich
  :after ivy
  :init (ivy-rich-mode 1)
   )

 (use-package counsel
   :bind (("M-x"     . counsel-M-x)
          ("C-x b"   . counsel-ibuffer)
          ("C-x C-f" . counsel-find-file)
          :map minibuffer-local-map ("C-r" . counsel-minibuffer-history))
   :config (setq ivy-initial-inputs-alist nil)	
   )

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-symbol]   . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-command]  . helpful-command)
  ([remap describe-key]      . helpful-key)
  )

(use-package hydra
  :defer t)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(rune/leader-keys
  "m"  '(:ignore t :which-key "mail & calendar"))

(use-package bbdb
  :hook bbdb-mode
  :config
  (bbdb-initialize 'message)
  (bbdb-insinuate-message)
  (add-hook 'message-setup-hook 'bbdb-insinuate-mail)
  )

(setq my/ical "https://outlook.office365.com/owa/calendar/3a00a6c64cf64207b72d7b78775016a1@polymorphic.group/e9f82d5bb0f549f480359102438444523290467437254753300/calendar.ics")

(defun my/calendar ()
  (interactive)
  (cfw:open-ical-calendar my/ical))

(use-package calfw :hook calfw-mode)
(use-package calfw-ical :after calfw)

(rune/leader-keys
  "mc" 'my/calendar)

(use-package notmuch :hook notmuch-mode)
;; set up mail sending using sendmail
(setq send-mail-function (quote sendmail-send-it))
(setq user-mail-address "jonathanp@polymorphic.group"
      user-full-name "Jonathan Peel")

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face))
    )

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block           nil :foreground nil :inherit 'fixed-pitch)
   (set-face-attribute 'org-code            nil :inherit '(shadow fixed-pitch))
   (set-face-attribute 'org-verbatim        nil :inherit '(shadow fixed-pitch))
   (set-face-attribute 'org-date            nil :inherit '(shadow fixed-pitch) :height 85)
   (set-face-attribute 'org-table           nil :inherit '(shadow fixed-pitch) :height 85)
  (set-face-attribute 'org-formula         nil :inherit '(shadow fixed-pitch) :height 85)
   (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
   (set-face-attribute 'org-meta-line       nil :inherit '(font-lock-comment-face fixed-pitch) :height 95)
   (set-face-attribute 'org-checkbox        nil :inherit 'fixed-pitch)
  )

;; Org Mode Configuration ------------------------------------------------------

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :pin org
  :ensure org-plus-contrib
  :commands (org-capture org-agenda)
  :hook (org-mode . efs/org-mode-setup)
  :config
  ;; (add-hook 'org-mode-hook #'valign-mode)
  (setq org-ellipsis " ▾"
        org-hide-empasis-markers t)

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-date 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
        (list
          (concat my/org-dir "habits.org")
          (concat my/org-dir "gtd.org")
          (concat my/org-dir "anniversaries.org")
          )
        )

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (setq org-refile-targets
    '(("archive.org" :maxlevel . 1)
      ("gtd.org" :maxlevel . 1)
      )
    )

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

 (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work-email")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))


   (setq org-capture-templates
    `(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "~/Projects/Code/emacs-from-scratch/OrgFiles/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("w" "Workflows")
      ("we" "Checking Email" entry (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "~/Projects/Code/emacs-from-scratch/OrgFiles/Metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))

  (efs/org-font-setup)
  )

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 110
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

;; Disable international and religious holidays  
  (setq holiday-general-holidays nil)
  (setq holiday-christian-holidays nil)
  (setq holiday-hebrew-holidays nil)
  (setq holiday-islamic-holidays nil)
  (setq holiday-bahai-holidays nil)
  (setq holiday-oriental-holidays nil)

  ;; Change these to your location in South Africa
  ;; useful for sunrise, sunset, equinox, solstice etc.
  (setq calendar-latitude -26.2041)
  (setq calendar-longitude 28.0473)
  (setq calendar-location-name "Johannesburg, Gauteng, South Africa")

  ;; Republic of South Africa's National Holidays.
  (setq holiday-local-holidays
        '((holiday-fixed 1 1 "New Years Day")
          (holiday-fixed 3 21 "Human Rights Day")
          (holiday-easter-etc -2 "Good Friday")
          (holiday-easter-etc +1 "Family Day")
          (holiday-fixed 4 27 "Freedom Day")
          (holiday-fixed 5 1 "Workers Day")
          (holiday-fixed 6 16 "Youth Day in South Africa")
          (holiday-fixed 8 9 "National Women's Day")
          (holiday-fixed 9 24 "Heritage Day")
          (holiday-fixed 12 16 "Day of Reconciliation")
          (holiday-fixed 12 25 "Christmas Day")
          (holiday-fixed 12 26 "Day of Goodwill"))
        )

;; Russian National Holidays
(setq calendar-holidays
      `(
        (holiday-fixed 1 1 "Новый год")
        (holiday-fixed 2 23 "День защитника Отечества")
        (holiday-fixed 3 8 "Международный женский день")
        (holiday-fixed 5 1 "День труда")
        (holiday-fixed 5 2 "День труда")
        (holiday-fixed 5 9 "День Победы")
        (holiday-fixed 6 12 "День России")
        (holiday-fixed 10 4 "День Народного единства")
        ))

(use-package org-contacts
  :ensure nil
  :after org
  :custom (org-contacts-files (list (my/org-file "contacts.org"))))

(setq org-ditaa-jar-path "~/.emacs.d/ditaa.jar")
(setq org-plantuml-jar-path "~/.emacs.d/plantuml.jar")

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (ditaa      . t)
     (plantuml   .t)
     (python     . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes)
  )

(use-package plantuml-mode
  :after org
)

;; This is needed as of Org 9.2

  (with-eval-after-load 'org
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
)

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.emacs.d/emacs.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy
  :after lsp)

(use-package dap-mode
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  ;; :config
  ;; (dap-ui-mode 1)
  :commands dap-debug
  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup) ;; Automatically installs Node debug adapter if needed

  ;; Bind `C-c l d` to `dap-hydra` for easy access
  (general-define-key
    :keymaps 'lsp-mode-map
    :prefix lsp-keymap-prefix
    "d" '(dap-hydra t :wk "debugger")))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

;; Projectile Configuration ---------------------------------------------------

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "e:/repos") (setq projectile-project-search-path '("e:/repos")))
  (setq projectile-switch-project-action #'projectile-dired)
  )

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  )

;; (use-package evil-magit :after magit)

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(defun run-powershell ()
  "Run powershell"
  (interactive)
  (async-shell-command "c:/windows/system32/WindowsPowerShell/v1.0/powershell.exe -Command -"
               nil
               nil))

;; (setq explicit-shell-file-name "c:\\windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe")
;; (setq explicit-powershell.exe-args '("-Command" "-" )) ; interactive, but no command prompt 

(use-package term
  :commands term
  :config
  (setq explicit-shell-file-name "c:/windows/system32/WindowsPowerShell/v1.0/powershell.exe -Command -")
  (setq explicit-powershell.exe-args '("-Command" "-" )) ; interactive, but no command prompt 
  ;; Change this to zsh, etc
  ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

  ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
  ;; (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
  )

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  ;;(setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "powershell.exe")
  (setq explicit-powershell.exe-args '()))

(defun efs/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt :after eshell)

(use-package eshell
  :hook (eshell-first-time-mode . efs/configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim")))

  (eshell-git-prompt-use-theme 'powerline))

(use-package dired
    :ensure nil
    :commands (dired dired-jump)
    :bind (("C-x C-j" . dired-jump))
    :custom ((dired-listing-switches "-agho --group-directories-first"))
    :config
    (evil-collection-define-key 'normal 'dired-mode-map
      "h" 'dired-single-up-directory
      "l" 'dired-single-buffer))

  (use-package dired-single :after dired)

  (use-package all-the-icons-dired
    :hook (dired-mode . all-the-icons-dired-mode))

  (use-package dired-open
  :after dired
    :config
    ;; Doesn't work as expected!
    ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
    (setq dired-open-extensions '(("png" . "feh")
                                  ("mkv" . "mpv"))))

  (use-package dired-hide-dotfiles
    :hook (dired-mode . dired-hide-dotfiles-mode)
    :config
    (evil-collection-define-key 'normal 'dired-mode-map
      "H" 'dired-hide-dotfiles-mode))

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))

(with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes
                 '("org-plain-latex"
                   "\\documentclass{article}
           [NO-DEFAULT-PACKAGES]
           [PACKAGES]
           [EXTRA]"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))



(setq org-latex-pdf-process
      '("pdflatex -interaction nonstopmode -output-directory %o %f"
        "bibtex %b"
        "pdflatex -interaction nonstopmode -output-directory %o %f"
        "pdflatex -interaction nonstopmode -output-directory %o %f"))

(setq bibtex-autokey-year-length 4
      bibtex-autokey-name-year-separator "-"
      bibtex-autokey-year-title-separator "-"
      bibtex-autokey-titleword-separator "-"
      bibtex-autokey-titlewords 2
      bibtex-autokey-titlewords-stretch 1
      bibtex-autokey-titleword-length 5)


;; (require 'dash)
;;(setq org-latex-default-packages-alist
;;      (-remove-item
;;       '("" "hyperref" nil)
;;       org-latex-default-packages-alist))

;; Append new packages
;;(add-to-list 'org-latex-default-packages-alist '("" "natbib" "") t)
;;(add-to-list 'org-latex-default-packages-alist
;;             '("linktocpage,pdfstartview=FitH,colorlinks,
;;linkcolor=blue,anchorcolor=blue,
;;citecolor=blue,filecolor=blue,menucolor=blue,urlcolor=blue"
;;               "hyperref" nil)
;;            t)

;; setup org-ref
(setq org-ref-bibliography-notes "~/Desktop/org-ref-example/notes.org"
      org-ref-default-bibliography '("~/Desktop/org-ref-example/references.bib")
      org-ref-pdf-directory "~/Desktop/org-ref-example/bibtex-pdfs/")

(unless (file-exists-p org-ref-pdf-directory)
  (make-directory org-ref-pdf-directory t))

 ;; (use-package org-ref :ensure t     :after org)
 ;; (use-package org-ref-pdf     :ensure nil     :after org)
 ;; (use-package org-ref-url-utils     :ensure nil     :after org)

(require 'org-ref)
(require 'org-ref-pdf)
(require 'org-ref-url-utils)


;; Citation Styles
(defun harvard-cite (key page)
  (interactive (list (completing-read "Cite: " (orhc-bibtex-candidates))
                     (read-string "Page: ")))


  (insert
   (org-make-link-string (format "cite:%s"
                                 (cdr (assoc
                                       "=key="
                                       (cdr (assoc key (orhc-bibtex-candidates))))))
                         page)))
