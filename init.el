
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

;; run server
(leaf server
      :require t
      :defun server-running-p
      :config (unless (server-running-p) (server-start)))

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

(provide 'init)
