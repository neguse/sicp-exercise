#lang racket

(require "test.scm")

(define (call-the-cops arity) "警察だ！逮捕する！")

(define (make-account balance password)
  (let ((wrong-num 0))
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
		((not (eq? pw password))
		 (set! wrong-num (+ 1 wrong-num))
		 (if (= wrong-num 7)
		   call-the-cops
		   (lambda (arity) "Incorrect password")))
		((eq? m 'withdraw) withdraw)
		((eq? m 'deposit) deposit)
		(else (error "Unknown request -- MAKE-ACCOUNT" m))))
	dispatch))

(define acc (make-account 100 'secret-password))

(test-is ((acc 'secret-password 'withdraw) 40) 60)

(test-is ((acc 'some-other-password 'deposit) 50) "Incorrect password")
(test-is ((acc 'some-other-password 'deposit) 50) "Incorrect password")
(test-is ((acc 'some-other-password 'deposit) 50) "Incorrect password")
(test-is ((acc 'some-other-password 'deposit) 50) "Incorrect password")
(test-is ((acc 'some-other-password 'deposit) 50) "Incorrect password")
(test-is ((acc 'some-other-password 'deposit) 50) "Incorrect password")
(test-is ((acc 'some-other-password 'deposit) 50) "警察だ！逮捕する！")

(test-done)

; むりやり…

