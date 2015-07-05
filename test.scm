#lang racket

(define test-num 0)
(define test-success 0)

(define (test-is x y)
  (set! test-num (+ 1 test-num))
  (if (eq? x y)
	(begin
	  (set! test-success (+ 1 test-success))
	  (list 'ok test-num))
	(error "failed test-is" x y)))

(define (test-done)
  (if (= test-num test-success)
	'all-ok
	(error "failed some tests" test-num test-success)))


(provide test-is test-done)

