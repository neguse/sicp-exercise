#lang racket

(define (sum term a next b)
  (if (> a b)
	0
	(+ (term a)
	   (sum term (next a) next b))))

(define (sum2 term a next b)
  (define (iter a result)
	(if (> a b)
	  result
	  (iter (next a) (+ result (term a)))))
  (iter a 0))

; こんな感じ?

(define (inc x) (+ x 1))
(define (ident x) x)
(define (square x) (* x x))

(sum ident 1 inc 10)
(sum2 ident 1 inc 10)
(sum square 1 inc 10)
(sum2 square 1 inc 10)

; うん、たぶん合ってるでしょう。

