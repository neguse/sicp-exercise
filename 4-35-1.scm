(define (require p)
  (if (not p) (amb)))

(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items))))

(define (an-integer-between low high)
  (require (<= low high))
  (amb low (an-integer-between (+ low 1) high)))

(an-integer-between 0 3)

try-again
try-again
try-again
try-again

; ambevalはevalと引数が異なってて、
; うまくユニットテストするのが難しそう。

