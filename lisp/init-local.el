;; run gofmt before saving .go files

(add-hook 'before-save-hook 'gofmt-before-save)

;; org mode

;; take screenshot and enter it into a org file
(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (org-display-inline-images)
  (setq filename
        (concat
         (make-temp-name
          (concat (file-name-nondirectory (buffer-file-name))
                  "_imgs/"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (unless (file-exists-p (file-name-directory filename))
    (make-directory (file-name-directory filename)))
                                        ; take screenshot
  (if (eq system-type 'darwin)
      (call-process "screencapture" nil nil nil "-i" filename))
  (if (eq system-type 'gnu/linux)
      (call-process "import" nil nil nil filename))
                                        ; insert into file if correctly taken
  (if (file-exists-p filename)
      (progn
        (insert "#+ATTR_ORG: :width 800 \n")
        (insert (concat "[[file:" filename "]]")))))
;;(setq org-image-actual-width nil)
(setq org-image-actual-width '(0.4))

;; https://github.com/james-stoup/emacs-org-mode-tutorial#org866128a


;; Must do this so the agenda knows where to look for my files
(setq org-agenda-files '("~/org"))

;; When a TODO is set to a done state, record a timestamp
(setq org-log-done 'time)

;; Follow the links
(setq org-return-follows-link  t)

;; Associate all org files with org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; Make the indentation look nicer
(add-hook 'org-mode-hook 'org-indent-mode)

;; Remap the change priority keys to use the UP or DOWN key
;;(define-key org-mode-map (kbd "C-c <up>") 'org-priority-up)
;;(define-key org-mode-map (kbd "C-c <down>") 'org-priority-down)

;; Shortcuts for storing links, viewing the agenda, and starting a capture
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

;; When you want to change the level of an org item, use SMR
;;(define-key org-mode-map (kbd "C-c C-g C-r") 'org-shiftmetaright)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

;; Wrap the lines in org mode so that things are easier to read
(add-hook 'org-mode-hook 'visual-line-mode)
;; (font-lock-add-keywords 'org-mode
;;                         '(("^ +\\([-*]\\) "
;;                            (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;; (let* ((variable-tuple
;;         (cond ((x-list-fonts "ETBembo")         '(:font "ETBembo"))
;;               ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
;;               ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
;;               ((x-list-fonts "Verdana")         '(:font "Verdana"))
;;               ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
;;               (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
;;        (base-font-color     (face-foreground 'default nil 'default))
;;        (headline           `(:inherit default :weight bold :foreground ,base-font-color)))
;;   (custom-theme-set-faces
;;    'user
;;    `(org-level-8 ((t (,@headline ,@variable-tuple))))
;;    `(org-level-7 ((t (,@headline ,@variable-tuple))))
;;    `(org-level-6 ((t (,@headline ,@variable-tuple))))
;;    `(org-level-5 ((t (,@headline ,@variable-tuple))))
;;    `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
;;    `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.2))))
;;    `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.3))))
;;    `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.5))))
;;    `(org-document-title ((t (,@headline ,@variable-tuple :height 1.6 :underline nil))))))

(setq org-capture-templates
      '(
        ("j" "Work Log Entry"
         entry (file+datetree "~/org/work-log.org")
         "* %?"
         :empty-lines 0)
        ("n" "Note"
         entry (file+headline "~/org/notes.org" "Random Notes")
         "** %?"
         :empty-lines 0)
        ("g" "General To-Do"
         entry (file+headline "~/org/todos.org" "General Tasks")
         "* TODO [#B] %?\n:Created: %T\n "
         :empty-lines 0)
        ("m" "Meeting"
         entry (file+datetree "~/org/meetings.org")
         "* %? :meeting:%^g \n:Created: %T\n** Attendees\n*** \n** Notes\n** Action Items\n*** TODO [#A] "
         :tree-type week
         :clock-in t
         :clock-resume t
         :empty-lines 0)
        )
      )
;; TODO states
(setq org-todo-keywords
      '((sequence "TODO(t)" "PLANNING(p)" "IN-PROGRESS(i@/!)" "VERIFYING(v!)" "BLOCKED(b@)"  "|" "DONE(d!)" "OBE(o@!)" "WONT-DO(w@/!)" )
        ))
;; TODO colors
(setq org-todo-keyword-faces
      '(
        ("TODO" . (:foreground "GoldenRod" :weight bold))
        ("PLANNING" . (:foreground "DeepPink" :weight bold))
        ("IN-PROGRESS" . (:foreground "Cyan" :weight bold))
        ("VERIFYING" . (:foreground "DarkOrange" :weight bold))
        ("BLOCKED" . (:foreground "Red" :weight bold))
        ("DONE" . (:foreground "LimeGreen" :weight bold))
        ("OBE" . (:foreground "LimeGreen" :weight bold))
        ("WONT-DO" . (:foreground "LimeGreen" :weight bold))
        ))



;; Kill current buffer (instead of asking first buffer name)
(global-set-key (kbd "C-x k") 'kill-current-buffer)


(add-to-list 'load-path "/Users/sumit/code/nano-emacs")
;; Default layout (optional)
;; (require 'nano-layout)
;; (setq nano-font-size 12)

;; Theme
(require 'nano-theme-light)
;; (require 'nano-faces)
;; (nano-faces)

;; (require 'nano-theme)
;; (nano-theme)

;; Nano default settings (optional)
;; (require 'nano-defaults)
;; Nano header & mode lines (optional)
;;(require 'nano-modeline)
;; (require 'nano-layout)
(require 'nano-writer)
(defun my-nov-font-setup ()
  (face-remap-add-relative 'variable-pitch :family "Times New Roman"
                           :height 1.0))
(add-hook 'nov-mode-hook 'my-nov-font-setup)
(setq nov-text-width t)
(setq visual-fill-column-center-text t)
(add-hook 'nov-mode-hook 'visual-line-mode)
(add-hook 'nov-mode-hook 'visual-fill-column-mode)
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

(provide 'init-local)
