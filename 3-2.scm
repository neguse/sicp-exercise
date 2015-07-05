#lang racket

(require "test.scm")

(define (make-monitored f)
  (let ((count 0))
	(lambda (x . xs)
	  (cond
		((eq? x 'reset-count)
		 (set! count 0)
		 count)
		((eq? x 'how-many-calls?)
		 count)
		(else
		  (set! count (+ 1 count))
		  (apply f (cons x xs)))))))

(define s (make-monitored sqrt))
(test-is (s 'how-many-calls?) 0)
(test-is (s 100) 10)
(test-is (s 'how-many-calls?) 1)
(test-is (s 'reset-count) 0)
(test-is (s 'how-many-calls?) 0)
(test-done)

