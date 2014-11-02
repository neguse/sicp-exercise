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

; うーんと、とりあえずintervalの和と差それぞれについて
; 結果の幅が元の幅から計算できることを示せばよいっぽい

; x, y : interval
; width x = (/ (- (upper-bound x) (lower-bound x)) 2)
; wx = width(x), wy = width(y)
;
; wadd = (width (add-interval x y))
;      = (width (make-interval (+ (lower-bound x) (lower-bound y)) (+ (upper-bound x) (upper-bound y))))
;      = (/ (- (+ (upper-bound x) (upper-bound y)) (+ (lower-bound x) (lower-bound y))) 2)
;      = (/ (+ (- (upper-bound x) (lower-bound x)) (- (upper-bound y) (lower-bound y))) 2)
;      = (/ (+ (* (width x) 2) (* (width y) 2)) 2)
;      = (+ (width x) (width y))
;
;
; wsub = (width (sub-interval x y))
;      = (width (make-interval (- (lower-bound x) (upper-bound y)) (- (upper-bound x) (lower-bound y))))
;      = (/ (- (- (upper-bound x) (lower-bound y)) (- (lower-bound x) (upper-bound y))) 2)
;      = (/ (+ (- (upper-bound x) (lower-bound x)) (- (- (upper-bound y) (lower-bound y)))) 2)
;      = (/ (- (* (width x) 2) (* (width y) 2)) 2)
;      = (- (width x) (width y))
;
; ということで、addとsubについてはwidthから一意に求まることが示せた。

; 積と商については、例を出せって言われても、どうすればいいんでしょうか。
; なんとなく、lower-boundとupper-boundの符号が違うと、計算結果がwidthと関係なくなりそう。
