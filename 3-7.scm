#lang racket

(require "test.scm")

(define (make-joint account password new-password)
  (define (withdraw ammount)
	((account password 'withdraw) ammount))
  (define (deposit ammount)
	((account password 'deposit) ammount))
  (define (dispatch pw m)
	(cond
	  ((not (eq? pw new-password))
	   (error "Incorrect password"))
	  ((eq? m 'withdraw) withdraw)
	  ((eq? m 'deposit) deposit)
	  (else (error "Unknown request -- MAKE-JOINT" m))))
  dispatch)

(define (make-account balance password)
  (define (withdraw amount)
	(if (>= balance amount)
	  (begin (set! balance (- balance amount))
			 balance)
	  "Insufficient funds"))
  (define (deposit amount)
	(set! balance (+ balance amount))
	balance)
  (define (dispatch pw m)
	(cond
	  ((not(eq? pw password)) (error "Incorrect password"))
	  ((eq? m 'withdraw) withdraw)
	  ((eq? m 'deposit) deposit)
	  (else (error "Unknown request -- MAKE-ACCOUNT" m))))
  dispatch)

(define acc (make-account 100 'secret-password))
(define new-acc (make-joint acc 'secret-password 'new-password))

(test-is ((new-acc 'new-password 'withdraw) 40) 60)

(test-done)

; こんな感じで、元のaccountをラップするようなaccountを作るようにしてみた。
; 解答例だとaccountの中にある単一のnew-passwordにset!で新しいパスワードを設定しているけど、
; これだと複数のjointしたいときにだめっぽい。

