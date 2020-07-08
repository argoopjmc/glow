
(export read-checkpoint-info-table
        write-checkpoint-info-table
        checkpoint-info-table=?)

(import :std/iter
        :std/format
        :std/misc/repr
        :std/misc/hash
        <expander-runtime>
        :clan/utils/base
        :glow/compiler/common
        :glow/compiler/checkpointify/checkpointify)

;; type CheckpointInfoTable
;; from :glow/compiler/checkpointify/checkpointify

;; type CheckpointInfo
;; CI from :glow/compiler/checkpointify/checkpointify

;; type TransitionInfo
;; TI from :glow/compiler/checkpointify/checkpointify

;; read-checkpoint-info-table : PathString -> CheckpointInfoTable
(def (read-checkpoint-info-table file)
  (repr-sexpr->checkpoint-info-table (call-with-input-file file read)))

;; write-checkpoint-info-table : CheckpointInfoTable OutputPort -> Void
(def (write-checkpoint-info-table cpit out)
  (fprintf out "~y" (checkpoint-info-table->repr-sexpr cpit)))

;; checkpoint-info-table=? : CheckpointInfoTable CheckpointInfoTable -> Boolean
(def (checkpoint-info-table=? a b)
  (equal? (checkpoint-info-table->repr-sexpr a)
          (checkpoint-info-table->repr-sexpr b)))


;; checkpoint-info-table->repr-sexpr : CheckpointInfoTable -> Sexpr
(def (checkpoint-info-table->repr-sexpr cpit)
  (cons 'hash
        (for/collect ((p (hash->list/sort cpit symbol<?)))
          (with (((cons k v) p))
            [k (checkpoint-info->repr-sexpr v)]))))

;; repr-sexpr->checkpoint-info-table : Sexpr -> CheckpointInfoTable
(def (repr-sexpr->checkpoint-info-table s)
  (match s
    ((cons 'hash entries)
     (def h (make-hash-table))
     (for ((e entries))
       (with (([k v] e))
         (hash-put! h k (repr-sexpr->checkpoint-info v))))
     h)
    (_ (error 'checkpoint-info-table "expected `hash`"))))

;; checkpoint-info->repr-sexpr : CheckpointInfo -> Sexpr
(def (checkpoint-info->repr-sexpr c)
  (match c
    ((ci checkpoint variables-live incoming-transitions outgoing-transitions)
     `(ci ,(symbol->repr-sexpr checkpoint)
          ,(list->repr-sexpr variables-live symbol->repr-sexpr)
          ,(list->repr-sexpr incoming-transitions transition-info->repr-sexpr)
          ,(list->repr-sexpr outgoing-transitions transition-info->repr-sexpr)))
    (_ (error 'checkpoint-info "expected ci struct"))))

;; repr-sexpr->checkpoint-info : Sexpr -> CheckpointInfo
(def (repr-sexpr->checkpoint-info s)
  (match s
    (['ci checkpoint variables-live incoming-transitions outgoing-transitions]
     (ci (repr-sexpr->symbol checkpoint)
         (repr-sexpr->list variables-live repr-sexpr->symbol)
         (repr-sexpr->list incoming-transitions repr-sexpr->transition-info)
         (repr-sexpr->list outgoing-transitions repr-sexpr->transition-info)))
    (_ (error 'checkpoint-info "expected `ci`"))))

;; transition-info->repr-sexpr : TransitionInfo -> Sexpr
(def (transition-info->repr-sexpr t)
  (match t
    ((ti from to participant effects variables-introduced variables-used variables-eliminated)
     `(ti ,(symbol->repr-sexpr from)
          ,(and to (symbol->repr-sexpr to))
          ,(and participant (symbol->repr-sexpr participant))
          ,(list->repr-sexpr effects stx->repr-sexpr)
          ,(list->repr-sexpr variables-introduced symbol->repr-sexpr)
          ,(list->repr-sexpr variables-used symbol->repr-sexpr)
          ,(list->repr-sexpr variables-eliminated symbol->repr-sexpr)))
    (_ (error 'transition-info "expected ti struct"))))

;; repr-sexpr->transition-info : Sexpr -> TransitionInfo
(def (repr-sexpr->transition-info s)
  (match s
    (['ti from to participant effects variables-introduced variables-used variables-eliminated]
     (ti (repr-sexpr->symbol from)
         (and to (repr-sexpr->symbol to))
         (and participant (repr-sexpr->symbol participant))
         (repr-sexpr->list effects repr-sexpr->stx)
         (repr-sexpr->list variables-introduced repr-sexpr->symbol)
         (repr-sexpr->list variables-used repr-sexpr->symbol)
         (repr-sexpr->list variables-eliminated repr-sexpr->symbol)))
    (_ (error 'transition-info "expected `ti`"))))

;; stx->repr-sexpr : Stx -> Sexpr
(def (stx->repr-sexpr stx) ['syntax (syntax->datum stx)])

;; repr-sexpr->stx : Sexpr -> Stx
(def (repr-sexpr->stx s)
  (match s
    (['syntax datum] datum)
    (_ (error 'repr-sexpr->stx "expected `syntax`"))))