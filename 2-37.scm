#lang racket

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

; (define (map p sequence)
;  (accumulate (lambda (x y) (cons (p x) y)) '() sequence))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      '()
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map (lambda (x) (dot-product x v)) m))

(define (transpose mat)
  (accumulate-n cons '() mat))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (v) (matrix-*-vector cols v)) m)))


(define v1 (list 1 3 -5))
(define w1 (list 4 -2 -1))
(dot-product v1 w1)

(define m2 (list (list 1 2 3) (list 4 5 6)))
(define v2 (list 1 2 3))
(matrix-*-vector m2 v2)

(define m3 '((1 2 3) (4 5 6)))
(transpose m3)

(define a4 (list (list 14 9 3) (list 2 11 15) (list 0 12 17) (list 5 2 3)))
(define b4 (list (list 12 25) (list 9 10) (list 8 5)))
(matrix-*-matrix a4 b4)

; はい。
