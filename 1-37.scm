#lang racket

(define (cont-frac n d k)
  (define (cont-frac-iter n d k i)
	(if (= k i)
	  (/ (n i) (d i))
	  (/ (n i) (+ (d i) (cont-frac-iter n d k (+ i 1))))))
  (cont-frac-iter n d k 1))

(define (k-term k)
  (cont-frac
	(lambda (i) 1.0)
	(lambda (i) 1.0)
	k))

; とりあえずcont-fracの定義はこんなもんで、
; kの値と精度については、どうでしょうね。

(define (4-col x) (floor (* 10000 x)))
(define exact-value
  (/ 1 (/ (+ 1 (sqrt 5)) 2)))

(define (search-enough-precision k)
  (let
	((a (4-col (k-term k)))
	 (b (4-col exact-value)))
	(begin
	  (display k)
	  (display " ")
	  (display a)
	  (display " ")
	  (display b)
	  (newline)
	  (if (= a b)
		k
		(search-enough-precision (+ k 1))))))

(search-enough-precision 1)
; 1 10000.0 6180.0
; 2 5000.0 6180.0
; 3 6666.0 6180.0
; 4 6000.0 6180.0
; 5 6250.0 6180.0
; 6 6153.0 6180.0
; 7 6190.0 6180.0
; 8 6176.0 6180.0
; 9 6181.0 6180.0
; 10 6179.0 6180.0
; 11 6180.0 6180.0
; 11
; ということで、11回でした。

(define (cont-frac-2 n d k)
  (define (cont-frac-2-iter n d k m)
	(let ((m (/ (n k) (+ (d k) m))))
	  (if (= k 1)
		m
		(cont-frac-2-iter n d (- k 1) m))))
  (cont-frac-2-iter n d k 0))

(=
  (cont-frac
	(lambda (i) 1.0)
	(lambda (i) 1.0)
	100)
  (cont-frac-2
	(lambda (i) 1.0)
	(lambda (i) 1.0)
	100))
; はい。

