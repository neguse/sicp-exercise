#lang racket
(require r5rs)

(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
         (count-pairs (cdr x))
         1)))

; いままでの話からすると、これもけっきょくset!とかで
; 参照がこんがらがってる場合におかしいのだと思うけど

(define v3 '(a b c))
v3
(count-pairs v3)

(define v4-1 '(b))
(define v4 (cons 'a (cons v4-1 v4-1)))
v4
(count-pairs v4)

(define v7-1 '(c))
(define v7-2 (cons v7-1 v7-1))
(define v7 (cons v7-2 v7-2))
v7
(count-pairs v7)

; よし。
