#lang racket

(define (make-rectangle w h)
  (cons w h))

(define (width r)
  (car r))

(define (height r)
  (cdr r))

(define (perimeter r)
  (* 2 (+
	(width r)
	(height r))))

(define (area r)
  (*
	(width r)
	(height r)))

(define r
  (make-rectangle 1 1))

(perimeter r)
(area r)


