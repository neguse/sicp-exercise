#lang racket

(define (f g)
  (g 2))

(define (square x) (* x x))

(f square)

(f (lambda (z) (* z (+ z 1))))

(f f)
; application: not a procedure;
;  expected a procedure that can be applied to arguments
; ほほう? てっきり無限再帰するものと思ったけど、違うのかな。
; (f f)
; -> (f 2)
; -> (2 2)
; -> あ、こうか。
