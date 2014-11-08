#lang racket

(define (make-interval a b) (cons a b))
(define (lower-bound x) (car x))
(define (upper-bound x) (cdr x))

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (div-interval x y)
  (mul-interval x 
                (make-interval (/ 1.0 (upper-bound y))
                               (/ 1.0 (lower-bound y)))))

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
				 (- (upper-bound x) (lower-bound y))))

(define (eq-interval x y)
  (and (= (upper-bound x) (upper-bound y))
	   (= (lower-bound x) (lower-bound y))))

(div-interval
  (make-interval 1 2)
  (make-interval -1 1))

; 除数が0になった時はそもそも0除算になるので、
; 除数区間が0を含む場合はエラーにしないといかんのじゃないか
; あと、これは積にも同じことが言えるんじゃないかと思うけどとりあえずおいておく

(define (around-zero-interval? x)
  (or
	(and
	  (= (lower-bound x) 0)
	  (= (upper-bound x) 0))
	(not (= (sgn (lower-bound x)) (sgn (upper-bound x))))))

; という判定関数を用意しておいて

(define (div-interval-safe x y)
  (cond
	((around-zero-interval? y) "error!")
	(else (mul-interval x
				  (make-interval (/ 1.0 (upper-bound y))
								 (/ 1.0 (lower-bound y)))))))

(div-interval-safe
  (make-interval 1 2)
  (make-interval -1 1))

