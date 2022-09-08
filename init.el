
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
   (completion-ignore-case . t)
   (electric-pair-mode . t)
   (electric-indent-mode . t)))

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

;; whitespace
(leaf whitespace
  :require t
  :global-minor-mode global-whitespace-mode
  :custom
  ((whitespace-style . '(face trailing tabs)))
  :custom-face
  ((whitespace-tab . '((t (:foreground "#236fc6" :background unspecified :underline t))))
   (whitespace-trailing . '((t (:foreground "orange" :background unspecified :underline t)))))
  )

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
  :init
  (defvar delete-trailing-whitespace-before-save t)
  (defun my-delete-trailing-whitespace ()
    (if delete-trailing-whitespace-before-save (delete-trailing-whitespace)))
  :hook (before-save-hook . my-delete-trailing-whitespace))

;; cus-edit
(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

;; bind-key
(leaf bind-key
  :ensure t
  :require t
  :bind* ("C-h" . delete-backward-char))

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
         ("M-y" . consult-yank-pop)
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
    "Symbol Overlay custom candidate 9"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-10
    '((t (:background "sky blue" :foreground "black")))
    "Symbol Overlay custom candidate 10"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-11
    '((t (:background "yellow green" :foreground "black")))
    "Symbol Overlay custom candidate 11"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-12
    '((t (:background "magenta" :foreground "black")))
    "Symbol Overlay custom candidate 12"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-13
    '((t (:background "aquamarine" :foreground "black")))
    "Symbol Overlay custom candidate 13"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-14
    '((t (:background "burly wood" :foreground "black")))
    "Symbol Overlay custom candidate 14"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-15
    '((t (:background "sandy brown" :foreground "black")))
    "Symbol Overlay custom candidate 15"
    :group 'symbol-overlay)
  (defface symbol-overlay-face-16
    '((t (:background "deep sky blue" :foreground "black")))
    "Symbol Overlay custom candidate 16"
    :group 'symbol-overlay)
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

;; bm
(leaf bm
  :ensure t
  :bind ("M-SPC" . bm-toggle))

;; undo-tree
(leaf undo-tree
  :ensure t
  :blackout t
  :global-minor-mode global-undo-tree-mode)

;; selected
(leaf selected
  :ensure t
  :blackout t
  :config
  (leaf expand-region :ensure t)
  :custom
  (selected-global-mode . t)
  :bind (selected-keymap
         ("e" . er/expand-region)
         ("E" . er/contract-region)
         ("u" . upcase-region)
         ("d" . downcase-region)
         ("w" . count-words-region)))

(leaf quickrun
  :ensure t
  :blackout t
  :config
  (quickrun-add-command "c++17"
                        '((:command . "g++")
                          (:exec . ("%c -o %e %s -std=c++17"
                                    "%e"))
                          (:remove . "%e")
                          (:description . "Compile C++ file with 'gcc -std=c++11' and execute"))
                        :default "c++")
  (when (executable-find "iverilog")
    (quickrun-add-command "iverilog"
                          '((:command . "iverilog")
                            (:exec . ("%c -o %e %s"
                                      "%e"))
                            (:remove . "%e")
                            (:description . "Compile Verilog file with iverilog and execute"))
                          :mode 'verilog-mode))
  (quickrun-add-command "python"
    '((:command . "python3"))
    :override t)
  :bind (("C-\\" . quickrun))
  )

(leaf company
  :ensure t
  :global-minor-mode global-company-mode
  :custom-face
  ((company-tooltip . '((t (:foreground "black" :background "lightgrey"))))
   (company-tooltip-common . '((t (:foreground "black" :background "lightgrey"))))
   (company-tooltip-common-selection . '((t (:foreground "white" :background "steelblue"))))
   (company-tooltip-selection . '((t (:foreground "black" :background "steelblue"))))
   (company-preview-common . '((t (:foreground nil :background "lightgrey" :underline t))))
   (company-scrollbar-fg . '((t (:background "orange"))))
   (company-scrollbar-bg . '((t (:background "gray40")))))
  :bind ((company-active-map ("C-n" . company-select-next)
                             ("C-p" . company-select-previous)
                             ("C-s" . company-filter-candidates)
                             ("C-i" . company-complete-selection)
                             ("<tab>" . company-complete-selection)
                             ("M-d" . company-show-doc-buffer))
         (company-search-map ("C-n" . company-select-next)
                             ("C-p" . company-select-previous)))
  :custom
  ((company-minimum-prefix-length . 1)
   (company-selection-wrap-arround . t)
   (company-idle-delay . 0.4)
   (company-transformers . '(company-sort-by-occurrence))))

(leaf flycheck
  :ensure t
  :global-minor-mode global-flycheck-mode
  :bind
  (("M-n" . flycheck-next-error)
   ("M-p" . flycheck-previous-error)))

(leaf lsp-mode
  :ensure t
  :config
  (leaf which-key
    :ensure t
    :global-minor-mode which-key-mode)
  (leaf lsp-ui
    :ensure t)
  :custom
  ((lsp-print-io . nil)
   (lsp-log-io . nil)
   (gc-cons-threshold . 100000000)
   (read-process-output-max . 1048576)
   (lsp-keymap-prefix . "C-c l"))
  :global-minor-mode lsp-mode
  :hook
  (lsp-mode . lsp-enable-which-key-integration))

(leaf c-config
  :init
  (c-set-offset 'innamespace 0)
  (c-set-offset 'inextern-lang 0)
  :custom
  (c++-basic-offset . 4)
  (c-basic-offset . 4)
  :hook
  ((lsp-deferred . c-mode)
   (lsp-deferred . c++-mode)))

(leaf python-config
  :hook (lsp-deferred . python-mode))

(leaf verilog-config
  :hook (lsp-deferred . verilog-mode))

(leaf golang-config
  :init
  (leaf go-mode
    :ensure t
    :mode "\\.go\\'")
  :hook (lsp-deferred . go-mode))

(leaf markdown-config
  :hook
  (markdown-mode-hook . (lambda ()
                          (set (make-local-variable 'delete-trailing-whitespace-before-save) nil))))

(leaf yasnippet
  :ensure t
  :global-minor-mode yas-global-mode
  :custom (yas-snippet-dirs . '("~/.emacs.d/snippets")))

(provide 'init)
