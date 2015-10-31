#lang racket

(define (make-mutex)
  (let ((cell (list false)))
	(define (the-mutex m)
	  (cond ((eq? m 'acquire)
			 (if (test-and-set! cell)
			   (the-mutex 'acquire))) ; retry
			((eq? m 'release) (clear! cell))))
	the-mutex))

(define (clear! cell)
  (set-car! cell false))

(define (test-and-set! cell)
  (if (car cell)
	true
	(begin (set-car! cell true)
		   false)))

(define (make-semaphore-with-mutex n)
  (let (
		(mutex (make-mutex))
		(p n))
	(define (the-semaphore m)
	  (cond ((eq? m 'p)
			 (mutex 'acquire)
			 (if (<= p 0)
			   (begin (mutex 'release) (the-semaphore 'p)) ; retry
			   (begin (set! p (- p 1)) (mutex 'release))))
			((eq? m 'v)
			 (mutex 'acquire)
			 (set! p (+ p 1))
			 (mutex 'release))))
	the-semaphore))

; test-and-set!版は…けっきょくmutexがtest-and-set!をベースにしてるので
; inline展開するだけでしょ?って思いますので、まあそのようにすればできるんじゃないでしょうか。

