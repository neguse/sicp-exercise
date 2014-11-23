#lang racket

(define (for-each f x)
  (if (null? x)
	#f
	(begin
	  (f (car x))
	  (for-each f (cdr x)))))

(for-each (lambda (x) (newline) (display x))
          (list 57 321 88))

; はい
