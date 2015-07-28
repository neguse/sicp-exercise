#lang racket
(require r5rs)

(define x (list 'a 'b))
(define z1 (cons x x))
(define z2 (cons (list 'a 'b) (list 'a 'b)))

(define (set-to-wow! x)
  (set-car! (car x) 'wow)
  x)

; 図をかくのはちょっと省略なのですが、
; z1に対してset-to-wow!を適用すると
; ('wow 'b) . ('wow 'b)
; z2に対してset-to-wow!を適用すると
; ('wow 'b) . ('a 'b) となるのではないかな

(set-to-wow! z1)
(set-to-wow! z2)

; うむ

