#lang planet neil/sicp

(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

(define (origin-frame frame)
  (car frame))

(define (edge1-frame frame)
  (cadr frame))

(define (edge2-frame frame)
  (cddr frame))

(= (origin-frame (make-frame 1 2 3)) 1)
(= (edge1-frame (make-frame 1 2 3)) 2)
(= (edge2-frame (make-frame 1 2 3)) 3)

