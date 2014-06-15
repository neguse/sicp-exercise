#lang racket

(define (cont-frac n d k)
  (define (cont-frac-iter n d k i)
	(if (= k i)
	  (/ (n i) (d i))
	  (/ (n i) (+ (d i) (cont-frac-iter n d k (+ i 1))))))
  (cont-frac-iter n d k 1))

(define (e k)
  (define (n i) 1)
  (define (d i)
	(cond
	  ((= (remainder (- i 1) 3) 0) 1)
	  ((= (remainder (- i 1) 3) 2) 1)
	  (else (* 2 (+ 1 (quotient i 3))))))
  (+ 2 (cont-frac n d k)))

(e 100)
; 13823891428306770374331665289458907890372191037173036666131/5085525453460186301777867529962655859538011626631066055111
; 2.7182818284590455
; よしよし。

