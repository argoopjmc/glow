(export #t)

(import
  :std/getopt :std/iter :std/misc/hash :std/misc/string :std/srfi/13 :std/sugar
  :clan/cli :clan/config :clan/filesystem :clan/hash :clan/multicall
  :clan/path :clan/path-config :clan/string
  :clan/poo/cli)

(def glow-path #f)
(def glow-dapps #f)

(def (initialize-glow-path! (user-provided #f))
  (set! glow-path (or user-provided
                      (getenv-absolute-paths "GLOW_PATH")
                      [(source-path "dapps")])))

(def (for-each-dapp-file f extension: (extension ".glow"))
  (assert! glow-path "You must initialize-glow-path! before you search for dapp files!")
  (for (top (reverse glow-path)) ;; reverse so earlier entries override later ones.
    (for (path (find-files top (cut string-suffix? extension <>)))
      (let (name (string-trim-suffix extension (path-enough path top)))
        (f name path)))))

(def (find-dapp-files extension: (extension ".glow") filter: (filter true))
  (def h (hash))
  (for-each-dapp-file
   extension: extension
   (lambda (name path)
     (when (filter name path)
       (hash-put! h name path))))
  h)

(def (initialize-glow-dapps!)
  (set! glow-dapps (find-dapp-files)))

(def (ensure-glow-dapps)
  (unless glow-dapps (initialize-glow-dapps!))
  glow-dapps)

(def options/glow-path
  (make-options [(option 'glow-path "-G" "--glow-path" help: "search path for Glow DApps"
                         value: (lambda (x) (filter path-absolute? (split-dirs x))))]
                [(lambda (opt) (initialize-glow-path! (hash-removed opt 'glow-path)))]))

;; List all of the applications in the search path.
(define-entry-point (list-applications)
  (help: "List interactions available in search path"
   getopt: options/glow-path)
  (def apps (hash->list/sort (ensure-glow-dapps) string<?))
  (for-each (lambda (n p) (displayln n "  " p)) (co-pad-strings (map car apps)) (map cdr apps)))

(def (find-dapp-path relpath)
  (find file-exists? (map (cut subpath <> relpath) glow-path)))

(def (find-dapp-file dapp (extension ".glow"))
  (def relpath (string-append dapp extension))
  (or (find-dapp-path relpath) (error "Glow DApp not found: " relpath)))