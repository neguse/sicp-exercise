#lang racket

(require "test.scm")

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

(test-is ((acc 'secret-password 'withdraw) 40) 60)

((acc 'some-other-password 'deposit) 50)

(test-done)

; これ、errorをハンドリングする仕組みないとテストしにくいなぁ
