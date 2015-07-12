#lang racket

(define random-init 1)

; 動作確認用に、乱数はprev + 1とする
(define (rand-update v)
  (+ v 1))

(define rand
  (let ((x random-init))
    (lambda (sym)
	  (cond
		((eq? sym 'generate)
		 (set! x (rand-update x))
		 x)
		((eq? sym 'reset)
		 (lambda (init-value)
		   (set! x init-value)))
		(else
		  (error "undefined behavior"))))))

((rand 'reset) 3)
(rand 'generate)
(rand 'generate)
((rand 'reset) 3)
(rand 'generate)
(rand 'generate)
; 4 5 4 5

