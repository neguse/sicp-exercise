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

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

(define (make-center-percent c p)
  (make-center-width c (abs (* c p 0.01))))

(define (percent i) (* 100.0 (/ (width i) (center i))))

(define (par1 r1 r2)
   (div-interval (mul-interval r1 r2)
                 (add-interval r1 r2)))

(define (par2 r1 r2)
   (let ((one (make-interval 1 1)))
      (div-interval one
                    (add-interval (div-interval one r1)
                                  (div-interval one r2)))))

; もうカンニングしてしまおう
; http://www.billthelizard.com/2010/12/sicp-212-216-extended-exercise-interval.html

(define a (make-center-percent 100 5))
(define b (make-center-percent 200 2))

(define aa (div-interval a a))
(define ab (div-interval a b))

aa
(center aa)
; 1.0050125313283207 <- 1に近いけど、ちょっと誤差あるよね、というのがあやしい?
(percent aa)
; 9.97506234413964

ab
(center ab)
; 0.5007002801120448
(percent ab)
; 6.993006993006991

(define apb1 (par1 a b))
(define apb2 (par2 a b))

apb1
; '(60.25889967637541 . 73.6082474226804)
apb2
; '(63.986254295532646 . 69.32038834951456)

(define apa1 (par1 a a))
(define apa2 (par2 a a))

apa1
; '(42.97619047619048 . 58.026315789473685)
apa2
; '(47.5 . 52.49999999999999)

; 確かに違うと。
