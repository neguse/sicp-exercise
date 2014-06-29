#lang racket

(define dx 0.0001)

(define (compose f g)
  (lambda (x)
	(f (g x))))

(define (repeated f n)
  (if (= n 1)
	f
	(compose f (repeated f (- n 1)))))

(define (smooth f)
  (lambda (x)
	(/ (+
		 (f (- x dx))
		 (f x)
		 (f (+ x dx))) 3)))

(define (smooth-n f n)
  (repeated (smooth f) n))

(define (inc x) (+ 1 x))
((smooth inc) 1)
((smooth-n inc 2) 1)
; よくわからんけど、こんなもんじゃないか

