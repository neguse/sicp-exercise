#lang racket

; 2章の最後のほうは、もうあきらめました…

(define (make-accumulator sum)
  (lambda (v)
	(begin
	  (set! sum (+ sum v))
	  sum)))

(define A (make-accumulator 5))

(= (A 10) 15)
(= (A 10) 25)

(define B (make-accumulator 5))

(= (B 10) 15)

