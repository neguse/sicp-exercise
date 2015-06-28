#lang racket

; 今回もなんとなく実装でいきます

(define (sub x y)
  (apply-generic 'add x (apply-generic 'minus y)))

(define (minus x)
  (apply-generic 'minus x))

(define (minus-poly x)
  (make-polynomial (variable x) (minus-termlist (term-list x))))

(define (minus-termlist x)
  (if (empty-termlist? x)
	(the-empty-termlist)
	(let ((t (first-term x)))
	  (adjoin-term (make-term (order t) (* -1 (coeff t)))
				   (rest-terms x)))))

