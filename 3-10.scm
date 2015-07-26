#lang racket

; とりあえずmake-withdrawをlambdaを使って書いてみる。

(define (make-withdraw initial-amount)
  ((lambda (balance)
	(lambda (amount)
	  (if (>= balance amount)
		(begin (set! balance (- balance amount))
			   balance)
		"Insufficient funds")))
   initial-amount))

; こうかな?

; after step (define W1 (make-withdraw 100))
; W1 : balance : 100

; after step (W1 50)
; W1 : balance : 50

; after step (define W2 (make-withdraw 100))
; W1 : balance : 50
; W2 : balance : 100

; 変わらないんじゃないかな…と思って答え見たけど、
; 今度はinitial-amountとbalanceがくっついてますね。
; たぶんなんだけど、lambdaがネストするとこうなって
; ネストしなければこうならないんじゃないかな。

