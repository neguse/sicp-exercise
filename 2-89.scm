#lang racket

; 今回もなんとなく実装でいきます

; うーん、denseであるうまみを活かそうとすると、
; adjoinスタイルは適さないんじゃないかなーという気がする。
; ということは、addとかmulとか書き直すことになるのかな。
; めんどい…

(define (the-empty-termlist) '())
(define (empty-termlist? term-list) (null? term-list))

; addはたぶんこんだけ。すごいシンプルですね。
(define (add-terms L1 L2)
  (cond
	((null? L1) L2)
	((null? L2) L1)
	(else
	  (cons
		(add (car L1) (car L2))
		(add-terms (cdr L1) (cdr L2))))))

; mulは…1項ずつやってくのがいいかな

(define (mul-terms L1 L2)
  (define (mul-terms-1 L o c)
	(cond
	  ((null? L)
	   (the-empty-termlist))
	  ((< 0 o)
	   (cons 0 (mul-terms-1 L (sub 0 1) c)))
	  (else
		(cons
		  (mul (car L) c)
		  (mul-terms-1 (cdr L) o c)))))
  (define (mul-terms-2 L1 L2 o2)
	(cond
	  ((null? L2) (the-empty-termlist))
	  (else
		(add-terms
		  (mul-terms-1 L1 o2 (car L2))
		  (mul-terms-2 L1 (cdr L2) (add 1 o2))))))
  (cond
	((null? L1) (the-empty-termlist))
	((null? L2) (the-empty-termlist))
	(else
	  (mul-terms-2 L1 L2 0))))

; こんなところで…


; これだけなら単体で動かせそうなので、テストしてみましょう。

(define (add x y) (+ x y))
(define (sub x y) (- x y))
(define (mul x y) (* x y))


(add-terms '(1 2 3) '(2 3 4 5))
(add-terms '(1 2 3 4) '(2 3 4))

(mul-terms '(0 1 2) '())
(mul-terms '(0 1 2) '(0))
(mul-terms '(0 1 2) '(1))
(mul-terms '(0 1 2) '(0 1))
(mul-terms '(0 1 2) '(1 1))

; よし。
