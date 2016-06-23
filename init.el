;;----------------------------------------------------
; パッケージ管理
;;----------------------------------------------------
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;;----------------------------------------------------
; 共通設定
;;----------------------------------------------------
;; 起動時のスプラッシュを表示させない
(setq inhibit-startup-message t)
;; 変更のあったファイルの自動再読み込み
(global-auto-revert-mode 1)
;; バックアップファイル自動生成無効化
(custom-set-variables
'(auto-save-default nil)
'(make-backup-files nil))
;; 行末の空白をハイライト
(setq-default show-trailing-whitespace t)
;; タブのスペース間隔
(setq default-tab-width 4)

;;----------------------------------------------------
;; サーバー起動
;;----------------------------------------------------
(server-start)
(defun iconify-emacs-when-server-is-done ()
    (unless server-clients (iconify-frame)))
;(global-set-key (kbd "C-x C-c") 'server-edit)
(global-set-key (kbd "C-x C-c") 'elscreen-kill-screen-and-buffers)
(defalias 'exit 'save-buffers-kill-emacs)

;;起動時のフレームサイズを設定する
(setq initial-frame-alist
    (append (list '(width . 160)
                  '(height . 52))
            initial-frame-alist))
(setq default-frame-alist initial-frame-alist)

;;----------------------------------------------------
;; キーバインド
;;----------------------------------------------------
(global-set-key [M-up]    'elscreen-create)
(global-set-key [M-left]   'elscreen-previous)
(global-set-key [M-right]  'elscreen-next)
(global-set-key [M-down]   'other-window)

(global-set-key (kbd "C-x g")   'goto-line)

;;----------------------------------------------------
;;  Fonts
;;----------------------------------------------------
(add-to-list 'default-frame-alist '(font . "ricty-13"))

;;----------------------------------------------------
;; 行番号
;;----------------------------------------------------
;; linum
(require 'linum)
(global-linum-mode 1)
(setq linum-format "%5d")

;;----------------------------------------------------
;; 列番号表示
;;----------------------------------------------------
(column-number-mode t)

;;----------------------------------------------------
;; ツールバーを非表示
;; M-x tool-bar-mode で表示非表示を切り替えられる
;;----------------------------------------------------
(tool-bar-mode 0)

;;----------------------------------------------------
;; ElScreen
;;----------------------------------------------------
(elscreen-start)

;;----------------------------------------------------
;; Flycheck
;;----------------------------------------------------
(add-hook 'after-init-hook #'global-flycheck-mode)

;;----------------------------------------------------
;; Auto-Complete
;;----------------------------------------------------
(global-auto-complete-mode t)

;;----------------------------------------------------
;; Ruby
;;----------------------------------------------------
;; ruby-block
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)

(add-hook 'enh-ruby-mode-hook '(lambda()
                               (auto-complete-mode)
                               (robe-mode)
                               (ac-robe-setup)
                               ;(inf-ruby)
                               ;(robe-start)
                               ))
;; 保存時にmagic commentを追加しないようにする
(defadvice enh-ruby-mode-set-encoding (around stop-enh-ruby-mode-set-encoding)
  "If enh-ruby-not-insert-magic-comment is true, stops enh-ruby-mode-set-encoding."
  (if (and (boundp 'enh-ruby-not-insert-magic-comment)
           (not enh-ruby-not-insert-magic-comment))
      ad-do-it))
(ad-activate 'enh-ruby-mode-set-encoding)
(setq-default enh-ruby-not-insert-magic-comment t)

;;----------------------------------------------------
;; Yaml
;;----------------------------------------------------
;; yaml-mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.ya?ml$". yaml-mode))

;;----------------------------------------------------
;; Helm
;;----------------------------------------------------
(helm-mode 1)
;; TABで補完
(define-key global-map (kbd "M-x") 'helm-M-x)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "C-x C-r") 'helm-recentf)
(define-key global-map (kbd "M-y") 'helm-show-kill-ring)
(define-key global-map (kbd "C-x b") 'helm-buffers-list)
(define-key helm-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
(define-key helm-read-file-map (kbd "<tab>") 'helm-execute-persistent-action)
(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)

;;----------------------------------------------------
;; Projectile
;;----------------------------------------------------
(require 'projectile)
(projectile-global-mode)

(require 'projectile-rails)
(add-hook 'projectile-mode-hook 'projectile-rails-on)
;; rirariと同様のキーバインドを使う
(define-key projectile-rails-mode-map (kbd "C-c ; f m") 'projectile-rails-find-current-model)
(define-key projectile-rails-mode-map (kbd "C-c ; f c") 'projectile-rails-find-current-controller)
(define-key projectile-rails-mode-map (kbd "C-c ; f v") 'projectile-rails-find-current-view)
(define-key projectile-rails-mode-map (kbd "C-c ; f s") 'projectile-rails-find-current-spec)
(define-key projectile-rails-mode-map (kbd "C-c ; c") 'projectile-rails-console)

;;----------------------------------------------------
;; Emmet
;;----------------------------------------------------
(require 'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode) ;; CSSにも使う
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2))) ;; indent はスペース2個
(eval-after-load "emmet-mode"
  '(define-key emmet-mode-keymap (kbd "C-j") nil)) ;; C-j は newline のままにしておく
(keyboard-translate ?\C-i ?\H-i) ;;C-i と Tabの被りを回避
(define-key emmet-mode-keymap (kbd "H-i") 'emmet-expand-line) ;; C-i で展開

;;----------------------------------------------------
;; Web Mode
;;----------------------------------------------------
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-html-offset   2)
  (setq web-mode-css-offset    2)
  (setq web-mode-script-offset 2)
  (setq web-mode-php-offset    2)
  (setq web-mode-java-offset   2)
  (setq web-mode-asp-offset    2)
  (emmet-mode))
(add-hook 'web-mode-hook 'web-mode-hook)

;;----------------------------------------------------
;; JS2 Mode
;;----------------------------------------------------
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js2-mode))

;;----------------------------------------------------
;; 各種モードMode
;;----------------------------------------------------
(cua-mode)
(setq cua-enable-cua-keys nil)  ; CUAキーバインドを無効化
(global-undo-tree-mode t)

;;----------------------------------------------------
;; Design
;;----------------------------------------------------
;;color-theme
;(load-theme 'wheatgrass t)
(load-theme 'zenburn t)

;;----------------------------------------------------
;; 言語・文字コード関連の設定
;;----------------------------------------------------
(require 'mozc)
(setq default-input-method "japanese-mozc")
(setq mozc-candidate-style 'overlay)

(global-set-key (kbd "<zenkaku-hankaku>") 'toggle-input-method)

;;----------------------------------------------------
;; インストール後の処理
;;----------------------------------------------------
; $ sudo apt-get install emacs-mozc-bin
; $ sudo apt-get install silversearcher-ag
; $ gem install rubocop ruby-lint
; $ git clone https://github.com/w3c/tidy-html5.git
; $ cd tidy-html5/build/cmake
; $ sudo apt-get install cmake g++
; $ cmake ../..
; $ make
; $ sudo make install
; $ git clone https://github.com/yascentur/Ricty.git
; $ sudo apt-get install fontforge
; $ unzip migu-1m-20130617.zip
; $ cp migu-1m-20130617/migu-*.ttf ../Ricty
; $ cd ..
; $ cd Ricty
; $ wget http://levien.com/type/myfonts/Inconsolata.otf
; $ ./ricty_generator.sh Inconsolata.otf migu-1m-regular.ttf migu-1m-bold.ttf
; $ sudo mkdir /usr/share/fonts/truetype/ricty
; $ sudo mv Ricty*.ttf /usr/share/fonts/truetype/ricty
; $ fc-cache -vf
