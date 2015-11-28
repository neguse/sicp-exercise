#lang racket

(require racket/stream)

(define (stream-limit s l)
  (let ((i1 (stream-first s))
		(i2 (stream-first (stream-rest s))))
	(if (< (abs (- i1 i2)) l)
	  i2
	  (stream-limit (stream-rest s) l))))

(define (stream-map* proc . argstreams)
  (if (null? (car argstreams))
	empty-stream
	(stream-cons
	  (apply proc (map stream-first argstreams))
	  (apply stream-map*
			 (cons proc (map stream-rest argstreams))))))

(define (add-streams s1 s2)
  (stream-map* + s1 s2))

(define (mul-streams s1 s2)
  (stream-map* * s1 s2))

(define (div-streams s1 s2)
  (stream-map* / s1 s2))

(define (sign-stream-from s)
  (stream-cons s (sign-stream-from (* -1 s))))

(define sign-stream
  (sign-stream-from 1))

(define (integers-starting-from n)
  (stream-cons n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))

(define one (stream-cons 1 one))

(define (partial-sums s)
  (stream-cons (stream-first s)
			   (add-streams (partial-sums s) (stream-rest s))))

(define ln2-stream
  (partial-sums
	(mul-streams sign-stream
				 (div-streams one integers))))

(stream-limit ln2-stream 0.01)
; 0.68817217931	
; だいたいあってる

