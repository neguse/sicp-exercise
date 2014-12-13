#lang planet neil/sicp

(define (make-vect x y)
  (cons x y))

(define (xcor-vect v)
  (car v))

(define (ycor-vect v)
  (cdr v))

(define (add-vect v1 v2)
  (make-vect
	(+ (xcor-vect v1) (xcor-vect v2))
	(+ (ycor-vect v1) (ycor-vect v2))))

(define (sub-vect v1 v2)
  (make-vect
	(- (xcor-vect v1) (xcor-vect v2))
	(- (ycor-vect v1) (ycor-vect v2))))

(define (scale-vect s v)
  (make-vect
	(* (xcor-vect v) s)
	(* (ycor-vect v) s)))

(define u (make-vect 2 4))
u
(define v (make-vect 3 1))
v
(define w (add-vect u v))
w
(define x (sub-vect w u))
x
(define y (scale-vect 3 w))
y
; よし
