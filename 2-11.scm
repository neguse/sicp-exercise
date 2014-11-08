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

; Benめんどくせーな
; そもそも、9つの場合に分けられるって言ってるけど
; 符号の組み合わせ的には2^4=16通りあるんじゃないか
; …と思ったけど、lower-bound < upper-bound は前提にできるわけで
; どっちも+, 0はさみ, どっちも-、の3択なわけですか

; x y : ans
; + + : xl*yl ~ xh*yh
; + 0 : xh*yl ~ xh*yh
; + - : xh*yl ~ xl*yh
; 0 + : xl*yh ~ xh*yh
; 0 0 : これはひとすじなわではいかない
; 0 - : xh*yl ~ xl*yl
; - + : xl*yh ~ xh*yl
; - 0 : xl*yh ~ xl*yl
; - - : xh*yh ~ xl*yl

; …こまかい場合ごとの条件を考えるの面倒です
; あとはこれを適当に落とし込めばいいわけですね

(define (mul-interval-opt x y)
  (define (sign-interval x)
	(sgn (+ (sgn (lower-bound x)) (sgn (upper-bound x)))))
  (define (pat? xs ys) (and (= (sign-interval x) xs) (= (sign-interval y) ys)))
  (let
	((xl (lower-bound x))
	 (xh (upper-bound x))
	 (yl (lower-bound y))
	 (yh (upper-bound y)))
	(cond
	  ((pat?  1  1) (make-interval (* xl yl) (* xh yh)))
	  ((pat?  1  0) (make-interval (* xh yl) (* xh yh)))
	  ((pat?  1 -1) (make-interval (* xh yl) (* xl yh)))
	  ((pat?  0  1) (make-interval (* xl yh) (* xh yh)))
	  ((pat?  0  0) (make-interval
					  (min (* xl yh) (* xh yl)) (max (* xl yl) (* xh yh))))
	  ((pat?  0 -1) (make-interval (* xh yl) (* xl yl)))
	  ((pat? -1  1) (make-interval (* xl yh) (* xh yl)))
	  ((pat? -1  0) (make-interval (* xl yh) (* xl yl)))
	  ((pat? -1 -1) (make-interval (* xh yh) (* xl yl))))))

(define (testcase-mul-interval-opt xl xh yl yh)
  (eq-interval
	(mul-interval (make-interval xl xh) (make-interval yl yh))
	(mul-interval-opt (make-interval xl xh) (make-interval yl yh))))

(testcase-mul-interval-opt  1  1  1  1)
(testcase-mul-interval-opt  1  1 -1  1)
(testcase-mul-interval-opt  1  1 -1 -1)
(testcase-mul-interval-opt -1  1  1  1)
(testcase-mul-interval-opt -1  1 -1  1)
(testcase-mul-interval-opt -1  1 -1 -1)
(testcase-mul-interval-opt -1 -1  1  1)
(testcase-mul-interval-opt -1 -1 -1  1)
(testcase-mul-interval-opt -1 -1 -1 -1)

; とてもつかれた

