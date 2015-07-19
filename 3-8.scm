#lang racket

(define g '())

(define (reset-g)
  (set! g '()))

(define (f x)
  (if
	(null? g)
	(begin
	  (set! g x)
	  x)
	0))

(reset-g)
(+ (f 0) (f 1))
(reset-g)
(+ (f 1) (f 0))

; なるほど。

