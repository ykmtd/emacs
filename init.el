;;; init.el --- Emacs configuration with use-package  -*- lexical-binding: t; -*-
;;; Code

;; -----------------------------------------------------------------------------
;; Bootstrap configuration
;; -----------------------------------------------------------------------------

;; initialize use-package
(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                       ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                       ("melpa" . "https://melpa.org/packages/")))
  (package-initialize))

;; -----------------------------------------------------------------------------
;; Basic Emacs Settings (Built-in)
;; -----------------------------------------------------------------------------
(use-package emacs
  :init
  ;; custom-file path
  (setq custom-file (locate-user-emacs-file "custom.el"))

  ;; view settings
  (setq menu-bar-mode nil
        indent-tabs-mode nil
        ring-bell-function 'ignore
        show-paren-mode t)

  ;; editor settings
  (setq tab-width 4
        truncate-lines nil
        completion-ignore-case t)
  (electric-pair-mode 1)
  (electric-indent-mode 1)
  (global-auto-revert-mode 1)

  ;; backup settings
  (setq make-backup-files nil
        auto-save-default nil)

  ;; startup settings
  (setq inhibit-startup-screen t
        inhibit-startup-message t
        inhibit-startup-echo-area-message t)

  (global-display-line-numbers-mode t)
  (custom-set-variables '(display-line-numbers-width-start t))

  :config
  ;; theme
  (load-theme 'wombat t)
  ;; custom-file のロード (存在すれば)
  (when (file-exists-p custom-file)
    (load custom-file))
  :bind* ("C-h" . delete-backward-char))

(use-package diminish
  :ensure t)

;; -----------------------------------------------------------------------------
;; Visual & UI
;; -----------------------------------------------------------------------------

;; whitespace
(use-package whitespace
  :ensure t
  :hook (emacs-startup . global-whitespace-mode)
  :custom
  (whitespace-style '(face trailing tabs))
  :custom-face
  (whitespace-tab ((t (:foreground "#236fc6" :background unspecified :underline t))))
  (whitespace-trailing ((t (:foreground "orange" :background unspecified :underline t)))))

(use-package auto-highlight-symbol
  :ensure t
  :hook (after-init . global-auto-highlight-symbol-mode)
  :custom (ahs-idle-interval 0.8))

(use-package volatile-highlights
  :ensure t
  :hook (after-init . volatile-highlights-mode))

;; anzu
(use-package anzu
  :ensure t
  :hook (after-init . global-anzu-mode)
  :custom
  (anzu-search-threshold 1000)
  (anzu-minimum-input-length 3)
  :bind (("C-c r" . anzu-query-replace)
         ("C-c R" . anzu-query-replace-regexp)))

;; symbol-overlay
(use-package symbol-overlay
  :ensure t
  :bind ("C-c m" . symbol-overlay-put)
  :custom-face
  ;; 顔定義のリストを作成
  (symbol-overlay-face-9 ((t (:background "chocolate" :foreground "black"))))
  (symbol-overlay-face-10 ((t (:background "sky blue" :foreground "black"))))
  (symbol-overlay-face-11 ((t (:background "yellow green" :foreground "black"))))
  (symbol-overlay-face-12 ((t (:background "magenta" :foreground "black"))))
  (symbol-overlay-face-13 ((t (:background "aquamarine" :foreground "black"))))
  (symbol-overlay-face-14 ((t (:background "burly wood" :foreground "black"))))
  (symbol-overlay-face-15 ((t (:background "sandy brown" :foreground "black"))))
  (symbol-overlay-face-16 ((t (:background "deep sky blue" :foreground "black"))))
  :custom
  (symbol-overlay-faces '(symbol-overlay-face-1
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
                          symbol-overlay-face-16)))

;; -----------------------------------------------------------------------------
;; File Management & System
;; -----------------------------------------------------------------------------

;; recentf
(use-package recentf
  :hook (emacs-startup . recentf-mode)
  :custom
  (recentf-max-saved-items 10000)
  (recentf-exclude '(".recentf"))
  :config
  (run-with-idle-timer 30 t 'recentf-save-list))

(use-package recentf-ext
  :ensure t
  :after recentf)

;; hooks (Whitespace cleanup)
(use-package emacs
  :config
  (defvar delete-trailing-whitespace-before-save t)
  (defun my-delete-trailing-whitespace ()
    (if delete-trailing-whitespace-before-save (delete-trailing-whitespace)))
  :hook (before-save . my-delete-trailing-whitespace))

;; xclip (クリップボード連携)
(use-package xclip
  :ensure t
  :hook (after-init . xclip-mode))

;; tramp
(use-package tramp
  :custom
  (password-cache-expiry nil)
  (tramp-copy-size-limit nil))

;; undo-tree
(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode
  :custom
  (undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  :config
  (global-undo-tree-mode))

;; bm (Bookmarks)
(use-package bm
  :ensure t
  :bind ("M-SPC" . bm-toggle))

;; -----------------------------------------------------------------------------
;; Completion & Navigation
;; -----------------------------------------------------------------------------

;; flymake
(use-package flymake
  :init
  (flymake-mode))

;; orderless
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic substring partial-completion flex)))))

;; vertico
(use-package vertico
  :ensure t
  :if (>= emacs-major-version 24) ;; emacs>= 24.5 check
  :diminish
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t))

;; consult
(use-package consult
  :ensure t
  :bind (("C-x C-r" . consult-recent-file)
         ("M-i"     . consult-line)
         ("M-y"     . consult-yank-pop)
         ("C-x b"   . consult-buffer)
         ("C-x i"   . consult-imenu)
         ("C-x g"   . consult-grep)
         ("C-x G"   . consult-grep)
         ("C-c M"   . consult-global-mark)))

;; company
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-selection-wrap-arround t)
  (company-idle-delay 0.2)
  (company-transformers '(company-sort-by-occurrence))

  :bind
  (:map company-active-map
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous)
        ("C-s" . company-filter-candidates)
        ("C-i" . company-complete-selection)
        ("<tab>" . company-complete-selection)
        ("M-d" . company-show-doc-buffer))
  (:map company-search-map
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous))

  :custom-face
  (company-tooltip ((t (:foreground "black" :background "lightgrey"))))
  (company-tooltip-common ((t (:foreground "black" :background "lightgrey"))))
  (company-tooltip-common-selection ((t (:foreground "white" :background "steelblue"))))
  (company-tooltip-selection ((t (:foreground "black" :background "steelblue"))))
  (company-preview-common ((t (:foreground nil :background "lightgrey" :underline t))))
  (company-scrollbar-fg ((t (:background "orange"))))
  (company-scrollbar-bg ((t (:background "gray40")))))


;; 補完候補に追加情報を表示 (ファイルサイズ、ドキュメントなど)
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; 候補に対するアクションメニュー (右クリックメニューのキーボード版)
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         ; 候補に対するアクション
   ("C-;" . embark-dwim)        ; 文脈に合わせたデフォルトアクション
   ("C-h B" . embark-bindings)) ; 現在のキーバインド一覧を表示
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

;; Consult と Embark の連携
(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; selected (region 選択時のメニュー)
(use-package selected
  :ensure t
  :diminish selected-minor-mode
  :hook (after-init . selected-global-mode)
  :bind (:map selected-keymap
              ("e" . er/expand-region)
              ("E" . er/contract-region)
              ("u" . upcase-region)
              ("d" . downcase-region)
              ("w" . count-words-region)))

;; expand region
(use-package expand-region :ensure t)

;; sequential-command
(use-package sequential-command
  :ensure t
  :bind (("C-a" . seq-home)
         ("C-e" . seq-end))
  :config
  (require 'sequential-command-config)
  (sequential-command-setup-keys))

;; smart-jump
(use-package smart-jump
  :ensure t
  :config
  (smart-jump-setup-default-registers))

;; -----------------------------------------------------------------------------
;; Programming & Languages
;; -----------------------------------------------------------------------------

;; quickrun
(use-package quickrun
  :ensure t
  :diminish
  :bind ("C-\\" . quickrun)
  :config
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
    :override t))

;; lsp-mode
(use-package eglot
  :ensure t
  :hook
  ((c-mode c++-mode python-mode go-mode verilog-mode) . eglot-ensure)
  :custom
  (eglot-autoshutdown t)      ; バッファをすべて閉じたらLSPサーバーも終了
  (eglot-sync-connect 1)      ; 接続タイムアウト(秒)。0なら非同期(推奨しない場合あり)
)

(use-package which-key
  :ensure t
  :hook (after-init . which-key-mode))

;; C / C++ Configuration
(use-package cc-mode
  :ensure nil
  :hook
  (c-mode-common . (lambda ()
                     (c-set-offset 'innamespace 0)
                     (c-set-offset 'inextern-lang 0)))
  :custom
  (c++-basic-offset 2)
  (c-basic-offset 2))

;; Verilog Configuration
(use-package verilog-mode
  :ensure nil
  :custom
  (verilog-case-indent 4)
  (verilog-cexp-indent 4)
  (verilog-indent-level 4)
  (verilog-indent-level-behavioral 4)
  (verilog-indent-level-declaration 4)
  (verilog-indent-level-module 4))

;; Markdown Configuration
(use-package markdown-mode
  :hook
  (markdown-mode . (lambda ()
                     (set (make-local-variable 'delete-trailing-whitespace-before-save) nil))))

;; Other languages
(use-package cmake-mode :ensure t)
(use-package meson-mode :ensure t)
(use-package markdown-mode :ensure t)

;; yasnippet
(use-package yasnippet
  :ensure t
  :hook (after-init . yas-global-mode)
  :custom
  (yas-snippet-dirs '("~/.emacs.d/snippets")))

;; -----------------------------------------------------------------------------
;; LLM
;; -----------------------------------------------------------------------------
;; (use-package gptel
;;   :ensure t
;;   :config
;;   (load "~/.emacs.d/secrets.el")
;;   (setq gptel-backend (gptel-make-ollama "Ollama"
;;                                      :host "localhost:11434"
;;                                      :stream t
;;                                      :models '(llama3.2)))
;;   :custom
;;   ((gptel-model 'llama3.2)))

(provide 'init)
