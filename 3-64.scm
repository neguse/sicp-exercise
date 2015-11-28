#lang racket

(require racket/stream)

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

(define (average x y)
  (/ (+ x y) 2))

(define (sqrt-improve guess x)
  (average guess (/ x guess)))


(define (sqrt-stream x)
  (define guesses
	(stream-cons 1.0
				 (stream-map (lambda (guess)
							   (sqrt-improve guess x))
							 guesses)))
  guesses)

; if文で分岐してしまえばよさそう。
(define (stream-limit s l)
  (let ((i1 (stream-first s))
		(i2 (stream-first (stream-rest s))))
	(if (< (abs (- i1 i2)) l)
	  i2
	  (stream-limit (stream-rest s) l))))

(define (mysqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

(mysqrt 10 0.01)
; 3.162277665175675
(mysqrt 100 0.01)
; 10.000000000139897

; よさそう。

