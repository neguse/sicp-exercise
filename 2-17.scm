#lang racket

(define (last-pair x)
  (if (null? (cdr x))
	(car x)
	(last-pair (cdr x))))

(last-pair '(1 2))
; 2
(last-pair '(1))
; 1
(last-pair '())
; cdr: contract violation

