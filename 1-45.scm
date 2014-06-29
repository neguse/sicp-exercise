#lang racket

; カンニングしながらやるか。

(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (average x y)
  (/ (+ x y) 2))
(define (average-damp f)
  (lambda (x) (average x (f x))))

(define (compose f g)
  (lambda (x)
	(f (g x))))

(define (repeated f n)
  (if (= n 1)
	f
	(compose f (repeated f (- n 1)))))

(define (log2 x)
  (/ (log x) (log 2)))

(define (nth-root x n)
  (fixed-point
     ((repeated average-damp (floor (log2 n)))
        (lambda (y) (/ x (expt y (- n 1)))))
     1.0))

(nth-root 100 2)
(nth-root 1000 3)
(nth-root 1000 4)
(nth-root 1000 5)
(nth-root 1000 6)
(nth-root 1000 7)
(nth-root 1000 8)
(nth-root 1000 15)
(nth-root 1000 16)
(nth-root 1000 100)
; うーん、確かにlog(n)とaverage-dampの反復回数が比例しそうな感じ

