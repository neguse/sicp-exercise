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

; 仮定
; 上限と下限を持つ「区間」がある
; 区間の短点が与えられたとき、make-intervalを用いて区間が構成できる
; 
; 差はどうやって計算すればいいだろう
; 差を計算する時に、区間の上限と下限の組み合わせから、4通りの計算方法があるんだけど、
; おそらくmul-intervalみたいに全部計算して総当りで最大・最小をもとめる必要はなくて、
; 上限は、一番結果が大きい時のもので、すなわち上限-下限
; 下限は一番結果が小さい時のもので、すなわち下限-上限
; だろう

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
				 (- (upper-bound x) (lower-bound y))))

(define (eq-interval x y)
  (and (= (upper-bound x) (upper-bound y))
	   (= (lower-bound x) (lower-bound y))))

(define d1 (make-interval 100 101))
(define d2 (make-interval 10 11))

(eq-interval (sub-interval d1 d2)
			 (make-interval 89 91))

