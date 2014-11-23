#lang racket

(define (reverse x)
  (define (inner y acc)
	(if (null? y)
	  acc
	  (inner (cdr y) (cons (car y) acc))))
  (inner x '()))

(define (deep-reverse x)
  (define (inner y acc)
	(cond
	  ((null? y) acc)
	  ((pair? (car y)) (inner (cdr y) (cons (deep-reverse (car y)) acc)))
	  (else (inner (cdr y) (cons (car y) acc)))))
  (inner x '()))

(define x '((1 2) (3 4)))

(reverse x)
; '((3 4) (1 2))

(deep-reverse x)
; '((4 3) (2 1))

; いちおうもうちょっと深いやつもためしとこう

(define y '(1 2 (3 4 (5 6 (7 (8) 9 10)))))

(reverse y)
; '((3 4 (5 6 (7 (8) 9 10))) 2 1)
(deep-reverse y)
; '((((10 9 (8) 7) 6 5) 4 3) 2 1)
; あってるっぽい
