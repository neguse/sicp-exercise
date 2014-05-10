#lang racket

(define (square x) (* x x))

(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

(define (even? n)
  (= (remainder n 2) 0))

(fast-expt 2 4)

; なんかこれ、「ハッカーのたのしみ」に書いてありそうな問題だなぁ。
; 奇数か偶数か見て分岐するのって、ようはビットが立ってるところで掛ければいいんだよね。

(define (fast-expt-iter-i b n a)
	(cond ((= n 0) a)
				((even? n)
				 (fast-expt-iter-i (square b) (/ n 2) a))
				(else
				 (fast-expt-iter-i (square b) (/ (- n 1) 2) (* b a)))))

(define (fast-expt-iter b n)
	(fast-expt-iter-i b n 1))
	

(= (fast-expt 1 1) (fast-expt-iter 1 1))
(= (fast-expt 1 2) (fast-expt-iter 1 2))
(= (fast-expt 2 1) (fast-expt-iter 2 1))
(= (fast-expt 2 2) (fast-expt-iter 2 2))
(= (fast-expt 3 2) (fast-expt-iter 3 2))
(= (fast-expt 3 36) (fast-expt-iter 3 36))

; よし。

