#lang racket

(define zero
  (lambda (f)
	(lambda (x)
	  x)))

(define (add-1 n)
  (lambda (f)
	(lambda (x)
	  (f ((n f) x)))))

; うーん、なんでこんな構造になってるんだろう
; なんか適当に普通の数に変換する関数引数がわかれば
; 試せそうなんだけど…

(define one
  (lambda (f)
	(lambda (x)
	  (f (((lambda (f1)
			 (lambda (x1)
			   x1)) f) x)))))
(define two
  (lambda (f)
	(lambda (x)
	  (f (((lambda (f2) (lambda (x2) (f2 (((lambda (f1) (lambda (x1) x1)) f2) x2)))) f) x)))))

; こんなもん?

(define num-add1 (lambda (x) (+ x 1)))
(define num-zero 0)
(define (num church)
  ((church num-add1) num-zero))

(num zero)
; -> 0
(num one)
; -> 1
(num two)
; -> 2

; 適当に+1する関数突っ込んだら大丈夫だった

