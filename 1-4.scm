(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

; (a-plus-abs-b 1 2)
; (> b 0) -> #t
; (if #t + -) -> +
; (+ a b) -> 3
;
; (a-plus-abs-b 1 -2)
; (> b 0) -> #f
; (if #f + -) -> -
; (- a b) -> 3

(= (a-plus-abs-b 1 2) 3)
(= (a-plus-abs-b 1 -2) 3)

