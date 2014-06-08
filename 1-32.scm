#lang racket

(define (accumulate combiner null-value term a next b)
  (if (> a b)
	null-value
	(combiner (term a)
			  (accumulate combiner null-value term (next a) next b))))

(define (accumulate2 combiner null-value term a next b)
  (define (iter a result)
	(if (> a b)
	  result
	  (iter (next a) (combiner result (term a)))))
  (iter a null-value))


(define (sum term a next b)
  (define (add x y) (+ x y))
  (accumulate add 0 term a next b))
(define (sum2 term a next b)
  (define (add x y) (+ x y))
  (accumulate2 add 0 term a next b))

; はい。

(define (ident x) x)
(define (inc x) (+ x 1))

(sum ident 0 inc 10)
(sum2 ident 0 inc 10)

