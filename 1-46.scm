#lang racket
(define (iterative-improve good-enough? improve)
  (define (iter-imp guess)
	(if (good-enough? guess)
	  guess
	  (iter-imp (improve guess))))
  iter-imp)
; あー、lambdaだと自己再帰できないからどうやるんだろうと思ったら、
; defineの入れ子使うんですね。

(define (average x y)
  (/ (+ x y) 2))
(define (square x) (* x x))

(define (sqrt x)
	(define (good-enough? guess)
	  (< (abs (- (square guess) x)) 0.001))
	(define (improve guess)
	  (average guess (/ x guess)))
	((iterative-improve good-enough? improve) x))

(sqrt 10)
  
(define tolerance 0.00001)
(define (fixed-point f guess)
  (define (close-enough? guess)
    (< (abs (- (f guess) guess)) tolerance))
  (define (improve guess)
	(f guess))
  ((iterative-improve close-enough? improve) guess))

(fixed-point (lambda (x) (+ 1 (/ 1 x))) 2.0)

