#lang racket

(define (make-point x y)
  (cons x y))

(define (x-point point)
  (car point))

(define (y-point point)
  (cdr point))

(define (make-rectangle p1 p2)
  (cons p1 p2))

(define (left-top r)
  (car r))

(define (right-bottom r)
  (cdr r))

(define (perimeter r)
  (* 2 (+
	(abs (- (x-point (left-top r)) (x-point (right-bottom r))))
	(abs (- (y-point (left-top r)) (y-point (right-bottom r)))))))

(define (area r)
  (*
	(abs (- (x-point (left-top r)) (x-point (right-bottom r))))
	(abs (- (y-point (left-top r)) (y-point (right-bottom r))))))

(define r
  (make-rectangle
	(make-point 0 0)
	(make-point 1 1)))

(perimeter r)
(area r)

