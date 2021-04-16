
;; For debug as `emacs -q -l <this_file>'
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

;; <leaf-install-code>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

;; leaf
(leaf leaf-tree
  :ensure t
  :custom (imenu-list-position . 'left))
(leaf leaf-convert :ensure t)

;; view settings
(leaf view
  :custom
  ((menu-bar-mode . nil)
   (scroll-bar-mode . nil)
   (indent-tabs-mode . nil)
   (ring-bell-function . 'ignore)))

;; editor settings
(leaf editor
  :custom
  ((tab-width . 4)
   (indent-tabs-mode . nil)
   (truncate-lines . nil)
   (completion-ignore-case . t)))

;; backup settings
(leaf backup
  :custom
  ((make-backup-files . nil)
   (auto-save-default . nil)))

;; startup settings
(leaf startup
  :custom
  ((inhibit-startup-screen . t)
   (inhibit-startup-message . t)
   (inhibit-startup-echo-area-message . t)
   (inhibit-scratch-message . nil)))

;; theme
(leaf theme
  :config (load-theme 'wombat t))

;; misc-modes
(leaf misc-modes
  :custom
  ((global-auto-revert-mode . 1)))

;; recentf
(leaf recentf
  :require t
  :init
  (leaf recentf-ext :ensure t)
  :custom
  ((recentf-max-saved-items . 10000)
   (recentf-exclude . '(".recentf")))
  :config
  (run-with-idle-timer 30 t 'recentf-save-list)
  :hook
  ((emacs-startup-hook . recentf-mode)))

;; hooks
(leaf cus-hooks
  :hook (before-save-hook . delete-trailing-whitespace))

;; cus-edit
(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

;; bind-key
(leaf bind-key
  :ensure t
  :config
  (bind-key* "C-h" 'delete-backward-char))

;; nlinum-mode
(leaf nlinum
  :ensure t
  :custom
  ((nlinum-format . "%3d ")
   (global-nlinum-mode . t)))

;; auto-sudoedit
(leaf auto-sudoedit
  :ensure t
  :custom
  (auto-sudoedit-mode . 1))

;; selectrum
(leaf selectrum
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :global-minor-mode t
  :config
  (leaf selectrum-prescient
    :ensure t
    :blackout t
    :custom (selectrum-prescient-mode . +1)))

;; prescient
(leaf prescient
  :ensure t
  :blackout t
  :custom (prescient-persist-mode . +1))

;; consult
(leaf consult
  :ensure t
  :bind (("C-x C-r" . consult-recent-file)
         ("M-i" . consult-line)
         ("M-y" . consult-yank)
         ("C-x b" . consult-buffer)
         ("C-x i" . consult-imenu)
         ("C-x g" . consult-grep)
         ("C-x G" . consult-grep)
         ("C-c M" . consult-global-mark)
         ("C-s" . consult-isearch)))

;; highlighting
(leaf highlighting
  :config
  (leaf show-paren
    :global-minor-mode t)
  (leaf auto-highlight-symbol
    :ensure t
    :global-minor-mode t
    :custom (set-idle-interval . 0.8))
  (leaf volatile-highlights
    :ensure t
    :global-minor-mode t))

;; xclip
(leaf xclip :ensure t :global-minor-mode t)

;; anzu
(leaf anzu
  :ensure t
  :global-minor-mode t
  :custom ((anzu-search-threshold . 1000)
           (anzu-minimum-input-length . 3))
  :bind (("C-c r" . anzu-query-replace)
         ("C-c R" . anzu-query-replace-regexp)))

;; tramp
(leaf tramp
  :require t
  :custom ((password-cache-expiry . nil)
           (tramp-copy-size-limit . nil)))

;; sequential-command
(leaf sequential-command
  :ensure t
  :config
  (leaf sequential-command-config
	:hook (emacs-startup-hook . sequential-command-setup-keys)))
  (bind-key "C-a" 'seq-home)
  (bind-key "C-e" 'seq-end)

;; symbol-overlay
(leaf symbol-overlay
  :ensure t
  :config
  (defface symbol-overlay-face-9
    '((t (:background "chocolate" :foreground "black")))
    "Symbol Overlay custom candidate 9")
  (defface symbol-overlay-face-10
    '((t (:background "sky blue" :foreground "black")))
    "Symbol Overlay custom candidate 10")
  (defface symbol-overlay-face-11
    '((t (:background "yellow green" :foreground "black")))
    "Symbol Overlay custom candidate 11")
  (defface symbol-overlay-face-12
    '((t (:background "magenta" :foreground "black")))
    "Symbol Overlay custom candidate 12")
  (defface symbol-overlay-face-13
    '((t (:background "aquamarine" :foreground "black")))
    "Symbol Overlay custom candidate 13")
  (defface symbol-overlay-face-14
    '((t (:background "burly wood" :foreground "black")))
    "Symbol Overlay custom candidate 14")
  (defface symbol-overlay-face-15
    '((t (:background "sandy brown" :foreground "black")))
    "Symbol Overlay custom candidate 15")
  (defface symbol-overlay-face-16
    '((t (:background "deep sky blue" :foreground "black")))
    "Symbol Overlay custom candidate 16")
  :custom (symbol-overlay-faces . '(symbol-overlay-face-1
                                    symbol-overlay-face-2
                                    symbol-overlay-face-3
                                    symbol-overlay-face-4
                                    symbol-overlay-face-5
                                    symbol-overlay-face-6
                                    symbol-overlay-face-7
                                    symbol-overlay-face-8
                                    symbol-overlay-face-9
                                    symbol-overlay-face-10
                                    symbol-overlay-face-11
                                    symbol-overlay-face-12
                                    symbol-overlay-face-13
                                    symbol-overlay-face-14
                                    symbol-overlay-face-15
                                    symbol-overlay-face-16))
  :bind (("C-c m" . symbol-overlay-put)))

;; undo-tree
(leaf undo-tree
  :ensure t
  :blackout t
  :global-minor-mode t
  :bind ("M-/" . undo-tree-visualize))

(provide 'init)
