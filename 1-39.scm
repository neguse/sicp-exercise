#lang racket

(define (cont-frac n d k)
  (define (cont-frac-iter n d k i)
	(if (= k i)
	  (/ (n i) (d i))
	  (/ (n i) (+ (d i) (cont-frac-iter n d k (+ i 1))))))
  (cont-frac-iter n d k 1))

(define (tan-cf x k)
  (define (n i)
	(if (= i 1) x (- (* x x))))
  (define (d i)
	(- (* i 2) 1))
  (cont-frac n d k))

(tan-cf 1.0 100)
; 1.557407724654902
(tan-cf 2.0 100)
; -2.185039863261519
; よしよし。

