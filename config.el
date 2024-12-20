;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


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
(setq doom-theme 'leuven)

;;(setq doom-font (font-spec :family "Hack" :size 14))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


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

;;(setq fancy-splash-image "~/Downloads/ohm.png")

(custom-set-faces!
  '(org-level-1 :height 1.4 :weight bold :family "Hack")
  '(org-level-2 :height 1.3 :weight semi-bold)
  '(org-level-3 :height 1.2 :weight medium)
  '(org-level-4 :height 1.1 :weight normal))

;; Enable system clipboard integration
(setq select-enable-clipboard t)

;; Configure evil-mode to use system clipboard
(setq evil-want-fine-undo t
      evil-want-keybinding nil
      evil-want-integration t
      evil-kill-on-visual-paste nil)

;; Key bindings for clipboard operations
(map! :n "y" #'evil-yank
      :v "y" #'evil-yank
      :n "p" #'evil-paste-after
      :v "p" #'evil-paste-after

      ;; Explicit system clipboard operations
      :leader
      "i p" #'clipboard-yank     ; Paste from system clipboard
      "i y" #'clipboard-kill-ring-save  ; Copy to system clipboard

      ;; Browse kill ring
      "i k" #'counsel-yank-pop)  ; Browse kill ring history


;; Configure LSP for org-mode
(after! org
  (add-hook! 'org-mode-hook #'lsp!)
  (setq org-support-shift-select t )
  ;; Customize capture templates
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/org/todo.org" "Tasks")
           "* TODO %?\n  %i\n  %a")))
;; LaTex Preview
  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
  (add-to-list 'org-latex-packages-alist '("" "amsmath" t))
  (add-to-list 'org-latex-packages-alist '("" "amssymb" t))

(setq org-preview-latex-process-alist
   '((dvisvgm :programs
      ("latex" "dvisvgm")
      :description "dvi > svg"
      :message "you need to install the programs: latex and dvisvgm"
      :use-xcolor t
      :image-input-type "dvi"
      :image-output-type "svg"
      :image-size-adjust (1.7 . 1.5)
      :latex-compiler
      ("latex -interaction nonstopmode -output-directory %o %f")
      :image-converter
      ("dvisvgm %f -n -b min -c %S -o %O"))))

  ;; Customize agenda files
  (setq org-agenda-files '("~/org/"))

  ;; Customize export settings
  (setq org-export-with-toc t)
  (setq org-export-with-section-numbers nil))

;; Org Pretty
(setq org-pretty-entities t)
(setq org-pretty-entities-include-sub-superscripts t)
(setq org-use-sub-superscripts '{})
;; To toggle preview, use C-c C-x C-l
(setq org-startup-with-latex-preview t)

  ;; If you want to use eglot instead of lsp-mode:
  ;; (add-hook! 'org-mode-hook #'eglot-ensure)
;; Set org-roam directory
(after! org-roam
  (setq org-roam-directory "~/roam/")  ; Set your preferred directory path
  (setq org-roam-db-location "~/roam/org-roam.db"))  ; Set database location

;; Optional but recommended configurations
(after! org-roam
  ;; Set default capture templates
  (setq org-roam-capture-templates
        '(("d" "default" plain
           "%?"
           :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                             "#+title: ${title}\n")
           :unnarrowed t)
          ("r" "reference" plain
           "%?"
           :target (file+head "references/${slug}.org"
                             "#+title: ${title}\n")
           :unnarrowed t)))

  ;; Set completion system
  (setq org-roam-completion-everywhere t)

  ;; Set auto-sync
  (setq org-roam-db-autosync-mode t)

  ;; Set node display template
  (setq org-roam-node-display-template
        (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag))))

  ;; Configure org-download
  (require 'org-download)

  ;; Main configuration
  (setq-default org-download-method 'directory
                org-download-image-dir "images"
                org-download-heading-lvl nil
                org-download-screenshot-method "flameshot gui --raw > %s"  ; Use flameshot for screenshots
                org-download-screenshot-file (expand-file-name "screenshot.png" temporary-file-directory))

  ;; Add drag-and-drop support
  (add-hook 'dired-mode-hook 'org-download-enable)

  ;; Keybindings (optional)
  (map! :map org-mode-map
        :leader
        (:prefix ("i" . "insert")
         :desc "Screenshot" "s" #'org-download-screenshot
         :desc "Clipboard image" "p" #'org-download-clipboard))


  ;; Optional: Configure company for better completion
(after! company
  (set-company-backend! 'org-mode
    '(company-org-block company-yasnippet company-dabbrev)))

  ;; Disables lsp for org mode
(after! lsp-mode
  (setq lsp-disabled-clients '(org-mode)))

(after! emms
  (emms-all)
  (emms-default-players)

  ;; Set up directories
  (setq emms-source-file-default-directory "~/Music/"
        emms-history-file "~/Music/.emms-history"
        emms-directory "~/Music/.emms"  ; For additional EMMS data
        emms-playlist-buffer-name "*Music*")

  ;; Enable tag editing
  (require 'emms-tag-editor)
  (setq emms-tag-editor-rename-format "%a - %t")  ; Artist - Title format

  ;; Tag editor configuration
  (setq emms-tag-editor-tags
        '((info-artist      . "Artist")
          (info-title       . "Title")
          (info-album       . "Album")
          (info-tracknumber . "Track")
          (info-year        . "Year")
          (info-genre       . "Genre")
          (info-date        . "Date")
          (info-composer    . "Composer")))

  ;; General settings
  (emms-mode-line 1)
  (emms-playing-time 1)
  (emms-info-asynchronously t)
  (setq emms-player-list '(emms-player-mpv)))

;; Doom-specific keybindings
(map! :leader
      (:prefix ("e" . "EMMS")  ; Using 'e' prefix for EMMS
       "b" #'emms-browser
       "p" #'emms-pause
       "s" #'emms-stop
       "n" #'emms-next
       "P" #'emms-previous
       "l" #'emms-playlist-mode-go
       "r" #'emms-shuffle
       "t" #'emms-tag-editor-edit))

;; Playlist mode specific bindings
(map! :map emms-playlist-mode-map
      :n "C-t" #'emms-tag-editor-edit
      :n "T" #'emms-tag-editor-edit-marked)
